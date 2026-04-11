import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/status_badge.dart';

class RegistrarEnrollmentScreen extends StatefulWidget {
  const RegistrarEnrollmentScreen({super.key});

  @override
  State<RegistrarEnrollmentScreen> createState() =>
      _RegistrarEnrollmentScreenState();
}

class _RegistrarEnrollmentScreenState extends State<RegistrarEnrollmentScreen> {
  String _searchQuery = '';
  String _statusFilter = 'all';

  final List<String> _statuses = [
    'all',
    'Pendiente',
    'En revisión',
    'Aprobado',
    'Rechazado',
  ];
  Map<String, dynamic>? _selectedAdmission;

  final List<Map<String, dynamic>> _admissions = [
    {
      'id': 'ADM-2025-001',
      'name': 'Laura Beatriz Santana',
      'cedula': '402-9988776-1',
      'program': 'Ing. en Sistemas',
      'date': '2025-03-10',
      'status': 'Pendiente',
      'email': 'laura.santana@gmail.com',
      'phone': '809-444-1122',
      'docs': true,
    },
    {
      'id': 'ADM-2025-002',
      'name': 'Carlos Eduardo Marte',
      'cedula': '031-8877665-2',
      'program': 'Administración de Empresas',
      'date': '2025-03-11',
      'status': 'En revisión',
      'email': 'carlos.marte@gmail.com',
      'phone': '829-555-3344',
      'docs': false,
    },
    {
      'id': 'ADM-2025-003',
      'name': 'Yesenia Altagracia Pujols',
      'cedula': '402-7766554-3',
      'program': 'Derecho',
      'date': '2025-03-12',
      'status': 'Pendiente',
      'email': 'yesenia.pujols@gmail.com',
      'phone': '849-666-5566',
      'docs': true,
    },
    {
      'id': 'ADM-2025-004',
      'name': 'Roberto Emilio Jiménez',
      'cedula': '031-6655443-4',
      'program': 'Psicología Clínica',
      'date': '2025-03-13',
      'status': 'Aprobado',
      'email': 'roberto.jimenez@gmail.com',
      'phone': '809-777-7788',
      'docs': true,
    },
    {
      'id': 'ADM-2025-005',
      'name': 'Ana Mercedes Feliz',
      'cedula': '402-5544332-5',
      'program': 'Contabilidad',
      'date': '2025-03-14',
      'status': 'Rechazado',
      'email': 'ana.feliz@gmail.com',
      'phone': '829-888-9900',
      'docs': false,
    },
    {
      'id': 'ADM-2025-006',
      'name': 'Miguel Antonio Vásquez',
      'cedula': '031-4433221-6',
      'program': 'Teología Pastoral',
      'date': '2025-03-15',
      'status': 'Pendiente',
      'email': 'miguel.vasquez@gmail.com',
      'phone': '849-999-0011',
      'docs': true,
    },
  ];

  void _changeStatus(String id, String newStatus) {
    setState(() {
      final idx = _admissions.indexWhere((a) => a['id'] == id);
      if (idx >= 0) {
        _admissions[idx]['status'] = newStatus;
      }
    });
    if (_selectedAdmission != null && _selectedAdmission!['id'] == id) {
      Navigator.pop(context); // close modal on action
    }
  }

