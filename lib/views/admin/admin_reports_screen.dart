import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/stat_card.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/services/pdf_service.dart';

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
                onPressed: () => PdfService.generateAdminReport(
                  title: 'Análisis del período Ago-Dic 2024',
                  enrollmentTrend: enrollmentTrend,
                  studentsByProgram: studentsByProgram,
                  statusBreakdown: statusBreakdown,
                ),
                icon: const Icon(LucideIcons.printer, size: 14),
                label: const Text(
                  'Exportar PDF',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
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

          // Enrollment Trend Chart (Line Chart)
          _CardContainer(
            title: 'Tendencia de Matrícula',
            onPdfPressed: () =>
                PdfService.generateEnrollmentTrendReport(enrollmentTrend),
            child: SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 100,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppColors.borderMedium,
                      strokeWidth: 1,
                      dashArray: [3, 3],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < enrollmentTrend.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                enrollmentTrend[value.toInt()]['period'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: 1200,
                  maxY: 1500,
                  lineBarsData: [
                    LineChartBarData(
                      spots: enrollmentTrend.asMap().entries.map((e) {
                        return FlSpot(
                          e.key.toDouble(),
                          (e.value['students'] as num).toDouble(),
                        );
                      }).toList(),
                      isCurved: false,
                      color: AppColors.primary,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.primary,
                            strokeWidth: 0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Students by Program
          _CardContainer(
            title: 'Estudiantes por Programa',
            onPdfPressed: () =>
                PdfService.generateProgramDistributionReport(studentsByProgram),
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
                            valueColor: AlwaysStoppedAnimation(
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
            onPdfPressed: () =>
                PdfService.generateTuitionCollectionReport(_tuitionData),
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
                          style: TextStyle(
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
                          decoration: BoxDecoration(
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
            onPdfPressed: () =>
                PdfService.generateGpaDistributionReport(_gpaDistribution),
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
                          decoration: BoxDecoration(
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
            onPdfPressed: () =>
                PdfService.generateStatusBreakdownReport(statusBreakdown),
            child: SizedBox(
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
                                (s['color'] as String).replaceFirst(
                                  '#',
                                  '0xFF',
                                ),
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
                            (s['color'] as String).replaceFirst('#', '0xFF'),
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
                              s['name'] as String,
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
          ),
        ],
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onPdfPressed;

  const _CardContainer({
    required this.title,
    required this.child,
    this.onPdfPressed,
  });

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
                onTap: onPdfPressed,
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
