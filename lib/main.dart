
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/app_routes.dart';
import 'app/controllers/auth_controller.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Pointage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.scan,
      getPages: AppRoutes.routes,
    );
  }
}


