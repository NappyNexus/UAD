import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/stat_card.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = [
      {
        'label': 'Estudiantes',
        'icon': LucideIcons.users,
        'route': AppConstants.routeAdminStudents,
        'count': '1,463',
        'color': AppColors.primary,
      },
      {
        'label': 'Programas',
        'icon': LucideIcons.building2,
        'route': AppConstants.routeAdminPrograms,
        'count': '7',
        'color': const Color(0xFF2563EB),
      }, // Blue
      {
        'label': 'Cursos',
        'icon': LucideIcons.bookOpen,
        'route': AppConstants.routeAdminCourses,
        'count': '156',
        'color': const Color(0xFF9333EA),
      }, // Purple
      {
        'label': 'Períodos',
        'icon': LucideIcons.calendar,
        'route': AppConstants.routeAdminPeriods,
        'count': '4',
        'color': AppColors.warning,
      },
      {
        'label': 'Reportes',
        'icon': LucideIcons.barChart3,
        'route': AppConstants.routeAdminReports,
        'count': '12',
        'color': const Color(0xFF4F46E5),
      }, // Indigo
      {
        'label': 'Auditoría',
        'icon': LucideIcons.shield,
        'route': AppConstants.routeAuditLog,
        'count': '847',
        'color': const Color(0xFFE11D48),
      }, // Rose
      {
        'label': 'Usuarios',
        'icon': LucideIcons.userCog,
        'route': AppConstants.routeAdminUsers,
        'count': '52',
        'color': const Color(0xFF0D9488),
      }, // Teal
      {
        'label': 'Certificados',
        'icon': LucideIcons.award,
        'route': AppConstants.routeAdminCertificates,
        'count': '24',
        'color': const Color(0xFFF97316),
      }, // Orange
    ];

    final enrollmentTrend =
        (reportData['enrollmentTrend'] ?? []) as List<dynamic>;
    final studentsByProgram =
        (reportData['studentsByProgram'] ?? []) as List<dynamic>;
    final statusBreakdown =
        (reportData['statusBreakdown'] ?? []) as List<dynamic>;

    final recentActivity = [
      {
        'action': 'Calificación actualizada',
        'detail': 'MAT-201 · STU-2024-001',
        'time': 'Hace 2h',
      },
      {
        'action': 'Retiro de materia',
        'detail': 'STU-2024-008 · ING-310',
        'time': 'Hace 3h',
      },
      {
        'action': 'Notas publicadas',
        'detail': 'MAT-301 Sec-01',
        'time': 'Ayer',
      },
      {
        'action': 'Estudiante suspendido',
        'detail': 'STU-2024-008',
        'time': 'Ayer',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Panel Administrativo',
            subtitle: 'Universidad Adventista Dominicana',
          ),

          // Quick Stats
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: LucideIcons.users,
                  label: 'ESTUDIANTES',
                  value: '1,463',
                  subtitle: '+45 este período',
                  iconColor: Colors.green,
                  iconBgColor: Colors.green.withValues(alpha: 0.1),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  icon: LucideIcons.graduationCap,
                  label: 'GRADUADOS',
                  value: '127',
                  subtitle: 'Este año',
                  iconColor: Colors.orange,
                  iconBgColor: Colors.orange.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: LucideIcons.dollarSign,
                  label: 'COBRADO',
                  value: 'RD\$45.2M',
                  subtitle: 'Este período',
                  iconColor: Colors.blue,
                  iconBgColor: Colors.blue.withValues(alpha: 0.1),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  icon: LucideIcons.trendingUp,
                  label: 'RETENCIÓN',
                  value: '94.2%',
                  subtitle: '+2.1% vs anterior',
                  iconColor: Colors.purple,
                  iconBgColor: Colors.purple.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Modules
          Text(
            'Módulos',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: modules.length,
            itemBuilder: (ctx, i) {
              final mod = modules[i];
              return InkWell(
                onTap: () => context.push((mod['route'] ?? '').toString()),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (mod['color'] ?? Colors.grey) as Color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          (mod['icon'] ?? LucideIcons.helpCircle) as IconData,
                          color: AppColors.surface,
                          size: 20,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        (mod['label'] ?? '').toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${mod['count']} registros',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Trend Chart (Simulated bar setup)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tendencia de Matrícula',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: enrollmentTrend.map((t) {
                      final val = (t['students'] ?? 0) is num
                          ? t['students'] as int
                          : 0;
                      final minVal = 1200.0;
                      final maxVal = 1500.0;
                      final pct = ((val - minVal) / (maxVal - minVal)).clamp(
                        0.1,
                        1.0,
                      );
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$val',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.textTertiary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 24,
                              height: 100 * pct,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              (t['period'] ?? '').toString(),
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Students by Program
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estudiantes por Programa',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16),
                ...studentsByProgram.map((p) {
                  final maxVal = 350.0;
                  final val = (p['value'] ?? 0) is num ? p['value'] as int : 0;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            (p['name'] ?? '').toString(),
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: val / maxVal,
                              minHeight: 6,
                              backgroundColor: AppColors.background,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 24,
                          child: Text(
                            '$val',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Status breakdown
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado de Estudiantes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: Row(
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: statusBreakdown.map((s) {
                              final val = (s['value'] as num).toDouble();
                              Color cColor;
                              try {
                                cColor = Color(
                                  int.parse(
                                    (s['color'] ?? '#000000')
                                        .toString()
                                        .replaceFirst('#', '0xFF'),
                                  ),
                                );
                              } catch (_) {
                                cColor = AppColors.primary;
                              }
                              return PieChartSectionData(
                                color: cColor,
                                value: val,
                                title: '',
                                radius: 20,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: statusBreakdown.map((s) {
                          Color cColor;
                          try {
                            cColor = Color(
                              int.parse(
                                (s['color'] ?? '#000000')
                                    .toString()
                                    .replaceFirst('#', '0xFF'),
                              ),
                            );
                          } catch (_) {
                            cColor = AppColors.primary;
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: cColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  (s['name'] ?? '').toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${s['value']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Activity List
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Actividad Reciente',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    InkWell(
                      onTap: () => context.push(AppConstants.routeAuditLog),
                      child: Row(
                        children: [
                          Text(
                            'Ver todo',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
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
                SizedBox(height: 16),
                ...recentActivity.map(
                  (a) => Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a['action']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                a['detail']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          a['time']!,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
