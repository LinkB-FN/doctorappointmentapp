import 'package:doctorappointmentapp/HomePage.dart';
import 'package:doctorappointmentapp/main.dart' hide LoginPage;
import 'package:doctorappointmentapp/profile_page.dart';
import 'package:doctorappointmentapp/PrivacyPage.dart';
import 'package:doctorappointmentapp/AboutUsPage.dart';
import 'package:doctorappointmentapp/appointment_page.dart';
import 'package:doctorappointmentapp/admin_page.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';

class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String privacy = '/privacy';
  static const String aboutus = '/aboutus';
  static const String appointment = '/appointment';
  static const String admin = '/admin';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case privacy:
        return MaterialPageRoute(builder: (_) => const PrivacyPage());
      case aboutus:
        return MaterialPageRoute(builder: (_) => const AboutUsPage());
      case appointment:
        return MaterialPageRoute(builder: (_) => const AppointmentPage());
      case admin:
        return MaterialPageRoute(builder: (_) => const AdminPage());
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