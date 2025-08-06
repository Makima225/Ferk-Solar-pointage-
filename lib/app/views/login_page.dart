import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../app_routes.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userCtrl,
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            TextField(
              controller: passCtrl,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authController.login(userCtrl.text, passCtrl.text);
                if (authController.isAdminLogged.value) {
                  Get.offAllNamed(AppRoutes.dashboard);
                } else {
                  Get.snackbar('Erreur', 'Identifiants invalides');
                }
              },
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
