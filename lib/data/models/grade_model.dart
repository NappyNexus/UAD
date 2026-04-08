/// A single grade entry for a student within a course.
class GradeModel {
  final String courseId;
  final String courseName;
  final int credits;
  final String professor;
  final double? midterm1;
  final double? midterm2;
  final double? finalExam;
  final double? finalGrade;
  final String? letterGrade;
  final String semester;
  final String status; // "En curso", "Aprobada", "Reprobada", "Retiro"

  const GradeModel({
    required this.courseId,
    required this.courseName,
    required this.credits,
    required this.professor,
    this.midterm1,
    this.midterm2,
    this.finalExam,
    this.finalGrade,
    this.letterGrade,
    required this.semester,
    this.status = 'En curso',
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      courseId: json['course_id'] as String,
      courseName: json['course_name'] as String,
      credits: json['credits'] as int,
      professor: json['professor'] as String? ?? '',
      midterm1: (json['midterm1'] as num?)?.toDouble(),
      midterm2: (json['midterm2'] as num?)?.toDouble(),
      finalExam: (json['final_exam'] as num?)?.toDouble(),
      finalGrade: (json['final_grade'] as num?)?.toDouble(),
      letterGrade: json['letter_grade'] as String?,
      semester: json['semester'] as String,
      status: json['status'] as String? ?? 'En curso',
    );
  }

  Map<String, dynamic> toJson() => {
    'course_id': courseId,
    'course_name': courseName,
    'credits': credits,
    'professor': professor,
    'midterm1': midterm1,
    'midterm2': midterm2,
    'final_exam': finalExam,
    'final_grade': finalGrade,
    'letter_grade': letterGrade,
    'semester': semester,
    'status': status,
  };
}
