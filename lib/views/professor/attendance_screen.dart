import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _selectedCourse = professorCourses[0]['id'] as String;
  late List<String> _classDates;
  late String _selectedDate;

  // Map structure: CourseID -> (Date -> (StudentID -> Status))
  final Map<String, Map<String, Map<String, String>>> _attendanceData = {};

  @override
  void initState() {
    super.initState();
    _classDates = _generateDates();
    _selectedDate = _classDates.last;
  }

  List<String> _generateDates() {
    final dates = <String>[];
    final base = DateTime(2024, 10, 15);
    for (int i = 5; i >= 0; i--) {
      final d = base.subtract(Duration(days: i * 2));
      dates.add('${d.day}/${d.month}');
    }
    return dates;
  }

  String? _getStatus(String studentId) {
    return _attendanceData[_selectedCourse]?[_selectedDate]?[studentId];
  }

  void _setStatus(String studentId, String status) {
    setState(() {
      _attendanceData
              .putIfAbsent(_selectedCourse, () => {})
              .putIfAbsent(_selectedDate, () => {})[studentId] =
          status;
    });
  }

  void _markAll(String status) {
    setState(() {
      final courseMap = _attendanceData.putIfAbsent(_selectedCourse, () => {});
      final dateMap = courseMap.putIfAbsent(_selectedDate, () => {});
      for (final s in professorStudents) {
      dateMap[(s['id'] ?? '').toString()] = status;
      }
    });
  }

  int? _studentAttPct(String studentId) {
    final courseAtt = _attendanceData[_selectedCourse];
    if (courseAtt == null || courseAtt.isEmpty) return null;

    int present = 0;
    int total = courseAtt.length;
    for (final dayMap in courseAtt.values) {
      final status = dayMap[studentId];
      if (status == 'P' || status == 'T') present++;
    }
    return ((present / total) * 100).round();
  }
  void _handleSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text('Asistencia guardada para el $_selectedDate'),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCourseEntry = professorCourses.firstWhere(
      (c) => c['id'] == _selectedCourse,
      orElse: () => {'name': _selectedCourse},
    );
    final cName = (selectedCourseEntry['name'] ?? '').toString();
    final dayDict = _attendanceData[_selectedCourse]?[_selectedDate] ?? {};
    int present = 0, absent = 0, late = 0;
    for (final s in dayDict.values) {
      if (s == 'P') present++;
      if (s == 'A') absent++;
      if (s == 'T') late++;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(title: 'Asistencia', subtitle: 'Registro por clase'),

          // Course selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: professorCourses.map((c) {
                final id = c['id'] as String;
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

          // Date selector card
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
                  children: [
                    Icon(
                      LucideIcons.calendar,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'SELECCIONAR FECHA DE CLASE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _classDates.map((d) {
                      final isSelected = d == _selectedDate;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            d,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedDate = d),
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                          backgroundColor: AppColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.borderMedium,
                            ),
                          ),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Stats
          Row(
            children: [
              _statBox(
                '${professorStudents.length}',
                'Total',
                AppColors.textPrimary,
              ),
              const SizedBox(width: 8),
              _statBox('$present', 'Presentes', AppColors.success),
              const SizedBox(width: 8),
              _statBox('$absent', 'Ausentes', AppColors.error),
              const SizedBox(width: 8),
              _statBox('$late', 'Tardanzas', AppColors.warning),
            ],
          ),
          const SizedBox(height: 12),

          // Mark all buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _markAll('P'),
                  icon: const Icon(LucideIcons.check, size: 14),
                  label: const Text('Todos Presentes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successSurface,
                    foregroundColor: AppColors.success,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFBBF7D0)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _markAll('A'),
                  icon: const Icon(LucideIcons.x, size: 14),
                  label: const Text('Todos Ausentes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorSurface,
                    foregroundColor: AppColors.error,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFFECACA)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Student list
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.users,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$cName — $_selectedDate',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${professorStudents.length} est.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: professorStudents.length,
                  separatorBuilder: (_, _) =>
                      Divider(height: 1, color: AppColors.border),
                  itemBuilder: (ctx, i) {
                    final s = professorStudents[i];
                    final id = (s['id'] ?? '').toString();
                    final name = (s['name'] ?? '').toString();
                    final status = _getStatus(id);
                    final pct = _studentAttPct(id);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                name
                                    .split(' ')
                                    .take(2)
                                    .map((e) => e[0])
                                    .join(''),
                                style: TextStyle(
                                  fontSize: 11,
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
                                  name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (pct != null)
                                  Text(
                                    '$pct% asistencia',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: pct >= 75
                                          ? AppColors.success
                                          : AppColors.error,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _attBtn(
                                'P',
                                'Presente',
                                AppColors.success,
                                status == 'P',
                                () => _setStatus(id, 'P'),
                              ),
                              const SizedBox(width: 4),
                              _attBtn(
                                'A',
                                'Ausente',
                                AppColors.error,
                                status == 'A',
                                () => _setStatus(id, 'A'),
                              ),
                              const SizedBox(width: 4),
                              _attBtn(
                                'T',
                                'Tardanza',
                                AppColors.warning,
                                status == 'T',
                                () => _setStatus(id, 'T'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Guardar Asistencia — $_selectedDate',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(String value, String label, Color color) => Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderMedium),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 9, color: AppColors.textTertiary),
          ),
        ],
      ),
    ),
  );

  Widget _attBtn(
    String letter,
    String tip,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Tooltip(
        message: tip,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isSelected ? color : AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
