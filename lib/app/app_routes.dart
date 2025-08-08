import 'package:get/get.dart';
import 'views/scan_page.dart';
import 'views/login_page.dart';
import 'views/dashboard_admin.dart';
import 'views/register_page.dart';
import 'views/projet_page.dart';
import 'models/projet_model.dart';
import 'middlewares/admin_auth_middleware.dart';

class AppRoutes {
  static const String scan = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String projet = '/projet';

  static final routes = [
    GetPage(
      name: scan,
      page: () => ScanPage(),
    ),
    GetPage(
      name: login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: register,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: dashboard,
      page: () => DashboardAdmin(),
      middlewares: [AdminAuthMiddleware()],
    ),
    GetPage(
      name: projet,
      page: () {
        final projet = Get.arguments as Projet;
        return ProjetPage(projet: projet);
      },
    ),
  ];
}
