import 'package:flutter/material.dart';
import 'package:frontendnew/services/service.dart';
import 'package:frontendnew/utils/show_snackbar.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  DataService service = DataService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<dynamic> _myData = [];
  List<dynamic> get myData => _myData;

  Future<void> getData() async {
    _isLoading = true;
    Response response = await service.getData();
    if (response.statusCode == 200) {
      _myData = response.body;
      print("We got the data");
    } else {
      print("Failed to get data");
    }
    _isLoading = false;
    update();
  }

  Future<void> postData(String taskName, String taskDetail, BuildContext context) async {
    _isLoading = true;
    update();
    Response response = await service.postData({
      "task_name": taskName,
      "task_detail": taskDetail,
    });
    _isLoading = false;

    if (response.statusCode == 200) {
      // Add the new task to the list
      _myData.add(response.body);
      update();
      if (context.mounted) {
        showCustomSnackBar(context, "Task added successfully");
        Get.back(); // Go back to the previous screen
      }
    } else {
      update();
      if (context.mounted) {
        showCustomSnackBar(context, "Failed to add task", isError: true);
      }
    }
  }

  Future<void> updateData(String id, String taskName, String taskDetail, BuildContext context) async {
    _isLoading = true;
    update();
    Response response = await service.updateData(id, {
      "task_name": taskName,
      "task_detail": taskDetail,
    });
    _isLoading = false;

    if (response.statusCode == 200) {
      // Find the index of the task to update
      var index = _myData.indexWhere((task) => task["id"].toString() == id.toString());
      if (index != -1) {
        _myData[index] = response.body;
      }
      update();
      if (context.mounted) {
        showCustomSnackBar(context, "Task updated successfully");
        Get.back(); // Go back to the previous screen
      }
    } else {
      update();
      if (context.mounted) {
        showCustomSnackBar(context, "Failed to update task", isError: true);
      }
    }
  }

  Future<void> deleteData(dynamic id, BuildContext context) async {
    _isLoading = true;
    update();

    final String taskId = id.toString();
    Response response = await service.deleteData(taskId);

    _isLoading = false;

    if (response.statusCode == 200) {
      // Remove the task from the list
      _myData.removeWhere((task) => task["id"].toString() == taskId);
      update();
      if (context.mounted) {
        showCustomSnackBar(context, "Task deleted successfully");
      }
    } else {
      update();
      if (context.mounted) {
        showCustomSnackBar(context, "Failed to delete task", isError: true);
      }
    }
  }
}
