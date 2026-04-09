import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/status_badge.dart';

class RegistrarRequestsScreen extends StatefulWidget {
  const RegistrarRequestsScreen({super.key});

  @override
  State<RegistrarRequestsScreen> createState() =>
      _RegistrarRequestsScreenState();
}

class _RegistrarRequestsScreenState extends State<RegistrarRequestsScreen> {
  String _searchQuery = '';
  String _statusFilter = 'all';

  final List<String> _statuses = [
    'all',
    'Pendiente',
    'En proceso',
    'Completada',
    'Cerrada',
  ];

  // Local state copy to modify
  final List<Map<String, dynamic>> _reqs = [
    {
      'id': 'REQ-001',
      'type': 'Certificado de Estudios',
      'date': '2024-10-01',
      'status': 'Completada',
      'studentId': 'STU-2024-001',
      'details': 'Certificado para beca externa',
      'priority': 'Normal',
    },
    {
      'id': 'REQ-002',
      'type': 'Revisión de Calificación',
      'date': '2024-10-05',
      'status': 'En proceso',
      'studentId': 'STU-2024-001',
      'details': 'Revisión nota final MAT-201',
      'priority': 'Alta',
    },
    {
      'id': 'REQ-003',
      'type': 'Reporte de Profesor',
      'date': '2024-09-20',
      'status': 'Cerrada',
      'studentId': 'STU-2024-001',
      'details': 'Ausencia repetida del profesor en ING-310',
      'priority': 'Normal',
    },
    {
      'id': 'REQ-004',
      'type': 'Retiro de Materia',
      'date': '2024-10-08',
      'status': 'En proceso',
      'studentId': 'STU-2024-004',
      'details': 'Retiro de ING-310 por razones médicas',
      'priority': 'Alta',
    },
    {
      'id': 'REQ-005',
      'type': 'Certificado de Calificaciones',
      'date': '2024-10-10',
      'status': 'Pendiente',
      'studentId': 'STU-2024-003',
      'details': 'Para pasantía empresa privada',
      'priority': 'Normal',
    },
    {
      'id': 'REQ-006',
      'type': 'Cambio de Sección',
      'date': '2024-10-12',
      'status': 'Pendiente',
      'studentId': 'STU-2024-002',
      'details': 'Cambio sección MAT-301 de 01 a 02',
      'priority': 'Baja',
    },
  ];

  void _changeStatus(String id, String status) {
    setState(() {
      final idx = _reqs.indexWhere((r) => r['id'] == id);
      if (idx >= 0) {
        _reqs[idx]['status'] = status;
      }
    });
    Navigator.pop(context);
  }

  void _showDetailModal(Map<String, dynamic> r) {
    final s = allStudents.firstWhere((st) => st.id == r['studentId']);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
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
                'Gestionar Solicitud',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            r['type'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        StatusBadge(status: r['status']),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${r['id']} · ${r['date']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Estudiante: ${s.name}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      r['details'],
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'CAMBIAR ESTADO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['En proceso', 'Completada', 'Cerrada', 'Pendiente']
                    .where((st) => st != r['status'])
                    .map(
                      (st) => ActionChip(
                        label: Text(st),
                        onPressed: () => _changeStatus(r['id'], st),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: AppColors.borderMedium),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _reqs.where((r) {
      final matchSearch =
          r['type'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          r['id'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchStatus =
          _statusFilter == 'all' || r['status'] == _statusFilter;
      return matchSearch && matchStatus;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          children: [
            const PageHeader(
              title: 'Solicitudes',
              subtitle: 'Solicitudes recibidas',
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
                  hintText: 'Buscar por tipo, ID...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
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
                  final r = filtered[i];
                  final s = allStudents.firstWhere(
                    (st) => st.id == r['studentId'],
                    orElse: () => allStudents[0],
                  );
                  return InkWell(
                    onTap: () => _showDetailModal(r),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        r['type'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      r['priority'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: r['priority'] == 'Alta'
                                            ? AppColors.error
                                            : AppColors.info,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${r['id']} · ${r['date']}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  s.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          StatusBadge(status: r['status']),
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
