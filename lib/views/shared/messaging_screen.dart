import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/chat_model.dart';
import '../../viewmodels/messaging_viewmodel.dart';

class MessagingScreen extends ConsumerStatefulWidget {
  const MessagingScreen({super.key});

  @override
  ConsumerState<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends ConsumerState<MessagingScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  void _sendMessage() {
    if (_msgCtrl.text.trim().isEmpty) return;
    ref.read(messagingProvider.notifier).sendMessage(_msgCtrl.text.trim());
    _msgCtrl.clear();
  }

  void _handleNewChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Función de "Nuevo Chat" estará disponible pronto'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      ref
          .read(messagingProvider.notifier)
          .sendMessage(
            'Imagen enviada',
            type: MessageType.image,
            fileName: image.name,
            fileSize: '1.2 MB', // Mock size
          );
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = result.files.first;
      ref
          .read(messagingProvider.notifier)
          .sendMessage(
            'Documento enviado',
            type: MessageType.file,
            fileName: file.name,
            fileSize: '${(file.size / 1024).toStringAsFixed(1)} KB',
          );
      if (mounted) Navigator.pop(context);
    }
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
              onTap: () => _pickImage(ImageSource.gallery),
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
              onTap: _pickFile,
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
              onTap: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messagingProvider);
    final selectedContactId = state.selectedContactId;
    final selectedContact = selectedContactId != null
        ? state.contacts.cast<ChatContact?>().firstWhere(
            (c) => c?.id == selectedContactId,
            orElse: () => null,
          )
        : null;

    if (selectedContact != null) {
      final msgs = state.messagesByContact[selectedContact.id] ?? [];
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
            onPressed: () => ref
                .read(messagingProvider.notifier)
                .selectContact(''), // Deselect
          ),
          title: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(selectedContact.photo),
                    radius: 18,
                  ),
                  if (selectedContact.online)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 10,
                        height: 10,
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedContact.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      selectedContact.role,
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
                  return _buildMessageBubble(m);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.of(context).padding.bottom,
              ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(24),
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
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(
                        LucideIcons.send,
                        color: Colors.white,
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                IconButton(
                  onPressed: _handleNewChat,
                  icon: Icon(LucideIcons.plusCircle, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderMedium),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.search,
                    size: 18,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar chats...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.textTertiary,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'CONVERSACIONES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.contacts.length,
                separatorBuilder: (ctx, i) =>
                    Divider(height: 1, color: AppColors.borderMedium),
                itemBuilder: (ctx, i) {
                  final contact = state.contacts[i];
                  return _buildContactTile(contact);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(ChatContact contact) {
    final timeStr =
        "${contact.lastMessageTime.hour}:${contact.lastMessageTime.minute.toString().padLeft(2, '0')}";

    return InkWell(
      onTap: () =>
          ref.read(messagingProvider.notifier).selectContact(contact.id),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(contact.photo),
                  radius: 26,
                ),
                if (contact.online)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        contact.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: contact.unreadCount > 0
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 11,
                          color: contact.unreadCount > 0
                              ? AppColors.primary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          contact.lastMessage,
                          style: TextStyle(
                            fontSize: 13,
                            color: contact.unreadCount > 0
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: contact.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (contact.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${contact.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage m) {
    return Align(
      alignment: m.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: m.isMe ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(m.isMe ? 16 : 4),
            bottomRight: Radius.circular(m.isMe ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: m.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (m.type == MessageType.text)
              Text(
                m.content,
                style: TextStyle(
                  color: m.isMe ? Colors.white : AppColors.textPrimary,
                  fontSize: 14,
                ),
              )
            else if (m.type == MessageType.image)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: m.isMe
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppColors.background,
                      child: Icon(
                        LucideIcons.image,
                        color: m.isMe ? Colors.white : AppColors.primary,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    m.fileName ?? 'Imagen.jpg',
                    style: TextStyle(
                      color: m.isMe
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              )
            else if (m.type == MessageType.file)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: m.isMe
                      ? Colors.white.withValues(alpha: 0.1)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.fileText,
                      color: m.isMe ? Colors.white : AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.fileName ?? 'Documento.pdf',
                            style: TextStyle(
                              color: m.isMe
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            m.fileSize ?? '0 KB',
                            style: TextStyle(
                              color: m.isMe
                                  ? Colors.white.withValues(alpha: 0.7)
                                  : AppColors.textTertiary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            Text(
              "${m.timestamp.hour}:${m.timestamp.minute.toString().padLeft(2, '0')}",
              style: TextStyle(
                color: m.isMe
                    ? Colors.white.withValues(alpha: 0.7)
                    : AppColors.textTertiary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
