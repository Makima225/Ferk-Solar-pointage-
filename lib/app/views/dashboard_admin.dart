import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../app_routes.dart';

class DashboardAdmin extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authController.logout();
              Get.offAllNamed(AppRoutes.scan);
            },
          ),
        ],
      ),
      body: Center(child: Text('Bienvenue, Admin!')),
    );
  }
}
