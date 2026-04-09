import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/constants/app_constants.dart';
import '../../data/mock/mock_data.dart';
import '../../viewmodels/app_preferences_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String? _activeSection = 'profile';
  bool _editingProfile = false;
  bool _saved = false;
  bool _showCurrentPass = false;
  bool _showNewPass = false;
  bool _showCvv = false;
  bool _addingCard = false;
  String? _expandedHelp;
  String _language = 'es-DO';

  late Map<String, String> _profile;
  late Map<String, bool> _notifs;

  List<Map<String, dynamic>> _cards = [
    {
      'id': 1,
      'last4': '4532',
      'brand': 'Visa',
      'expiry': '08/27',
      'holder': 'MARIA E RODRIGUEZ',
    },
    {
      'id': 2,
      'last4': '8821',
      'brand': 'Mastercard',
      'expiry': '03/26',
      'holder': 'MARIA E RODRIGUEZ',
    },
  ];

  final Map<String, String> _newCard = {
    'number': '',
    'holder': '',
    'expiry': '',
    'cvv': '',
  };

  static const Map<String, String> _currentAdmin = {
    'name': 'Juan Administrador',
    'email': 'admin@unad.edu.do',
    'phone': '809-525-3080 ext. 100',
    'address': 'UNAD, Bonao, Monseñor Nouel',
    'id': 'ADM-001',
    'department': 'Rectoría',
    'photo':
        'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150&h=150&fit=crop&crop=face',
  };

  static const Map<String, String> _currentRegistrar = {
    'name': 'Ana Registradora',
    'email': 'registrar@unad.edu.do',
    'phone': '809-525-3080 ext. 120',
    'address': 'UNAD, Bonao, Monseñor Nouel',
    'id': 'REG-001',
    'department': 'Oficina de Registro',
    'photo':
        'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&h=150&fit=crop&crop=face',
  };

  List<Map<String, dynamic>> get _menuSections {
    final role = ref.watch(authProvider).currentRole ?? 'student';
    final isStudent = role == 'student';
    final isAdmin = role == 'admin' || role == 'registrar';
    return [
      {
        'id': 'profile',
        'label': isAdmin
            ? 'Mi Perfil Admin'
            : (role == 'professor' ? 'Mi Perfil' : 'Perfil Personal'),
        'icon': LucideIcons.user,
        'color': Colors.blue,
      },
      {
        'id': 'notifications',
        'label': 'Notificaciones',
        'icon': LucideIcons.bell,
        'color': Colors.amber,
      },
      {
        'id': 'security',
        'label': 'Seguridad',
        'icon': LucideIcons.shield,
        'color': Colors.red,
      },
      if (isStudent)
        {
          'id': 'cards',
          'label': 'Mis Tarjetas',
          'icon': LucideIcons.creditCard,
          'color': Colors.indigo,
        },
      {
        'id': 'appearance',
        'label': 'Apariencia',
        'icon': LucideIcons.palette,
        'color': Colors.purple,
      },
      {
        'id': 'language',
        'label': 'Idioma y Región',
        'icon': LucideIcons.globe,
        'color': Colors.green,
      },
      {
        'id': 'help',
        'label': 'Ayuda y Soporte',
        'icon': LucideIcons.helpCircle,
        'color': Colors.grey,
      },
    ];
  }

  static const List<Map<String, String>> _accentColors = [
    {'value': '#026a45', 'label': 'Verde UNAD'},
    {'value': '#2563eb', 'label': 'Azul'},
    {'value': '#7c3aed', 'label': 'Violeta'},
    {'value': '#dc2626', 'label': 'Rojo'},
    {'value': '#ea580c', 'label': 'Naranja'},
  ];

  static const List<Map<String, String>> _languages = [
    {
      'flag': '🇩🇴',
      'code': 'es-DO',
      'label': 'Español (República Dominicana)',
    },
    {'flag': '🇺🇸', 'code': 'en-US', 'label': 'English (United States)'},
    {'flag': '🇫🇷', 'code': 'fr-FR', 'label': 'Français (France)'},
    {'flag': '🇵🇹', 'code': 'pt-BR', 'label': 'Português (Brasil)'},
  ];

  @override
  void initState() {
    super.initState();
    final role = ref.read(authProvider).currentRole ?? 'student';
    final isAdmin = role == 'admin' || role == 'registrar';
    final isProfessor = role == 'professor';
    final isRegistrar = role == 'registrar';

    final adminData = isRegistrar ? _currentRegistrar : _currentAdmin;

    if (isAdmin) {
      _profile = {
        'name': adminData['name']!,
        'email': adminData['email']!,
        'phone': adminData['phone']!,
        'address': adminData['address']!,
      };
      _notifs = {
        'system': true,
        'requests': true,
        'announcements': true,
        'reports': false,
        'reminders': true,
        'email': true,
        'sms': false,
      };
    } else if (isProfessor) {
      _profile = {
        'name': currentProfessor['name']!,
        'email': currentProfessor['email']!,
        'phone': '809-555-9876',
        'address': 'Santiago, República Dominicana',
      };
      _notifs = {
        'grades': true,
        'announcements': true,
        'requests': true,
        'reminders': true,
        'email': true,
        'sms': false,
      };
    } else {
      _profile = {
        'name': currentStudent.name,
        'email': currentStudent.email,
        'phone': currentStudent.phone,
        'address': currentStudent.address,
      };
      _notifs = {
        'grades': true,
        'payments': true,
        'announcements': true,
        'requests': false,
        'reminders': true,
        'email': true,
        'sms': false,
      };
    }
  }

  void _handleSave() {
    setState(() {
      _saved = true;
      _editingProfile = false;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final tc = context.appColors;
    final role = ref.watch(authProvider).currentRole ?? 'student';
    final isAdmin = role == 'admin' || role == 'registrar';
    final isProfessor = role == 'professor';
    final isRegistrar = role == 'registrar';
    final adminData = isRegistrar ? _currentRegistrar : _currentAdmin;

    final String rolePhoto = isAdmin
        ? adminData['photo']!
        : (isProfessor
              ? currentProfessor['photo']!
              : currentStudent.photo ?? '');

    final String roleSub1 = isAdmin
        ? adminData['department']!
        : (isProfessor
              ? 'Departamento de ${currentProfessor['department']}'
              : currentStudent.program);

    final String roleSub2 = isAdmin
        ? '${adminData['id']} · ${isRegistrar ? 'Registradora' : 'Administrador'}'
        : (isProfessor
              ? '${currentProfessor['id']} · Profesor'
              : '${currentStudent.id} · Sem. ${currentStudent.semester}');
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuración',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: tc.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Administra tu cuenta y preferencias',
              style: TextStyle(fontSize: 14, color: tc.textSecondary),
            ),
            const SizedBox(height: 24),

            // Saved banner
            if (_saved)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.checkCircle,
                      size: 16,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Cambios guardados exitosamente.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),

            // Profile summary card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: tc.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: tc.border),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: rolePhoto.isNotEmpty
                            ? Image.network(
                                rolePhoto,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => _avatarFallback(),
                              )
                            : _avatarFallback(),
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            LucideIcons.camera,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _profile['name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          roleSub1,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          roleSub2,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Menu Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _menuSections.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (ctx, i) {
                final s = _menuSections[i];
                final active = _activeSection == s['id'];
                return InkWell(
                  onTap: () => setState(
                    () => _activeSection = _activeSection == s['id']
                        ? null
                        : s['id'],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primarySurface : tc.cardColor,
                      border: Border.all(
                        color: active ? AppColors.primary : tc.border,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: (s['color'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(s['icon'], size: 18, color: s['color']),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            s['label'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Content Panel
            if (_activeSection != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: tc.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: tc.border),
                ),
                child: _buildSectionContent(),
              ),

            const SizedBox(height: 16),

            // Logout
            ElevatedButton.icon(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                context.go(AppConstants.routeRoleSelect);
              },
              icon: const Icon(LucideIcons.logOut, size: 18),
              label: const Text(
                'Cerrar Sesión',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorSurface,
                foregroundColor: AppColors.error,
                minimumSize: const Size(double.infinity, 50),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.errorLight),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'UNAD Sistema Académico · v3.2.1',
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(LucideIcons.user, color: Colors.white, size: 28),
    );
  }

  Widget _buildSectionContent() {
    switch (_activeSection) {
      case 'profile':
        return _buildProfileSection();
      case 'notifications':
        return _buildNotificationsSection();
      case 'security':
        return _buildSecuritySection();
      case 'cards':
        return _buildCardsSection();
      case 'appearance':
        return _buildAppearanceSection();
      case 'language':
        return _buildLanguageSection();
      case 'help':
        return _buildHelpSection();
      default:
        return const SizedBox.shrink();
    }
  }

  // ════════════════════════════════════════════════════
  // PROFILE
  // ════════════════════════════════════════════════════
  Widget _buildProfileSection() {
    final role = ref.watch(authProvider).currentRole ?? 'student';
    final isAdmin = role == 'admin' || role == 'registrar';
    final isProfessor = role == 'professor';
    final isRegistrar = role == 'registrar';
    final adminData = isRegistrar ? _currentRegistrar : _currentAdmin;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Información Personal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (!_editingProfile)
              InkWell(
                onTap: () => setState(() => _editingProfile = true),
                child: Row(
                  children: const [
                    Icon(LucideIcons.edit2, size: 14, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Editar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              )
            else
              Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => _editingProfile = false),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        LucideIcons.x,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _handleSave,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(LucideIcons.save, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Guardar',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 20),
        ...[
          {'label': 'Nombre Completo', 'key': 'name'},
          {'label': 'Correo Electrónico', 'key': 'email'},
          {'label': 'Teléfono', 'key': 'phone'},
          {'label': 'Dirección', 'key': 'address'},
        ].map(
          (field) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field['label']!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                if (_editingProfile)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: TextEditingController(
                        text: _profile[field['key']],
                      ),
                      onChanged: (v) => _profile[field['key']!] = v,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  )
                else
                  Text(
                    _profile[field['key']!] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (isAdmin) ...[
          _readOnlyField('Departamento / Área', adminData['department']!),
          _readOnlyField('ID de Administrador', adminData['id']!),
        ] else if (isProfessor) ...[
          _readOnlyField(
            'Departamento',
            'Departamento de ${currentProfessor['department']}',
          ),
          _readOnlyField('ID de Empleado', currentProfessor['id']!),
        ] else ...[
          _readOnlyField('Cédula', currentStudent.cedula),
          _readOnlyField('Número de Matrícula', currentStudent.id),
        ],
      ],
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 6),
              Text(
                '(no editable)',
                style: TextStyle(fontSize: 10, color: AppColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // NOTIFICATIONS
  // ════════════════════════════════════════════════════
  Widget _buildNotificationsSection() {
    final role = ref.watch(authProvider).currentRole ?? 'student';
    final isAdmin = role == 'admin' || role == 'registrar';
    final isProfessor = role == 'professor';

    final notifOptions = isAdmin
        ? [
            {
              'key': 'system',
              'label': 'Alertas del sistema',
              'desc': 'Errores, mantenimiento y actualizaciones',
            },
            {
              'key': 'requests',
              'label': 'Solicitudes de usuarios',
              'desc': 'Nuevas solicitudes de estudiantes y profesores',
            },
            {
              'key': 'announcements',
              'label': 'Anuncios institucionales',
              'desc': 'Comunicados institucionales importantes',
            },
            {
              'key': 'reports',
              'label': 'Reportes automáticos',
              'desc': 'Resúmenes periódicos de estadísticas',
            },
            {
              'key': 'reminders',
              'label': 'Recordatorios administrativos',
              'desc': 'Fechas de cierre de períodos, etc.',
            },
          ]
        : (isProfessor
              ? [
                  {
                    'key': 'grades',
                    'label': 'Recordatorio de calificaciones',
                    'desc': 'Alertas de notas pendientes por publicar',
                  },
                  {
                    'key': 'announcements',
                    'label': 'Anuncios institucionales',
                    'desc': 'Comunicados de la universidad',
                  },
                  {
                    'key': 'requests',
                    'label': 'Solicitudes de estudiantes',
                    'desc': 'Cuando un estudiante te envíe una consulta',
                  },
                  {
                    'key': 'reminders',
                    'label': 'Recordatorios académicos',
                    'desc': 'Fechas límite de calificaciones, etc.',
                  },
                ]
              : [
                  {
                    'key': 'grades',
                    'label': 'Publicación de calificaciones',
                    'desc': 'Cuando un profesor publique notas',
                  },
                  {
                    'key': 'payments',
                    'label': 'Pagos y estados de cuenta',
                    'desc': 'Vencimientos y confirmaciones',
                  },
                  {
                    'key': 'announcements',
                    'label': 'Anuncios institucionales',
                    'desc': 'Comunicados de la universidad',
                  },
                  {
                    'key': 'requests',
                    'label': 'Actualización de solicitudes',
                    'desc': 'Cambios de estado en tus solicitudes',
                  },
                  {
                    'key': 'reminders',
                    'label': 'Recordatorios académicos',
                    'desc': 'Fechas de selección, retiro, etc.',
                  },
                ]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferencias de Notificaciones',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ...notifOptions.map(
          (item) =>
              _notificationToggle(item['key']!, item['label']!, item['desc']!),
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 12),
        Text(
          'CANALES',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        _channelToggle('email', 'Correo electrónico', LucideIcons.mail),
        const SizedBox(height: 12),
        _channelToggle(
          'sms',
          'Mensajes de texto (SMS)',
          LucideIcons.smartphone,
        ),
      ],
    );
  }

  Widget _notificationToggle(String key, String label, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _notifs[key] ?? false,
            onChanged: (v) => setState(() => _notifs[key] = v),
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _channelToggle(String key, String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
        Switch(
          value: _notifs[key] ?? false,
          onChanged: (v) => setState(() => _notifs[key] = v),
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════
  // SECURITY
  // ════════════════════════════════════════════════════
  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seguridad de la Cuenta',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // Password fields
        _passwordField(
          'Contraseña actual',
          _showCurrentPass,
          () => setState(() => _showCurrentPass = !_showCurrentPass),
        ),
        const SizedBox(height: 12),
        _passwordField(
          'Nueva contraseña',
          _showNewPass,
          () => setState(() => _showNewPass = !_showNewPass),
        ),
        const SizedBox(height: 12),
        _passwordField('Confirmar nueva contraseña', false, null),
        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Actualizar Contraseña',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 16),

        // 2FA
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Autenticación de dos factores',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Agrega una capa extra de seguridad',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: false,
              onChanged: (v) {},
              activeThumbColor: AppColors.primary,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Active sessions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sesiones activas',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              _sessionRow(
                'Chrome · Windows 11',
                'Bonao, RD',
                'Ahora mismo',
                true,
              ),
              const Divider(height: 20),
              _sessionRow(
                'App Móvil · Android',
                'Bonao, RD',
                'Hace 2 horas',
                false,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 12),

        // Danger zone
        Text(
          'ZONA DE PELIGRO',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _showDeleteAccountDialog(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    LucideIcons.trash2,
                    size: 16,
                    color: Colors.red.shade600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Eliminar Cuenta',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade700,
                        ),
                      ),
                      Text(
                        'Esta acción no se puede deshacer',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordField(String label, bool showText, VoidCallback? onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            obscureText: !showText,
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(color: AppColors.textTertiary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              suffixIcon: onToggle != null
                  ? IconButton(
                      icon: Icon(
                        showText ? LucideIcons.eyeOff : LucideIcons.eye,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: onToggle,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sessionRow(
    String device,
    String location,
    String time,
    bool isCurrent,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$location · $time',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        if (isCurrent)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Actual',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
          )
        else
          InkWell(
            onTap: () {},
            child: Text(
              'Cerrar',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  void _showDeleteAccountDialog() {
    String confirmText = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
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
              const SizedBox(height: 20),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  LucideIcons.trash2,
                  size: 22,
                  color: Colors.red.shade600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Eliminar Cuenta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Esta acción es ',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextSpan(
                      text: 'irreversible',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextSpan(
                      text:
                          '. Se eliminarán todos tus datos académicos, historial de pagos y acceso a la plataforma.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Escribe ',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    TextSpan(
                      text: 'ELIMINAR',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade500,
                      ),
                    ),
                    TextSpan(
                      text: ' para confirmar',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (v) => setSheetState(() => confirmText = v),
                  decoration: const InputDecoration(
                    hintText: 'ELIMINAR',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: confirmText == 'ELIMINAR'
                      ? () => Navigator.pop(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.red.shade200,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Eliminar mi cuenta permanentemente',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.background,
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // CARDS
  // ════════════════════════════════════════════════════
  Widget _buildCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mis Tarjetas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () => setState(() => _addingCard = !_addingCard),
              child: Row(
                children: [
                  Icon(
                    _addingCard ? LucideIcons.x : LucideIcons.plus,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _addingCard ? 'Cancelar' : 'Agregar',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._cards.map(
          (card) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade500, Colors.purple.shade600],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    LucideIcons.creditCard,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${card['brand']} •••• ${card['last4']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Vence ${card['expiry']} · ${card['holder']}',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => setState(
                    () => _cards = _cards
                        .where((c) => c['id'] != card['id'])
                        .toList(),
                  ),
                  child: Icon(
                    LucideIcons.trash2,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_cards.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'No tienes tarjetas guardadas.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ),
          ),
        if (_addingCard) ...[
          const Divider(height: 24),
          Text(
            'NUEVA TARJETA',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _cardInputField('Número de tarjeta', '0000 0000 0000 0000', 'number'),
          const SizedBox(height: 12),
          _cardInputField(
            'Nombre del titular',
            'Como aparece en la tarjeta',
            'holder',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _cardInputField('Vencimiento', 'MM/AA', 'expiry'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CVV',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        obscureText: !_showCvv,
                        onChanged: (v) => _newCard['cvv'] = v,
                        decoration: InputDecoration(
                          hintText: '•••',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showCvv ? LucideIcons.eyeOff : LucideIcons.eye,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () =>
                                setState(() => _showCvv = !_showCvv),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final last4 = (_newCard['number'] ?? '').replaceAll(' ', '');
                setState(() {
                  _cards.add({
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'last4': last4.length >= 4
                        ? last4.substring(last4.length - 4)
                        : last4,
                    'brand': 'Visa',
                    'expiry': _newCard['expiry'] ?? '',
                    'holder': (_newCard['holder'] ?? '').toUpperCase(),
                  });
                  _newCard.updateAll((k, v) => '');
                  _addingCard = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Guardar Tarjeta',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _cardInputField(String label, String hint, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            onChanged: (v) => _newCard[key] = v,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════
  // APPEARANCE
  // ════════════════════════════════════════════════════
  Widget _buildAppearanceSection() {
    final prefs = ref.watch(appPreferencesProvider);
    final prefsNotifier = ref.read(appPreferencesProvider.notifier);
    final isDark = prefs.isDarkMode;
    final fontSize = prefs.fontSizeIndex;
    final accentHex = prefs.accentColorHex;
    final fontLabels = ['Pequeño', 'Mediano', 'Grande'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Apariencia',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // Dark mode
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.yellow.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDark ? LucideIcons.moon : LucideIcons.sun,
                size: 20,
                color: isDark ? Colors.blue : Colors.amber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Modo Oscuro',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    isDark ? 'Tema oscuro activado' : 'Tema claro activado',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isDark,
              onChanged: (v) => prefsNotifier.setDarkMode(v),
              activeThumbColor: AppColors.primary,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Font size
        const Text(
          'Tamaño de fuente',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          'Actual: ${fontLabels[fontSize]}',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(3, (i) {
            final active = fontSize == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => prefsNotifier.setFontSize(i),
                child: Container(
                  margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: active
                          ? AppColors.primary
                          : AppColors.borderMedium,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      fontLabels[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: active ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Vista previa del tamaño de texto seleccionado.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),

        const SizedBox(height: 24),

        // Accent color
        const Text(
          'Color de acento',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: _accentColors.map((c) {
            final color = _hexToColor(c['value']!);
            final active = accentHex == c['value'];
            return GestureDetector(
              onTap: () => prefsNotifier.setAccentColor(c['value']!),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 0,
                            spreadRadius: 3,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: _hexToColor(accentHex).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: _hexToColor(accentHex).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: _hexToColor(accentHex),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          _accentColors.firstWhere(
                (c) => c['value'] == accentHex,
                orElse: () => {'label': ''},
              )['label'] ??
              '',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════
  // LANGUAGE
  // ════════════════════════════════════════════════════
  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Idioma y Región',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ..._languages.map((l) {
          final active = _language == l['code'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => setState(() => _language = l['code']!),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: active ? AppColors.primary : AppColors.borderMedium,
                  ),
                  color: active ? AppColors.primarySurface : null,
                ),
                child: Row(
                  children: [
                    Text(l['flag']!, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l['label']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (active)
                      const Icon(
                        LucideIcons.checkCircle,
                        size: 16,
                        color: AppColors.primary,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
        if (_language != 'es-DO') ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade100),
            ),
            child: Text(
              '⚠️ La traducción completa estará disponible próximamente. Actualmente la app está en español.',
              style: TextStyle(fontSize: 12, color: Colors.amber.shade700),
            ),
          ),
        ],
      ],
    );
  }

  // ════════════════════════════════════════════════════
  // HELP
  // ════════════════════════════════════════════════════
  Widget _buildHelpSection() {
    final helpItems = [
      {
        'id': 'faq',
        'label': 'Centro de Ayuda',
        'desc': 'Artículos y guías de uso',
        'icon': LucideIcons.helpCircle,
      },
      {
        'id': 'contact',
        'label': 'Contáctanos',
        'desc': 'Envía un mensaje al soporte técnico',
        'icon': LucideIcons.messageSquare,
      },
      {
        'id': 'report',
        'label': 'Reportar un problema',
        'desc': 'Informa errores en la aplicación',
        'icon': LucideIcons.alertCircle,
      },
      {
        'id': 'about',
        'label': 'Acerca de la app',
        'desc': 'Versión 3.2.1 · UNAD 2024',
        'icon': LucideIcons.info,
      },
      {
        'id': 'terms',
        'label': 'Términos y Condiciones',
        'desc': 'Políticas de uso de la plataforma',
        'icon': LucideIcons.fileText,
      },
      {
        'id': 'privacy',
        'label': 'Política de Privacidad',
        'desc': 'Cómo manejamos tus datos',
        'icon': LucideIcons.lock,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ayuda y Soporte',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...helpItems.map((item) {
          final isOpen = _expandedHelp == item['id'];
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderMedium),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () => setState(
                    () => _expandedHelp = isOpen ? null : item['id'] as String,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
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
                            item['icon'] as IconData,
                            size: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['label'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                item['desc'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isOpen
                              ? LucideIcons.chevronUp
                              : LucideIcons.chevronRight,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isOpen)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                    child: _buildHelpContent(item['id'] as String),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHelpContent(String id) {
    switch (id) {
      case 'faq':
        return Column(
          children:
              [
                    {
                      'q': '¿Cómo selecciono mis materias?',
                      'a':
                          'Ve a la sección \'Selección\' en el menú principal durante el período de inscripciones.',
                    },
                    {
                      'q': '¿Dónde veo mis calificaciones?',
                      'a':
                          'En la sección \'Calificaciones\' encontrarás el historial completo y las notas del semestre actual.',
                    },
                    {
                      'q': '¿Cómo solicito un certificado?',
                      'a':
                          'En la sección \'Solicitudes\', elige \'Certificado de Estudios\' y completa el formulario.',
                    },
                    {
                      'q': '¿Cómo pago mi matrícula?',
                      'a':
                          'Ve a \'Pagos\', selecciona el concepto y utiliza tu tarjeta registrada o efectivo en caja.',
                    },
                  ]
                  .map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['q']!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['a']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        );
      case 'contact':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ASUNTO',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderMedium),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: 'Problema técnico',
                  items:
                      [
                            'Problema técnico',
                            'Consulta académica',
                            'Problema con pagos',
                            'Otro',
                          ]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (_) {},
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'MENSAJE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderMedium),
              ),
              child: const TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Describe tu consulta o problema...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Enviar Mensaje',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '📞 (809) 525-3080 ext. 200',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
            Text(
              '✉️ soporte@unad.edu.do',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
            Text(
              '🕐 Lun–Vie 8:00 am – 5:00 pm',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
          ],
        );
      case 'report':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TIPO DE PROBLEMA',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderMedium),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: 'Error en pantalla',
                  items:
                      [
                            'Error en pantalla',
                            'Datos incorrectos',
                            'Función no responde',
                            'Problema de rendimiento',
                          ]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (_) {},
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'DESCRIPCIÓN',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderMedium),
              ),
              child: const TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '¿Qué pasó y en qué pantalla ocurrió?',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Enviar Reporte',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        );
      case 'about':
        return Column(
          children: [
            _aboutRow('Versión', '3.2.1'),
            _aboutRow('Plataforma', 'Mobile / Flutter'),
            _aboutRow('Institución', 'UNAD'),
            _aboutRow('Año', '2024–2025'),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Universidad Nacional Dominicana · Todos los derechos reservados',
                style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      case 'terms':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. Uso Aceptable',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Esta plataforma es de uso exclusivo para estudiantes, profesores y personal administrativo de la UNAD. El acceso no autorizado está prohibido.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            const Text(
              '2. Responsabilidad del Usuario',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'El usuario es responsable de mantener la confidencialidad de sus credenciales de acceso.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            const Text(
              '3. Propiedad Intelectual',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Todo el contenido académico disponible en la plataforma es propiedad de la UNAD.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            const Text(
              '4. Modificaciones',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'La institución se reserva el derecho de modificar estos términos con previo aviso de 30 días.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        );
      case 'privacy':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos que recopilamos',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Recopilamos información académica, de contacto y de uso de la plataforma para brindar los servicios institucionales.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            const Text(
              'Uso de los datos',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Tus datos son utilizados exclusivamente para gestionar tu expediente académico y brindarte los servicios de la universidad.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            const Text(
              'No compartimos tus datos',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'No vendemos ni compartimos tu información personal con terceros sin tu consentimiento expreso.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tus derechos',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Tienes derecho a solicitar acceso, rectificación o eliminación de tus datos personales contactando a registros@unad.edu.do.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _aboutRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
