
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/app_routes.dart';
import 'app/controllers/auth_controller.dart';
import 'app/views/register_page.dart';
import 'app/views/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Pointage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Obx(() {
        // Affiche RegisterPage si aucun admin, sinon LoginPage
        if (!authController.hasAdmin.value) {
          return RegisterPage();
        } else {
          return LoginPage();
        }
      }),
      getPages: AppRoutes.routes,
    );
  }
}


