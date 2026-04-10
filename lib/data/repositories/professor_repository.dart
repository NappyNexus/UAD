import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../mock/mock_data.dart';

class ProfessorRepository {
  /// Fetch courses taught by the professor
  Future<List<Map<String, dynamic>>> getTaughtCourses(
    String professorId,
  ) async {
    return MockData.professorCoursesList;
  }

  /// Fetch students enrolled in a specific course
  Future<List<Map<String, dynamic>>> getCourseStudents(String courseId) async {
    return MockData.professorStudentsList;
  }

  /// Update a student's grade (Mock)
  Future<void> updateGrade({
    required String studentId,
    required String courseId,
    required String gradeType,
    required double grade,
  }) async {
    // In mock mode, we just pretend it worked
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

final professorRepositoryProvider = Provider<ProfessorRepository>((ref) {
  return ProfessorRepository();
});
