import 'dart:math';

import 'package:flutter/material.dart';
import 'routes.dart';

class PaginaSobreNosotros extends StatelessWidget {
  const PaginaSobreNosotros({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1730),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF001F3F),
              Color(0xFF240046),
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: min(600.0, max(350.0, MediaQuery.of(context).size.width * 0.8)),
            height: MediaQuery.of(context).size.height * 0.85,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SOBRE NOSOTROS",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sobre DoctorAppointmentApp",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Sobre DoctorAppointmentApp\n\n"
                    "DoctorAppointmentApp es una aplicación diseñada para facilitar la reserva de citas médicas. "
                    "Conectamos a pacientes con doctores de diversas especialidades de manera rápida y segura. "
                    "Nuestro objetivo es mejorar la experiencia de atención médica mediante tecnología innovadora. "
                    "¡Gracias por usar nuestra app!",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Routes.home);
                    },
                    child: const Text("Volver a Inicio"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
