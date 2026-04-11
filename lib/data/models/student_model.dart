/// Represents a student in the UNAD system.
class StudentModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String cedula;
  final String program;
  final int semester;
  final double gpa;
  final String status;
  final int currentCredits;
  final int cumulativeCredits;
  final int totalCredits;
  final double balance;
  final String? photo;
  final String? emergencyContact;

  const StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.cedula,
    required this.program,
    required this.semester,
    required this.gpa,
    this.status = 'Activo',
    required this.currentCredits,
    required this.cumulativeCredits,
    required this.totalCredits,
    required this.balance,
    this.photo,
    this.emergencyContact,
  });

  /// Progress percentage (cumulative credits / total credits).
  double get progressPercent =>
      totalCredits > 0 ? (cumulativeCredits / totalCredits) * 100 : 0;

  StudentModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? cedula,
    String? program,
    int? semester,
    double? gpa,
    String? status,
    int? currentCredits,
    int? cumulativeCredits,
    int? totalCredits,
    double? balance,
    String? photo,
    String? emergencyContact,
  }) {
    return StudentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      cedula: cedula ?? this.cedula,
      program: program ?? this.program,
      semester: semester ?? this.semester,
      gpa: gpa ?? this.gpa,
      status: status ?? this.status,
      currentCredits: currentCredits ?? this.currentCredits,
      cumulativeCredits: cumulativeCredits ?? this.cumulativeCredits,
      totalCredits: totalCredits ?? this.totalCredits,
      balance: balance ?? this.balance,
      photo: photo ?? this.photo,
      emergencyContact: emergencyContact ?? this.emergencyContact,
    );
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      cedula: json['cedula'] as String? ?? '',
      program: json['program'] as String,
      semester: json['semester'] as int,
      gpa: (json['gpa'] as num).toDouble(),
      status: json['status'] as String? ?? 'Activo',
      currentCredits: json['current_credits'] as int? ?? 0,
      cumulativeCredits: json['cumulative_credits'] as int? ?? 0,
      totalCredits: json['total_credits'] as int? ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      photo: json['photo'] as String?,
      emergencyContact: json['emergency_contact'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'cedula': cedula,
    'program': program,
    'semester': semester,
    'gpa': gpa,
    'status': status,
    'current_credits': currentCredits,
    'cumulative_credits': cumulativeCredits,
    'total_credits': totalCredits,
    'balance': balance,
    'photo': photo,
    'emergency_contact': emergencyContact,
  };
}
