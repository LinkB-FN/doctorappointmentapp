import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacidad")),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            "Política de Privacidad\n\n"
            "En DoctorAppointmentApp, nos comprometemos a proteger tu privacidad. "
            "Recopilamos información personal solo para mejorar nuestros servicios. "
            "Tus datos se almacenan de forma segura y no se comparten con terceros sin tu consentimiento. "
            "Para más detalles, contacta con nosotros.",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
