class ConversationWith {
  String? userId;
  String? entityId;
  String name;
  String? imageUrl;

  ConversationWith({
    this.userId,
    this.entityId,
    required this.name,
    this.imageUrl,
  });

  factory ConversationWith.fromMap(Map<String, dynamic> map) {
    return ConversationWith(
      userId: map['user_id']?.toString(),
      entityId: map['entity_id']?.toString(),
      name: map['name'] ?? 'Unknown User',
      imageUrl: map['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'entity_id': entityId,
      'name': name,
      'image_url': imageUrl,
    };
  }
}

class Message {
  String? messageId;
  String? senderId;
  String? receiverId;
  String content;
  String? sentAt;
  String? senderName;
  String? senderEntityId;
  String? receiverName;
  String? receiverEntityId;
  bool isOptimistic = false;
  bool isConfirmed = false;

  Message({
    this.messageId,
    this.senderId,
    this.receiverId,
    required this.content,
    this.sentAt,
    this.senderName,
    this.senderEntityId,
    this.receiverName,
    this.receiverEntityId,
    this.isOptimistic = false,
    this.isConfirmed = false,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['message_id']?.toString(),
      senderId: map['sender_id']?.toString(),
      receiverId: map['receiver_id']?.toString(),
      content: map['content'] ?? '',
      sentAt: map['sent_at'],
      senderName: map['sender_name'],
      senderEntityId: map['sender_entity_id']?.toString(),
      receiverName: map['receiver_name'],
      receiverEntityId: map['receiver_entity_id']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message_id': messageId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'sent_at': sentAt,
      'sender_name': senderName,
      'sender_entity_id': senderEntityId,
      'receiver_name': receiverName,
      'receiver_entity_id': receiverEntityId,
    };
  }
}

class Conversation {
  ConversationWith conversationWith;
  List<Message> messages;

  Conversation({required this.conversationWith, required this.messages});

  factory Conversation.fromMap(Map<String, dynamic> map) {
    final messagesList = (map['messages'] as List? ?? [])
        .map((m) => Message.fromMap(m as Map<String, dynamic>))
        .toList();
    return Conversation(
      conversationWith: ConversationWith.fromMap(
        map['conversation_with'] ?? {},
      ),
      messages: messagesList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conversation_with': conversationWith.toMap(),
      'messages': messages.map((m) => m.toMap()).toList(),
    };
  }
}
