import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/material.dart';

/// Application-wide constants: roles, navigation items, and route paths.
class AppConstants {
  AppConstants._();

  // ─── Roles ───────────────────────────────────────────────────────
  static const String roleStudent = 'student';
  static const String roleTeacher = 'professor';
  static const String roleAdmin = 'admin';
  static const String roleRegistrar = 'registrar';

  static const Map<String, String> roleLabels = {
    roleStudent: 'Estudiante',
    roleTeacher: 'Profesor',
    roleAdmin: 'Administrador',
    roleRegistrar: 'Registrador',
  };

  // ─── Route Paths ─────────────────────────────────────────────────
  static const String routeSplash = '/';
  static const String routeAuth = '/auth';

  // Student
  static const String routeStudentDashboard = '/student/dashboard';
  static const String routePayments = '/student/payments';
  static const String routeGrades = '/student/grades';
  static const String routeCourseSelection = '/student/course-selection';
  static const String routeSchedule = '/student/schedule';
  static const String routeAcademicRecord = '/student/academic-record';
  static const String routeStudyPlan = '/student/study-plan';
  static const String routeProgress = '/student/progress';
  static const String routeRequests = '/student/requests';
  static const String routeStudentProfile = '/student/profile';

  // Professor
  static const String routeProfessorCourses = '/professor/courses';
  static const String routeGradeEntry = '/professor/grade-entry';
  static const String routeAttendance = '/professor/attendance';
  static const String routeCourseAnnouncements = '/professor/announcements';
  static const String routeGradeAnalytics = '/professor/grade-analytics';
  static const String routeCourseCalendar = '/professor/course-calendar';
  static const String routeCourseProfile = '/professor/course-profile';
  static const String routeGradeRevisions = '/professor/grade-revisions';

  // Admin
  static const String routeAdminDashboard = '/admin/dashboard';
  static const String routeAdminStudents = '/admin/students';
  static const String routeAdminPrograms = '/admin/programs';
  static const String routeAdminCourses = '/admin/courses';
  static const String routeAdminPeriods = '/admin/periods';
  static const String routeAdminReports = '/admin/reports';
  static const String routeAdminUsers = '/admin/users';
  static const String routeAdminCertificates = '/admin/certificates';
  static const String routeAuditLog = '/admin/audit-log';

  // Registrar
  static const String routeRegistrarEnrollment = '/registrar/enrollment';
  static const String routeRegistrarRequests = '/registrar/requests';

  // Shared
  static const String routeMessaging = '/messaging';
  static const String routeResources = '/resources';
  static const String routeSurveys = '/surveys';
  static const String routeAcademicCalendar = '/academic-calendar';
  static const String routeSettings = '/settings';

  // ─── Navigation Items ────────────────────────────────────────────
  /// Bottom nav items + drawer items for each role.
  /// The first 4 items go in the bottom bar, the rest show in "More" drawer.
  static List<NavItem> getNavItems(String role) {
    switch (role) {
      case roleStudent:
        return _studentNavItems;
      case roleTeacher:
        return _professorNavItems;
      case roleAdmin:
        return _adminNavItems;
      case roleRegistrar:
        return _registrarNavItems;
      default:
        return _studentNavItems;
    }
  }

  static final List<NavItem> _studentNavItems = [
    NavItem(
      label: 'Inicio',
      icon: LucideIcons.home,
      route: routeStudentDashboard,
    ),
    NavItem(label: 'Pagos', icon: LucideIcons.creditCard, route: routePayments),
    NavItem(label: 'Notas', icon: LucideIcons.bookOpen, route: routeGrades),
    NavItem(
      label: 'Selección',
      icon: LucideIcons.clipboardList,
      route: routeCourseSelection,
    ),
    // Drawer-only items:
    NavItem(label: 'Horario', icon: LucideIcons.clock, route: routeSchedule),
    NavItem(
      label: 'Récord',
      icon: LucideIcons.fileText,
      route: routeAcademicRecord,
    ),
    NavItem(
      label: 'Plan de Estudios',
      icon: LucideIcons.graduationCap,
      route: routeStudyPlan,
    ),
    NavItem(
      label: 'Progreso',
      icon: LucideIcons.trendingUp,
      route: routeProgress,
    ),
    NavItem(
      label: 'Solicitudes',
      icon: LucideIcons.helpCircle,
      route: routeRequests,
    ),
    NavItem(
      label: 'Mi Perfil',
      icon: LucideIcons.user,
      route: routeStudentProfile,
    ),
    NavItem(
      label: 'Mensajes',
      icon: LucideIcons.messageCircle,
      route: routeMessaging,
    ),
    NavItem(
      label: 'Recursos',
      icon: LucideIcons.library,
      route: routeResources,
    ),
    NavItem(label: 'Encuestas', icon: LucideIcons.star, route: routeSurveys),
    NavItem(
      label: 'Calendario',
      icon: LucideIcons.calendar,
      route: routeAcademicCalendar,
    ),
  ];

