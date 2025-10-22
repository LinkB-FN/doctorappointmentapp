class Appointment {
  final String id;
  final DateTime date;
  final String time;
  final String patientId;
  final String doctorId;
  final String reason;

  Appointment({
    required this.id,
    required this.date,
    required this.time,
    required this.patientId,
    required this.doctorId,
    required this.reason,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'time': time,
      'patientId': patientId,
      'doctorId': doctorId,
      'reason': reason,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      time: map['time'] ?? '',
      patientId: map['patientId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      reason: map['reason'] ?? '',
    );
  }
}
