import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/status_badge.dart';

final _initialCourses = [
  {
    'id': 'MAT-301',
    'name': 'Cálculo III',
    'credits': 4,
    'program': 'Ing. en Sistemas',
    'semester': 4,
    'prerequisite': 'MAT-201',
    'status': 'Activo',
    'sections': [
      {
        'id': '01',
        'professor': 'Dr. Carlos Martínez',
        'schedule': 'LMV 8:00-9:30',
        'room': 'A-201',
        'capacity': 35,
        'enrolled': 32,
      },
    ],
  },
  {
    'id': 'ING-305',
    'name': 'Base de Datos II',
    'credits': 3,
    'program': 'Ing. en Sistemas',
    'semester': 4,
    'prerequisite': 'ING-205',
    'status': 'Activo',
    'sections': [
      {
        'id': '01',
        'professor': 'Ing. Ana Pérez',
        'schedule': 'MJ 10:00-11:30',
        'room': 'Lab-3',
        'capacity': 30,
        'enrolled': 28,
      },
    ],
  },
  {
    'id': 'ING-310',
    'name': 'Ingeniería de Software',
    'credits': 4,
    'program': 'Ing. en Sistemas',
    'semester': 4,
    'prerequisite': 'ING-210',
    'status': 'Activo',
    'sections': [
      {
        'id': '01',
        'professor': 'Ing. Roberto Díaz',
        'schedule': 'LMV 10:00-11:30',
        'room': 'A-105',
        'capacity': 35,
        'enrolled': 35,
      },
      {
        'id': '02',
        'professor': 'Ing. Roberto Díaz',
        'schedule': 'LMV 14:00-15:30',
        'room': 'A-105',
        'capacity': 35,
        'enrolled': 20,
      },
    ],
  },
  {
    'id': 'ADM-100',
    'name': 'Introducción a la Administración',
    'credits': 3,
    'program': 'Administración',
    'semester': 1,
    'prerequisite': null,
    'status': 'Activo',
    'sections': [
      {
        'id': '01',
        'professor': 'Lic. María Torres',
        'schedule': 'MJ 8:00-9:30',
        'room': 'B-101',
        'capacity': 40,
        'enrolled': 38,
      },
    ],
  },
  {
    'id': 'DER-200',
    'name': 'Derecho Civil I',
    'credits': 4,
    'program': 'Derecho',
    'semester': 3,
    'prerequisite': 'DER-100',
    'status': 'Activo',
    'sections': [
      {
        'id': '01',
        'professor': 'Dr. Rafael Sánchez',
        'schedule': 'LMV 16:00-17:30',
        'room': 'C-201',
        'capacity': 45,
        'enrolled': 40,
      },
    ],
  },
];

class AdminCoursesScreen extends StatefulWidget {
  const AdminCoursesScreen({super.key});

  @override
  State<AdminCoursesScreen> createState() => _AdminCoursesScreenState();
}

class _AdminCoursesScreenState extends State<AdminCoursesScreen> {
  final List<Map<String, dynamic>> _courses = List.from(_initialCourses);
  String _searchQuery = '';

