import 'package:flutter/material.dart';

import '../../presentation/login_screen.dart';
import 'app_route_name.dart';

class AppRoute {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteName.home:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
    }

    return null;
  }
}
