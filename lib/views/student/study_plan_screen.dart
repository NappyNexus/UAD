import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/status_badge.dart';

class StudyPlanScreen extends StatelessWidget {
  const StudyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Group courses by semester
    final semesters = <int, List<Map<String, dynamic>>>{};
    for (final c in studyPlanCourses) {
      final sem = c['semester'] as int;
      semesters.putIfAbsent(sem, () => []).add(c);
    }
    final semesterKeys = semesters.keys.toList()..sort();

    // Calculate progress
    final totalCredits = studyPlanCourses.fold<int>(
      0,
      (a, c) => a + (c['credits'] as int),
    );
    final completedCredits = studyPlanCourses
        .where((c) => c['status'] == 'Aprobada')
        .fold<int>(0, (a, c) => a + (c['credits'] as int));
    final progress = totalCredits > 0
        ? (completedCredits / totalCredits * 100).round()
        : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Plan de Estudios',
            subtitle: 'Ingeniería en Sistemas',
          ),

          // ═══ Progress Card ═══
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progreso General',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '$progress%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 12,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$completedCredits créditos completados',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '$totalCredits créditos totales',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _legend(AppColors.success, 'Completada'),
                    const SizedBox(width: 16),
                    _legend(AppColors.info, 'En curso'),
                    const SizedBox(width: 16),
                    _legend(AppColors.textTertiary, 'Pendiente'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ═══ Semesters ═══
          ...semesterKeys.map((semNum) {
            final courses = semesters[semNum]!;
            final semCredits = courses.fold<int>(
              0,
              (a, c) => a + (c['credits'] as int),
            );
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.bookMarked,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Semestre $semNum',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$semCredits créditos',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primary.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...courses.map((c) {
                    final status = c['status'] as String;
                    final isCompleted = status == 'Aprobada';
                    final isInProgress = status == 'En curso';
                    final isPending = status == 'Pendiente';

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
                    final iconColor = isCompleted
                        ? AppColors.success
                        : isInProgress
                        ? AppColors.info
                        : AppColors.textTertiary;
                    final icon = isCompleted
                        ? LucideIcons.check
                        : isInProgress
                        ? LucideIcons.clock
                        : LucideIcons.lock;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        border: Border(
                          bottom: BorderSide(
                            color: borderColor.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: iconColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon, size: 14, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c['name'] as String,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: isPending
                                        ? AppColors.textSecondary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${c['id']} · ${c['credits']} cr.',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StatusBadge(status: c['type'] as String),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) => Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
      ),
    ],
  );
}
