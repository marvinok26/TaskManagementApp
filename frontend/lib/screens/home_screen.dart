import 'package:flutter/material.dart';
import 'package:frontendnew/colors/app_colors.dart';
import 'package:frontendnew/routes/app_routes.dart';
import 'package:frontendnew/widgets/button_widget.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Hello",
                    style: TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "\nStart your beautiful day",
                        style: TextStyle(
                          color: AppColors.smallTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 2.5),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.addTask);
                  },
                  child: ButtonWidget(
                    backgroundcolor: AppColors.mainColor,
                    textColor: Colors.white,
                    text: "Add Task",
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.allTasks);
                  },
                  child: ButtonWidget(
                    backgroundcolor: Colors.white,
                    textColor: AppColors.smallTextColor,
                    text: "View All",
                  ),
                ),
              ],
            ),
          ),
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/welcome.jpg"),
          ),
        ),
      ), // Container
    ); //Container
  }
}
