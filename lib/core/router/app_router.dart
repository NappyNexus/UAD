import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../views/auth/auth_screen.dart';
import '../../views/shell/app_shell.dart';
import '../../views/student/student_dashboard_screen.dart';
import '../../views/student/payments_screen.dart';
import '../../views/student/grades_screen.dart';
import '../../views/student/course_selection_screen.dart';
import '../../views/student/schedule_screen.dart';
import '../../views/student/academic_record_screen.dart';
import '../../views/student/study_plan_screen.dart';
import '../../views/student/progress_screen.dart';
import '../../views/student/requests_screen.dart';
import '../../views/student/student_profile_screen.dart';
import '../../views/professor/professor_courses_screen.dart';
import '../../views/professor/grade_entry_screen.dart';
import '../../views/professor/attendance_screen.dart';
import '../../views/professor/course_announcements_screen.dart';
import '../../views/professor/grade_analytics_screen.dart';
import '../../views/professor/course_calendar_screen.dart';
import '../../views/professor/course_profile_screen.dart';
import '../../views/professor/grade_revisions_screen.dart';
import '../../views/admin/admin_dashboard_screen.dart';
import '../../views/admin/admin_students_screen.dart';
import '../../views/admin/admin_programs_screen.dart';
import '../../views/admin/admin_courses_screen.dart';
import '../../views/admin/admin_periods_screen.dart';
import '../../views/admin/admin_reports_screen.dart';
import '../../views/admin/admin_users_screen.dart';
import '../../views/admin/admin_certificates_screen.dart';
import '../../views/admin/audit_log_screen.dart';

import '../../views/registrar/registrar_enrollment_screen.dart';
import '../../views/registrar/registrar_requests_screen.dart';

import '../../views/shared/messaging_screen.dart';
import '../../views/shared/resources_screen.dart';
import '../../views/shared/surveys_screen.dart';
import '../../views/shared/academic_calendar_screen.dart';
import '../../views/shared/settings_screen.dart';

/// GoRouter configuration for the app.
GoRouter createRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppConstants.routeAuth,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final isAuthRoute = state.matchedLocation == AppConstants.routeAuth;

      // If not authenticated and not on auth route, redirect to login
      if (!auth.isAuthenticated && !isAuthRoute) {
        return AppConstants.routeAuth;
      }

      return null;
    },
    routes: [
      // ── Auth Routes ──
      GoRoute(
        path: AppConstants.routeAuth,
        builder: (context, state) => const AuthScreen(),
      ),

      // ── Shell Route (authenticated screens) ──
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          // Student
          GoRoute(
            path: AppConstants.routeStudentDashboard,
            builder: (_, _) => const StudentDashboardScreen(),
          ),
          GoRoute(
            path: AppConstants.routePayments,
            builder: (_, _) => const PaymentsScreen(),
          ),
          GoRoute(
            path: AppConstants.routeGrades,
            builder: (_, _) => const GradesScreen(),
          ),
          GoRoute(
            path: AppConstants.routeCourseSelection,
            builder: (_, _) => const CourseSelectionScreen(),
          ),
          GoRoute(
            path: AppConstants.routeSchedule,
            builder: (_, _) => const ScheduleScreen(),
          ),
          GoRoute(
            path: AppConstants.routeAcademicRecord,
            builder: (_, _) => const AcademicRecordScreen(),
          ),
          GoRoute(
            path: AppConstants.routeStudyPlan,
            builder: (_, _) => const StudyPlanScreen(),
          ),
          GoRoute(
            path: AppConstants.routeProgress,
            builder: (_, _) => const ProgressScreen(),
          ),
          GoRoute(
            path: AppConstants.routeRequests,
            builder: (_, _) => const RequestsScreen(),
          ),
          GoRoute(
            path: AppConstants.routeStudentProfile,
            builder: (_, _) => const StudentProfileScreen(),
          ),

          // Professor
          GoRoute(
            path: AppConstants.routeProfessorCourses,
            builder: (_, _) => const ProfessorCoursesScreen(),
          ),
          GoRoute(
            path: AppConstants.routeGradeEntry,
            builder: (_, _) => const GradeEntryScreen(),
          ),
          GoRoute(
            path: AppConstants.routeAttendance,
            builder: (_, _) => const AttendanceScreen(),
          ),
          GoRoute(
            path: AppConstants.routeCourseAnnouncements,
            builder: (_, _) => const CourseAnnouncementsScreen(),
          ),
          GoRoute(
            path: AppConstants.routeGradeAnalytics,
            builder: (_, _) => const GradeAnalyticsScreen(),
          ),
          GoRoute(
            path: AppConstants.routeCourseCalendar,
            builder: (_, _) => const CourseCalendarScreen(),
          ),
          GoRoute(
            path: AppConstants.routeCourseProfile,
            builder: (_, _) => const CourseProfileScreen(),
          ),
          GoRoute(
            path: AppConstants.routeGradeRevisions,
            builder: (_, _) => const GradeRevisionsScreen(),
          ),

          // Admin
          GoRoute(
            path: AppConstants.routeAdminDashboard,
            builder: (_, _) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: AppConstants.routeAdminStudents,
            builder: (_, _) => const AdminStudentsScreen(),
          ),
          GoRoute(
            path: AppConstants.routeAdminPrograms,
            builder: (_, _) => const AdminProgramsScreen(),
          ),
          GoRoute(
            path: AppConstants.routeAdminCourses,
            builder: (_, _) => const AdminCoursesScreen(),
          ),
          GoRoute(
            path: AppConstants.routeAdminPeriods,
            builder: (_, _) => const AdminPeriodsScreen(),
          ),
          GoRoute(
            path: AppConstants.routeAdminReports,
            builder: (_, _) => const AdminReportsScreen(),
          ),
          GoRoute(
            path: AppConstants.routeAdminUsers,
            builder: (_, _) => const AdminUsersScreen(),
          ),
          GoRoute(
            path: AppConstants.routeAdminCertificates,
            builder: (_, _) => const AdminCertificatesScreen(),
          ),
          GoRoute(
            path: AppConstants.routeAuditLog,
            builder: (_, _) => const AuditLogScreen(),
          ),

          // Registrar
          GoRoute(
            path: AppConstants.routeRegistrarEnrollment,
            builder: (_, _) => const RegistrarEnrollmentScreen(),
          ),
          GoRoute(
            path: AppConstants.routeRegistrarRequests,
            builder: (_, _) => const RegistrarRequestsScreen(),
          ),

          // Shared
          GoRoute(
            path: AppConstants.routeMessaging,
            builder: (_, _) => const MessagingScreen(),
          ),
          GoRoute(
            path: AppConstants.routeResources,
            builder: (_, _) => const ResourcesScreen(),
          ),
          GoRoute(
            path: AppConstants.routeSurveys,
            builder: (_, _) => const SurveysScreen(),
          ),
          GoRoute(
            path: AppConstants.routeAcademicCalendar,
            builder: (_, _) => const AcademicCalendarScreen(),
          ),
          GoRoute(
            path: AppConstants.routeSettings,
            builder: (_, _) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}

/// Provider for the GoRouter instance.
final routerProvider = Provider<GoRouter>((ref) => createRouter(ref));