  void _showCourseModal(Map<String, dynamic>? initial) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _CourseForm(
        initial: initial,
        onSave: (updated) {
          setState(() {
            if (initial == null) {
              _courses.insert(0, {
                ...updated,
                'status': 'Activo',
                'sections': [],
              });
            } else {
              final idx = _courses.indexWhere((c) => c['id'] == updated['id']);
              if (idx >= 0) _courses[idx] = {..._courses[idx], ...updated};
            }
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _courses.where((c) {
      final name = (c['name'] as String).toLowerCase();
      final id = (c['id'] as String).toLowerCase();
      final q = _searchQuery.toLowerCase();
      return name.contains(q) || id.contains(q);
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: PageHeader(
                  title: 'Gestión de Cursos',
                  subtitle: 'Administra cursos, secciones y asignaciones',
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCourseModal(null),
                icon: const Icon(LucideIcons.plus, size: 14),
                label: const Text(
                  'Nuevo',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          // Search
          Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderMedium),
            ),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  LucideIcons.search,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
                hintText: 'Buscar cursos...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: AppColors.textTertiary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                isDense: true,
              ),
            ),
          ),

          // Courses List
          ...filtered.map(
            (c) => Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      c['name'] as String,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  StatusBadge(status: c['status'] as String),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${c['id']} · ${c['credits']} créditos · ${c['program']} · Sem. ${c['semester']}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (c['prerequisite'] != null) ...[
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      LucideIcons.link,
                                      size: 12,
                                      color: AppColors.textTertiary,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Prerrequisito: ${c['prerequisite']}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showCourseModal(c),
                          icon: const Icon(LucideIcons.edit3, size: 12),
                          label: const Text(
                            'Editar',
                            style: TextStyle(fontSize: 11),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textSecondary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: Size(0, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: AppColors.borderMedium),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: (c['sections'] as List)
                          .map(
                            (sec) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: AppColors.borderMedium,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Wrap(
                                      spacing: 12,
                                      runSpacing: 4,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          'Sec. ${sec['id']}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          '${sec['professor']}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              LucideIcons.clock,
                                              size: 12,
                                              color: AppColors.textTertiary,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '${sec['schedule']}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textTertiary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              LucideIcons.mapPin,
                                              size: 12,
                                              color: AppColors.textTertiary,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '${sec['room']}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textTertiary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        LucideIcons.users,
                                        size: 12,
                                        color: AppColors.textTertiary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${sec['enrolled']}/${sec['capacity']}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              (sec['enrolled'] as int) >=
                                                  (sec['capacity'] as int)
                                              ? AppColors.error
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
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

class _CourseForm extends StatefulWidget {
  final Map<String, dynamic>? initial;
  final Function(Map<String, dynamic>) onSave;

  const _CourseForm({this.initial, required this.onSave});

  @override
  State<_CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<_CourseForm> {
  late String id;
  late String name;
  late int credits;
  late String program;
  late String prerequisite;

  @override
  void initState() {
    super.initState();
    id = widget.initial?['id'] ?? '';
    name = widget.initial?['name'] ?? '';
    credits = widget.initial?['credits'] ?? 3;
    program = widget.initial?['program'] ?? 'Ing. en Sistemas';
    prerequisite = widget.initial?['prerequisite'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Editar Curso' : 'Nuevo Curso',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _input('Nombre del Curso', name, (v) => name = v),
              Row(
                children: [
                  Expanded(
                    child: _input(
                      'Código',
                      id,
                      (v) => id = v,
                      isReadOnly: isEdit,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _input(
                      'Créditos',
                      '$credits',
                      (v) => credits = int.tryParse(v) ?? 0,
                      kbd: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Programa',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderMedium),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: program,
                          hint: const Text('Seleccionar...'),
                          items:
                              [
                                    'Ing. en Sistemas',
                                    'Administración',
                                    'Contabilidad',
                                    'Derecho',
                                  ]
                                  .map(
                                    (p) => DropdownMenuItem(
                                      value: p,
                                      child: Text(
                                        p,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => program = v);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _input(
                'Prerrequisito',
                prerequisite,
                (v) => prerequisite = v,
                placeholder: 'Opcional',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => widget.onSave({
                  'id': id,
                  'name': name,
                  'credits': credits,
                  'program': program,
                  'prerequisite': prerequisite.isEmpty ? null : prerequisite,
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(isEdit ? 'Guardar Cambios' : 'Crear Curso'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    String label,
    String value,
    Function(String) onChanged, {
    TextInputType kbd = TextInputType.text,
    bool isReadOnly = false,
    String? placeholder,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4),
          TextFormField(
            initialValue: value,
            onChanged: onChanged,
            keyboardType: kbd,
            readOnly: isReadOnly,
            style: TextStyle(
              fontSize: 13,
              color: isReadOnly
                  ? AppColors.textTertiary
                  : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderMedium),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              filled: isReadOnly,
              fillColor: isReadOnly ? AppColors.background : Colors.white,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
