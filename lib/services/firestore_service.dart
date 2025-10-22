import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/appointment.dart';
import '../models/doctor_availability.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _users => _firestore.collection('usuarios');
  CollectionReference get _appointments => _firestore.collection('citas');
  CollectionReference get _doctorAvailability => _firestore.collection('disponibilidad_medicos');

  // User CRUD operations
  Future<void> createUser(User user) async {
    await _users.doc(user.id).set(user.toMap());
  }

  Future<User?> getUser(String userId) async {
    DocumentSnapshot doc = await _users.doc(userId).get();
    if (doc.exists) {
      return User.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    await _users.doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String userId) async {
    await _users.doc(userId).delete();
  }

  // Appointment CRUD operations
  Future<void> createAppointment(Appointment appointment) async {
    await _appointments.doc(appointment.id).set(appointment.toMap());
  }

  Future<Appointment?> getAppointment(String appointmentId) async {
    DocumentSnapshot doc = await _appointments.doc(appointmentId).get();
    if (doc.exists) {
      return Appointment.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Appointment>> getAppointmentsForUser(String userId) async {
    QuerySnapshot query = await _appointments.where('patientId', isEqualTo: userId).get();
    return query.docs.map((doc) => Appointment.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> updateAppointment(Appointment appointment) async {
    await _appointments.doc(appointment.id).update(appointment.toMap());
  }

  Future<void> deleteAppointment(String appointmentId) async {
    await _appointments.doc(appointmentId).delete();
  }

  // Doctor Availability CRUD operations
  Future<void> createDoctorAvailability(DoctorAvailability availability) async {
    await _doctorAvailability.doc(availability.id).set(availability.toMap());
  }

  Future<DoctorAvailability?> getDoctorAvailability(String availabilityId) async {
    DocumentSnapshot doc = await _doctorAvailability.doc(availabilityId).get();
    if (doc.exists) {
      return DoctorAvailability.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<DoctorAvailability>> getDoctorAvailabilityForDoctor(String doctorId) async {
    QuerySnapshot query = await _doctorAvailability.where('doctorId', isEqualTo: doctorId).get();
    return query.docs.map((doc) => DoctorAvailability.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<DoctorAvailability>> getAvailableSlots(DateTime date, String doctorId) async {
    // Query by doctorId and isAvailable only to avoid composite index requirement
    QuerySnapshot query = await _doctorAvailability
        .where('doctorId', isEqualTo: doctorId)
        .where('isAvailable', isEqualTo: true)
        .get();

    // Filter by date in code
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    List<DoctorAvailability> slots = query.docs
        .map((doc) => DoctorAvailability.fromMap(doc.data() as Map<String, dynamic>))
        .where((slot) => slot.date.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
                         slot.date.isBefore(endOfDay))
        .toList();

    return slots;
  }

  Future<void> updateDoctorAvailability(DoctorAvailability availability) async {
    await _doctorAvailability.doc(availability.id).update(availability.toMap());
  }

  Future<void> deleteDoctorAvailability(String availabilityId) async {
    await _doctorAvailability.doc(availabilityId).delete();
  }
}
