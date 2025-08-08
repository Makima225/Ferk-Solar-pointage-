import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enregistrement Admin'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed('/scan'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: controller.nameCtrl,
                decoration: InputDecoration(labelText: 'Nom complet'),
                validator: controller.validateName,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: controller.usernameCtrl,
                decoration: InputDecoration(labelText: "Nom d'utilisateur"),
                validator: controller.validateUsername,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: controller.passwordCtrl,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: controller.validatePassword,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: controller.confirmCtrl,
                decoration: InputDecoration(labelText: 'Confirmer le mot de passe'),
                obscureText: true,
                validator: controller.validateConfirm,
              ),
              SizedBox(height: 24),
              controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => controller.registerAdmin(context, _formKey),
                      child: Text('Enregistrer'),
                    ),
            ],
          )),
        ),
      ),
    );
  }
}
