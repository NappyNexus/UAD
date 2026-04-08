/// Represents a course in the UNAD system.
class CourseModel {
  final String id;
  final String name;
  final int credits;
  final String professor;
  final String schedule;
  final String room;
  final int enrolled;
  final int capacity;
  final String? prerequisite;
  final String status;
  final String? program;
  final int? semester;

  const CourseModel({
    required this.id,
    required this.name,
    required this.credits,
    required this.professor,
    required this.schedule,
    required this.room,
    required this.enrolled,
    required this.capacity,
    this.prerequisite,
    this.status = 'Activo',
    this.program,
    this.semester,
  });

  bool get isFull => enrolled >= capacity;

  CourseModel copyWith({
    String? id,
    String? name,
    int? credits,
    String? professor,
    String? schedule,
    String? room,
    int? enrolled,
    int? capacity,
    String? prerequisite,
    String? status,
    String? program,
    int? semester,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      credits: credits ?? this.credits,
      professor: professor ?? this.professor,
      schedule: schedule ?? this.schedule,
      room: room ?? this.room,
      enrolled: enrolled ?? this.enrolled,
      capacity: capacity ?? this.capacity,
      prerequisite: prerequisite ?? this.prerequisite,
      status: status ?? this.status,
      program: program ?? this.program,
      semester: semester ?? this.semester,
    );
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      credits: json['credits'] as int,
      professor: json['professor'] as String? ?? '',
      schedule: json['schedule'] as String? ?? '',
      room: json['room'] as String? ?? '',
      enrolled: json['enrolled'] as int? ?? 0,
      capacity: json['capacity'] as int? ?? 0,
      prerequisite: json['prerequisite'] as String?,
      status: json['status'] as String? ?? 'Activo',
      program: json['program'] as String?,
      semester: json['semester'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'credits': credits,
    'professor': professor,
    'schedule': schedule,
    'room': room,
    'enrolled': enrolled,
    'capacity': capacity,
    'prerequisite': prerequisite,
    'status': status,
    'program': program,
    'semester': semester,
  };
}
