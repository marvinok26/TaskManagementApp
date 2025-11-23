import 'package:flutter/material.dart';
import 'package:frontendnew/controllers/data_controller.dart';
import 'package:frontendnew/routes/app_routes.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  loadData() async {
    await Get.find<DataController>().getData();
  }

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => DataController());
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,
    );
  }
}
