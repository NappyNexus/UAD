import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/status_badge.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = requests.length;
    final inProcess = requests.where((r) => r['status'] == 'En proceso').length;
    final completed = requests.where((r) => r['status'] == 'Completada').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Solicitudes',
            subtitle: 'Gestiona tus solicitudes y seguimientos',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showNewRequest(context),
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text('Nueva Solicitud'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ═══ Stats ═══
          Row(
            children: [
              _statMini('$total', 'Total', AppColors.textPrimary),
              const SizedBox(width: 10),
              _statMini('$inProcess', 'En Proceso', AppColors.warning),
              const SizedBox(width: 10),
              _statMini('$completed', 'Completadas', AppColors.success),
            ],
          ),
          const SizedBox(height: 16),

          // ═══ Request List ═══
          ...requests.map((r) {
            final status = r['status'] as String;
            final IconData icon;
            final Color iconColor;
            if (status == 'Completada') {
              icon = LucideIcons.fileText;
              iconColor = AppColors.success;
            } else if (status == 'En proceso') {
              icon = LucideIcons.clock;
              iconColor = AppColors.warning;
            } else {
              icon = LucideIcons.messageSquare;
              iconColor = AppColors.textTertiary;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 16, color: iconColor),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r['type'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${r['id']} · ${r['date']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          r['details'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: status),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _statMini(String value, String label, Color color) => Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    ),
  );

  void _showNewRequest(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const NewRequestFormSheet(),
    );
  }
}

class NewRequestFormSheet extends StatefulWidget {
  const NewRequestFormSheet({super.key});

  @override
  State<NewRequestFormSheet> createState() => _NewRequestFormSheetState();
}

class _NewRequestFormSheetState extends State<NewRequestFormSheet> {
  String? _type;
  bool _submitted = false;

  final _requestTypes = [
    "Certificado de Estudios",
    "Certificado de Inscripción",
    "Certificado de Calificaciones",
    "Certificado de Buena Conducta",
    "Revisión de Calificación",
    "Reporte de Profesor",
    "Cambio de Sección",
    "Retiro de Materia",
    "Carta de Recomendación",
    "Otro",
  ];

  final _professors = [
    "Dr. Carlos Martínez",
    "Ing. Ana Pérez",
    "Ing. Roberto Díaz",
    "Ing. Luis Gómez",
    "Lic. Carmen Sosa",
  ];

  final _incidentTypes = [
    "Ausencias repetidas sin aviso",
    "Trato irrespetuoso al estudiante",
    "No cumple con el programa del curso",
    "Evaluaciones fuera de tiempo",
    "Conducta inapropiada",
    "Otro",
  ];

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6, top: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items) {
    return DropdownButtonFormField<String>(
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
      hint: Text(
        hint,
        style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
      ),
      items: items
          .map(
            (i) => DropdownMenuItem(
              value: i,
              child: Text(i, style: const TextStyle(fontSize: 13)),
            ),
          )
          .toList(),
      onChanged: (_) {},
    );
  }

  Widget _buildTextField(
    String hint, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13, color: AppColors.textTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderMedium),
        ),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildRadio(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        Row(
          children: options
              .map(
                (o) => Row(
                  children: [
                    Radio<String>(
                      value: o,
                      groupValue: null,
                      onChanged: (_) {},
                    ),
                    Text(o, style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 16),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  void _submit() {
    setState(() => _submitted = true);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.check,
                color: Color(0xFF16A34A),
                size: 28,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Solicitud enviada exitosamente',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Recibirás una respuesta en 3-5 días hábiles.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    final courses = studyPlanCourses
        .where((c) => c['status'] == 'En curso')
        .map((c) => c['name'] as String)
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
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
              'Nueva Solicitud',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildLabel('TIPO DE SOLICITUD'),
            DropdownButtonFormField<String>(
              initialValue: _type,
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
              hint: const Text(
                '-- Selecciona un tipo --',
                style: TextStyle(fontSize: 13),
              ),
              items: _requestTypes
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(t, style: const TextStyle(fontSize: 13)),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _type = val),
            ),

            if (_type == "Certificado de Estudios" ||
                _type == "Certificado de Inscripción" ||
                _type == "Certificado de Calificaciones" ||
                _type == "Certificado de Buena Conducta") ...[
              _buildLabel('PROPÓSITO DEL CERTIFICADO'),
              _buildDropdown('Seleccionar...', [
                'Beca externa',
                'Empleo',
                'Trámite migratorio',
                'Institución bancaria',
                'Uso personal',
                'Otro',
              ]),
              _buildLabel('NÚMERO DE COPIAS'),
              _buildTextField('Ej: 1', keyboardType: TextInputType.number),
              _buildRadio('¿REQUIERE APOSTILLA?', ['Sí', 'No']),
            ],

            if (_type == "Revisión de Calificación") ...[
              _buildLabel('MATERIA'),
              _buildDropdown('Seleccionar materia...', courses),
              _buildLabel('TIPO DE EVALUACIÓN A REVISAR'),
              _buildDropdown('Seleccionar...', [
                'Primer parcial',
                'Segundo parcial',
                'Examen final',
                'Tarea / Proyecto',
              ]),
              _buildLabel('CALIFICACIÓN RECIBIDA'),
              _buildTextField('Ej: 65'),
              _buildLabel('ARGUMENTO / JUSTIFICACIÓN'),
              _buildTextField(
                'Explica por qué consideras que la nota es incorrecta...',
                maxLines: 3,
              ),
            ],

            if (_type == "Reporte de Profesor") ...[
              _buildLabel('PROFESOR A REPORTAR'),
              _buildDropdown('Seleccionar profesor...', _professors),
              _buildLabel('MATERIA INVOLUCRADA'),
              _buildDropdown('Seleccionar...', courses),
              _buildLabel('TIPO DE INCIDENCIA'),
              _buildDropdown('Seleccionar...', _incidentTypes),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('FECHA'),
                        _buildTextField('YYYY-MM-DD'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_buildLabel('HORA'), _buildTextField('HH:MM')],
                    ),
                  ),
                ],
              ),
              _buildRadio('¿HUBO TESTIGOS?', ['Sí', 'No']),
              _buildLabel('DESCRIPCIÓN DETALLADA DE LO OCURRIDO'),
              _buildTextField(
                'Describe con detalle lo que ocurrió...',
                maxLines: 4,
              ),
            ],

            if (_type == "Cambio de Sección") ...[
              _buildLabel('MATERIA ACTUAL'),
              _buildDropdown('Seleccionar...', courses),
              _buildLabel('SECCIÓN DESEADA'),
              _buildTextField('Ej: Sección 02'),
              _buildLabel('MOTIVO DEL CAMBIO'),
              _buildDropdown('Seleccionar...', [
                'Conflicto de horario laboral',
                'Problemas de transporte',
                'Razones médicas',
                'Preferencia de profesor',
                'Otro',
              ]),
              _buildLabel('DETALLES ADICIONALES'),
              _buildTextField('', maxLines: 3),
            ],

            if (_type == "Retiro de Materia") ...[
              _buildLabel('MATERIA A RETIRAR'),
              _buildDropdown('Seleccionar...', courses),
              _buildLabel('MOTIVO DEL RETIRO'),
              _buildDropdown('Seleccionar...', [
                'Carga académica alta',
                'Problemas económicos',
                'Razones de salud',
                'Situación familiar',
                'Otro',
              ]),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '⚠️ El retiro puede afectar tu índice académico y créditos del semestre. Consulta con tu asesor antes de proceder.',
                  style: TextStyle(fontSize: 11, color: Color(0xFFB45309)),
                ),
              ),
            ],

            if (_type == "Carta de Recomendación") ...[
              _buildLabel('DIRIGIDA A'),
              _buildTextField('Institución o empresa'),
              _buildLabel('PROPÓSITO'),
              _buildDropdown('Seleccionar...', [
                'Empleo',
                'Maestría / Posgrado',
                'Beca',
                'Intercambio estudiantil',
                'Otro',
              ]),
              _buildLabel('FECHA LÍMITE REQUERIDA'),
              _buildTextField('YYYY-MM-DD'),
            ],

            if (_type == "Otro") ...[
              _buildLabel('DESCRIPCIÓN DE LA SOLICITUD'),
              _buildTextField(
                'Describe detalladamente tu solicitud...',
                maxLines: 5,
              ),
            ],

            const SizedBox(height: 24),
            if (_type != null)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Enviar Solicitud',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
