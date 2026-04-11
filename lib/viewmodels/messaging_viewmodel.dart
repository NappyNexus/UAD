import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uad/data/models/chat_model.dart';
import 'package:uad/data/mock/mock_data.dart';
import 'package:uad/viewmodels/auth_viewmodel.dart';

class MessagingState {
  final List<ChatContact> contacts;
  final Map<String, List<ChatMessage>> messagesByContact;
  final String? selectedContactId;

  MessagingState({
    required this.contacts,
    required this.messagesByContact,
    this.selectedContactId,
  });

  MessagingState copyWith({
    List<ChatContact>? contacts,
    Map<String, List<ChatMessage>>? messagesByContact,
    String? selectedContactId,
  }) {
    return MessagingState(
      contacts: contacts ?? this.contacts,
      messagesByContact: messagesByContact ?? this.messagesByContact,
      selectedContactId: selectedContactId ?? this.selectedContactId,
    );
  }
}

class MessagingViewModel extends StateNotifier<MessagingState> {
  final Ref ref;

  MessagingViewModel(this.ref)
    : super(
        MessagingState(
          contacts: _initialContacts,
          messagesByContact: _initialMessages,
        ),
      );

  static final List<ChatContact> _initialContacts = [
    ChatContact(
      id: 'prof-001',
      name: 'Dr. Roberto Méndez',
      role: 'Profesor - Ing. Software',
      photo:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop',
      lastMessage: 'Recuerda subir el proyecto final mañana.',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 45)),
      online: true,
      unreadCount: 1,
    ),
    ChatContact(
      id: 'reg-001',
      name: 'Lic. Ana Martínez',
      role: 'Registro Académico',
      photo:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop',
      lastMessage: 'Su solicitud ha sido procesada.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
      online: false,
    ),
    ChatContact(
      id: 'admin-001',
      name: 'Soporte Técnico',
      role: 'Departamento TI',
      photo:
          'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=100&h=100&fit=crop',
      lastMessage: '¿En qué puedo ayudarle hoy?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      online: true,
    ),
  ];

  static final Map<String, List<ChatMessage>> _initialMessages = {
    'prof-001': [
      ChatMessage(
        id: '1',
        senderId: 'prof-001',
        senderName: 'Dr. Roberto Méndez',
        content: 'Hola Gabriel, ¿cómo vas con el avance de la práctica?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
      ),
      ChatMessage(
        id: '2',
        senderId: 'student-2022',
        senderName: 'Gabriel Santana',
        content: 'Muy bien profesor, ya casi termino el módulo de Riverpod.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isMe: true,
      ),
      ChatMessage(
        id: '3',
        senderId: 'prof-001',
        senderName: 'Dr. Roberto Méndez',
        content: 'Recuerda subir el proyecto final mañana.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        isMe: false,
      ),
    ],
    'reg-001': [
      ChatMessage(
        id: '4',
        senderId: 'reg-001',
        senderName: 'Lic. Ana Martínez',
        content: 'Su solicitud de récord académico ha sido recibida.',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isMe: false,
      ),
      ChatMessage(
        id: '5',
        senderId: 'reg-001',
        senderName: 'Lic. Ana Martínez',
        content: 'Su solicitud ha sido procesada.',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isMe: false,
      ),
    ],
    'admin-001': [
      ChatMessage(
        id: '6',
        senderId: 'admin-001',
        senderName: 'Soporte Técnico',
        content: '¿En qué puedo ayudarle hoy?',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isMe: false,
      ),
    ],
  };

  void selectContact(String contactId) {
    state = state.copyWith(selectedContactId: contactId);

    // Clear unread count
    final updatedContacts = state.contacts.map((c) {
      if (c.id == contactId) {
        return ChatContact(
          id: c.id,
          name: c.name,
          role: c.role,
          photo: c.photo,
          lastMessage: c.lastMessage,
          lastMessageTime: c.lastMessageTime,
          unreadCount: 0,
          online: c.online,
        );
      }
      return c;
    }).toList();

    state = state.copyWith(contacts: updatedContacts);
  }

  void sendMessage(
    String content, {
    MessageType type = MessageType.text,
    String? fileName,
    String? fileSize,
  }) {
    final contactId = state.selectedContactId;
    if (contactId == null) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      senderName: 'Gabriel Santana',
      content: content,
      timestamp: DateTime.now(),
      type: type,
      fileName: fileName,
      fileSize: fileSize,
      isMe: true,
    );

    final currentMessages = state.messagesByContact[contactId] ?? [];
    final updatedMessages = {
      ...state.messagesByContact,
      contactId: [...currentMessages, newMessage],
    };

    // Update last message in contact list
    final updatedContacts = state.contacts.map((c) {
      if (c.id == contactId) {
        return ChatContact(
          id: c.id,
          name: c.name,
          role: c.role,
          photo: c.photo,
          lastMessage: type == MessageType.text
              ? content
              : 'Adjunto: $fileName',
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
          online: c.online,
        );
      }
      return c;
    }).toList();

    state = state.copyWith(
      messagesByContact: updatedMessages,
      contacts: updatedContacts,
    );

    // Simulate auto-reply
    _simulateReply(contactId);
  }

  void _simulateReply(String contactId) {
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      final reply = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: contactId,
        senderName: state.contacts.firstWhere((c) => c.id == contactId).name,
        content: 'He recibido tu mensaje. Lo revisaré en breve.',
        timestamp: DateTime.now(),
        isMe: false,
      );

      final currentMessages = state.messagesByContact[contactId] ?? [];
      final updatedMessages = {
        ...state.messagesByContact,
        contactId: [...currentMessages, reply],
      };

      final updatedContacts = state.contacts.map((c) {
        if (c.id == contactId) {
          return ChatContact(
            id: c.id,
            name: c.name,
            role: c.role,
            photo: c.photo,
            lastMessage: reply.content,
            lastMessageTime: DateTime.now(),
            unreadCount: state.selectedContactId == contactId ? 0 : 1,
            online: c.online,
          );
        }
        return c;
      }).toList();

      state = state.copyWith(
        messagesByContact: updatedMessages,
        contacts: updatedContacts,
      );
    });
  }
}

final messagingProvider =
    StateNotifierProvider<MessagingViewModel, MessagingState>((ref) {
      return MessagingViewModel(ref);
    });
