import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'models/appointment.dart';
import 'models/doctor_availability.dart';
import 'services/firestore_service.dart';
import 'routes.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  String? _selectedDoctorId;
  List<DoctorAvailability> _availableSlots = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toLocal().toString().split(' ')[0];
        _loadAvailableSlots(picked);
      });
    }
  }

  Future<void> _loadAvailableSlots(DateTime date) async {
    if (_selectedDoctorId != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        _availableSlots = await _firestoreService.getAvailableSlots(date, _selectedDoctorId!);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar horarios disponibles: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _scheduleAppointment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = auth.FirebaseAuth.instance.currentUser;
        if (user != null && _selectedDoctorId != null) {
          final appointment = Appointment(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            date: DateTime.parse(_dateController.text),
            time: _timeController.text,
            patientId: user.uid,
            doctorId: _selectedDoctorId!,
            reason: _reasonController.text.trim(),
          );

          await _firestoreService.createAppointment(appointment);

          // Mark the slot as unavailable
          final slot = _availableSlots.firstWhere(
            (slot) => slot.startTime == _timeController.text,
            orElse: () => DoctorAvailability(
              id: '',
              date: DateTime.parse(_dateController.text),
              startTime: _timeController.text,
              endTime: '', // Assuming end time is start + 1 hour
              doctorId: _selectedDoctorId!,
              isAvailable: false,
            ),
          );
          if (slot.id.isNotEmpty) {
            final updatedSlot = DoctorAvailability(
              id: slot.id,
              date: slot.date,
              startTime: slot.startTime,
              endTime: slot.endTime,
              doctorId: slot.doctorId,
              isAvailable: false,
            );
            await _firestoreService.updateDoctorAvailability(updatedSlot);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cita agendada exitosamente')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agendar cita: $e')),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Agendar Cita')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Doctor selection (simplified, assuming a list of doctors)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Seleccionar Doctor'),
                  value: _selectedDoctorId,
                  items: const [
                    DropdownMenuItem(value: 'doctor1', child: Text('Dr. Juan Pérez')),
                    DropdownMenuItem(value: 'doctor2', child: Text('Dra. María López')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedDoctorId = value;
                      _availableSlots = []; // Clear previous slots
                      _timeController.clear(); // Clear selected time
                      if (_dateController.text.isNotEmpty) {
                        _loadAvailableSlots(DateTime.parse(_dateController.text));
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona un doctor';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(labelText: 'Fecha'),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona una fecha';
                    }
                    return null;
                  },
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else if (_availableSlots.isEmpty && _selectedDoctorId != null && _dateController.text.isNotEmpty)
                  const Text('No hay horarios disponibles para esta fecha y doctor')
                else
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Horario Disponible'),
                    value: _timeController.text.isEmpty ? null : _timeController.text,
                    items: _availableSlots.map((slot) {
                      return DropdownMenuItem(
                        value: slot.startTime,
                        child: Text('${slot.startTime} - ${slot.endTime}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _timeController.text = value ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona un horario';
                      }
                      return null;
                    },
                  ),
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(labelText: 'Motivo de la consulta'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el motivo de la consulta';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _scheduleAppointment,
                  child: const Text('Agendar Cita'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