  static final List<NavItem> _professorNavItems = [
    NavItem(
      label: 'Mis Cursos',
      icon: LucideIcons.bookOpen,
      route: routeProfessorCourses,
    ),
    NavItem(
      label: 'Calificaciones',
      icon: LucideIcons.clipboardList,
      route: routeGradeEntry,
    ),
    NavItem(
      label: 'Asistencia',
      icon: LucideIcons.userCheck,
      route: routeAttendance,
    ),
    NavItem(
      label: 'Comunicados',
      icon: LucideIcons.megaphone,
      route: routeCourseAnnouncements,
    ),
    // Drawer-only items:
    NavItem(
      label: 'Analíticas',
      icon: LucideIcons.barChart3,
      route: routeGradeAnalytics,
    ),
    NavItem(
      label: 'Calendario',
      icon: LucideIcons.calendar,
      route: routeCourseCalendar,
    ),
    NavItem(
      label: 'Perfil Curso',
      icon: LucideIcons.bookMarked,
      route: routeCourseProfile,
    ),
    NavItem(
      label: 'Revisiones',
      icon: LucideIcons.fileSearch,
      route: routeGradeRevisions,
    ),
    NavItem(
      label: 'Mensajes',
      icon: LucideIcons.messageCircle,
      route: routeMessaging,
    ),

    NavItem(label: 'Encuestas', icon: LucideIcons.star, route: routeSurveys),
  ];

  static final List<NavItem> _adminNavItems = [
    NavItem(
      label: 'Dashboard',
      icon: LucideIcons.layoutDashboard,
      route: routeAdminDashboard,
    ),
    NavItem(
      label: 'Estudiantes',
      icon: LucideIcons.users,
      route: routeAdminStudents,
    ),
    NavItem(
      label: 'Programas',
      icon: LucideIcons.graduationCap,
      route: routeAdminPrograms,
    ),
    NavItem(
      label: 'Reportes',
      icon: LucideIcons.barChart3,
      route: routeAdminReports,
    ),
    // Drawer-only items:
    NavItem(
      label: 'Cursos',
      icon: LucideIcons.bookOpen,
      route: routeAdminCourses,
    ),
    NavItem(
      label: 'Períodos',
      icon: LucideIcons.calendar,
      route: routeAdminPeriods,
    ),
    NavItem(
      label: 'Usuarios',
      icon: LucideIcons.userCog,
      route: routeAdminUsers,
    ),
    NavItem(
      label: 'Certificados',
      icon: LucideIcons.award,
      route: routeAdminCertificates,
    ),
    NavItem(label: 'Auditoría', icon: LucideIcons.shield, route: routeAuditLog),
    NavItem(
      label: 'Mensajes',
      icon: LucideIcons.messageCircle,
      route: routeMessaging,
    ),
  ];

  static final List<NavItem> _registrarNavItems = [
    NavItem(
      label: 'Estudiantes',
      icon: LucideIcons.users,
      route: routeAdminStudents,
    ),
    NavItem(
      label: 'Inscripciones',
      icon: LucideIcons.userPlus,
      route: routeRegistrarEnrollment,
    ),
    NavItem(
      label: 'Solicitudes',
      icon: LucideIcons.fileText,
      route: routeRegistrarRequests,
    ),
    NavItem(
      label: 'Certificados',
      icon: LucideIcons.award,
      route: routeAdminCertificates,
    ),
    // Drawer-only items:
    NavItem(
      label: 'Mensajes',
      icon: LucideIcons.messageCircle,
      route: routeMessaging,
    ),
  ];
}

/// A single navigation item (used in bottom nav and drawer).
class NavItem {
  final String label;
  final IconData icon;
  final String route;

  const NavItem({required this.label, required this.icon, required this.route});
}
