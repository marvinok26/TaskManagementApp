import 'package:flutter/material.dart';
import 'package:frontendnew/colors/app_colors.dart';
import 'package:frontendnew/controllers/data_controller.dart';
import 'package:frontendnew/routes/app_routes.dart';
import 'package:get/get.dart';

class AllTasks extends StatelessWidget {
  const AllTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<DataController>(builder: (controller) {
        return Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 20, top: 60),
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 3.2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/header1.jpg"),
                ),
              ),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: AppColors.secondaryColor),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.home);
                    },
                    child: Icon(Icons.home, color: AppColors.secondaryColor),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.addTask);
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.5),
                        color: Colors.black,
                      ),
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );

                      if (selectedDate != null && context.mounted) {
                        // Filter tasks by selected date
                        final filteredTasks = controller.myData.where((task) {
                          return task['date'] == selectedDate.toString().split(' ')[0];
                        }).toList();

                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: Text('Tasks for ${selectedDate.toString().split(' ')[0]}'),
                            content: filteredTasks.isEmpty
                                ? const Text('No tasks for this date')
                                : SizedBox(
                                    width: double.maxFinite,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: filteredTasks.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(filteredTasks[index]['task_name']),
                                          subtitle: Text(filteredTasks[index]['task_detail']),
                                        );
                                      },
                                    ),
                                  ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Icon(Icons.calendar_month_sharp,
                        color: AppColors.secondaryColor),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    controller.myData.length.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: controller.myData.length,
                      itemBuilder: (context, index) {
                        var task = controller.myData[index];
                        return Dismissible(
                          key: Key(task['id'].toString()),
                          direction: DismissDirection.horizontal,
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              // Swipe left to delete
                              return await showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: const Text('Delete Task'),
                                    content: const Text(
                                        'Are you sure you want to delete this task?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop(false);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Delete'),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop(true);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // Swipe right - show options
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext sheetContext) {
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.visibility,
                                              color: Colors.blue),
                                          title: const Text('View Task'),
                                          onTap: () {
                                            Navigator.pop(sheetContext);
                                            Get.toNamed(AppRoutes.viewTask,
                                                arguments: task);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.edit,
                                              color: Colors.green),
                                          title: const Text('Edit Task'),
                                          onTap: () {
                                            Navigator.pop(sheetContext);
                                            Get.toNamed(AppRoutes.editTask,
                                                arguments: task);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              return false;
                            }
                          },
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              controller.deleteData(task['id'], context);
                            }
                          },
                          background: Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Row(
                              children: [
                                Icon(Icons.visibility, color: Colors.white),
                                SizedBox(width: 8),
                                Text('View/Edit',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          secondaryBackground: Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Delete',
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(width: 8),
                                Icon(Icons.delete, color: Colors.white),
                              ],
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            height: MediaQuery.of(context).size.height / 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFFedf0f8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    task['task_name'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
