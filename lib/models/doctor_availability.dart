class DoctorAvailability {
  final String id;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String doctorId;
  final bool isAvailable;

  DoctorAvailability({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.doctorId,
    required this.isAvailable,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'doctorId': doctorId,
      'isAvailable': isAvailable,
    };
  }

  factory DoctorAvailability.fromMap(Map<String, dynamic> map) {
    return DoctorAvailability(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      doctorId: map['doctorId'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
    );
  }
}
