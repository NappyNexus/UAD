import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';

// Temporary type to track grades locally since mock data is constant
class LocalStudent {
  final String id;
  final String name;
  final num? midterm1;
  final num? midterm2;
  final num? finalExam;
  final int attendance;

  LocalStudent({
    required this.id,
    required this.name,
    this.midterm1,
    this.midterm2,
    this.finalExam,
    required this.attendance,
  });

  LocalStudent copyWith({num? m1, num? m2, num? finalEx}) {
    return LocalStudent(
      id: id,
      name: name,
      attendance: attendance,
      midterm1: m1 != null && m1 < 0 ? null : (m1 ?? midterm1),
      midterm2: m2 != null && m2 < 0 ? null : (m2 ?? midterm2),
      finalExam: finalEx != null && finalEx < 0 ? null : (finalEx ?? finalExam),
    );
  }
}

class GradeEntryScreen extends StatefulWidget {
  const GradeEntryScreen({super.key});

  @override
  State<GradeEntryScreen> createState() => _GradeEntryScreenState();
}

class _GradeEntryScreenState extends State<GradeEntryScreen> {
  String _selectedCourse = professorCourses[0]['id'] as String;
  List<LocalStudent> _students = [];
  bool _published = false;
  bool _saved = false;
  String _search = '';
  String? _csvStatusMsg;
  final bool _csvStatusIsSuccess = true;
  bool _showPublishedBanner = false;

  @override
  void initState() {
    super.initState();
    _students = (professorStudents as List<dynamic>)
        .map(
          (s) => LocalStudent(
            id: s['id'] as String,
            name: s['name'] as String,
            midterm1: s['midterm1'] as num?,
            midterm2: s['midterm2'] as num?,
            finalExam: s['final'] as num?,
            attendance: s['attendance'] as int,
          ),
        )
        .toList();
  }

  double? _calcAvg(LocalStudent s) {
    if (s.midterm1 == null && s.midterm2 == null && s.finalExam == null) {
      return null;
    }
    double total = 0, weight = 0;
    if (s.midterm1 != null) {
      total += s.midterm1! * 0.3;
      weight += 0.3;
    }
    if (s.midterm2 != null) {
      total += s.midterm2! * 0.3;
      weight += 0.3;
    }
    if (s.finalExam != null) {
      total += s.finalExam! * 0.4;
      weight += 0.4;
    }
    return weight > 0 ? total / weight : null;
  }

  String _getLetter(double? avg) {
    if (avg == null) return '-';
    if (avg >= 90) return 'A';
    if (avg >= 85) return 'A-';
    if (avg >= 80) return 'B+';
    if (avg >= 75) return 'B';
    if (avg >= 70) return 'C+';
    if (avg >= 65) return 'C';
    if (avg >= 60) return 'D';
    return 'F';
  }

  Color _getLetterColor(String letter) {
    if (letter == '-') return AppColors.textTertiary;
    if (letter == 'F') return AppColors.error;
    if (letter.startsWith('A')) return AppColors.success;
    if (letter.startsWith('B')) return AppColors.info;
    return AppColors.warning;
  }

  Color _getLetterBg(String letter) {
    if (letter == '-') return AppColors.background;
    if (letter == 'F') return AppColors.error.withValues(alpha: 0.1);
    if (letter.startsWith('A')) return AppColors.success.withValues(alpha: 0.1);
    if (letter.startsWith('B')) return AppColors.info.withValues(alpha: 0.1);
    return AppColors.warning.withValues(alpha: 0.1);
  }

