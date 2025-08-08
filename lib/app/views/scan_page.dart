import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class ScanPage extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: ElevatedButton(
              onPressed: () async {
                await authController.checkAdminExists();
                if (authController.hasAdmin.value) {
                  Get.toNamed('/login');
                } else {
                  Get.toNamed('/register');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Admin', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Center(child: Text('Page de scan')),
    );
  }
}
