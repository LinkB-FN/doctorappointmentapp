import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'routes.dart';
import 'models/user.dart';
import 'services/firestore_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final user = auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await _firestoreService.getUser(user.uid);
      if (userData != null) {
        setState(() {
          _nameController.text = userData.name;
          _phoneController.text = userData.phone;
          _medicalHistoryController.text = userData.medicalHistory;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = auth.FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userData = User(
            id: user.uid,
            name: _nameController.text.trim(),
            email: user.email ?? '',
            phone: _phoneController.text.trim(),
            medicalHistory: _medicalHistoryController.text.trim(),
          );

          await _firestoreService.createUser(userData);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil guardado exitosamente')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar perfil: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu teléfono';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _medicalHistoryController,
                  decoration: const InputDecoration(labelText: 'Historial médico'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu historial médico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Guardar'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushReplacementNamed(context, Routes.login);
                  },
                  child: const Text("Cerrar sesión"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
