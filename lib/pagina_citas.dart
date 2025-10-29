import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firestore_service.dart';
import 'routes.dart';

class PaginaCitas extends StatefulWidget {
  const PaginaCitas({super.key});

  @override
  State<PaginaCitas> createState() => PaginaCitasState();
}

class PaginaCitasState extends State<PaginaCitas> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController motivoController = TextEditingController();

  String? nombreUsuario;
  DateTime? fechaSeleccionada;
  String? citaEnEdicion; // ID de la cita que estamos editando

  @override
  void initState() {
    super.initState();
    cargarNombreUsuario();
  }

  // Cargar el nombre del usuario desde Firestore usando el servicio
  Future<void> cargarNombreUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await _firestoreService.getUser(user.uid);
      if (userData != null && userData.name.isNotEmpty) {
        setState(() {
          nombreUsuario = userData.name;
        });
      } else {
        setState(() {
          nombreUsuario = user.displayName ?? user.email ?? 'Usuario sin nombre';
        });
      }
    } else {
      setState(() {
        nombreUsuario = 'Usuario no autenticado';
      });
    }
  }

  // Seleccionar fecha y hora
  Future<void> seleccionarFechaYHora() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(fechaSeleccionada ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          fechaSeleccionada = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  // Agregar o actualizar cita
  Future<void> guardarCita() async {
    if (motivoController.text.isEmpty || fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    final data = {
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'nombreUsuario': nombreUsuario ?? 'Sin nombre',
      'motivo': motivoController.text.trim(),
      'fechaHora': Timestamp.fromDate(fechaSeleccionada!),
      'creadoEn': FieldValue.serverTimestamp(),
    };

    if (citaEnEdicion == null) {
      await firestore.collection('citas').add(data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cita creada')));
    } else {
      await firestore.collection('citas').doc(citaEnEdicion).update(data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cita actualizada')));
    }
    
    // Este bloque viene de una imagen separada y parece ser parte de otra función
    // o el final de la función guardarCita. Lo coloco aquí como una pieza suelta.
    motivoController.clear();
    setState(() {
      fechaSeleccionada = null;
      citaEnEdicion = null;
    });
  }

  // Eliminar cita
  Future<void> eliminarCita(String id) async {
    await firestore.collection('citas').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cita eliminada')));
  }

  // Preparar cita para edición
  void editarCita(String id, Map<String, dynamic> data) {
    setState(() {
      citaEnEdicion = id;
      motivoController.text = data['motivo'] ?? '';
      fechaSeleccionada = (data['fechaHora'] as Timestamp?)?.toDate() ?? DateTime.now();
    });
  }

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
            width: 350,
            height: MediaQuery.of(context).size.height * 0.9,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "CITAS",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Routes.home);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nombreUsuario == null
                        ? 'Cargando...'
                        : 'Usuario: $nombreUsuario',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.3),
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextField(
                      controller: motivoController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          fechaSeleccionada == null
                              ? 'No se ha seleccionado fecha y hora'
                              : 'Fecha: ${fechaSeleccionada.toString()}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, color: Colors.white),
                        onPressed: seleccionarFechaYHora,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.withOpacity(0.9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        elevation: 0,
                      ),
                      onPressed: guardarCita,
                      child: Text(
                        citaEnEdicion == null ? 'Programar cita' : 'Guardar cambios',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "CITAS PROGRAMADAS",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: firestore
                          .collection('citas')
                          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('Error al cargar citas', style: TextStyle(color: Colors.white)));
                        }
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final citas = snapshot.data!.docs..sort((a, b) {
                          final aFecha = (a.data() as Map<String, dynamic>)['fechaHora'] as Timestamp?;
                          final bFecha = (b.data() as Map<String, dynamic>)['fechaHora'] as Timestamp?;
                          if (aFecha == null && bFecha == null) return 0;
                          if (aFecha == null) return 1;
                          if (bFecha == null) return -1;
                          return aFecha.compareTo(bFecha);
                        });

                        if (citas.isEmpty) {
                          return const Center(child: Text('No hay citas programadas', style: TextStyle(color: Colors.white)));
                        }

                        return ListView.builder(
                          itemCount: citas.length,
                          itemBuilder: (context, index) {
                            final cita = citas[index];
                            final data = cita.data() as Map<String, dynamic>;
                            final fecha = (data['fechaHora'] as Timestamp?)?.toDate();

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.3),
                                border: Border.all(color: Colors.white24),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: ListTile(
                                title: Text(
                                  "${data['motivo'] ?? 'Sin motivo'} (${data['nombreUsuario'] ?? 'Desconocido'})",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Fecha: ${fecha ?? 'Sin fecha'}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => editarCita(cita.id, data),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => eliminarCita(cita.id),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
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