import 'package:get/get.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

class AuthController extends GetxController {
  var isAdminLogged = false.obs;
  var hasAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAdminExists();
  }


  Future<void> checkAdminExists() async {
    hasAdmin.value = await UserService().hasAnyUser();
  }


  Future<void> registerAdmin(String name, String username, String password) async {
    final user = User(name: name, username: username, password: password);
    await UserService().insertUser(user);
    hasAdmin.value = true;
  }


  Future<bool> login(String username, String password) async {
    final user = await UserService().getUserByUsername(username);
    if (user != null && user.password == password) {
      isAdminLogged.value = true;
      return true;
    }
    return false;
  }

  void logout() {
    isAdminLogged.value = false;
  }
}
