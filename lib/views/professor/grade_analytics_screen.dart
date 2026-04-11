import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

// Mock grades data
const Map<String, List<int>> _mockGrades = {
  'MAT-301': [88, 75, 95, 62, 85, 70, 90, 55],
  'MAT-401': [78, 82, 91, 68, 74, 88, 65, 72],
  'MAT-201': [90, 84, 97, 71, 86, 79, 93, 60],
};

class GradeAnalyticsScreen extends StatefulWidget {
  const GradeAnalyticsScreen({super.key});

  @override
  State<GradeAnalyticsScreen> createState() => _GradeAnalyticsScreenState();
}

class _GradeAnalyticsScreenState extends State<GradeAnalyticsScreen> {
  String _selectedCourse = (professorCourses[0]['id'] ?? '').toString();

  List<Map<String, dynamic>> _buildHistogram(List<int> grades) {
    final ranges = [
      {'label': '0–59', 'min': 0, 'max': 59, 'color': AppColors.error},
      {
        'label': '60–69',
        'min': 60,
        'max': 69,
        'color': AppColors.goldDark,
      }, // close to orange
      {'label': '70–79', 'min': 70, 'max': 79, 'color': AppColors.gold},
      {'label': '80–89', 'min': 80, 'max': 89, 'color': AppColors.success},
      {'label': '90–100', 'min': 90, 'max': 100, 'color': AppColors.primary},
    ];
    return ranges.map((r) {
      final min = r['min'] as int;
      final max = r['max'] as int;
      return {...r, 'count': grades.where((g) => g >= min && g <= max).length};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final grades = _mockGrades[_selectedCourse] ?? [];
    final hist = _buildHistogram(grades);

    final avg = grades.isNotEmpty
        ? (grades.reduce((a, b) => a + b) / grades.length).toStringAsFixed(1)
        : '0.0';
    final passing = grades.where((g) => g >= 70).length;
    final failing = grades.where((g) => g < 70).length;
    final highest = grades.isNotEmpty ? grades.reduce(max) : 0;
    final lowest = grades.isNotEmpty ? grades.reduce(min) : 0;

    final studentData = professorStudents.asMap().entries.map((e) {
      final s = e.value;
      final rawName = (s['name'] ?? 'Estudiante').toString();
      final nameParts = rawName.split(' ');
      final cName =
          '${nameParts[0]} ${nameParts.length > 2 ? nameParts[2] : ''}';
      final g = e.key < grades.length ? grades[e.key] : 0;
      return {
        'name': cName,
        'grade': g,
        'attendance': (s['attendance'] ?? 0) is num
            ? s['attendance'] as num
            : 0,
        'atRisk': g < 70,
      };
    }).toList();

    final atRiskStudents = studentData
        .where((s) => s['atRisk'] as bool)
        .toList();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Análisis de Notas',
            subtitle: 'Distribución y estadísticas por grupo',
          ),

          // Course selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: professorCourses.map((c) {
                final id = (c['id'] ?? '').toString();
                final isSelected = id == _selectedCourse;
                return Padding(
                  padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: () => setState(() => _selectedCourse = id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? AppColors.primary
                          : AppColors.surface,
                      foregroundColor: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                      elevation: isSelected ? 2 : 0,
                      side: isSelected
                          ? null
                          : BorderSide(color: AppColors.borderMedium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      (c['name'] ?? '').toString(),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // KPIs
          Row(
            children: [
              _kpiBox(
                LucideIcons.trendingUp,
                'PROM. GRUPO',
                avg,
                'puntos',
                AppColors.primary,
                AppColors.primarySurface,
              ),
              const SizedBox(width: 8),
              _kpiBox(
                LucideIcons.users,
                'APROBADOS',
                '$passing/${grades.length}',
                '${grades.isNotEmpty ? (passing / grades.length * 100).round() : 0}%',
                AppColors.success,
                AppColors.success.withValues(alpha: 0.1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _kpiBox(
                LucideIcons.alertTriangle,
                'EN RIESGO',
                '$failing',
                'nota < 70',
                AppColors.error,
                AppColors.error.withValues(alpha: 0.1),
              ),
              const SizedBox(width: 8),
              _kpiBox(
                LucideIcons.award,
                'NOTA ALTA',
                '$highest',
                'Mín: $lowest',
                AppColors.info,
                AppColors.infoSurface,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Histogram with fl_chart
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distribución de Calificaciones',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 180,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (grades.isEmpty
                          ? 4
                          : hist
                                    .map((e) => e['count'] as int)
                                    .reduce(max)
                                    .toDouble() +
                                1),
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 &&
                                  value.toInt() < hist.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    hist[value.toInt()]['label'] as String,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              if (value % 1 == 0) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: AppColors.border,
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.textSecondary,
                            width: 1,
                          ),
                          left: BorderSide(
                            color: AppColors.textSecondary,
                            width: 1,
                          ),
                        ),
                      ),
                      barGroups: List.generate(hist.length, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: (hist[i]['count'] as int).toDouble(),
                              color: hist[i]['color'] as Color,
                              width: 32,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Legend
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: hist
                      .map(
                        (r) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: r['color'] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${r['label']}: ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${r['count']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tendencia por Parcial Line Chart
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tendencia por Parcial',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 160,
                  child: LineChart(
                    LineChartData(
                      minY: 50,
                      maxY: 100,
                      minX: 0,
                      maxX: 2,
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 75), // default mock data to match visual
                            FlSpot(1, 80),
                            FlSpot(2, 78),
                          ],
                          isCurved: true,
                          color: AppColors.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                  radius: 6,
                                  color: AppColors.primary,
                                  strokeWidth: 2,
                                  strokeColor: AppColors.surface,
                                ),
                          ),
                        ),
                      ],
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: 70,
                            color: AppColors.error,
                            strokeWidth: 1,
                            dashArray: [4, 4],
                            label: HorizontalLineLabel(
                              show: true,
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                              alignment: Alignment.center,
                              labelResolver: (line) => '70',
                              padding: const EdgeInsets.only(
                                right: 5,
                                bottom: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              const titles = [
                                'Parcial 1',
                                'Parcial 2',
                                'Final (est.)',
                              ];
                              if (value >= 0 && value < titles.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    titles[value.toInt()],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 15,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: AppColors.border,
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.textSecondary,
                            width: 1,
                          ),
                          left: BorderSide(
                            color: AppColors.textSecondary,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // En Riesgo List
          if (atRiskStudents.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.errorSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.alertTriangle,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Estudiantes en Riesgo (${atRiskStudents.length})',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  ...atRiskStudents.map(
                    (s) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s['name'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Asistencia: ${s['attendance']}%',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${s['grade']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Full list
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Detalle por Estudiante',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Divider(height: 1, color: AppColors.borderMedium),
                Column(
                  children: List.generate(studentData.length, (i) {
                    final s = studentData[i];
                    final isRisk = s['atRisk'] as bool;
                    final g = s['grade'] as int;
                    final barColor = g >= 90
                        ? AppColors.primary
                        : g >= 70
                        ? AppColors.gold
                        : AppColors.error;

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          color: isRisk
                              ? AppColors.error.withValues(alpha: 0.05)
                              : Colors.transparent,
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.primarySurface,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    (s['name'] as String)
                                        .split(' ')
                                        .take(2)
                                        .map((e) => e[0])
                                        .join(''),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s['name'] as String,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      'Asistencia ${s['attendance']}%',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: g / 100,
                                    minHeight: 6,
                                    backgroundColor: AppColors.background,
                                    valueColor: AlwaysStoppedAnimation(
                                      barColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 28,
                                child: Text(
                                  '$g',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isRisk
                                        ? AppColors.error
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (i < studentData.length - 1)
                          Divider(height: 1, color: AppColors.borderMedium),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpiBox(
    IconData icon,
    String label,
    String value,
    String sub,
    Color color,
    Color bg,
  ) => Expanded(
    child: Container(
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
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            sub,
            style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
          ),
        ],
      ),
    ),
  );
}
