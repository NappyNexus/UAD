import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/student_model.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/status_badge.dart';
import '../../core/services/export_service.dart';

class AdminStudentsScreen extends StatefulWidget {
  const AdminStudentsScreen({super.key});

  @override
  State<AdminStudentsScreen> createState() => _AdminStudentsScreenState();
}

class _AdminStudentsScreenState extends State<AdminStudentsScreen> {
  String _searchQuery = '';
  String _statusFilter = 'all';

  final List<String> _statuses = [
    'all',
    'Activo',
    'Probatoria',
    'Suspendido',
    'Graduando',
    'Retiro',
  ];

  bool _exportDone = false;

  void _handleExport() async {
    final success = await ExportService.exportStudentsToCsv(allStudents);
    if (success && mounted) {
      setState(() => _exportDone = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _exportDone = false);
      });
    }
  }

  void _showNewStudentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _NewStudentForm(),
    );
  }

  void _showStudentDetail(StudentModel st) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalle del Estudiante',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      st.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${st.id} · ${st.cedula}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _detailData('Programa', st.program)),
                  Expanded(child: _detailData('Semestre', '${st.semester}°')),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _detailData('Índice', '${st.gpa}')),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estado',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        StatusBadge(status: st.status),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _detailData(
                'Balance',
                st.balance > 0
                    ? 'RD\$${_formatCurrency(st.balance)}'
                    : 'Al día',
                isAlert: st.balance > 0,
              ),

              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(LucideIcons.edit3, size: 16, color: AppColors.primary),
                        label: Text(
                          'Editar',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.textPrimary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(LucideIcons.ban, size: 16),
                        label: const Text(
                          'Suspender',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorSurface.withValues(alpha: 0.9),
                          foregroundColor: AppColors.error,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: AppColors.error.withValues(alpha: 0.2), width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailData(String label, String value, {bool isAlert = false}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isAlert ? AppColors.error : AppColors.textPrimary,
            ),
          ),
        ],
      );

  String _formatCurrency(double amount) {
    String value = amount.toStringAsFixed(0);
    return value.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = allStudents.where((s) {
      final nameStr = s.name.toLowerCase();
      final idStr = s.id.toLowerCase();
      final ced = s.cedula.toLowerCase();
      final q = _searchQuery.toLowerCase();

      final matchSearch =
          nameStr.contains(q) || idStr.contains(q) || ced.contains(q);
      final matchStatus = _statusFilter == 'all' || s.status == _statusFilter;

      return matchSearch && matchStatus;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: PageHeader(
                    title: 'Estudiantes',
                    subtitle: '${allStudents.length} estudiantes registrados',
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showNewStudentModal,
                  icon: const Icon(LucideIcons.userPlus, size: 14),
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

            // Search and Export
            Row(
              children: [
                Expanded(
                  child: Container(
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
                        hintText: 'Buscar por nombre, matrícula...',
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
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _handleExport,
                  icon: Icon(
                    _exportDone ? LucideIcons.check : LucideIcons.download,
                    size: 14,
                  ),
                  label: Text(
                    _exportDone ? 'Exportado' : 'Exportar CSV',
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: _exportDone
                        ? AppColors.success
                        : AppColors.textSecondary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _exportDone
                            ? AppColors.success
                            : AppColors.borderMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Status Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _statuses.map((s) {
                  final isSelected = _statusFilter == s;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      onPressed: () => setState(() => _statusFilter = s),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? AppColors.primary
                            : AppColors.background,
                        foregroundColor: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Text(
                        s == 'all' ? 'Todos' : s,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Students List
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (_, _) =>
                    Divider(height: 1, color: AppColors.borderMedium),
                itemBuilder: (ctx, i) {
                  final s = filtered[i];
                  final gpa = s.gpa;
                  final balance = s.balance;
                  return InkWell(
                    onTap: () => _showStudentDetail(s),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${s.id} · ${s.cedula}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      'G: ${gpa.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: gpa >= 3.0
                                            ? AppColors.success
                                            : (gpa >= 2.0
                                                  ? AppColors.warning
                                                  : AppColors.error),
                                      ),
                                    ),
                                    StatusBadge(status: s.status),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                balance > 0
                                    ? 'RD\$${_formatCurrency(balance)}'
                                    : 'Al día',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: balance > 0
                                      ? AppColors.error
                                      : AppColors.success,
                                ),
                              ),
                              SizedBox(height: 8),
                              Icon(
                                LucideIcons.chevronRight,
                                size: 16,
                                color: AppColors.textTertiary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewStudentForm extends StatefulWidget {
  @override
  State<_NewStudentForm> createState() => _NewStudentFormState();
}

class _NewStudentFormState extends State<_NewStudentForm> {
  String _gender = 'Femenino';
  String _nationality = 'Dominicana';
  DateTime? _dob;
  final _cedulaController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Registrar Nuevo Estudiante',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _input('Nombre Completo', 'Nombre completo'),
                    _formattedInput(
                      'Cédula',
                      '000-0000000-0',
                      _cedulaController,
                      13,
                    ),
                    _datePickerInput('Fecha de Nacimiento', _dob),
                    _dropdown(
                      'Género',
                      ['Femenino', 'Masculino'],
                      _gender,
                      (v) => setState(() => _gender = v!),
                    ),
                    _dropdown(
                      'Nacionalidad',
                      ['Dominicana', 'Extranjero'],
                      _nationality,
                      (v) => setState(() => _nationality = v!),
                    ),
                    _input(
                      'Correo',
                      'correo@ejemplo.com',
                      kbd: TextInputType.emailAddress,
                    ),
                    _formattedInput(
                      'Teléfono',
                      '809-000-0000',
                      _phoneController,
                      12,
                      isPhone: true,
                    ),
                    _input('Dirección', 'Dirección completa', maxLines: 2),
                    _input('Programa', 'Ing. en Sistemas'),
                    _input('Contacto de Emergencia', 'Nombre - Teléfono'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Registrar Estudiante'),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    String label,
    String hint, {
    int maxLines = 1,
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
          TextField(
            maxLines: maxLines,
            keyboardType: kbd,
            decoration: InputDecoration(
              hintText: hint,
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

  Widget _formattedInput(
    String label,
    String hint,
    TextEditingController ctrl,
    int maxLength, {
    bool isPhone = false,
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
          TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            maxLength: maxLength,
            onChanged: (v) {
              String cleaned = v.replaceAll(RegExp(r'\D'), '');
              String formatted = '';
              if (isPhone) {
                if (cleaned.isNotEmpty) {
                  formatted = cleaned.substring(
                    0,
                    cleaned.length > 3 ? 3 : cleaned.length,
                  );
                }
                if (cleaned.length > 3) {
                  formatted +=
                      '-${cleaned.substring(3, cleaned.length > 6 ? 6 : cleaned.length)}';
                }
                if (cleaned.length > 6) {
                  formatted +=
                      '-${cleaned.substring(6, cleaned.length > 10 ? 10 : cleaned.length)}';
                }
              } else {
                if (cleaned.isNotEmpty) {
                  formatted = cleaned.substring(
                    0,
                    cleaned.length > 3 ? 3 : cleaned.length,
                  );
                }
                if (cleaned.length > 3) {
                  formatted +=
                      '-${cleaned.substring(3, cleaned.length > 10 ? 10 : cleaned.length)}';
                }
                if (cleaned.length > 10) {
                  formatted +=
                      '-${cleaned.substring(10, cleaned.length > 11 ? 11 : cleaned.length)}';
                }
              }
              if (v != formatted) {
                ctrl.value = ctrl.value.copyWith(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }
            },
            decoration: InputDecoration(
              hintText: hint,
              counterText: '',
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

  Widget _datePickerInput(String label, DateTime? value) {
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
          InkWell(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderMedium),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value != null
                        ? '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}'
                        : 'Seleccionar fecha',
                    style: TextStyle(
                      fontSize: 13,
                      color: value != null
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                  ),
                  Icon(
                    LucideIcons.calendar,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
    String label,
    List<String> items,
    String value,
    Function(String?) onChanged,
  ) {
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderMedium),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                items: items
                    .map(
                      (i) => DropdownMenuItem(
                        value: i,
                        child: Text(i, style: TextStyle(fontSize: 13)),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
