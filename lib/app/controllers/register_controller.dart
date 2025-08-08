
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class RegisterController extends GetxController {
  final nameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  var isLoading = false.obs;

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Champ requis';
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Champ requis';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Champ requis';
    return null;
  }

  String? validateConfirm(String? value) {
    if (value == null || value.isEmpty) return 'Champ requis';
    if (value != passwordCtrl.text) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  Future<void> registerAdmin(BuildContext context, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final user = User(
        name: nameCtrl.text.trim(),
        username: usernameCtrl.text.trim(),
        password: passwordCtrl.text,
      );
      await UserService().insertUser(user);
      isLoading.value = false;
      Get.snackbar('Succès', 'Admin enregistré avec succès', snackPosition: SnackPosition.BOTTOM);
      Future.delayed(const Duration(milliseconds: 800), () {
        Get.offAllNamed('/login');
      });
    } catch (e) {
      isLoading.value = false;
      String errorMsg = e.toString();
      if (errorMsg.contains('UNIQUE constraint failed')) {
        Get.snackbar('Erreur', 'Nom d\'utilisateur déjà utilisé', snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Erreur', 'Erreur lors de l\'enregistrement : $errorMsg', snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    super.onClose();
  }
}
