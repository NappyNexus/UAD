import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_color_scheme.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final List<Map<String, dynamic>> _contacts = [
    {
      'id': 1,
      'name': 'Dr. Carlos Martínez',
      'role': 'Profesor · Cálculo III',
      'initials': 'CM',
      'lastMessage': 'El examen final será el próximo viernes.',
      'time': '10:32',
      'unread': 2,
      'online': true,
    },
    {
      'id': 2,
      'name': 'Ing. Ana Pérez',
      'role': 'Profesora · Base de Datos II',
      'initials': 'AP',
      'lastMessage': 'Recuerden entregar el proyecto.',
      'time': 'Ayer',
      'unread': 0,
      'online': false,
    },
    {
      'id': 3,
      'name': 'Oficina de Registro',
      'role': 'Administración',
      'initials': 'OR',
      'lastMessage': 'Su solicitud ha sido procesada.',
      'time': 'Lun',
      'unread': 1,
      'online': true,
    },
  ];

  Map<String, dynamic>? _selectedContact;
  final TextEditingController _msgCtrl = TextEditingController();

  final Map<int, List<Map<String, dynamic>>> _messages = {
    1: [
      {
        'sender': 'them',
        'text': 'Buenos días María, ¿cómo van con el tema?',
        'time': '09:15',
      },
      {
        'sender': 'me',
        'text': 'Buenos días Dr., estamos estudiando.',
        'time': '09:18',
      },
      {
        'sender': 'them',
        'text': 'Perfecto, horas de oficina mañana.',
        'time': '09:20',
      },
      {'sender': 'me', 'text': 'Excelente, ahí estaremos!', 'time': '09:22'},
      {
        'sender': 'them',
        'text': 'El examen final será el próximo viernes.',
        'time': '10:32',
      },
    ],
    3: [
      {
        'sender': 'me',
        'text': 'Buenos días, quisiera solicitar un certificado.',
        'time': 'Lun 08:00',
      },
      {
        'sender': 'them',
        'text': 'Claro, hemos recibido su solicitud.',
        'time': 'Lun 09:30',
      },
      {
        'sender': 'them',
        'text': 'Su solicitud ha sido procesada.',
        'time': 'Lun 11:00',
      },
    ],
  };

  void _sendMessage() {
    if (_msgCtrl.text.trim().isEmpty || _selectedContact == null) return;
    setState(() {
      final cid = _selectedContact!['id'];
      if (_messages[cid] == null) _messages[cid] = [];
      _messages[cid]!.add({
        'sender': 'me',
        'text': _msgCtrl.text.trim(),
        'time': 'Ahora',
      });
      _msgCtrl.clear();
    });
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(
          16,
        ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.image,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              title: const Text(
                'Galería',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.fileText,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              title: const Text(
                'Documentos',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.camera,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              title: const Text(
                'Cámara',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_selectedContact != null) {
      final msgs = _messages[_selectedContact!['id']] ?? [];
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
            onPressed: () => setState(() => _selectedContact = null),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 16,
                child: Text(
                  _selectedContact!['initials'],
                  style: TextStyle(
                    color: AppColors.surface,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedContact!['name'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _selectedContact!['role'],
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                LucideIcons.phone,
                size: 18,
                color: AppColors.textSecondary,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                LucideIcons.video,
                size: 18,
                color: AppColors.textSecondary,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: msgs.length,
                itemBuilder: (ctx, i) {
                  final m = msgs[i];
                  final isMe = m['sender'] == 'me';
                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 16 : 4),
                          bottomRight: Radius.circular(isMe ? 4 : 16),
                        ),
                        border: isMe
                            ? null
                            : Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            m['text'],
                            style: TextStyle(
                              color: isMe
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            m['time'],
                            style: TextStyle(
                              color: isMe
                                  ? Colors.white70
                                  : AppColors.textTertiary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(
                16,
              ).copyWith(bottom: 16 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.borderMedium)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      LucideIcons.paperclip,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => _showAttachmentOptions(context),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _msgCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 13),
                        ),
                        style: const TextStyle(fontSize: 13),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      icon: Icon(
                        LucideIcons.send,
                        color: AppColors.surface,
                        size: 18,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          children: [
            Padding(
              // padding: const EdgeInsets.symmetric(vertical: 8.0, bottom: 16.0),
              padding: EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mensajes',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.plus, size: 16),
                    label: const Text('Nuevo chat'),
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
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderMedium),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    LucideIcons.search,
                    size: 18,
                    color: AppColors.textTertiary,
                  ),
                  hintText: 'Buscar...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _contacts.length,
                separatorBuilder: (_, _) =>
                    Divider(height: 1, color: AppColors.borderMedium),
                itemBuilder: (ctx, i) {
                  final c = _contacts[i];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        c['unread'] = 0;
                        _selectedContact = c;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primary,
                                radius: 24,
                                child: Text(
                                  c['initials'],
                                  style: TextStyle(
                                    color: AppColors.surface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (c['online'])
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.surface,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      c['name'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: (c['unread'] > 0)
                                            ? FontWeight.bold
                                            : FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      c['time'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: c['unread'] > 0
                                            ? AppColors.primary
                                            : AppColors.textTertiary,
                                        fontWeight: c['unread'] > 0
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        c['lastMessage'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: c['unread'] > 0
                                              ? AppColors.textPrimary
                                              : AppColors.textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (c['unread'] > 0)
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '${c['unread']}',
                                          style: TextStyle(
                                            color: AppColors.surface,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  c['role'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
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
