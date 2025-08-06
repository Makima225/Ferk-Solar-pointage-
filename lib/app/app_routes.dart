import 'package:get/get.dart';
import 'views/scan_page.dart';
import 'views/login_page.dart';
import 'views/dashboard_admin.dart';
import 'middlewares/admin_auth_middleware.dart';

class AppRoutes {
  static const String scan = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';

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
      name: dashboard,
      page: () => DashboardAdmin(),
      middlewares: [AdminAuthMiddleware()],
    ),
  ];
}
