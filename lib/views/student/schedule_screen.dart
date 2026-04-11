import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';

final _dayMap = {
  'L': 'Lunes',
  'M': 'Martes',
  'V': 'Viernes',
  'J': 'Jueves',
  'S': 'Sábado',
};
final _days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  List<Color> _getCourseColors(int index, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColors = [
      AppColors.primary,
      AppColors.info,
      const Color(0xFF7C3AED), // Purple
      AppColors.warning,
      const Color(0xFFF43F5E), // Rose
    ];

    final color = baseColors[index % baseColors.length];

    if (isDark) {
      return [
        color.withValues(alpha: 0.15),
        color.withValues(alpha: 0.4),
        color.withValues(alpha: 0.9),
      ];
    } else {
      return [
        color.withValues(alpha: 0.08),
        color.withValues(alpha: 0.2),
        color,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleByDay = <String, List<Map<String, dynamic>>>{};
    for (final d in _days) {
      scheduleByDay[d] = [];
    }

    for (int i = 0; i < currentCourses.length; i++) {
      final course = currentCourses[i];
      final match = RegExp(r'^([LMVJS]+)\s+(.+)$').firstMatch(course.schedule);
      if (match != null) {
        final dayLetters = match.group(1)!.split('');
        final time = match.group(2)!;
        for (final d in dayLetters) {
          final dayName = _dayMap[d] ?? d;
          scheduleByDay[dayName]?.add({
            ...{'course': course, 'time': time, 'colorIdx': i},
          });
        }
      }
    }

    final totalCredits = currentCourses.fold<int>(0, (a, c) => a + c.credits);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Mi Horario',
            subtitle: 'Agosto - Diciembre 2024',
          ),

          // ═══ Course Legend ═══
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: currentCourses.asMap().entries.map((entry) {
              final i = entry.key;
              final c = entry.value;
              final clrs = _getCourseColors(i, context);
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: clrs[0],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: clrs[1]),
                ),
                child: Text(
                  c.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: clrs[2],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // ═══ Schedule Grid ═══
          ..._days.where((day) => (scheduleByDay[day] ?? []).isNotEmpty).map((
            day,
          ) {
            final courses = scheduleByDay[day]!
              ..sort(
                (a, b) => (a['time'] as String).compareTo(b['time'] as String),
              );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                ...courses.map((slot) {
                  final course = slot['course'];
                  final clrs = _getCourseColors(
                    slot['colorIdx'] as int,
                    context,
                  );
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: clrs[0],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: clrs[1]),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: clrs[2],
                                    ),
                                  ),
                                  Text(
                                    '${course.id} · ${course.credits} créditos',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: clrs[2].withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Sec. 01',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: clrs[2],
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
                              color: clrs[2].withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              slot['time'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                color: clrs[2].withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              LucideIcons.mapPin,
                              size: 12,
                              color: clrs[2].withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              course.room,
                              style: TextStyle(
                                fontSize: 11,
                                color: clrs[2].withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              LucideIcons.user,
                              size: 12,
                              color: clrs[2].withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              course.professor.split(' ').take(2).join(' '),
                              style: TextStyle(
                                fontSize: 11,
                                color: clrs[2].withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ],
            );
          }),
          const SizedBox(height: 8),

          // ═══ Weekly Summary ═══
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Text(
                  'Resumen Semanal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _summaryItem('${currentCourses.length}', 'Materias'),
                    _summaryItem('$totalCredits', 'Créditos'),
                    _summaryItem('14', 'Horas/semana'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String value, String label) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}
