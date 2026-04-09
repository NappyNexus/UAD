import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../viewmodels/auth_viewmodel.dart';

class RoleSelectScreen extends ConsumerWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF026A45), Color(0xFF015A3A), Color(0xFF013D28)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // ── Logo & Title ──
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/logos/Logo-UNAD-Blanco 2.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'UNAD',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.cardColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sistema Académico',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Select your role text ──
                Text(
                  'Selecciona tu perfil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Elige un rol para explorar el sistema',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Role Cards Grid ──
                GridView.count(
                  crossAxisCount: size.width > 500 ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: size.width > 500
                      ? 0.85
                      : (size.width < 380 ? 0.65 : 0.72),
                  children: [
                    _RoleCard(
                      role: AppConstants.roleStudent,
                      label: 'Estudiante',
                      subtitle: 'Acceso a tu portal académico',
                      icon: LucideIcons.graduationCap,
                      gradient: AppColors.studentGradient,
                      photoUrl:
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop&crop=face',
                      onTap: () =>
                          _selectRole(context, ref, AppConstants.roleStudent),
                    ),
                    _RoleCard(
                      role: AppConstants.roleTeacher,
                      label: 'Profesor',
                      subtitle: 'Gestión de cursos y notas',
                      icon: LucideIcons.bookOpen,
                      gradient: AppColors.professorGradient,
                      photoUrl:
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                      onTap: () =>
                          _selectRole(context, ref, AppConstants.roleTeacher),
                    ),
                    _RoleCard(
                      role: AppConstants.roleAdmin,
                      label: 'Admin',
                      subtitle: 'Administración del sistema',
                      icon: LucideIcons.shield,
                      gradient: AppColors.adminGradient,
                      photoUrl:
                          'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150&h=150&fit=crop&crop=face',
                      onTap: () =>
                          _selectRole(context, ref, AppConstants.roleAdmin),
                    ),
                    _RoleCard(
                      role: AppConstants.roleRegistrar,
                      label: 'Registrador',
                      subtitle: 'Oficina de registro',
                      icon: LucideIcons.clipboardList,
                      gradient: AppColors.registrarGradient,
                      photoUrl:
                          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&h=150&fit=crop&crop=face',
                      onTap: () =>
                          _selectRole(context, ref, AppConstants.roleRegistrar),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ── Footer ──
                Text(
                  'Universidad Adventista Dominicana',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bonao, Monseñor Nouel · RD',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectRole(BuildContext context, WidgetRef ref, String role) {
    ref.read(authProvider.notifier).selectRole(role);

    // Navigate to the first nav item for that role
    final navItems = AppConstants.getNavItems(role);
    if (navItems.isNotEmpty) {
      context.go(navItems.first.route);
    }
  }
}

// ═════════════════════════════════════════════════════════════════════
// Role Card Widget
// ═════════════════════════════════════════════════════════════════════

class _RoleCard extends StatefulWidget {
  final String role;
  final String label;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final String photoUrl;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.photoUrl,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isPressed ? 0.08 : 0.15),
                blurRadius: _isPressed ? 8 : 16,
                offset: Offset(0, _isPressed ? 2 : 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Role-colored gradient strip at top ──
              Container(
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: widget.gradient),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 12),

              // ── Avatar with icon badge ──
              Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.gradient.first.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        widget.photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: widget.gradient.first.withValues(alpha: 0.1),
                          child: Icon(
                            widget.icon,
                            size: 24,
                            color: widget.gradient.first,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: widget.gradient),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: AppColors.cardColor,
                          width: 2,
                        ),
                      ),
                      child: Icon(widget.icon, size: 11, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ── Label ──
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
