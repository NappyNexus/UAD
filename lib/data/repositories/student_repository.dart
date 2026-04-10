import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../mock/mock_data.dart';
import '../models/course_model.dart';
import '../models/grade_model.dart';
import '../models/student_model.dart';
import '../models/payment_model.dart';

class StudentRepository {
  /// Fetch student profile by matricula (id)
  Future<StudentModel> getStudentProfile(String matricula) async {
    // For now, always return the mock student
    return MockData.currentStudent;
  }

  /// Fetch courses currently enrolled
  Future<List<CourseModel>> getCurrentEnrollments(String matricula) async {
    return MockData.enrolledCourses;
  }

  /// Fetch historical grades
  Future<List<GradeModel>> getGradeHistory(String matricula) async {
    return MockData.gradeHistory;
  }

  /// Fetch announcements targeting the student
  Future<List<Map<String, dynamic>>> getAnnouncements(String matricula) async {
    return MockData.announcements;
  }

  /// Fetch payment history
  Future<List<PaymentModel>> getPaymentHistory(String matricula) async {
    return MockData.payments;
  }

  /// Fetch available courses for selection
  Future<List<CourseModel>> getAvailableCourses(String matricula) async {
    return MockData.availableCourses;
  }

  /// Fetch student requests
  Future<List<Map<String, dynamic>>> getStudentRequests(String matricula) async {
    // Simple mock for requests
    return [
      { 'id': "REQ-001", 'type': "Certificado de Estudios", 'date': "2024-10-01", 'status': "Completada", 'details': "Certificado para beca externa" },
      { 'id': "REQ-002", 'type': "Revisión de Calificación", 'date': "2024-10-05", 'status': "En proceso", 'details': "Revisión nota final" },
    ];
  }

  /// Dummy method for financial balance
  Future<double> getFinancialBalance(String matricula) async {
    return MockData.currentStudent.balance;
  }
}

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository();
});
