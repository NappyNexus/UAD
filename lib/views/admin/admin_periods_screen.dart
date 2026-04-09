import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/common/push_toast.dart';

class AdminPeriodsScreen extends StatefulWidget {
  const AdminPeriodsScreen({super.key});

  @override
  State<AdminPeriodsScreen> createState() => _AdminPeriodsScreenState();
}

class _AdminPeriodsScreenState extends State<AdminPeriodsScreen> {
  final List<dynamic> _periods = List.from(academicPeriods);
  String? _toastMessage;

  void _showToast(String msg) {
    setState(() => _toastMessage = msg);
    Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      if (mounted) setState(() => _toastMessage = null);
    });
  }

  void _handleOpenEnrollment(Map<String, dynamic> p) {
    setState(() {
      final idx = _periods.indexWhere((per) => per['id'] == p['id']);
      if (idx >= 0) {
        _periods[idx] = {
          'id': p['id'],
          'name': p['name'],
          'startDate': p['startDate'],
          'endDate': p['endDate'],
          'status': 'Abierto',
          'enrollmentOpen': true,
        };
      }
    });
    _showToast('✅ Inscripción abierta para ${p['name']}');
  }

  void _handleCloseEnrollment(Map<String, dynamic> p) {
    setState(() {
      final idx = _periods.indexWhere((per) => per['id'] == p['id']);
      if (idx >= 0) {
        _periods[idx] = {
          'id': p['id'],
          'name': p['name'],
          'startDate': p['startDate'],
          'endDate': p['endDate'],
          'status': 'Cerrado',
          'enrollmentOpen': false,
        };
      }
    });
    _showToast('🔒 Inscripción cerrada para ${p['name']}');
  }

  void _showConfigModal(Map<String, dynamic>? initial) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _ConfigForm(
        initial: initial,
        onSave: (updated) {
          setState(() {
            if (initial == null) {
              _periods.add({
                'id': 'NEW-${DateTime.now().millisecondsSinceEpoch}',
                'name': updated['name'],
                'startDate': updated['startDate'],
                'endDate': updated['endDate'],
                'status': 'Planificación',
                'enrollmentOpen': false,
              });
            } else {
              final idx = _periods.indexWhere(
                (per) => per['id'] == updated['id'],
              );
              if (idx >= 0) {
                _periods[idx] = {
                  'id': updated['id'],
                  'name': updated['name'],
                  'startDate': updated['startDate'],
                  'endDate': updated['endDate'],
                  'status': _periods[idx]['status'],
                  'enrollmentOpen': _periods[idx]['enrollmentOpen'],
                };
              }
            }
          });
          Navigator.pop(ctx);
          _showToast('✅ Configuración guardada');
        },
      ),
    );
  }

  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'Abierto':
        return const Icon(LucideIcons.play, size: 16, color: AppColors.success);
      case 'Cerrado':
        return Icon(LucideIcons.lock, size: 16, color: AppColors.textTertiary);
      case 'Planificación':
        return const Icon(LucideIcons.settings, size: 16, color: Colors.purple);
      default:
        return const Icon(
          LucideIcons.calendar,
          size: 16,
          color: AppColors.primary,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: PageHeader(
                        title: 'Períodos Académicos',
                        subtitle: 'Configura y gestiona períodos',
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showConfigModal(null),
                      icon: const Icon(LucideIcons.plus, size: 14),
                      label: const Text(
                        'Nuevo',
                        style: TextStyle(
                          fontSize: 13,
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
                  ],
                ),

                ..._periods.map((p) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(20),
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
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: _getStatusIcon(p['status'] as String),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p['name'] as String,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    p['id'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(status: p['status'] as String),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Inicio',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    p['startDate'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fin',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    p['endDate'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            if (p['status'] == 'Planificación')
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _handleOpenEnrollment(p),
                                  icon: const Icon(LucideIcons.play, size: 12),
                                  label: const Text('Abrir Inscripción'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    minimumSize: const Size(0, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            if (p['status'] == 'Abierto')
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _handleCloseEnrollment(p),
                                  icon: const Icon(LucideIcons.pause, size: 12),
                                  label: const Text('Cerrar Inscripción'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.warning,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    minimumSize: const Size(0, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: AppColors.warning.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (p['status'] == 'Planificación' ||
                                p['status'] == 'Abierto')
                              SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _showConfigModal(p),
                                icon: const Icon(
                                  LucideIcons.settings,
                                  size: 12,
                                ),
                                label: Text('Configurar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.textSecondary,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  minimumSize: Size(0, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: AppColors.borderMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          if (_toastMessage != null) PushToast(message: _toastMessage!),
        ],
      ),
    );
  }
}

class _ConfigForm extends StatefulWidget {
  final Map<String, dynamic>? initial;
  final Function(Map<String, dynamic>) onSave;

  const _ConfigForm({this.initial, required this.onSave});

  @override
  State<_ConfigForm> createState() => _ConfigFormState();
}

class _ConfigFormState extends State<_ConfigForm> {
  late String name;
  late String startDate;
  late String endDate;
  int credits = 21;

  @override
  void initState() {
    super.initState();
    name = widget.initial?['name'] ?? '';
    startDate = widget.initial?['startDate'] ?? '';
    endDate = widget.initial?['endDate'] ?? '';
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
                isEdit
                    ? 'Configurar: ${widget.initial!['name']}'
                    : 'Nuevo Período Académico',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _input(
                'Nombre',
                name,
                (v) => name = v,
                placeholder: 'Ej: Enero - Mayo 2025',
              ),
              Row(
                children: [
                  Expanded(
                    child: _input(
                      'Fecha de Inicio',
                      startDate,
                      (v) => startDate = v,
                      placeholder: 'YYYY-MM-DD',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _input(
                      'Fecha de Fin',
                      endDate,
                      (v) => endDate = v,
                      placeholder: 'YYYY-MM-DD',
                    ),
                  ),
                ],
              ),
              _input(
                'Máximo de créditos por estudiante',
                '$credits',
                (v) => credits = int.tryParse(v) ?? 21,
                kbd: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => widget.onSave({
                  'id': widget.initial?['id'],
                  'name': name,
                  'startDate': startDate,
                  'endDate': endDate,
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(isEdit ? 'Guardar Configuración' : 'Crear Período'),
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
            style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(fontSize: 13, color: AppColors.textTertiary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderMedium),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
