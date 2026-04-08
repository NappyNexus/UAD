import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/layout/app_drawer.dart';
import '../../widgets/layout/notifications_panel.dart';
import '../../widgets/layout/profile_panel.dart';

/// The main scaffold shell for authenticated screens.
/// Provides bottom navigation, app bar, and drawer.
class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _showNotifications = false;
  bool _showProfile = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = ref.watch(authProvider);
    final role = auth.currentRole ?? AppConstants.roleStudent;
    final navItems = AppConstants.getNavItems(role);
    final bottomNavItems = navItems.take(4).toList();

    // Determine which bottom nav item is active
    final currentLocation = GoRouterState.of(context).matchedLocation;
    int currentIndex = bottomNavItems.indexWhere(
      (item) => currentLocation.startsWith(item.route),
    );
    if (currentIndex == -1) currentIndex = 0;

    return Scaffold(
      // ── App Bar ──
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leadingWidth: 100,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) => IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  LucideIcons.menu,
                  color: AppColors.surface,
                  size: 24,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Image.asset(
                    'assets/logos/Logo-UNAD-Blanco 2.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            AppConstants.roleLabels[role] ?? role,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.surface,
              letterSpacing: 0.5,
            ),
          ),
        ),
        actions: [
          // Notification bell
          IconButton(
            icon: Stack(
              children: [
                const Icon(LucideIcons.bell, color: Colors.white, size: 24),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () => setState(() {
              _showNotifications = true;
              _showProfile = false;
            }),
          ),
          // Profile avatar
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() {
                _showProfile = true;
                _showNotifications = false;
              }),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: auth.userPhoto != null
                      ? Image.network(auth.userPhoto!, fit: BoxFit.cover)
                      : Container(
                          color: Colors.white.withValues(alpha: 0.2),
                          child: Center(
                            child: Text(
                              (auth.userName ?? 'U')[0].toUpperCase(),
                              style: TextStyle(
                                color: AppColors.surface,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Drawer ──
      drawer: AppDrawer(
        navItems: navItems,
        currentRoute: currentLocation,
        currentRole: role,
      ),

      // ── Body ──
      body: Stack(
        children: [
          widget.child,
          if (_showNotifications)
            NotificationsPanel(
              onClose: () => setState(() => _showNotifications = false),
            ),
          if (_showProfile)
            ProfilePanel(
              onClose: () => setState(() => _showProfile = false),
              currentRole: role,
            ),
        ],
      ),

      // ── Bottom Navigation ──
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                // 4 nav items
                ...bottomNavItems.asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;
                  final isActive = i == currentIndex;
                  return Expanded(
                    child: _BottomNavItem(
                      icon: item.icon,
                      label: item.label,
                      isActive: isActive,
                      onTap: () => context.go(item.route),
                    ),
                  );
                }),
                // "More" button
                Expanded(
                  child: Builder(
                    builder: (context) => _BottomNavItem(
                      icon: LucideIcons.moreHorizontal,
                      label: 'Más',
                      isActive: false,
                      onTap: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// Bottom Nav Item
// ════════════════════════════════════════════════════════════════════

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primarySurface : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 3),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
