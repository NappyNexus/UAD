import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/stat_card.dart';

final _tuitionData = [
  {'month': 'Ago', 'cobrado': 12500000, 'pendiente': 3200000},
  {'month': 'Sep', 'cobrado': 10800000, 'pendiente': 2800000},
  {'month': 'Oct', 'cobrado': 8500000, 'pendiente': 4500000},
  {'month': 'Nov', 'cobrado': 6200000, 'pendiente': 6800000},
  {'month': 'Dic', 'cobrado': 0, 'pendiente': 8500000},
];

final _gpaDistribution = [
  {'range': '0-1.0', 'count': 12},
  {'range': '1.0-2.0', 'count': 45},
  {'range': '2.0-2.5', 'count': 120},
  {'range': '2.5-3.0', 'count': 280},
  {'range': '3.0-3.5', 'count': 520},
  {'range': '3.5-4.0', 'count': 486},
];
class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final enrollmentTrend = reportData['enrollmentTrend'] as List<dynamic>;
    final studentsByProgram = reportData['studentsByProgram'] as List<dynamic>;
    final statusBreakdown = reportData['statusBreakdown'] as List<dynamic>;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: PageHeader(
                  title: 'Reportes y Est.',
                  subtitle: 'Análisis del período Ago-Dic 2024',
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(LucideIcons.printer, size: 14),
                label: const Text(
                  'Exportar PDF',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.textPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.borderMedium),
                  ),
                ),
              ),
            ],
          ),

          // KPIs
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              StatCard(
                icon: LucideIcons.users,
                label: 'ESTUDIANTES',
                value: '1,463',
                iconColor: Colors.green,
                iconBgColor: Colors.green.withValues(alpha: 0.1),
              ),
              StatCard(
                icon: LucideIcons.graduationCap,
                label: 'ÍNDICE PROM.',
                value: '3.18',
                iconColor: Colors.blue,
                iconBgColor: Colors.blue.withValues(alpha: 0.1),
              ),
              StatCard(
                icon: LucideIcons.dollarSign,
                label: 'RECAUDADO',
                value: 'RD\$45.2M',
                iconColor: Colors.orange,
                iconBgColor: Colors.orange.withValues(alpha: 0.1),
              ),
              StatCard(
                icon: LucideIcons.trendingUp,
                label: 'APROBACIÓN',
                value: '87.3%',
                iconColor: Colors.purple,
                iconBgColor: Colors.purple.withValues(alpha: 0.1),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Enrollment Trend Chart (Simulated Area Chart)
          _CardContainer(
            title: 'Tendencia de Matrícula',
            child: SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: enrollmentTrend.map((t) {
                  final val = t['students'] as int;
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
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 32,
                          height: 130 * pct,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          t['period'] as String,
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Students by Program
          _CardContainer(
            title: 'Estudiantes por Programa',
            child: Column(
              children: studentsByProgram.map((p) {
                final maxVal = 350.0;
                final val = p['value'] as int;
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          p['name'] as String,
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
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: val / maxVal,
                            minHeight: 8,
                            backgroundColor: AppColors.background,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 30,
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
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Tuition Collection (Stacked simulation)
          _CardContainer(
            title: 'Cobranza de Matrícula (M = Millones)',
            child: SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _tuitionData.map((t) {
                  final c = (t['cobrado'] as int) / 1000000;
                  final p = (t['pendiente'] as int) / 1000000;
                  final totalHeight = 130.0;
                  final maxVal = 16.0;

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${c.toStringAsFixed(1)}M',
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 24,
                          height: totalHeight * (p / maxVal),
                          decoration: const BoxDecoration(
                            color: AppColors.warning,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                        Container(
                          width: 24,
                          height: totalHeight * (c / maxVal),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          t['month'] as String,
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // GPA Distribution
          _CardContainer(
            title: 'Distribución de Índice',
            child: SizedBox(
              height: 160,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _gpaDistribution.map((t) {
                  final val = t['count'] as int;
                  final maxVal = 600.0;
                  final pct = (val / maxVal).clamp(0.05, 1.0);
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$val',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 30,
                          height: 110 * pct,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          t['range'] as String,
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Status breakdown
          _CardContainer(
            title: 'Estado de Estudiantes',
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: statusBreakdown.length,
              itemBuilder: (ctx, i) {
                final s = statusBreakdown[i];
                Color cColor;
                try {
                  cColor = Color(
                    int.parse((s['color'] as String).replaceFirst('#', '0xFF')),
                  );
                } catch (_) {
                  cColor = AppColors.primary;
                }
                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: cColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${s['value']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              s['name'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _CardContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
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
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.printer,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'PDF',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