  void _showNewAdmissionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _NewAdmissionForm(
        onSave: (val) {
          setState(() => _admissions.insert(0, val));
          Navigator.pop(ctx);
          _showSuccessDialog();
        },
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.checkCircle,
                size: 32,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Admisión Registrada',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            Text(
              'El expediente del aspirante fue creado exitosamente y está pendiente de revisión.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailModal(Map<String, dynamic> adm) {
    _selectedAdmission = adm;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expediente de Admisión',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          adm['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          adm['cedula'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    StatusBadge(status: adm['status']),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _detailBox('ID Solicitud', adm['id'])),
                  const SizedBox(width: 8),
                  Expanded(child: _detailBox('Fecha', adm['date'])),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _detailBox('Programa', adm['program'])),
                  const SizedBox(width: 8),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: adm['docs']
                      ? AppColors.successSurface
                      : AppColors.errorSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.fileText,
                      size: 16,
                      color: adm['docs'] ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        adm['docs']
                            ? 'Documentos completos y verificados'
                            : 'Documentos pendientes de entrega',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: adm['docs']
                              ? AppColors.successText
                              : AppColors.errorText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (adm['status'] != 'Aprobado' &&
                  adm['status'] != 'Rechazado') ...[
                Text(
                  'DECISIÓN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _changeStatus(adm['id'], 'Aprobado'),
                        icon: const Icon(LucideIcons.check, size: 16),
                        label: const Text('Aprobar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _changeStatus(adm['id'], 'Rechazado'),
                        icon: const Icon(LucideIcons.x, size: 16),
                        label: const Text('Rechazar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.error,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: AppColors.errorLight),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (adm['status'] == 'Pendiente') ...[
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _changeStatus(adm['id'], 'En revisión'),
                    icon: const Icon(LucideIcons.alertCircle, size: 16),
                    label: const Text('Marcar En Revisión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.textPrimary,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppColors.borderMedium),
                      ),
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 24),
              Text(
                'NOTAS DEL REGISTRADOR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      'Agregar observaciones o notas sobre esta solicitud...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.borderMedium),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 24),
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
                child: const Text('Guardar Cambios'),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailBox(String label, String value) => Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final filtered = _admissions.where((a) {
      final matchSearch =
          a['name'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          a['id'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          a['cedula'].toString().contains(_searchQuery);
      final matchStatus =
          _statusFilter == 'all' || a['status'] == _statusFilter;
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
                const Expanded(
                  child: PageHeader(
                    title: 'Inscripción',
                    subtitle: 'Gestión de admisiones',
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showNewAdmissionModal,
                  icon: const Icon(LucideIcons.userPlus, size: 14),
                  label: const Text(
                    'Admisión',
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
                  hintText: 'Buscar por nombre, ID...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Filters
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

            // List
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
                  final a = filtered[i];
                  Color iconColor = AppColors.textTertiary;
                  Color iconBg = AppColors.background;
                  IconData iconData = LucideIcons.file;

                  if (a['status'] == 'Pendiente' ||
                      a['status'] == 'En revisión') {
                    iconColor = AppColors.warning;
                    iconBg = AppColors.warningLight;
                    iconData = a['status'] == 'Pendiente'
                        ? LucideIcons.clock
                        : LucideIcons.alertCircle;
                  } else if (a['status'] == 'Aprobado') {
                    iconColor = AppColors.success;
                    iconBg = AppColors.successLight;
                    iconData = LucideIcons.checkCircle;
                  } else if (a['status'] == 'Rechazado') {
                    iconColor = AppColors.error;
                    iconBg = AppColors.errorLight;
                    iconData = LucideIcons.xCircle;
                  }

                  return InkWell(
                    onTap: () => _showDetailModal(a),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: iconBg,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(iconData, size: 20, color: iconColor),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${a['name']}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${a['id']} · ${a['cedula']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '${a['program']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    StatusBadge(status: a['status']),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          a['docs']
                                              ? LucideIcons.check
                                              : LucideIcons.x,
                                          size: 14,
                                          color: a['docs']
                                              ? AppColors.success
                                              : AppColors.error,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          a['docs']
                                              ? 'Docs completos'
                                              : 'Docs incompletos',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: a['docs']
                                                ? AppColors.success
                                                : AppColors.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      a['date'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.eye,
                                size: 16,
                                color: AppColors.textPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Ver',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
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

class _NewAdmissionForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  const _NewAdmissionForm({required this.onSave});
  @override
  State<_NewAdmissionForm> createState() => _NewAdmissionFormState();
}

class _NewAdmissionFormState extends State<_NewAdmissionForm> {
  final _name = TextEditingController();
  final _cedula = TextEditingController();
  final _email = TextEditingController();

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
              const Text(
                'Nueva Admisión',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    TextField(
                      controller: _name,
                      decoration: const InputDecoration(
                        labelText: 'Nombre Completo',
                      ),
                    ),
                    TextField(
                      controller: _cedula,
                      decoration: const InputDecoration(labelText: 'Cédula'),
                    ),
                    TextField(
                      controller: _email,
                      decoration: const InputDecoration(
                        labelText: 'Correo Electrónico',
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_name.text.isNotEmpty && _cedula.text.isNotEmpty) {
                          widget.onSave({
                            'id': 'ADM-2025-00${DateTime.now().millisecond}',
                            'name': _name.text,
                            'cedula': _cedula.text,
                            'email': _email.text,
                            'program': 'Ingeniería en Sistemas',
                            'date': '2025-04-07',
                            'status': 'Pendiente',
                            'docs': false,
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Registrar Admisión'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
