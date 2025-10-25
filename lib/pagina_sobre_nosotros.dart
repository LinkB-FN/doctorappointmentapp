import 'package:flutter/material.dart';

class PaginaSobreNosotros extends StatelessWidget {
  const PaginaSobreNosotros({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sobre nosotros")),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            "Sobre DoctorAppointmentApp\n\n"
            "DoctorAppointmentApp es una aplicación diseñada para facilitar la reserva de citas médicas. "
            "Conectamos a pacientes con doctores de diversas especialidades de manera rápida y segura. "
            "Nuestro objetivo es mejorar la experiencia de atención médica mediante tecnología innovadora. "
            "¡Gracias por usar nuestra app!",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
