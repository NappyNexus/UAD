import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String _view = 'overview';

  // Computed data
  int get _completedCredits => studyPlanCourses
      .where((c) => c['status'] == 'Aprobada')
      .fold(0, (a, c) => a + (c['credits'] as int));
  int get _inProgressCredits => studyPlanCourses
      .where((c) => c['status'] == 'En curso')
      .fold(0, (a, c) => a + (c['credits'] as int));
  static const int _totalCredits = 160;
  int get _pendingCredits =>
      _totalCredits - _completedCredits - _inProgressCredits;
  int get _progressPct => ((_completedCredits / _totalCredits) * 100).round();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Mi Progreso',
            subtitle:
                '${currentStudent.program} · Sem. ${currentStudent.semester}',
          ),

          // ═══ Tab Switcher ═══
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _tabButton('overview', 'Resumen'),
                _tabButton('semesters', 'Por Período'),
                _tabButton('materias', 'Materias'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ═══ Overview ═══
          if (_view == 'overview') ...[
            // Stat Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.4,
              children: [
                _miniStat(
                  LucideIcons.checkCircle,
                  'APROBADOS',
                  '$_completedCredits',
                  'créditos completados',
                  AppColors.primary,
                  AppColors.primarySurface,
                ),
                _miniStat(
                  LucideIcons.clock,
                  'EN CURSO',
                  '$_inProgressCredits',
                  'créditos este semestre',
                  AppColors.info,
                  AppColors.infoSurface,
                ),
                _miniStat(
                  LucideIcons.graduationCap,
                  'FALTAN',
                  '$_pendingCredits',
                  'de $_totalCredits totales',
                  AppColors.goldDark,
                  AppColors.goldSurface,
                ),
                _miniStat(
                  LucideIcons.trendingUp,
                  'AVANCE',
                  '$_progressPct%',
                  'del plan completado',
                  AppColors.textSecondary,
                  AppColors.background,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Radial Progress Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Text(
                    'Créditos vs. Meta',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Custom circular progress
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: Stack(
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: _progressPct / 100,
                            strokeWidth: 12,
                            strokeCap: StrokeCap.round,
                            backgroundColor: AppColors.border,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.primary,
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_progressPct%',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                '$_completedCredits/$_totalCredits cr.',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _progressLabel(
                        '$_completedCredits',
                        'Aprobados',
                        AppColors.primary,
                      ),
                      _progressLabel(
                        '$_inProgressCredits',
                        'En curso',
                        AppColors.info,
                      ),
                      _progressLabel(
                        '$_pendingCredits',
                        'Pendientes',
                        AppColors.textTertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Credit Distribution
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Distribución de Créditos',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _distBar('Completados', _completedCredits, AppColors.primary),
                  const SizedBox(height: 10),
                  _distBar('En curso', _inProgressCredits, AppColors.info),
                  const SizedBox(height: 10),
                  _distBar('Pendientes', _pendingCredits, AppColors.border),
                ],
              ),
            ),
          ],

          // ═══ Por Período ═══
          if (_view == 'semesters') ...[
            ...gradeHistory
                .fold<Map<String, List<dynamic>>>({}, (map, g) {
                  map.putIfAbsent(g.semester, () => []).add(g);
                  return map;
                })
                .entries
                .map((entry) {
                  final semName = entry.key;
                  final courses = entry.value;
                  final semCredits = courses.fold<int>(
                    0,
                    (a, c) => a + (c.credits as int),
                  );
                  final avgGrade =
                      courses.fold<double>(
                        0,
                        (a, c) => a + (c.finalGrade ?? 0),
                      ) /
                      courses.length;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                              'Período $semName',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '$semCredits cr.',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Índice ${avgGrade.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: courses.map<Widget>((c) {
                            final grade = (c.finalGrade ?? 0).round();
                            final color = grade >= 90
                                ? AppColors.success
                                : grade >= 80
                                ? AppColors.info
                                : grade >= 70
                                ? AppColors.warning
                                : AppColors.error;
                            final bgColor = grade >= 90
                                ? const Color(0xFFF0FDF4)
                                : grade >= 80
                                ? const Color(0xFFEFF6FF)
                                : grade >= 70
                                ? const Color(0xFFFFFBEB)
                                : const Color(0xFFFEF2F2);
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: color.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.courseName,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${c.credits} cr.',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                  Text(
                                    '$grade',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }),
          ],

          // ═══ Materias ═══
          if (_view == 'materias') ...[
            ..._groupBySemester().entries.map((entry) {
              final semNum = entry.key;
              final courses = entry.value;
              final done = courses
                  .where((c) => c['status'] == 'Aprobada')
                  .length;
              final pct = (done / courses.length * 100).round();

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                          'Semestre $semNum',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '$done/${courses.length} completadas',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: pct / 100,
                        minHeight: 6,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...courses.map((c) {
                      final status = c['status'] as String;
                      final isCompleted = status == 'Aprobada';
                      final isInProgress = status == 'En curso';
                      final dotColor = isCompleted
                          ? AppColors.success
                          : isInProgress
                          ? AppColors.info
                          : AppColors.textTertiary;
                      final bgColor = isCompleted
                          ? const Color(0xFFF0FDF4)
                          : isInProgress
                          ? const Color(0xFFEFF6FF)
                          : Colors.white;
                      final borderColor = isCompleted
                          ? const Color(0xFFBBF7D0)
                          : isInProgress
                          ? const Color(0xFFBFDBFE)
                          : AppColors.border;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: dotColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                c['name'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${c['credits']} cr.',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? const Color(0xFFDCFCE7)
                                    : isInProgress
                                    ? const Color(0xFFDBEAFE)
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isCompleted
                                    ? '✓'
                                    : isInProgress
                                    ? '●'
                                    : '–',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: dotColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Map<int, List<Map<String, dynamic>>> _groupBySemester() {
    final map = <int, List<Map<String, dynamic>>>{};
    for (final c in studyPlanCourses) {
      map.putIfAbsent(c['semester'] as int, () => []).add(c);
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  Widget _tabButton(String key, String label) {
    final isActive = _view == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _view = key),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniStat(
    IconData icon,
    String label,
    String value,
    String sub,
    Color color,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: color),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            sub,
            style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _progressLabel(String value, String label, Color color) => Column(
    children: [
      Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
      ),
    ],
  );

  Widget _distBar(String label, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          '$value cr.',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
