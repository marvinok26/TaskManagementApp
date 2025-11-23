import 'package:flutter/material.dart';
import 'package:frontendnew/colors/app_colors.dart';
import 'package:frontendnew/widgets/button_widget.dart';
import 'package:frontendnew/widgets/textfield_widget.dart';
import 'package:get/get.dart';

class AddTask extends StatelessWidget {
  AddTask({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  void _dataValidation() {
    if (nameController.text.trim() == '') {
      Get.snackbar("Task name", "Task name is empty");
    } else if (detailController.text.trim() == '') {
      Get.snackbar("Task detail", "Task detail is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Container(
          width: double.maxFinite,
          height: double.maxFinite,
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/addtask1.jpg"),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 40),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon:
                        Icon(Icons.arrow_back, color: AppColors.secondaryColor),
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
                      _dataValidation();
                    },
                    child: ButtonWidget(
                      backgroundcolor: AppColors.mainColor,
                      text: "Add",
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20),
            ],
          ),
        );
      }),
    );
  }
}
