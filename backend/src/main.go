package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/mux"
)

// Task struct remains the same
type Tasks struct {
	ID         string `json:"id"`
	TaskName   string `json:"task_name"`
	TaskDetail string `json:"task_detail"`
	Date       string `json:"date"`
}

var db *sql.DB

func initDb() {
	var err error
	// Connect to MySQL server without specifying a database first
	db, err = sql.Open("mysql", "root:12345678@tcp(127.0.0.1:3306)/")
	if err != nil {
		log.Fatal("Failed to connect to MySQL server: ", err)
	}

	// Create the database if it doesn't exist
	_, err = db.Exec("CREATE DATABASE IF NOT EXISTS task_mgt_flutterGo")
	if err != nil {
		log.Fatal("Failed to create database: ", err)
	}

	// Re-connect to the specific database
	db.Close()
	db, err = sql.Open("mysql", "root:12345678@tcp(127.0.0.1:3306)/task_mgt_flutterGo")
	if err != nil {
		log.Fatal("Failed to connect to task_mgt_flutterGo database: ", err)
	}

	// Create the tasks table if it doesn't exist
	createTableSQL := `CREATE TABLE IF NOT EXISTS tasks (
		id INT NOT NULL AUTO_INCREMENT,
		task_name VARCHAR(255) NOT NULL,
		task_detail TEXT,
		date DATE,
		PRIMARY KEY (id)
	);`
	_, err = db.Exec(createTableSQL)
	if err != nil {
		log.Fatal("Failed to create tasks table: ", err)
	}

	fmt.Println("Database and table initialized successfully.")
}

func homePage(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode(map[string]string{"message": "Welcome to the Task Manager API"})
}

func getTasks(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	tasks := make([]Tasks, 0)
	rows, err := db.Query("SELECT id, task_name, task_detail, date FROM tasks")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	for rows.Next() {
		var task Tasks
		var date sql.NullString
		if err := rows.Scan(&task.ID, &task.TaskName, &task.TaskDetail, &date); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		if date.Valid {
			task.Date = date.String
		}
		tasks = append(tasks, task)
	}
	json.NewEncoder(w).Encode(tasks)
}

func getTask(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)
	id := params["id"]
	var task Tasks
	var date sql.NullString
	err := db.QueryRow("SELECT id, task_name, task_detail, date FROM tasks WHERE id = ?", id).Scan(&task.ID, &task.TaskName, &task.TaskDetail, &date)
	if err != nil {
		if err == sql.ErrNoRows {
			http.NotFound(w, r)
			return
		}
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	if date.Valid {
		task.Date = date.String
	}
	json.NewEncoder(w).Encode(task)
}

func createTask(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var task Tasks
	_ = json.NewDecoder(r.Body).Decode(&task)
	task.Date = time.Now().Format("2006-01-02")

	log.Printf("Received request to create task: %+v\n", task) // Log received data

	stmt, err := db.Prepare("INSERT INTO tasks(task_name, task_detail, date) VALUES(?, ?, ?)")
	if err != nil {
		log.Printf("Error preparing statement: %v\n", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	res, err := stmt.Exec(task.TaskName, task.TaskDetail, task.Date)
	if err != nil {
		log.Printf("Error executing statement: %v\n", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	id, err := res.LastInsertId()
	if err != nil {
		log.Printf("Error getting last insert ID: %v\n", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	task.ID = strconv.FormatInt(id, 10)

	log.Printf("Successfully created task with ID: %s\n", task.ID)
	json.NewEncoder(w).Encode(task)
}

func deleteTask(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)
	id := params["id"]

	stmt, err := db.Prepare("DELETE FROM tasks WHERE id = ?")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	_, err = stmt.Exec(id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]string{"message": "Task deleted successfully"})
}

func updateTask(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)
	id := params["id"]
	var task Tasks
	_ = json.NewDecoder(r.Body).Decode(&task)
	task.Date = time.Now().Format("2006-01-02")

	stmt, err := db.Prepare("UPDATE tasks SET task_name = ?, task_detail = ?, date = ? WHERE id = ?")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	_, err = stmt.Exec(task.TaskName, task.TaskDetail, task.Date, id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	task.ID = id
	json.NewEncoder(w).Encode(task)
}

func handleRoutes() {
	router := mux.NewRouter()
	router.HandleFunc("/", homePage).Methods("GET")
	router.HandleFunc("/gettasks", getTasks).Methods("GET")
	router.HandleFunc("/gettask/{id}", getTask).Methods("GET")
	router.HandleFunc("/create", createTask).Methods("POST")
	router.HandleFunc("/delete/{id}", deleteTask).Methods("DELETE")
	router.HandleFunc("/update/{id}", updateTask).Methods("PUT")

	corsHandler := func(h http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			w.Header().Set("Access-Control-Allow-Origin", "*")
			w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
			w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
			if r.Method == "OPTIONS" {
				w.WriteHeader(http.StatusOK)
				return
			}
			h.ServeHTTP(w, r)
		})
	}

	log.Fatal(http.ListenAndServe("0.0.0.0:8081", corsHandler(router)))
}

func main() {
	initDb()
	fmt.Println("Server starting on port 8081...")
	handleRoutes()
}
