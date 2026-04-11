import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/status_badge.dart';

final _initialUsers = [
  {
    'id': 1,
    'name': 'Juan Administrador',
    'email': 'admin@unad.edu.do',
    'role': 'Admin',
    'status': 'Activo',
    'lastLogin': '2024-10-15 14:32',
  },
  {
    'id': 2,
    'name': 'María Registradora',
    'email': 'registrar@unad.edu.do',
    'role': 'Registrador',
    'status': 'Activo',
    'lastLogin': '2024-10-15 13:15',
  },
  {
    'id': 3,
    'name': 'Dr. Carlos Martínez',
    'email': 'carlos.martinez@unad.edu.do',
    'role': 'Profesor',
    'status': 'Activo',
    'lastLogin': '2024-10-14 09:45',
  },
  {
    'id': 4,
    'name': 'Ing. Ana Pérez',
    'email': 'ana.perez@unad.edu.do',
    'role': 'Profesor',
    'status': 'Activo',
    'lastLogin': '2024-10-13 16:20',
  },
  {
    'id': 5,
    'name': 'María Elena Rodríguez',
    'email': 'maria.rodriguez@unad.edu.do',
    'role': 'Estudiante',
    'status': 'Activo',
    'lastLogin': '2024-10-15 10:05',
  },
  {
    'id': 6,
    'name': 'Pedro Luis Santos',
    'email': 'pedro.santos@unad.edu.do',
    'role': 'Estudiante',
    'status': 'Suspendido',
    'lastLogin': '2024-09-30 08:00',
  },
];

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final List<Map<String, dynamic>> _users = List.from(_initialUsers);
  String _searchQuery = '';

  void _showUserModal(Map<String, dynamic>? initial) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _UserForm(
        initial: initial,
        onSave: (updated) {
          setState(() {
            if (initial == null) {
              _users.add({
                ...updated,
                'id': DateTime.now().millisecondsSinceEpoch,
                'status': 'Activo',
                'lastLogin': 'Nunca',
              });
            } else {
              final idx = _users.indexWhere((u) => u['id'] == updated['id']);
              if (idx >= 0) _users[idx] = {..._users[idx], ...updated};
            }
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'Admin':
        return LucideIcons.shield;
      case 'Registrador':
        return LucideIcons.clipboardList;
      case 'Profesor':
        return LucideIcons.bookOpen;
      case 'Estudiante':
        return LucideIcons.graduationCap;
      default:
        return LucideIcons.user;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return Colors.purple;
      case 'Registrador':
        return Colors.blue;
      case 'Profesor':
        return Colors.orange;
      case 'Estudiante':
        return Colors.green;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _users.where((u) {
      final name = (u['name'] ?? '').toString().toLowerCase();
      final email = (u['email'] ?? '').toString().toLowerCase();
      final role = (u['role'] ?? '').toString().toLowerCase();
      final q = _searchQuery.toLowerCase();
      return name.contains(q) || email.contains(q) || role.contains(q);
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
                  title: 'Gestión de Usuarios',
                  subtitle: 'Administra roles y permisos',
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showUserModal(null),
                icon: const Icon(LucideIcons.plus, size: 14),
                label: const Text(
                  'Nuevo Usuario',
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
                hintText: 'Buscar por nombre, correo o rol...',
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

          // Role Summary
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: ['Admin', 'Registrador', 'Profesor', 'Estudiante'].map((
              role,
            ) {
              final count = _users.where((u) => u['role'] == role).length;
              final color = _getRoleColor(role);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(_getRoleIcon(role), size: 16, color: color),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${role}s',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // User List
          ...filtered.map((u) {
            final color = _getRoleColor((u['role'] ?? '').toString());
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getRoleIcon((u['role'] ?? '').toString()),
                      size: 18,
                      color: color,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (u['name'] ?? '').toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          (u['email'] ?? '').toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusBadge(status: (u['status'] ?? 'Activo').toString()),
                      SizedBox(height: 4),
                      Text(
                        'Último: ${u['lastLogin']}',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12),
                  IconButton(
                    onPressed: () => _showUserModal(u),
                    icon: Icon(
                      LucideIcons.edit3,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _UserForm extends StatefulWidget {
  final Map<String, dynamic>? initial;
  final Function(Map<String, dynamic>) onSave;

  const _UserForm({this.initial, required this.onSave});

  @override
  State<_UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<_UserForm> {
  late String name;
  late String email;
  late String role;
  late String status;
  String tempPassword = '';

  @override
  void initState() {
    super.initState();
    name = widget.initial?['name'] ?? '';
    email = widget.initial?['email'] ?? '';
    role = widget.initial?['role'] ?? 'Estudiante';
    status = widget.initial?['status'] ?? 'Activo';
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
                isEdit ? 'Editar Usuario' : 'Nuevo Usuario',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _input('Nombre', name, (v) => name = v),
              _input(
                'Correo',
                email,
                (v) => email = v,
                kbd: TextInputType.emailAddress,
              ),
              _dropdown('Rol', role, [
                'Admin',
                'Registrador',
                'Profesor',
                'Estudiante',
              ], (v) => setState(() => role = v!)),
              if (isEdit)
                _dropdown('Estado', status, [
                  'Activo',
                  'Suspendido',
                ], (v) => setState(() => status = v!)),
              if (!isEdit)
                _input(
                  'Contraseña temporal',
                  tempPassword,
                  (v) => tempPassword = v,
                  obscure: true,
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => widget.onSave({
                  'id': widget.initial?['id'],
                  'name': name,
                  'email': email,
                  'role': role,
                  'status': status,
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(isEdit ? 'Guardar Cambios' : 'Crear Usuario'),
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
    bool obscure = false,
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
            obscureText: obscure,
            style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
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

  Widget _dropdown(
    String label,
    String value,
    List<String> options,
    void Function(String?) onChanged,
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
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderMedium),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                items: options
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(p, style: const TextStyle(fontSize: 13)),
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
