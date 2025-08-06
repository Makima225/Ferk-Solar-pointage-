import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../app_routes.dart';

class AdminAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final isLogged = Get.find<AuthController>().isAdminLogged.value;
    if (!isLogged) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}
