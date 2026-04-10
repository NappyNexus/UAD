import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../mock/mock_data.dart';
import '../models/payment_model.dart';
import '../models/student_model.dart';

class AdminRepository {
  /// Fetch all students in the system
  Future<List<StudentModel>> getAllStudents() async {
    return MockData.allStudentsList;
  }

  /// Fetch all academic programs
  Future<List<ProgramModel>> getAllPrograms() async {
    return MockData.programsList;
  }

  /// Fetch all academic periods
  Future<List<AcademicPeriodModel>> getAllPeriods() async {
    return MockData.academicPeriodsList;
  }

  /// Fetch audit logs
  Future<List<Map<String, dynamic>>> getAuditLogs() async {
    return MockData.auditLogList;
  }

  /// Fetch certificate requests
  Future<List<Map<String, dynamic>>> getCertificates() async {
    return MockData.certificatesList;
  }

  /// Fetch statistical data for reports
  Future<Map<String, dynamic>> getReportSummary() async {
    return MockData.reportSummary;
  }
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository();
});
