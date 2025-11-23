import 'package:frontendnew/screens/add_task.dart';
import 'package:frontendnew/screens/all_tasks.dart';
import 'package:frontendnew/screens/edit_task.dart';
import 'package:frontendnew/screens/home_screen.dart';
import 'package:frontendnew/screens/view_task.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String home = '/';
  static const String allTasks = '/all-tasks';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task';
  static const String viewTask = '/view-task';

  static final routes = [
    GetPage(
      name: home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: allTasks,
      page: () => const AllTasks(),
      transition: Transition.fade,
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: addTask,
      page: () => AddTask(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: editTask,
      page: () {
        final Map<String, dynamic> task = Get.arguments;
        return EditTask(task: task);
      },
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: viewTask,
      page: () {
        final Map<String, dynamic> task = Get.arguments;
        return ViewTask(task: task);
      },
      transition: Transition.downToUp,
    )
  ];
}