  void _handlePublish() {
    setState(() {
      _published = true;
      _saved = true;
      _showPublishedBanner = true;
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _showPublishedBanner = false);
    });
  }

  void _showGradeModal(BuildContext context, LocalStudent student, int index) {
    num? m1 = student.midterm1;
    num? m2 = student.midterm2;
    num? fn = student.finalExam;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final tempS = student.copyWith(
            m1: m1 ?? -1,
            m2: m2 ?? -1,
            finalEx: fn ?? -1,
          );
          final avg = _calcAvg(tempS);
          final letter = _getLetter(avg);

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Notas — ${student.name.split(' ').take(2).join(' ')}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Summaries
                Row(
                  children: [
                    _chip(
                      (avg?.toStringAsFixed(1) ?? '—'),
                      'Promedio',
                      avg != null && avg < 70
                          ? AppColors.error
                          : AppColors.textPrimary,
                      AppColors.background,
                    ),
                    const SizedBox(width: 8),
                    _chip(
                      letter,
                      'Letra',
                      _getLetterColor(letter),
                      _getLetterBg(letter),
                    ),
                    const SizedBox(width: 8),
                    _chip(
                      '${student.attendance}%',
                      'Asist.',
                      student.attendance < 75
                          ? AppColors.error
                          : AppColors.textPrimary,
                      student.attendance < 75
                          ? AppColors.error.withValues(alpha: 0.1)
                          : AppColors.background,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Inputs
                Row(
                  children: [
                    _gradeInput(
                      'Parcial 1',
                      '30%',
                      m1?.toString() ?? '',
                      (v) => setModalState(() => m1 = num.tryParse(v)),
                    ),
                    const SizedBox(width: 8),
                    _gradeInput(
                      'Parcial 2',
                      '30%',
                      m2?.toString() ?? '',
                      (v) => setModalState(() => m2 = num.tryParse(v)),
                    ),
                    const SizedBox(width: 8),
                    _gradeInput(
                      'Final',
                      '40%',
                      fn?.toString() ?? '',
                      (v) => setModalState(() => fn = num.tryParse(v)),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Pesos: P1 30% · P2 30% · Final 40%. Aprobado ≥ 70.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: AppColors.textTertiary),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _students[index] = tempS;
                        _saved = false;
                        _published = false;
                      });
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(LucideIcons.check, size: 16),
                    label: const Text(
                      'Guardar Notas',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _chip(String value, String label, Color color, Color bg) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    ),
  );

  Widget _gradeInput(
    String label,
    String weight,
    String value,
    Function(String) onChanged,
  ) => Expanded(
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
                color: AppColors.textSecondary,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                weight,
                style: TextStyle(fontSize: 8, color: AppColors.textTertiary),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: '—',
            contentPadding: EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderMedium),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderMedium),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final filtered = _students
        .where((s) => s.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();
    final avgs = _students
        .map(_calcAvg)
        .where((a) => a != null)
        .map((e) => e!)
        .toList();
    final classAvg = avgs.isNotEmpty
        ? (avgs.fold<double>(0, (a, b) => a + b) / avgs.length).toStringAsFixed(
            1,
          )
        : '—';
    final passing = avgs.where((a) => a >= 70).length;
    final courseName =
        (professorCourses.firstWhere((c) => c['id'] == _selectedCourse)['name']
            as String);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(title: 'Calificaciones', subtitle: courseName),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(LucideIcons.download, size: 15),
                label: const Text('CSV', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: AppColors.borderMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(LucideIcons.uploadCloud, size: 15),
                label: const Text('Importar', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => setState(() => _saved = true),
                icon: Icon(
                  _saved ? LucideIcons.check : LucideIcons.save,
                  size: 12,
                ),
                label: Text(
                  _saved ? 'Guardado' : 'Guardar',
                  style: const TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Course Selector Slider
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: professorCourses.map((c) {
                final id = c['id'] as String;
                final isSelected = id == _selectedCourse;
                return Padding(
                  padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: () => setState(() {
                      _selectedCourse = id;
                      _search = '';
                      _published = false;
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? AppColors.primary
                          : Colors.white,
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
                    child: Text(c['name'] as String),
                  ),
                );
              }).toList(),
            ),
          ),

          if (_showPublishedBanner)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.checkCircle2,
                    color: AppColors.surface,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Calificaciones publicadas exitosamente para $courseName.',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          if (_csvStatusMsg != null)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _csvStatusIsSuccess
                    ? const Color(0xFFF0FDF4)
                    : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _csvStatusIsSuccess
                      ? const Color(0xFFBBF7D0)
                      : const Color(0xFFFECACA),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _csvStatusIsSuccess
                        ? LucideIcons.checkCircle2
                        : LucideIcons.alertCircle,
                    color: _csvStatusIsSuccess
                        ? AppColors.success
                        : AppColors.error,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _csvStatusMsg!,
                      style: TextStyle(
                        color: _csvStatusIsSuccess
                            ? AppColors.success
                            : AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Stats
          const SizedBox(height: 8),
          Row(
            children: [
              _statBox(
                LucideIcons.trendingUp,
                'Promedio',
                classAvg,
                '${_students.length} est.',
                AppColors.primary,
                AppColors.primarySurface,
              ),
              const SizedBox(width: 8),
              _statBox(
                LucideIcons.users,
                'Aprobados',
                avgs.isNotEmpty ? '$passing/${avgs.length}' : '—',
                'nota >= 70',
                AppColors.success,
                AppColors.success.withValues(alpha: 0.1),
              ),
              const SizedBox(width: 8),
              _statBox(
                LucideIcons.award,
                'Estado',
                _published ? '✓' : '—',
                _published ? 'Publicado' : 'Borrador',
                _published ? AppColors.success : AppColors.textTertiary,
                _published
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.background,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search
          TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'Buscar estudiante...',
              prefixIcon: const Icon(LucideIcons.search, size: 18),
              suffixIcon: _search.isNotEmpty
                  ? IconButton(
                      icon: const Icon(LucideIcons.x, size: 16),
                      onPressed: () => setState(() => _search = ''),
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderMedium),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderMedium),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
          if (_search.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 4, top: 4),
              child: Text(
                '${filtered.length} resultado(s)',
                style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
              ),
            ),
          const SizedBox(height: 12),

          // Warning
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderMedium),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.alertCircle,
                  size: 14,
                  color: AppColors.warning,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pesos: Parcial 1 (30%) · Parcial 2 (30%) · Final (40%) · Aprobado ≥ 70',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // List
          ...filtered.map((s) {
            final avg = _calcAvg(s);
            final letter = _getLetter(avg);
            final isLow = avg != null && avg < 70;
            final isComplete =
                s.midterm1 != null && s.midterm2 != null && s.finalExam != null;
            final actualIdx = _students.indexWhere((stu) => stu.id == s.id);

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLow
                    ? const Color(0xFFFEF2F2).withValues(alpha: 0.5)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isLow ? const Color(0xFFFECACA) : AppColors.border,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isLow
                              ? const Color(0xFFFEE2E2)
                              : AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            s.name.split(' ').take(2).map((e) => e[0]).join(''),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isLow
                                  ? AppColors.error
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              s.id,
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              (avg?.toStringAsFixed(1) ?? '—'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isLow
                                    ? AppColors.error
                                    : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Prom.',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _getLetterBg(letter),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                letter,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: _getLetterColor(letter),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${s.attendance}%',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: s.attendance < 75
                                    ? AppColors.error
                                    : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Asist.',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isComplete
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isComplete
                                ? AppColors.success.withValues(alpha: 0.2)
                                : AppColors.warning.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          isComplete ? 'Completo' : 'Notas incompletas',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isComplete
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showGradeModal(context, s, actualIdx),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            LucideIcons.pencil,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          if (filtered.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'No se encontraron estudiantes.',
                  style: TextStyle(color: AppColors.textTertiary, fontSize: 13),
                ),
              ),
            ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _published ? null : _handlePublish,
              icon: Icon(
                _published ? LucideIcons.eye : LucideIcons.barChart2,
                size: 16,
              ),
              label: Text(
                _published
                    ? 'Publicado — Ver Resultados'
                    : 'Calcular y Publicar Calificaciones',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _published
                    ? AppColors.success
                    : AppColors.gold,
                foregroundColor: _published ? Colors.white : AppColors.primary,
                disabledBackgroundColor: AppColors.success,
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(
    IconData icon,
    String label,
    String value,
    String sub,
    Color color,
    Color bg,
  ) => Expanded(
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            sub,
            style: TextStyle(fontSize: 9, color: AppColors.textTertiary),
          ),
        ],
      ),
    ),
  );
}
