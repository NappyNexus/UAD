import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';

const Map<String, List<int>> _mockGrades = {
  'MAT-301': [88, 75, 95, 62, 85, 70, 90, 55],
  'MAT-401': [78, 82, 91, 68, 74, 88, 65, 72],
  'MAT-201': [90, 84, 97, 71, 86, 79, 93, 60],
};

class CourseProfileScreen extends StatefulWidget {
  const CourseProfileScreen({super.key});

  @override
  State<CourseProfileScreen> createState() => _CourseProfileScreenState();
}

class _CourseProfileScreenState extends State<CourseProfileScreen> {
  String _selectedCourse = professorCourses[0]['id'] as String;
  String _expandedSection = 'students';

  void _toggle(String section) {
    setState(() {
      _expandedSection = _expandedSection == section ? '' : section;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.appColors;
    final course = professorCourses.firstWhere(
      (c) => c['id'] == _selectedCourse,
      orElse: () => professorCourses[0],
    );
    final syllabusList = (syllabi as List<dynamic>)
        .where((s) => s['courseId'] == _selectedCourse)
        .toList();
    final syllabus = syllabusList.isNotEmpty ? syllabusList.first : null;
    final grades = _mockGrades[_selectedCourse] ?? [];

    final avg = grades.isNotEmpty
        ? (grades.reduce((a, b) => a + b) / grades.length).toStringAsFixed(1)
        : '-';
    final passing = grades.where((g) => g >= 70).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Perfil del Curso',
            subtitle: 'Información detallada por sección',
          ),

          // Course Cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: professorCourses.map((c) {
                final id = c['id'] as String;
                final isSelected = id == _selectedCourse;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0, bottom: 12.0),
                  child: InkWell(
                    onTap: () => setState(() => _selectedCourse = id),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c['name'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '$id · Sec. ${c['section']}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.white70
                                  : AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.users,
                                size: 12,
                                color: isSelected
                                    ? Colors.white70
                                    : AppColors.textTertiary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${c['enrolled']}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSelected
                                      ? Colors.white70
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                LucideIcons.clock,
                                size: 12,
                                color: isSelected
                                    ? Colors.white70
                                    : AppColors.textTertiary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  c['schedule'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSelected
                                        ? Colors.white70
                                        : AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Course Header Info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF026A45), Color(0xFF038556)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['name'] as String,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.surface,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.users,
                          size: 14,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${course['enrolled']} estudiantes',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.surface,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.clock,
                          size: 14,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 4),
                        Text(
                          course['schedule'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.surface,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.mapPin,
                          size: 14,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 4),
                        Text(
                          course['room'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.surface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Promedio: ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            avg,
                            style: TextStyle(
                              color: AppColors.surface,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Aprobados: ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            '$passing/${grades.length}',
                            style: TextStyle(
                              color: AppColors.surface,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Accordions
          _accordion(
            'students',
            'Lista de Estudiantes',
            LucideIcons.users,
            Column(
              children: professorStudents.asMap().entries.map((e) {
                final s = e.value;
                final grade = e.key < grades.length ? grades[e.key] : null;
                final atRisk = grade != null && grade < 70;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: atRisk ? const Color(0xFFFEF2F2) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: atRisk
                          ? const Color(0xFFFECACA)
                          : AppColors.borderMedium,
                    ),
                  ),
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
                            style: const TextStyle(
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
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Asistencia: ${s['attendance']}%',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (grade != null)
                        Text(
                          '$grade',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: atRisk ? AppColors.error : AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          _accordion(
            'syllabus',
            'Sílabo del Curso',
            LucideIcons.bookOpen,
            syllabus == null
                ? Text(
                    'No hay sílabo registrado para este curso.',
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 13,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        syllabus['description'] as String,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'OBJETIVOS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textTertiary,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...(syllabus['objectives'] as List<dynamic>)
                          .asMap()
                          .entries
                          .map(
                            (e) => Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: AppColors.primarySurface,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${e.key + 1}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      e.value as String,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      SizedBox(height: 16),
                      Text(
                        'TEMAS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textTertiary,
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (syllabus['topics'] as List<dynamic>)
                            .map(
                              (t) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  t as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
          ),

          _accordion(
            'progress',
            'Progreso del Grupo',
            LucideIcons.trendingUp,
            Column(
              children: [
                Row(
                  children: [
                    _progStat(
                      avg,
                      'Promedio',
                      AppColors.primary,
                      AppColors.background,
                    ),
                    const SizedBox(width: 8),
                    _progStat(
                      '$passing',
                      'Aprobados',
                      AppColors.success,
                      const Color(0xFFF0FDF4),
                    ),
                    const SizedBox(width: 8),
                    _progStat(
                      '${grades.where((g) => g < 70).length}',
                      'En riesgo',
                      AppColors.error,
                      const Color(0xFFFEF2F2),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ...professorStudents.asMap().entries.map((e) {
                  final s = e.value;
                  final grade = e.key < grades.length ? grades[e.key] : 0;
                  final color = grade >= 90
                      ? AppColors.primary
                      : grade >= 70
                      ? AppColors.gold
                      : AppColors.error;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            (s['name'] as String).split(' ')[0],
                            style: TextStyle(
                              fontSize: 11,
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
                              value: grade / 100,
                              minHeight: 6,
                              backgroundColor: AppColors.background,
                              valueColor: AlwaysStoppedAnimation(color),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 24,
                          child: Text(
                            '$grade',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: grade < 70
                                  ? AppColors.error
                                  : AppColors.textPrimary,
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
        ],
      ),
    );
  }

  Widget _progStat(String val, String label, Color color, Color bg) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    ),
  );

  Widget _accordion(String id, String label, IconData icon, Widget content) {
    final isExpanded = _expandedSection == id;
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _toggle(id),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 16, color: AppColors.primary),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? LucideIcons.chevronUp
                        : LucideIcons.chevronDown,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(height: 1, color: AppColors.borderMedium),
            Padding(padding: const EdgeInsets.all(16.0), child: content),
          ],
        ],
      ),
    );
  }
}
