import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';

/// Right-sliding profile panel, ported from ProfilePanel.jsx.
class ProfilePanel extends StatelessWidget {
  final VoidCallback onClose;
  final String currentRole;

  const ProfilePanel({
    super.key,
    required this.onClose,
    required this.currentRole,
  });

  @override
  Widget build(BuildContext context) {
    final profile = _getProfile(currentRole);
    final quickLinks = _getQuickLinks(currentRole);

    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: GestureDetector(
          onTap: () {},
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width > 400
                  ? 380
                  : MediaQuery.of(context).size.width,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(-4, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ── Header with gradient ──
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16,
                      left: 20,
                      right: 16,
                      bottom: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Close button
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: onClose,
                            icon: Icon(
                              LucideIcons.x,
                              size: 18,
                              color: AppColors.surface,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.surface.withValues(
                                alpha: 0.1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),

                        // Avatar & Name
                        Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: profile['photo'] != null
                                    ? Image.network(
                                        profile['photo']!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) =>
                                            _avatarFallback(profile['name']!),
                                      )
                                    : _avatarFallback(profile['name']!),
                              ),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile['name']!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.surface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    profile['email']!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.gold,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Text(
                                          profile['tag']!,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Text(
                                          'Activo',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.surface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Stats row
                        Row(
                          children: profile['stats'].map<Widget>((stat) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${stat['value']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.surface,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      stat['label'] as String,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // ── Program info ──
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.goldSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.award,
                          size: 14,
                          color: AppColors.goldDark,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile['program']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                profile['programSub']!,
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

                  // ── Progress bar (student only) ──
                  if (profile['progress'] != null) ...[
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progreso académico',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '${profile['progress']}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (profile['progress'] as int) / 100,
                              minHeight: 8,
                              backgroundColor: AppColors.border,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            profile['progressLabel']!,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ── Quick Links ──
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ACCESO RÁPIDO',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textTertiary,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: quickLinks.length,
                              itemBuilder: (context, index) {
                                final link = quickLinks[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      onTap: () {
                                        onClose();
                                        context.go(link['route'] as String);
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: AppColors.primarySurface,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                link['icon'] as IconData,
                                                size: 16,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    link['label'] as String,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                                  ),
                                                  Text(
                                                    link['desc'] as String,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .textTertiary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              LucideIcons.chevronRight,
                                              size: 16,
                                              color: Colors.grey.shade300,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Logout ──
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () {
                          onClose();
                          context.go(AppConstants.routeAuth);
                        },
                        icon: const Icon(LucideIcons.logOut, size: 16),
                        label: const Text('Cerrar Sesión'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                          backgroundColor: AppColors.errorSurface,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatarFallback(String name) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.2),
      child: Center(
        child: Text(
          name[0],
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.surface,
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getProfile(String role) {
    switch (role) {
      case AppConstants.roleStudent:
        return {
          'name': currentStudent.name,
          'email': currentStudent.email,
          'photo': currentStudent.photo,
          'tag': 'Estudiante',
          'program': currentStudent.program,
          'programSub': 'Matrícula: ${currentStudent.id}',
          'progress': currentStudent.progressPercent.round(),
          'progressLabel':
              '${currentStudent.cumulativeCredits} / ${currentStudent.totalCredits} créditos',
          'stats': [
            {'label': 'Semestre', 'value': currentStudent.semester},
            {'label': 'Índice', 'value': currentStudent.gpa.toStringAsFixed(2)},
            {'label': 'Créditos', 'value': currentStudent.cumulativeCredits},
          ],
        };
      case AppConstants.roleTeacher:
        return {
          'name': currentProfessor['name'],
          'email': currentProfessor['email'],
          'photo': currentProfessor['photo'],
          'tag': 'Profesor',
          'program': currentProfessor['department'],
          'programSub': 'ID: ${currentProfessor['id']}',
          'progress': null,
          'progressLabel': '',
          'stats': [
            {'label': 'Cursos', 'value': 3},
            {'label': 'Dept.', 'value': 'Ing.'},
            {'label': 'Sección', 'value': '01'},
          ],
        };
      case AppConstants.roleAdmin:
        return {
          'name': 'Juan Administrador',
          'email': 'admin@unad.edu.do',
          'photo':
              'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150&h=150&fit=crop&crop=face',
          'tag': 'Admin',
          'program': 'Administración General',
          'programSub': 'Acceso completo al sistema',
          'progress': null,
          'progressLabel': '',
          'stats': [
            {'label': 'Usuarios', 'value': '1,463'},
            {'label': 'Programas', 'value': 8},
            {'label': 'Rol', 'value': 'Adm.'},
          ],
        };
      case AppConstants.roleRegistrar:
        return {
          'name': 'Ana Registradora',
          'email': 'registrar@unad.edu.do',
          'photo':
              'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&h=150&fit=crop&crop=face',
          'tag': 'Registrador',
          'program': 'Oficina de Registro',
          'programSub': 'Gestión de certificados',
          'progress': null,
          'progressLabel': '',
          'stats': [
            {'label': 'Solicitudes', 'value': 12},
            {'label': 'Certif.', 'value': 4},
            {'label': 'Rol', 'value': 'Reg.'},
          ],
        };
      default:
        return _getProfile(AppConstants.roleStudent);
    }
  }

  List<Map<String, dynamic>> _getQuickLinks(String role) {
    switch (role) {
      case AppConstants.roleStudent:
        return [
          {
            'label': 'Mi Perfil',
            'icon': LucideIcons.graduationCap,
            'route': AppConstants.routeStudentProfile,
            'desc': 'Ver información personal',
          },
          {
            'label': 'Estado de Cuenta',
            'icon': LucideIcons.creditCard,
            'route': AppConstants.routePayments,
            'desc': 'Pagos y saldos pendientes',
          },
          {
            'label': 'Mis Calificaciones',
            'icon': LucideIcons.bookOpen,
            'route': AppConstants.routeGrades,
            'desc': 'Notas del semestre actual',
          },
          {
            'label': 'Récord Académico',
            'icon': LucideIcons.fileText,
            'route': AppConstants.routeAcademicRecord,
            'desc': 'Kardex y historial completo',
          },
          {
            'label': 'Configuración',
            'icon': LucideIcons.settings,
            'route': AppConstants.routeSettings,
            'desc': 'Cuenta y preferencias',
          },
        ];
      case AppConstants.roleTeacher:
        return [
          {
            'label': 'Mis Cursos',
            'icon': LucideIcons.bookOpen,
            'route': AppConstants.routeProfessorCourses,
            'desc': 'Ver mis asignaciones',
          },
          {
            'label': 'Calificaciones',
            'icon': LucideIcons.fileText,
            'route': AppConstants.routeGradeEntry,
            'desc': 'Ingresar notas',
          },
          {
            'label': 'Configuración',
            'icon': LucideIcons.settings,
            'route': AppConstants.routeSettings,
            'desc': 'Cuenta y preferencias',
          },
        ];
      case AppConstants.roleAdmin:
        return [
          {
            'label': 'Dashboard',
            'icon': LucideIcons.barChart3,
            'route': AppConstants.routeAdminDashboard,
            'desc': 'Panel principal',
          },
          {
            'label': 'Usuarios',
            'icon': LucideIcons.userCog,
            'route': AppConstants.routeAdminUsers,
            'desc': 'Gestión de usuarios',
          },
          {
            'label': 'Estudiantes',
            'icon': LucideIcons.users,
            'route': AppConstants.routeAdminStudents,
            'desc': 'Ver todos los estudiantes',
          },
          {
            'label': 'Configuración',
            'icon': LucideIcons.settings,
            'route': AppConstants.routeSettings,
            'desc': 'Cuenta y preferencias',
          },
        ];
      case AppConstants.roleRegistrar:
        return [
          {
            'label': 'Estudiantes',
            'icon': LucideIcons.users,
            'route': AppConstants.routeAdminStudents,
            'desc': 'Ver estudiantes',
          },
          {
            'label': 'Certificados',
            'icon': LucideIcons.award,
            'route': AppConstants.routeAdminCertificates,
            'desc': 'Emitir certificados',
          },
          {
            'label': 'Configuración',
            'icon': LucideIcons.settings,
            'route': AppConstants.routeSettings,
            'desc': 'Cuenta y preferencias',
          },
        ];
      default:
        return _getQuickLinks(AppConstants.roleStudent);
    }
  }
}
