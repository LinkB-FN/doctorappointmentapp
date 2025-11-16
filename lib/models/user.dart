class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String medicalHistory;
  final String role; // "Paciente" o "Médico"

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.medicalHistory,
    this.role = 'Paciente', // Valor por defecto
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'medicalHistory': medicalHistory,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      medicalHistory: map['medicalHistory'] ?? '',
      role: map['role'] ?? 'Paciente',
    );
  }
}
