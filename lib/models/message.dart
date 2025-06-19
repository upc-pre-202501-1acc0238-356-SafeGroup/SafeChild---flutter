class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final String senderUsername;
  final String receiverUsername;
  final String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderUsername,
    required this.receiverUsername,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    print(json);
    return Message(
      id: json['id'],
      senderId: json['sender']['id'],
      receiverId: json['receiver']['id'],
      senderUsername: json['sender']['username'],
      receiverUsername: json['receiver']['username'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderUsername': senderUsername,
      'receiverUsername': receiverUsername,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

