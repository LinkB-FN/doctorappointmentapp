import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart'; // NUEVO

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key}); // Constructors for public widgets should have a named 'key'

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DoctorAppointmentApp")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1. Campo de Email
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Correo electrónico",
                  border: OutlineInputBorder(),
                ), // InputDecoration
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa tu correo";
                  }
                  return null;
                },
              ), // TextFormField

              const SizedBox(height: 16),
              
              // 2. Campo de Contraseña
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ), // InputDecoration
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa tu contraseña";
                  }
                  return null;
                },
              ), // TextFormField
              
              const SizedBox(height: 24),
              
              // 3. Botón de Iniciar Sesión
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      UserCredential userCredential = 
                          await _auth.signInWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                      
                      // Éxito: Mostrar Snackbar y navegar a Home
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Bienvenido ${userCredential.user!.email}")), // Don't use 'BuildContext' across async gaps
                      );
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.home, // NUEVO
                      );
                    } on FirebaseAuthException catch (e) {
                      // Error: Manejo de Excepciones de Firebase
                      String message = "";
                      if (e.code == 'user-not-found') {
                        message = "Usuario no encontrado";
                      } else if (e.code == 'wrong-password') {
                        message = "Contraseña incorrecta";
                      } else {
                        message = e.message!;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  }
                },
                child: const Text("Iniciar sesión"),
              ), // ElevatedButton

              const SizedBox(height: 16),

              // 4. Botón de Cerrar Sesión (Útil para tests/debug en Login)
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sesión cerrada")),
                  );
                },
                child: const Text("Cerrar sesión"),
              ), // ElevatedButton

              const SizedBox(height: 16.0),

              // 5. Botón de Crear Cuenta
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cuenta creada para ${userCredential.user!.email}')),
                      );
                    } on FirebaseAuthException catch (e) {
                      String message = "";
                      if (e.code == 'weak-password') {
                        message = 'La contraseña es demasiado débil';
                      } else if (e.code == 'email-already-in-use') {
                        message = 'El correo electrónico ya está en uso';
                      } else if (e.code == 'invalid-email') {
                        message = 'El correo electrónico no es válido';
                      } else {
                        message = e.message!;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  }
                },
                child: const Text('Crear cuenta'),
              ),

              const SizedBox(height: 16.0),

              // 6. Botón de Olvidé mi Contraseña
              ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isNotEmpty) {
                    try {
                      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Correo de restablecimiento enviado')),
                      );
                    } on FirebaseAuthException catch (e) {
                      String message = "";
                      if (e.code == 'user-not-found') {
                        message = 'No se encontró el usuario';
                      } else if (e.code == 'invalid-email') {
                        message = 'El correo electrónico no es válido';
                      } else {
                        message = e.message!;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ingresa tu correo electrónico')),
                    );
                  }
                },
                child: const Text('Olvidé mi contraseña'),
              ),
            ],
          ), // Column
        ), // Form
      ), // Padding
    ); // Scaffold
  }
}