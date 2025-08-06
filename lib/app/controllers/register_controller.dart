import 'package:get/get.dart';
import 'package:flutter/material.dart';

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

  void registerAdmin(BuildContext context, GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    // Ici, ajouter la logique d'enregistrement local (SharedPreferences, SQLite, etc.)
    Future.delayed(Duration(seconds: 1), () {
      isLoading.value = false;
      Get.snackbar('Succès', 'Admin enregistré (logique à implémenter)', snackPosition: SnackPosition.BOTTOM);
    });
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
