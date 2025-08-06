import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isAdminLogged = false.obs;
  var hasAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAdminExists();
  }

  Future<void> checkAdminExists() async {
    final prefs = await SharedPreferences.getInstance();
    hasAdmin.value = prefs.containsKey('admin_username');
  }

  Future<void> registerAdmin(String name, String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('admin_name', name);
    await prefs.setString('admin_username', username);
    await prefs.setString('admin_password', password);
    hasAdmin.value = true;
  }

  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString('admin_username');
    final storedPass = prefs.getString('admin_password');
    if (username == storedUser && password == storedPass) {
      isAdminLogged.value = true;
      return true;
    }
    return false;
  }

  void logout() {
    isAdminLogged.value = false;
  }
}
