import 'package:doctorappointmentapp/pagina_inicio.dart';
import 'package:doctorappointmentapp/pagina_perfil.dart';
import 'package:doctorappointmentapp/pagina_privacidad.dart';
import 'package:doctorappointmentapp/pagina_sobre_nosotros.dart';
import 'package:doctorappointmentapp/pagina_citas.dart';
import 'package:doctorappointmentapp/pagina_admin.dart';
import 'package:flutter/material.dart';
import 'pagina_login.dart';

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
        return MaterialPageRoute(builder: (_) => PaginaLogin());
      case home:
        return MaterialPageRoute(builder: (_) => const PaginaInicio());
      case profile:
        return MaterialPageRoute(builder: (_) => const PaginaPerfil());
      case privacy:
        return MaterialPageRoute(builder: (_) => const PaginaPrivacidad());
      case aboutus:
        return MaterialPageRoute(builder: (_) => const PaginaSobreNosotros());
      case appointment:
        return MaterialPageRoute(builder: (_) => const PaginaCitas());
      case admin:
        return MaterialPageRoute(builder: (_) => const PaginaAdmin());
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