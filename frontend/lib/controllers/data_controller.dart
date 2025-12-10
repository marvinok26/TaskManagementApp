import 'package:flutter/material.dart';
import 'package:frontendnew/services/database_service.dart';
import 'package:frontendnew/utils/show_snackbar.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  final DatabaseService _dbService = DatabaseService.instance;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<dynamic> _myData = [];
  List<dynamic> get myData => _myData;

  Future<void> getData() async {
    _isLoading = true;
    update();

    try {
      _myData = await _dbService.getAllTasks();
      print("We got the data");
    } catch (e) {
      print("Failed to get data: $e");
    }

    _isLoading = false;
    update();
  }

  Future<void> postData(String taskName, String taskDetail, BuildContext context) async {
    _isLoading = true;
    update();

    try {
      final taskId = await _dbService.createTask({
        'task_name': taskName,
        'task_detail': taskDetail,
        'date': DateTime.now().toString().split(' ')[0],
      });

      // Reload data to get the new task
      await getData();

      _isLoading = false;
      update();

      if (context.mounted) {
        showCustomSnackBar(context, "Task added successfully");
        Get.back();
      }
    } catch (e) {
      _isLoading = false;
      update();
      if (context.mounted) {
        showCustomSnackBar(context, "Failed to add task", isError: true);
      }
    }
  }

  Future<void> updateData(dynamic id, String taskName, String taskDetail, BuildContext context) async {
    _isLoading = true;
    update();

    try {
      int taskId = id is int ? id : int.parse(id.toString());
      await _dbService.updateTask(taskId, {
        'task_name': taskName,
        'task_detail': taskDetail,
        'date': DateTime.now().toString().split(' ')[0],
      });

      // Reload data to get updated tasks
      await getData();

      _isLoading = false;
      update();

      if (context.mounted) {
        showCustomSnackBar(context, "Task updated successfully");
        Get.back();
      }
    } catch (e) {
      _isLoading = false;
      update();
      if (context.mounted) {
        showCustomSnackBar(context, "Failed to update task", isError: true);
      }
    }
  }

  Future<void> deleteData(dynamic id, BuildContext context) async {
    _isLoading = true;
    update();

    try {
      await _dbService.deleteTask(int.parse(id.toString()));

      // Reload data
      await getData();

      _isLoading = false;
      update();

      if (context.mounted) {
        showCustomSnackBar(context, "Task deleted successfully");
      }
    } catch (e) {
      _isLoading = false;
      update();
      if (context.mounted) {
        showCustomSnackBar(context, "Failed to delete task", isError: true);
      }
    }
  }
}
