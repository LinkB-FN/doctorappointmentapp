import 'package:doctorappointmentapp/HomePage.dart';
import 'package:doctorappointmentapp/main.dart' hide LoginPage;
import 'package:doctorappointmentapp/profile_page.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';

class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ), // Center
          ), // Scaffold
        ); // MaterialPageRoute
    }
  }
}