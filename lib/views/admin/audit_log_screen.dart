import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/page_header.dart';

final _initialAuditLog = [
  {
    'id': 1,
    'date': '2024-10-15 14:32:05',
    'user': 'admin@unad.edu.do',
    'role': 'Admin',
    'action': 'Actualización de calificación',
    'details': 'MAT-201, STU-2024-001: B+ → A-',
    'ip': '192.168.1.45',
  },
  {
    'id': 2,
    'date': '2024-10-15 13:15:22',
    'user': 'registrar@unad.edu.do',
    'role': 'Registrador',
    'action': 'Retiro de materia',
    'details': 'STU-2024-008 retiró ING-310',
    'ip': '192.168.1.12',
  },
  {
    'id': 3,
    'date': '2024-10-14 09:45:11',
    'user': 'carlos.martinez@unad.edu.do',
    'role': 'Profesor',
    'action': 'Publicación de notas',
    'details': 'MAT-301 Sec-01: Parcial 2 publicado',
    'ip': '192.168.2.33',
  },
  {
    'id': 4,
    'date': '2024-10-14 08:30:00',
    'user': 'admin@unad.edu.do',
    'role': 'Admin',
    'action': 'Cambio de estado estudiante',
    'details': 'STU-2024-008: Activo → Suspendido',
    'ip': '192.168.1.45',
  },
  {
    'id': 5,
    'date': '2024-10-13 16:20:45',
    'user': 'registrar@unad.edu.do',
    'role': 'Registrador',
    'action': 'Certificado emitido',
    'details': 'Certificado de estudios para STU-2024-003',
    'ip': '192.168.1.12',
  },
  {
    'id': 6,
    'date': '2024-10-13 11:05:33',
    'user': 'admin@unad.edu.do',
    'role': 'Admin',
    'action': 'Programa modificado',
    'details': 'ING-SIS: Actualización plan de estudios 2024',
    'ip': '192.168.1.45',
  },
  {
    'id': 7,
    'date': '2024-10-12 15:00:00',
    'user': 'maria.rodriguez@unad.edu.do',
    'role': 'Estudiante',
    'action': 'Solicitud creada',
    'details': 'REQ-002: Revisión de calificación MAT-201',
    'ip': '10.0.0.55',
  },
];

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  String _searchQuery = '';

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return const Color(0xFFB91C1C); // red-700
      case 'Registrador':
        return const Color(0xFF1D4ED8); // blue-700
      case 'Profesor':
        return const Color(0xFF7E22CE); // purple-700
      case 'Estudiante':
        return const Color(0xFF374151); // gray-700
      default:
        return AppColors.primary;
    }
  }

  Color _getRoleBgColor(String role) {
    switch (role) {
      case 'Admin':
        return AppColors.errorSurface;
      case 'Registrador':
        return AppColors.infoSurface;
      case 'Profesor':
        return const Color(0xFFFAF5FF);
      case 'Estudiante':
        return const Color(0xFFF9FAFB);
      default:
        return AppColors.primary.withValues(alpha: 0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _initialAuditLog.where((log) {
      final a = (log['action'] as String).toLowerCase();
      final u = (log['user'] as String).toLowerCase();
      final d = (log['details'] as String).toLowerCase();
      final q = _searchQuery.toLowerCase();
      return a.contains(q) || u.contains(q) || d.contains(q);
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Registro de Auditoría',
            subtitle: 'Historial de acciones del sistema',
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
                hintText: 'Buscar en el registro...',
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

          // Log List
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
                final log = filtered[i];
                final roleColor = _getRoleColor(log['role'] as String);
                final roleBgColor = _getRoleBgColor(log['role'] as String);

                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.clock,
                                  size: 14,
                                  color: AppColors.textTertiary,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  log['date'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: roleBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              log['role'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: roleColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        log['action'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        log['details'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            log['user'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            log['ip'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'monospace',
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
