import 'package:doctorappointmentapp/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login de prueba', 
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login de prueba'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Correo electrónico', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      UserCredential userCredential = await auth.signInWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bienvenido ${userCredential.user!.email}')),
                      );
                    } on FirebaseAuthException catch (e) {
                      String message = "";
                      if (e.code == 'user-not-found') {
                        message = 'No se encontró el usuario';
                      } else if (e.code == 'wrong-password') {
                        message = 'Contraseña incorrecta';
                      } else {
                        message = e.message!;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                     
                    }
               },
                child: const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async{
                 await auth.signOut();
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Sesión cerrada')),
                 );/*  */
                },
                child: const Text('Cerrar sesión'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cuenta creada para ${userCredential.user!.email}')),
                      );
                    } on FirebaseAuthException catch (e) {
                      String message = "";
                      if (e.code == 'weak-password') {
                        message = 'La contraseña es demasiado débil';
                      } else if (e.code == 'email-already-in-use') {
                        message = 'El correo electrónico ya está en uso';
                      } else if (e.code == 'invalid-email') {
                        message = 'El correo electrónico no es válido';
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
              ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isNotEmpty) {
                    try {
                      await auth.sendPasswordResetEmail(email: emailController.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Correo de restablecimiento enviado')),
                      );
                    } on FirebaseAuthException catch (e) {
                      String message = "";
                      if (e.code == 'user-not-found') {
                        message = 'No se encontró el usuario';
                      } else if (e.code == 'invalid-email') {
                        message = 'El correo electrónico no es válido';
                      } else {
                        message = e.message!;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ingresa tu correo electrónico')),
                    );
                  }
                },
                child: const Text('Olvidé mi contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

