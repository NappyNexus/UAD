import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/stat_card.dart';

final _quickActions = [
  {
    'label': 'Pagos',
    'icon': LucideIcons.creditCard,
    'route': AppConstants.routePayments,
    'color': const Color(0xFF026A45),
  },
  {
    'label': 'Calificaciones',
    'icon': LucideIcons.bookOpen,
    'route': AppConstants.routeGrades,
    'color': const Color(0xFF2563EB),
  },
  {
    'label': 'Selección',
    'icon': LucideIcons.calendar,
    'route': AppConstants.routeCourseSelection,
    'color': const Color(0xFF7C3AED),
  },
  {
    'label': 'Horario',
    'icon': LucideIcons.clock,
    'route': AppConstants.routeSchedule,
    'color': const Color(0xFFD97706),
  },
  {
    'label': 'Récord',
    'icon': LucideIcons.fileText,
    'route': AppConstants.routeAcademicRecord,
    'color': const Color(0xFF4F46E5),
  },
  {
    'label': 'Solicitudes',
    'icon': LucideIcons.clipboardList,
    'route': AppConstants.routeRequests,
    'color': const Color(0xFFF43F5E),
  },
  {
    'label': 'Plan',
    'icon': LucideIcons.bookMarked,
    'route': AppConstants.routeStudyPlan,
    'color': const Color(0xFF0D9488),
  },
  {
    'label': 'Perfil',
    'icon': LucideIcons.user,
    'route': AppConstants.routeStudentProfile,
    'color': const Color(0xFF4B5563),
  },
];

final _mockDeadlines = [
  {
    'id': 1,
    'courseId': 'MAT-301',
    'courseName': 'Cálculo III',
    'title': 'Segundo Parcial',
    'type': 'examen',
    'date': '2024-10-25',
    'time': '8:00 AM',
  },
  {
    'id': 2,
    'courseId': 'ING-310',
    'courseName': 'Ingeniería de Software',
    'title': 'Entrega Avance Proyecto',
    'type': 'entrega',
    'date': '2024-10-28',
    'time': '11:59 PM',
  },
  {
    'id': 3,
    'courseId': 'ING-315',
    'courseName': 'Redes de Computadoras',
    'title': 'Quiz Capítulo 5',
    'type': 'entrega',
    'date': '2024-10-18',
    'time': '8:00 AM',
  },
  {
    'id': 4,
    'courseId': 'ING-305',
    'courseName': 'Base de Datos II',
    'title': 'Proyecto Final',
    'type': 'proyecto',
    'date': '2024-11-10',
    'time': '11:59 PM',
  },
];

final _mockAnnouncements = [
  {
    'id': 1,
    'courseId': 'MAT-301',
    'courseName': 'Cálculo III',
    'title': 'Cambio de horario — 18 oct',
    'body':
        'La clase del viernes 18 de octubre se moverá al jueves 17 a las 10:00 AM en el aula A-202.',
    'date': '2024-10-14',
    'type': 'aviso',
    'pinned': true,
  },
  {
    'id': 2,
    'courseId': 'ING-305',
    'courseName': 'Base de Datos II',
    'title': 'Material del Parcial 2 disponible',
    'body':
        'El resumen de los temas del segundo parcial ya está disponible en la plataforma. Incluye funciones vectoriales y campos escalares.',
    'date': '2024-10-13',
    'type': 'material',
    'pinned': false,
  },
  {
    'id': 3,
    'courseId': 'ING-310',
    'courseName': 'Ingeniería de Software',
    'title': 'Recordatorio: Proyecto Final',
    'body':
        'El proyecto final es individual y debe entregarse antes del 10 de noviembre.',
    'date': '2024-10-10',
    'type': 'entrega',
    'pinned': false,
  },
];

