import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_color_scheme.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/messaging_viewmodel.dart';

/// Notification filter tabs.
const _tabs = ['Todas', 'Sin leer', 'Mensajes', 'Notas', 'Calendario'];

/// Map notification types to tabs.
const _typeTabMap = {
  'message': 'Mensajes',
  'grade': 'Notas',
  'calendar': 'Calendario',
};

/// A single notification item for the panel.
class NotifItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String time;
  final String? route;
  bool unread;

  NotifItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.time,
    this.route,
    this.unread = true,
  });
}

/// Mock notifications for display.
final List<NotifItem> _mockNotifications = [
  NotifItem(
    id: '1',
    title: 'Calificación publicada',
    message: 'Dr. Carlos Martínez publicó notas del Parcial 1 de Cálculo III.',
    type: 'grade',
    icon: LucideIcons.bookOpen,
    iconBg: const Color(0xFFECFDF5),
    iconColor: const Color(0xFF047857),
    time: 'Hace 5 min',
    route: '/student/grades',
    unread: true,
  ),
  NotifItem(
    id: '2',
    title: 'Pago pendiente',
    message:
        'Tu matrícula de Ago-Dic 2024 tiene un saldo pendiente de RD\$ 45,000.',
    type: 'payment',
    icon: LucideIcons.creditCard,
    iconBg: const Color(0xFFFFFBEB),
    iconColor: const Color(0xFFB45309),
    time: 'Hace 2 horas',
    route: '/student/payments',
    unread: true,
  ),
  NotifItem(
    id: '4',
    title: 'Fecha límite',
    message: 'Recuerda: mañana vence el plazo de selección de materias.',
    type: 'calendar',
    icon: LucideIcons.calendar,
    iconBg: const Color(0xFFF5F3FF),
    iconColor: const Color(0xFF7C3AED),
    time: 'Ayer',
    route: '/student/schedule',
    unread: false,
  ),
];

class NotificationsPanel extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const NotificationsPanel({super.key, required this.onClose});

  @override
  ConsumerState<NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends ConsumerState<NotificationsPanel> {
  String _activeTab = 'Todas';
  late List<NotifItem> _localNotifications;

  @override
  void initState() {
    super.initState();
    _localNotifications = _mockNotifications
        .map(
          (n) => NotifItem(
            id: n.id,
            title: n.title,
            message: n.message,
            type: n.type,
            icon: n.icon,
            iconBg: n.iconBg,
            iconColor: n.iconColor,
            time: n.time,
            route: n.route,
            unread: n.unread,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final msgState = ref.watch(messagingProvider);

    // Combine local notifications with dynamic message notifications
    final allNotifications = [..._localNotifications];

    for (final contact in msgState.contacts) {
      if (contact.unreadCount > 0) {
        allNotifications.insert(
          0,
          NotifItem(
            id: 'msg-${contact.id}',
            title: 'Nuevo mensaje de ${contact.name}',
            message: contact.lastMessage,
            type: 'message',
            icon: LucideIcons.messageCircle,
            iconBg: const Color(0xFFEFF6FF),
            iconColor: const Color(0xFF1D4ED8),
            time: 'Ahora',
            route: '/messaging',
            unread: true,
          ),
        );
      }
    }

    final filtered = _getFiltered(allNotifications);
    final unreadCount = allNotifications.where((n) => n.unread).length;

    return GestureDetector(
      onTap: widget.onClose,
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
                color: c.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: const Offset(-4, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 12,
                      left: 20,
                      right: 12,
                      bottom: 12,
                    ),
                    color: AppColors.primary,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notificaciones',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                '$unreadCount sin leer',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _markAllRead,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    LucideIcons.checkCheck,
                                    size: 14,
                                    color: AppColors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Leídas',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: widget.onClose,
                          icon: Icon(
                            LucideIcons.x,
                            size: 18,
                            color: AppColors.white,
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
                      ],
                    ),
                  ),

                  // Tabs
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: c.border)),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _tabs.map((tab) {
                          final isActive = _activeTab == tab;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: GestureDetector(
                              onTap: () => setState(() => _activeTab = tab),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.primary
                                      : c.inputFill,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      tab,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: isActive
                                            ? Colors.white
                                            : c.textSecondary,
                                      ),
                                    ),
                                    if (tab == 'Sin leer' &&
                                        unreadCount > 0) ...[
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? Colors.white
                                              : AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Text(
                                          '$unreadCount',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: isActive
                                                ? AppColors.primary
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // List
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.bell,
                                  size: 32,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Sin notificaciones',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) =>
                                Divider(height: 1, color: Colors.grey.shade50),
                            itemBuilder: (context, index) {
                              final notif = filtered[index];
                              return Dismissible(
                                key: Key(notif.id),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) =>
                                    _deleteNotification(notif.id),
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  color: AppColors.errorSurface,
                                  child: const Icon(
                                    LucideIcons.trash2,
                                    size: 18,
                                    color: AppColors.error,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () =>
                                      _markRead(notif.id, allNotifications),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    color: notif.unread
                                        ? const Color(0x08026A45)
                                        : Colors.transparent,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: notif.iconBg,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Icon(
                                            notif.icon,
                                            size: 17,
                                            color: notif.iconColor,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      notif.title,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: notif.unread
                                                            ? FontWeight.w600
                                                            : FontWeight.w500,
                                                        color: c.textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                  if (notif.unread)
                                                    Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColors.primary,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                notif.message,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: c.textSecondary,
                                                  height: 1.4,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(
                                                    LucideIcons.clock,
                                                    size: 10,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    notif.time,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
        ),
      ),
    );
  }

  List<NotifItem> _getFiltered(List<NotifItem> all) {
    if (_activeTab == 'Todas') return all;
    if (_activeTab == 'Sin leer') {
      return all.where((n) => n.unread).toList();
    }
    return all.where((n) => _typeTabMap[n.type] == _activeTab).toList();
  }

  void _markAllRead() {
    setState(() {
      for (final n in _localNotifications) {
        n.unread = false;
      }
    });
    // Message notifications are handled by the viewmodel (cleared when selecting chat)
  }

  void _markRead(String id, List<NotifItem> all) {
    // Find the notification in the combined list
    final notif = all.firstWhere((n) => n.id == id);

    // Perform navigation if route exists
    if (notif.route != null) {
      context.go(notif.route!);
      widget.onClose();
    }

    if (id.startsWith('msg-')) {
      final contactId = id.replaceFirst('msg-', '');
      ref.read(messagingProvider.notifier).selectContact(contactId);
    } else {
      setState(() {
        final n = _localNotifications.firstWhere((n) => n.id == id);
        n.unread = false;
      });
    }
  }

  void _deleteNotification(String id) {
    if (!id.startsWith('msg-')) {
      setState(() {
        _localNotifications.removeWhere((n) => n.id == id);
      });
    }
  }
}
