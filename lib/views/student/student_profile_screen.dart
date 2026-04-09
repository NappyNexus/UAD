import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    final s = currentStudent;

    final infoSections = [
      {
        'title': 'Información Personal',
        'fields': [
          {
            'icon': LucideIcons.user,
            'label': 'Nombre Completo',
            'value': s.name,
            'editable': false,
          },
          {
            'icon': LucideIcons.shield,
            'label': 'Cédula',
            'value': s.cedula,
            'editable': false,
          },
          {
            'icon': LucideIcons.calendar,
            'label': 'Fecha de Nacimiento',
            'value': '15/03/2002',
            'editable': false,
          },
          {
            'icon': LucideIcons.globe,
            'label': 'Nacionalidad',
            'value': 'Dominicana',
            'editable': false,
          },
          {
            'icon': LucideIcons.user,
            'label': 'Género',
            'value': 'Femenino',
            'editable': false,
          },
          {
            'icon': LucideIcons.heart,
            'label': 'Tipo de Sangre',
            'value': 'O+',
            'editable': false,
          },
        ],
      },
      {
        'title': 'Contacto',
        'fields': [
          {
            'icon': LucideIcons.mail,
            'label': 'Correo',
            'value': s.email,
            'editable': true,
          },
          {
            'icon': LucideIcons.phone,
            'label': 'Teléfono',
            'value': s.phone,
            'editable': true,
          },
          {
            'icon': LucideIcons.mapPin,
            'label': 'Dirección',
            'value': s.address,
            'editable': true,
          },
          {
            'icon': LucideIcons.phone,
            'label': 'Contacto de Emergencia',
            'value': '809-555-0100 (Madre)',
            'editable': true,
          },
        ],
      },
      {
        'title': 'Información Académica',
        'fields': [
          {
            'icon': LucideIcons.graduationCap,
            'label': 'Programa',
            'value': s.program,
            'editable': false,
          },
          {
            'icon': LucideIcons.calendar,
            'label': 'Cohorte',
            'value': s.cohort,
            'editable': false,
          },
          {
            'icon': LucideIcons.calendar,
            'label': 'Semestre Actual',
            'value': '${s.semester}°',
            'editable': false,
          },
          {
            'icon': LucideIcons.shield,
            'label': 'Matrícula',
            'value': s.id,
            'editable': false,
          },
          {
            'icon': LucideIcons.calendar,
            'label': 'Fecha de Ingreso',
            'value': 'Enero 2022',
            'editable': false,
          },
        ],
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Mi Perfil',
            action: ElevatedButton.icon(
              onPressed: () => setState(() => _editing = !_editing),
              icon: Icon(
                _editing ? LucideIcons.save : LucideIcons.edit3,
                size: 16,
              ),
              label: Text(_editing ? 'Guardar' : 'Editar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _editing ? AppColors.primary : AppColors.surface,
                foregroundColor: _editing
                    ? Colors.white
                    : AppColors.textPrimary,
                side: _editing
                    ? null
                    : BorderSide(color: AppColors.borderMedium),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // ═══ Profile Header ═══
          Container(
            width: double.infinity,
            // padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF026A45), Color(0xFF038556)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.surface.withValues(alpha: 0.2),
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: s.photo != null
                              ? Image.network(s.photo!, fit: BoxFit.cover)
                              : Container(
                                  color: AppColors.surface.withValues(alpha: 0.2),
                                  child: Center(
                                    child: Text(
                                      s.name[0],
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s.program,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.surface.withValues(alpha: 0.8),
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    s.status,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Indice: ${s.gpa}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.surface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ═══ Info Sections ═══
          ...infoSections.map(
            (section) => Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
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
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        section['title'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  ...(section['fields'] as List).map((field) {
                    final f = field as Map<String, dynamic>;
                    final isEditable = f['editable'] == true;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.border.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              f['icon'] as IconData,
                              size: 16,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  f['label'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                if (_editing && isEditable)
                                  TextFormField(
                                    initialValue: f['value'] as String?,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                        bottom: 4,
                                        top: 4,
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.primary,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    f['value'] as String? ?? '-',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
