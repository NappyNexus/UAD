import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../widgets/common/page_header.dart';

class GradeRevisionsScreen extends StatefulWidget {
  const GradeRevisionsScreen({super.key});

  @override
  State<GradeRevisionsScreen> createState() => _GradeRevisionsScreenState();
}

class _GradeRevisionsScreenState extends State<GradeRevisionsScreen> {
  final List<Map<String, dynamic>> _requests = [
    {
      'id': 1,
      'studentId': 'STU-2024-001',
      'studentName': 'María Elena Rodríguez',
      'courseId': 'MAT-301',
      'courseName': 'Cálculo III',
      'partial': 'Parcial 1',
      'currentGrade': 75,
      'requestedGrade': 82,
      'reason':
          'Creo que mi ejercicio 3 fue corregido incorrectamente. La integral por partes estaba bien resuelta pero no se tomó en cuenta la constante de integración.',
      'date': '2024-10-12',
      'status': 'pending',
      'response': null,
    },
    {
      'id': 2,
      'studentId': 'STU-2024-003',
      'studentName': 'Ana Isabel Martínez',
      'courseId': 'MAT-301',
      'courseName': 'Cálculo III',
      'partial': 'Parcial 2',
      'currentGrade': 88,
      'requestedGrade': 92,
      'reason':
          'El problema de series de Taylor fue marcado como incorrecto, pero verifiqué el procedimiento con el libro de texto y la respuesta coincide.',
      'date': '2024-10-14',
      'status': 'pending',
      'response': null,
    },
    {
      'id': 3,
      'studentId': 'STU-2024-002',
      'studentName': 'José Alberto Hernández',
      'courseId': 'MAT-401',
      'courseName': 'Ecuaciones Diferenciales',
      'partial': 'Parcial 1',
      'currentGrade': 68,
      'requestedGrade': 75,
      'reason':
          'Me faltaron 3 puntos del ejercicio final. Creo que el procedimiento fue correcto aunque la respuesta numérica fue diferente.',
      'date': '2024-10-08',
      'status': 'approved',
      'response':
          'Revisé el ejercicio y tienes razón, el procedimiento es correcto. Se actualizó la nota a 74.',
    },
  ];

  int? _expandedId;
  String _filter = 'all';
  final Map<int, String> _responses = {};

  void _handleRespond(int id, String status) {
    setState(() {
      final idx = _requests.indexWhere((r) => r['id'] == id);
      if (idx >= 0) {
        _requests[idx]['status'] = status;
        _requests[idx]['response'] = _responses[id] ?? '';
      }
      _expandedId = null;
    });
  }

  Map<String, dynamic> _getStatusConf(String st) {
    switch (st) {
      case 'pending':
        return {
          'label': 'Pendiente',
          'color': AppColors.warning,
          'bg': const Color(0xFFFEF3C7),
          'icon': LucideIcons.clock,
        };
      case 'approved':
        return {
          'label': 'Aprobada',
          'color': AppColors.success,
          'bg': const Color(0xFFD1FAE5),
          'icon': LucideIcons.check,
        };
      case 'rejected':
        return {
          'label': 'Rechazada',
          'color': AppColors.error,
          'bg': const Color(0xFFFEE2E2),
          'icon': LucideIcons.x,
        };
      default:
        return {
          'label': 'Desconocido',
          'color': AppColors.textSecondary,
          'bg': AppColors.background,
          'icon': LucideIcons.helpCircle,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pending = _requests.where((r) => r['status'] == 'pending').length;
    final filtered = _filter == 'all'
        ? _requests
        : _requests.where((r) => r['status'] == _filter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Solicitudes de Revisión',
            subtitle: pending > 0
                ? '$pending pendiente(s) de respuesta'
                : 'Todo al día',
          ),

          // Summary
          Row(
            children: [
              _summaryBox('Pendientes', pending.toString(), AppColors.warning),
              const SizedBox(width: 8),
              _summaryBox(
                'Aprobadas',
                _requests
                    .where((r) => r['status'] == 'approved')
                    .length
                    .toString(),
                AppColors.success,
              ),
              const SizedBox(width: 8),
              _summaryBox(
                'Rechazadas',
                _requests
                    .where((r) => r['status'] == 'rejected')
                    .length
                    .toString(),
                AppColors.error,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterBtn('all', 'Todas'),
                _filterBtn('pending', 'Pendientes'),
                _filterBtn('approved', 'Aprobadas'),
                _filterBtn('rejected', 'Rechazadas'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (filtered.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'No hay solicitudes.',
                  style: TextStyle(color: AppColors.textTertiary),
                ),
              ),
            ),

          ...filtered.map((req) {
            final id = req['id'] as int;
            final isOpen = _expandedId == id;
            final conf = _getStatusConf(req['status'] as String);

            return Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () =>
                        setState(() => _expandedId = isOpen ? null : id),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
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
                                    Expanded(
                                      child: Text(
                                        req['studentName'] as String,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: conf['bg'] as Color,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            conf['icon'] as IconData,
                                            size: 10,
                                            color: conf['color'] as Color,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            conf['label'] as String,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: conf['color'] as Color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${req['courseName']} · ${req['partial']}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 4,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Nota actual: ',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textTertiary,
                                          ),
                                        ),
                                        Text(
                                          '${req['currentGrade']}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Solicitada: ',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textTertiary,
                                          ),
                                        ),
                                        Text(
                                          '${req['requestedGrade']}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      req['date'] as String,
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
                          SizedBox(width: 12),
                          Icon(
                            isOpen
                                ? LucideIcons.chevronUp
                                : LucideIcons.chevronDown,
                            size: 16,
                            color: AppColors.textTertiary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (isOpen) ...[
                    Divider(height: 1, color: AppColors.borderMedium),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MOTIVO DEL ESTUDIANTE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textTertiary,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              req['reason'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          if (req['status'] == 'pending') ...[
                            Text(
                              'TU RESPUESTA',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textTertiary,
                                letterSpacing: 1.0,
                              ),
                            ),
                            SizedBox(height: 6),
                            TextField(
                              onChanged: (v) => _responses[id] = v,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText:
                                    'Escribe tu respuesta al estudiante...',
                                hintStyle: TextStyle(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.borderMedium,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _handleRespond(id, 'rejected'),
                                    icon: const Icon(LucideIcons.x, size: 14),
                                    label: const Text('Rechazar'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFEF2F2),
                                      foregroundColor: AppColors.error,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: const BorderSide(
                                          color: Color(0xFFFECACA),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _handleRespond(id, 'approved'),
                                    icon: const Icon(
                                      LucideIcons.check,
                                      size: 14,
                                    ),
                                    label: const Text('Aprobar Revisión'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else if (req['response'] != null) ...[
                            Text(
                              'TU RESPUESTA',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textTertiary,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: req['status'] == 'approved'
                                    ? const Color(0xFFF0FDF4)
                                    : const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                req['response'] as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: req['status'] == 'approved'
                                      ? AppColors.success
                                      : AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ],
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

  Widget _summaryBox(String label, String value, Color col) => Expanded(
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
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: col,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: AppColors.textTertiary),
          ),
        ],
      ),
    ),
  );

  Widget _filterBtn(String value, String label) {
    final isSelected = _filter == value;
    return Padding(
      padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: ElevatedButton(
        onPressed: () => setState(() => _filter = value),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : Colors.white,
          foregroundColor: isSelected ? Colors.white : AppColors.textSecondary,
          elevation: 0,
          side: isSelected ? null : BorderSide(color: AppColors.borderMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
