import 'package:flutter/material.dart';
import 'package:frontendnew/colors/app_colors.dart';
import 'package:frontendnew/controllers/data_controller.dart';
import 'package:frontendnew/utils/show_snackbar.dart';
import 'package:frontendnew/widgets/button_widget.dart';
import 'package:frontendnew/widgets/textfield_widget.dart';
import 'package:get/get.dart';

class EditTask extends StatelessWidget {
  final Map<String, dynamic> task;
  const EditTask({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: task['task_name']);
    final TextEditingController detailController =
        TextEditingController(text: task['task_detail']);

    void _dataValidation(BuildContext context) {
      if (nameController.text.trim() == '') {
        showCustomSnackBar(context, "Task name is empty", isError: true);
      } else if (detailController.text.trim() == '') {
        showCustomSnackBar(context, "Task detail is empty", isError: true);
      } else {
        Get.find<DataController>().updateData(
          task['id'],
          nameController.text,
          detailController.text,
          context,
        );
      }
    }

    return Scaffold(
      body: Builder(builder: (context) {
        return Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/addtask2.jpg"),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.arrow_back,
                                color: AppColors.secondaryColor),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          TextFieldWidget(
                            textController: nameController,
                            hintText: "Task name",
                          ),
                          const SizedBox(height: 20),
                          TextFieldWidget(
                            textController: detailController,
                            hintText: "Task detail",
                            borderRadius: 15,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              _dataValidation(context);
                            },
                            child: ButtonWidget(
                              backgroundcolor: AppColors.mainColor,
                              text: "Update",
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
