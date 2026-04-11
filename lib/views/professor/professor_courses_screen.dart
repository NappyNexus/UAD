import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';

class ProfessorCoursesScreen extends StatefulWidget {
  const ProfessorCoursesScreen({super.key});

  @override
  State<ProfessorCoursesScreen> createState() => _ProfessorCoursesScreenState();
}

class _ProfessorCoursesScreenState extends State<ProfessorCoursesScreen> {
  Map<String, dynamic>? _docsModalCourse;
  final Map<String, List<Map<String, dynamic>>> _docs = {};
  bool _uploading = false;
  String _docType = 'Avalúo';
  final List<String> _docTypes = [
    'Avalúo',
    'Cronograma',
    'Programa del Curso',
    'Material de Apoyo',
    'Otro',
  ];
  String? _selectedFileName;

  List<Map<String, dynamic>> _courseDocs(String courseId) =>
      _docs[courseId] ?? [];

  void _handleUpload(StateSetter setModalState) {
    if (_selectedFileName == null || _docsModalCourse == null) return;
    setModalState(() => _uploading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          final newDoc = {
            'name': _selectedFileName!,
            'type': _docType,
            'date': '07/04/2026',
          };
          _docs
              .putIfAbsent((_docsModalCourse!['id'] ?? '').toString(), () => [])
              .add(newDoc);
        });
        setModalState(() {
          _selectedFileName = null;
          _uploading = false;
        });
      }
    });
  }

  void _handleDelete(String courseId, int index, StateSetter setModalState) {
    setState(() {
      _docs[courseId]?.removeAt(index);
    });
    setModalState(() {});
  }

  void _showDocsModal(BuildContext context, Map<String, dynamic> course) {
    setState(() => _docsModalCourse = course);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final numDocs = _courseDocs((course['id'] ?? '').toString()).length;
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
                  'Documentos — ${course['name'] ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // Upload Form
                Text(
                  'TIPO DE DOCUMENTO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _docType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.borderMedium),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  items: _docTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setModalState(() => _docType = v);
                  },
                ),
                SizedBox(height: 12),
                Text(
                  'ARCHIVO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 6),
                GestureDetector(
                  onTap: () => setModalState(
                    () => _selectedFileName = 'documento_curso.pdf',
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.borderMedium,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.fileUp,
                          size: 20,
                          color: AppColors.textTertiary,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedFileName ??
                                    'Haz clic para simular subida',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                'PDF, DOC, DOCX, XLSX',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: (_selectedFileName == null || _uploading)
                        ? null
                        : () => _handleUpload(setModalState),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _uploading ? 'Subiendo...' : 'Subir Documento',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                if (numDocs > 0) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  SizedBox(height: 8),
                  Text(
                    'DOCUMENTOS SUBIDOS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: 8),
                  ..._courseDocs(
                    (course['id'] ?? '').toString(),
                  ).asMap().entries.map((entry) {
                    final i = entry.key;
                    final doc = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.fileText,
                            size: 16,
                            color: AppColors.info,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (doc['name'] ?? '').toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${doc['type'] ?? ''} · ${doc['date'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _handleDelete(
                              (course['id'] ?? '').toString(),
                              i,
                              setModalState,
                            ),
                            child: Icon(
                              LucideIcons.trash2,
                              size: 16,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          );
        },
      ),
    ).whenComplete(
      () => setState(() {
        _docsModalCourse = null;
        _selectedFileName = null;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = currentProfessor;
    final totalStudents = professorCourses.fold<int>(
      0,
      (sum, c) =>
          sum + ((c['enrolled'] ?? 0) is num ? c['enrolled'] as int : 0),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ═══ Welcome Card ═══
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
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.surface.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: p['photo'] != null
                        ? Image.network(
                            (p['photo'] ?? '').toString(),
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: AppColors.surface.withValues(alpha: 0.2),
                          ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Portal del Profesor',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.surface.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        (p['name'] ?? '').toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.surface,
                        ),
                      ),
                      Text(
                        (p['department'] ?? '').toString(),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.surface.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          const PageHeader(
            title: 'Mis Cursos',
            subtitle: 'Período Agosto - Diciembre 2024',
          ),

          // ═══ Courses Grid ═══
          ...professorCourses.map((c) {
            final numDocs = _courseDocs((c['id'] ?? '').toString()).length;
            return InkWell(
              onTap: () => context.push(
                '${AppConstants.routeCourseProfile}?courseId=${c['id']}',
              ),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (c['name'] ?? '').toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${c['id'] ?? ''} · Sección ${c['section'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronRight,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.clock,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          (c['schedule'] ?? '').toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(
                          LucideIcons.mapPin,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          (c['room'] ?? '').toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.users,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${c['enrolled'] ?? 0} estudiantes',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => _showDocsModal(context, c),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.infoSurface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  LucideIcons.fileText,
                                  size: 14,
                                  color: AppColors.info,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Documentos ',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.info,
                                  ),
                                ),
                                if (numDocs > 0)
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: AppColors.info,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$numDocs',
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: AppColors.surface,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),

          // ═══ Quick Stats ═══
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
                Text(
                  'Resumen',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _resumenItem('${professorCourses.length}', 'Cursos'),
                    _resumenItem('$totalStudents', 'Estudiantes'),
                    _resumenItem('12', 'Horas/semana'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resumenItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
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
}