class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = currentStudent;
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ═══════════════ Welcome Card ═══════════════
          Container(
            width: double.infinity,
            //padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF026A45), Color(0xFF038556)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  top: -30,
                  right: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  left: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: s.photo != null
                                  ? Image.network(
                                      s.photo!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) =>
                                          _avatarFallback(s.name),
                                    )
                                  : _avatarFallback(s.name),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bienvenida 👋',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                Text(
                                  s.name.split(' ').take(2).join(' '),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _infoPill(
                            s.program,
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.8),
                          ),
                          _infoPill(
                            '${s.semester}° Semestre',
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.8),
                          ),
                          _infoPill(
                            'Índice ${s.gpa.toStringAsFixed(2)}',
                            AppColors.gold.withValues(alpha: 0.2),
                            AppColors.gold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ═══════════════ Stats Grid ═══════════════
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: size.width < 380 ? 1.4 : 1.6,
            children: [
              StatCard(
                icon: LucideIcons.trendingUp,
                iconColor: AppColors.primary,
                iconBgColor: AppColors.primarySurface,
                label: 'Índice',
                value: s.gpa.toStringAsFixed(2),
                subtitle: 'Acumulado',
              ),
              StatCard(
                icon: LucideIcons.bookOpen,
                iconColor: AppColors.info,
                iconBgColor: AppColors.infoSurface,
                label: 'Créditos',
                value: '${s.cumulativeCredits}',
                subtitle: 'de ${s.totalCredits} totales',
              ),
              StatCard(
                icon: LucideIcons.dollarSign,
                iconColor: s.balance > 0 ? AppColors.error : AppColors.success,
                iconBgColor: s.balance > 0
                    ? AppColors.errorSurface
                    : AppColors.successSurface,
                label: 'Balance',
                value: Formatters.currencyShort(s.balance),
                subtitle: 'Pendiente',
              ),
              StatCard(
                icon: LucideIcons.calendar,
                iconColor: const Color(0xFF7C3AED),
                iconBgColor: const Color(0xFFF5F3FF),
                label: 'Materias',
                value: '${currentCourses.length}',
                subtitle: 'Este semestre',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ═══════════════ Balance Alert ═══════════════
          if (s.balance > 0) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warningSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.warningLight),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    LucideIcons.alertCircle,
                    size: 20,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pago pendiente',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warningText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tienes un balance de ${Formatters.currencyShort(s.balance)} pendiente. Realiza tu pago antes de la fecha límite.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.warning.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ═══════════════ Quick Actions ═══════════════
          const Text(
            'Acceso Rápido',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: size.width < 380 ? 0.75 : 0.85,
            children: _quickActions.map((action) {
              return GestureDetector(
                onTap: () => context.go(action['route'] as String),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: action['color'] as Color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        action['label'] as String,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // ═══════════════ Upcoming Deadlines ═══════════════
          Row(
            children: [
              Icon(LucideIcons.calendar, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                'Próximas Entregas y Exámenes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _mockDeadlines.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final ev = _mockDeadlines[index];
              final date = DateTime.parse(ev['date'] as String);
              final type = ev['type'] as String;

              Color typeBg;
              Color typeText;
              if (type == 'examen') {
                typeBg = const Color(0xFFFEE2E2);
                typeText = const Color(0xFFB91C1C);
              } else if (type == 'proyecto') {
                typeBg = const Color(0xFFF3E8FF);
                typeText = const Color(0xFF7E22CE);
              } else {
                typeBg = const Color(0xFFDBEAFE);
                typeText = const Color(0xFF1D4ED8);
              }

              // Calculate days until
              final days = date.difference(DateTime.parse('2024-10-15')).inDays;
              final daysText = (days == 0)
                  ? 'Hoy'
                  : (days == 1)
                  ? 'Mañana'
                  : '$days días';

              Color daysBg = (days <= 3)
                  ? const Color(0xFFFEE2E2)
                  : (days <= 7)
                  ? const Color(0xFFFEF3C7)
                  : const Color(0xFFF3F4F6);
              Color daysTextCol = (days <= 3)
                  ? const Color(0xFFB91C1C)
                  : (days <= 7)
                  ? const Color(0xFFB45309)
                  : const Color(0xFF4B5563);
              Color eventBorder = (days <= 3)
                  ? const Color(0xFFFECACA)
                  : (days <= 7)
                  ? const Color(0xFFFDE68A)
                  : AppColors.border;

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: eventBorder),
                ),
                child: Row(
                  children: [
                    // Date Box
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${date.day}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'OCT',
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ev['title'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    LucideIcons.bookOpen,
                                    size: 10,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    ev['courseName'] as String,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    LucideIcons.clock,
                                    size: 10,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    ev['time'] as String,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: typeBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: typeText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Days Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: daysBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        daysText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: daysTextCol,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // ═══════════════ Announcements ═══════════════
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.megaphone,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Comunicados de Cursos',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const Text(
                'Ver todos (4)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _mockAnnouncements.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final ann = _mockAnnouncements[index];
              final pinned = ann['pinned'] as bool;
              final type = ann['type'] as String;

              Color typeBg;
              Color typeText;
              if (type == 'aviso') {
                typeBg = const Color(0xFFFEF3C7);
                typeText = const Color(0xFFB45309);
              } else if (type == 'material') {
                typeBg = const Color(0xFFDBEAFE);
                typeText = const Color(0xFF1D4ED8);
              } else {
                typeBg = const Color(0xFFF3E8FF);
                typeText = const Color(0xFF7E22CE);
              }

              return _AnnouncementCard(
                announcement: ann,
                pinned: pinned,
                typeBg: typeBg,
                typeText: typeText,
              );
            },
          ),
          const SizedBox(height: 24),

          // ═══════════════ Current Courses ═══════════════
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Materias en Curso',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => context.go(AppConstants.routeSchedule),
                child: Row(
                  children: [
                    Text(
                      'Ver horario',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...currentCourses.map(
            (course) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${course.id} · ${course.professor}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${course.credits} cr.',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.clock,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.schedule,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        course.room,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _avatarFallback(String name) {
    return Container(
      color: Colors.white.withValues(alpha: 0.2),
      child: Center(
        child: Text(
          name[0],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static Widget _infoPill(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _AnnouncementCard extends StatefulWidget {
  final Map<String, dynamic> announcement;
  final bool pinned;
  final Color typeBg;
  final Color typeText;

  const _AnnouncementCard({
    required this.announcement,
    required this.pinned,
    required this.typeBg,
    required this.typeText,
  });

  @override
  State<_AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<_AnnouncementCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final ann = widget.announcement;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.pinned
                ? AppColors.primary.withValues(alpha: 0.25)
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: widget.pinned
                          ? AppColors.primary
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      LucideIcons.megaphone,
                      size: 14,
                      color: widget.pinned
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              ann['title'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (widget.pinned)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySurface,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  '📌 Fijado',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  LucideIcons.bookOpen,
                                  size: 10,
                                  color: AppColors.textTertiary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  ann['courseName'] as String,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  LucideIcons.clock,
                                  size: 10,
                                  color: AppColors.textTertiary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  ann['date'] as String,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: widget.typeBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                ann['type'] as String,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: widget.typeText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
            if (_expanded)
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Text(
                  ann['body'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
