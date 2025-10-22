import 'package:flutter/material.dart';
import 'models/doctor_availability.dart';
import 'services/firestore_service.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  Future<void> _addSampleAvailability() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Sample availability for Dr. Juan Pérez (doctor1)
      final availability1 = DoctorAvailability(
        id: 'avail1',
        date: DateTime.now().add(const Duration(days: 1)),
        startTime: '09:00',
        endTime: '10:00',
        doctorId: 'doctor1',
        isAvailable: true,
      );

      final availability2 = DoctorAvailability(
        id: 'avail2',
        date: DateTime.now().add(const Duration(days: 1)),
        startTime: '10:00',
        endTime: '11:00',
        doctorId: 'doctor1',
        isAvailable: true,
      );

      // Sample availability for Dra. María López (doctor2)
      final availability3 = DoctorAvailability(
        id: 'avail3',
        date: DateTime.now().add(const Duration(days: 2)),
        startTime: '14:00',
        endTime: '15:00',
        doctorId: 'doctor2',
        isAvailable: true,
      );

      await _firestoreService.createDoctorAvailability(availability1);
      await _firestoreService.createDoctorAvailability(availability2);
      await _firestoreService.createDoctorAvailability(availability3);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disponibilidad agregada exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar disponibilidad: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Agregar Disponibilidad')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Esta página permite agregar disponibilidad de médicos de ejemplo.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _addSampleAvailability,
                    child: const Text('Agregar Disponibilidad de Ejemplo'),
                  ),
          ],
        ),
      ),
    );
  }
}
