import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/stat_card.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  int? _expandedSemester;
  bool _expandedCurrentSemester = false;

  // Mock attendance per course
  final Map<String, int> _attendance = {
    'MAT-301': 95,
    'ING-305': 88,
    'ING-310': 100,
    'ING-315': 82,
    'HUM-200': 90,
  };

  // Group grade history by semester
  List<_SemesterGroup> get _semesters {
    final map = <String, List<Map<String, dynamic>>>{};
    for (final g in gradeHistory) {
      map.putIfAbsent(g.semester, () => []).add({
        'id': g.courseId,
        'name': g.courseName,
        'credits': g.credits,
        'grade': g.finalGrade,
        'letter': g.letterGrade,
      });
    }
    return map.entries
        .map((e) => _SemesterGroup(semester: e.key, courses: e.value))
        .toList();
  }

  Color _scoreColor(double? score) {
    if (score == null) return AppColors.textTertiary;
    if (score >= 90) return AppColors.success;
    if (score >= 80) return AppColors.info;
    if (score >= 70) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final s = currentStudent;
    final gpaIndex = (s.gpa / 4.0 * 100).toStringAsFixed(1);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Calificaciones',
            subtitle: 'Consulta tus notas y promedios',
          ),

          // ═══ Stats ═══
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: LucideIcons.trendingUp,
                  iconColor: AppColors.primary,
                  iconBgColor: AppColors.primarySurface,
                  label: 'Índice',
                  value: gpaIndex,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  icon: LucideIcons.bookOpen,
                  iconColor: AppColors.info,
                  iconBgColor: AppColors.infoSurface,
                  label: 'Créditos',
                  value: '${s.cumulativeCredits}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  icon: LucideIcons.award,
                  iconColor: AppColors.goldDark,
                  iconBgColor: AppColors.goldSurface,
                  label: 'Más Alta',
                  value: '100',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ═══ Current Semester ═══
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: InkWell(
              onTap: () => setState(
                () => _expandedCurrentSemester = !_expandedCurrentSemester,
              ),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        LucideIcons.calendar,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Semestre Actual',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Ago-Dic 2024',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _expandedCurrentSemester
                            ? LucideIcons.chevronUp
                            : LucideIcons.chevronDown,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_expandedCurrentSemester) ...[
            ...currentCourses.map((c) {
              final att = _attendance[c.id] ?? 100;
              final lowAtt = att < 75;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: lowAtt ? const Color(0xFFFEF2F2) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: lowAtt ? const Color(0xFFFECACA) : AppColors.border,
                  ),
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
                                c.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${c.id} · ${c.professor}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
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
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'En curso',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Attendance bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Asistencia',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Text(
                          '$att%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: lowAtt ? AppColors.error : AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: att / 100,
                        minHeight: 6,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation(
                          lowAtt ? AppColors.error : AppColors.primary,
                        ),
                      ),
                    ),
                    if (lowAtt) ...[
                      const SizedBox(height: 6),
                      const Text(
                        '⚠ Asistencia por debajo del mínimo requerido (75%)',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
          const SizedBox(height: 20),

          // ═══ Grade History ═══
          const Text(
            'Historial de Calificaciones',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ..._semesters.asMap().entries.map((entry) {
            final idx = entry.key;
            final sem = entry.value;
            final isOpen = _expandedSemester == idx;
            final totalCredits = sem.courses.fold<int>(
              0,
              (a, c) => a + (c['credits'] as int),
            );
            final avgGrade =
                sem.courses.fold<double>(
                  0,
                  (a, c) => a + ((c['grade'] as double?) ?? 0),
                ) /
                sem.courses.length;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () =>
                        setState(() => _expandedSemester = isOpen ? null : idx),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              LucideIcons.bookOpen,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sem.semester,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${sem.courses.length} materias · $totalCredits créditos',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            avgGrade.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _scoreColor(avgGrade),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isOpen
                                ? LucideIcons.chevronUp
                                : LucideIcons.chevronDown,
                            size: 18,
                            color: AppColors.textTertiary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isOpen) ...[
                    const Divider(height: 1),
                    ...sem.courses.map(
                      (c) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${c['id']} · ${c['credits']} cr.',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              (c['grade'] as double?)?.toStringAsFixed(0) ??
                                  '-',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _scoreColor(c['grade'] as double?),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SemesterGroup {
  final String semester;
  final List<Map<String, dynamic>> courses;
  _SemesterGroup({required this.semester, required this.courses});
}
