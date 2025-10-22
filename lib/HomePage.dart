import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart'; // NUEVO

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Menú Principal")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Esta será la pantalla de Menú Principal",
              style: TextStyle(fontSize: 18),
            ), // Text
            
            const SizedBox(height: 20),

            // Botón para ir al perfil
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.profile); // NUEVO
              },
              child: const Text("Ir a Perfil"),
            ), // ElevatedButton

            const SizedBox(height: 20),

            // Botón para cerrar sesión
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut(); // NUEVO
                Navigator.pushReplacementNamed(context, Routes.login); // NUEVO
              },
              child: const Text("Cerrar sesión"), // NUEVO
            ), // ElevatedButton
          ],
        ), // Column
      ), // Center
    ); // Scaffold
  }
}