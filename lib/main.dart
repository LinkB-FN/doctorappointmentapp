import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'routes.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:html' as html; // Solo afecta Web

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AudioController(child: MyApp()));
}

class AudioController extends StatefulWidget {
  final Widget child;
  const AudioController({super.key, required this.child});

  @override
  State<AudioController> createState() => _AudioControllerState();
}

class _AudioControllerState extends State<AudioController> {
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await audioPlayer.setSource(AssetSource('og.mp3'));
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.resume();
      print('✅ Música de fondo iniciada');
    } catch (e) {
      print('⚠️ Error al iniciar música: $e');
    }

    // Si Chrome bloquea autoplay, reintentar tras un clic
    html.window.onClick.listen((_) async {
      if (audioPlayer.state != PlayerState.playing) {
        try {
          await audioPlayer.resume();
          print('🎵 Música iniciada tras clic del usuario');
        } catch (e) {
          print('⚠️ Error al reintentar música: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoctorAppointmentApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'BurbankBigCondensed',
        primaryColor: const Color(0xFF87CEEB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF87CEEB),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF87CEEB),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF87CEEB), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
      initialRoute: Routes.login,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
