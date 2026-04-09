import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/status_badge.dart';

class AdminProgramsScreen extends StatefulWidget {
  const AdminProgramsScreen({super.key});

  @override
  State<AdminProgramsScreen> createState() => _AdminProgramsScreenState();
}

class _AdminProgramsScreenState extends State<AdminProgramsScreen> {
  final List<Map<String, dynamic>> _programList = List.from(programs);

  // States
  String? _confirmToggleId;

  void _showProgramModal(Map<String, dynamic>? initial) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _ProgramForm(
        initial: initial,
        onSave: (updated) {
          setState(() {
            if (initial == null) {
              _programList.add({...updated, 'status': 'Activo', 'students': 0});
            } else {
              final idx = _programList.indexWhere(
                (p) => p['id'] == updated['id'],
              );
              if (idx >= 0) {
                _programList[idx] = {..._programList[idx], ...updated};
              }
            }
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _toggleStatus(Map<String, dynamic> p) {
    setState(() {
      final idx = _programList.indexWhere((item) => item['id'] == p['id']);
      if (idx >= 0) {
        _programList[idx]['status'] = p['status'] == 'Activo'
            ? 'Inactivo'
            : 'Activo';
      }
      _confirmToggleId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: PageHeader(
                  title: 'Programas Acad.',
                  subtitle: '${_programList.length} programas registrados',
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showProgramModal(null),
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

          ..._programList.map((p) {
            final isActive = p['status'] == 'Activo';
            final id = p['id'] as String;

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
                              '$id · ${p['faculty']}',
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _stat(LucideIcons.bookOpen, '${p['credits']} cr.'),
                      _stat(LucideIcons.clock, p['duration'] as String),
                      _stat(LucideIcons.users, '${p['students']}'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showProgramModal(p),
                          icon: const Icon(LucideIcons.edit3, size: 14),
                          label: Text('Editar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textSecondary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: AppColors.borderMedium),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _confirmToggleId == id
                            ? Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => _toggleStatus(p),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isActive
                                            ? AppColors.error
                                            : AppColors.success,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: const Text('Confirmar'),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  ElevatedButton(
                                    onPressed: () =>
                                        setState(() => _confirmToggleId = null),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.textSecondary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: AppColors.borderMedium,
                                        ),
                                      ),
                                    ),
                                    child: const Icon(LucideIcons.x, size: 14),
                                  ),
                                ],
                              )
                            : ElevatedButton.icon(
                                onPressed: () =>
                                    setState(() => _confirmToggleId = id),
                                icon: const Icon(LucideIcons.power, size: 14),
                                label: Text(
                                  isActive ? 'Desactivar' : 'Activar',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: isActive
                                      ? AppColors.error
                                      : AppColors.success,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: isActive
                                          ? const Color(0xFFFECACA)
                                          : const Color(0xFFA7F3D0),
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
    );
  }

  Widget _stat(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 14, color: AppColors.textTertiary),
      SizedBox(width: 4),
      Text(
        text,
        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
      ),
    ],
  );
}

class _ProgramForm extends StatefulWidget {
  final Map<String, dynamic>? initial;
  final Function(Map<String, dynamic>) onSave;

  const _ProgramForm({this.initial, required this.onSave});

  @override
  State<_ProgramForm> createState() => _ProgramFormState();
}

class _ProgramFormState extends State<_ProgramForm> {
  late String id;
  late String name;
  late String faculty;
  late int credits;
  late String duration;

  @override
  void initState() {
    super.initState();
    id = widget.initial?['id'] ?? 'NUEVO_ID';
    name = widget.initial?['name'] ?? '';
    faculty = widget.initial?['faculty'] ?? '';
    credits = widget.initial?['credits'] ?? 0;
    duration = widget.initial?['duration'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
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
                widget.initial != null ? 'Editar Programa' : 'Nuevo Programa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _input('ID (Código)', id, (v) => id = v),
              _input('Nombre', name, (v) => name = v),
              _input('Facultad', faculty, (v) => faculty = v),
              Row(
                children: [
                  Expanded(
                    child: _input(
                      'Créditos',
                      '$credits',
                      (v) => credits = int.tryParse(v) ?? 0,
                      kbd: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _input('Duración', duration, (v) => duration = v),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => widget.onSave({
                  'id': id,
                  'name': name,
                  'faculty': faculty,
                  'credits': credits,
                  'duration': duration,
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Guardar Cambios'),
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
            decoration: InputDecoration(
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
