enum MessageType { text, image, file }

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final String? fileName;
  final String? fileSize;
  final bool isMe;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.fileName,
    this.fileSize,
    required this.isMe,
  });
}

class ChatContact {
  final String id;
  final String name;
  final String role;
  final String photo;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool online;

  const ChatContact({
    required this.id,
    required this.name,
    required this.role,
    required this.photo,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.online = false,
  });

  ChatContact copyWith({
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? online,
  }) {
    return ChatContact(
      id: id,
      name: name,
      role: role,
      photo: photo,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      online: online ?? this.online,
    );
  }
}
