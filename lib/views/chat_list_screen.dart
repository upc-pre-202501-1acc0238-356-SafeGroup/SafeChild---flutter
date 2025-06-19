import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../network/message_service.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  final int userId;

  const ChatListScreen({super.key, required this.userId});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late Future<List<Message>> _conversations;

  @override
  void initState() {
    super.initState();
    _conversations = MessageService().getConversationListForUser(widget.userId);
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2), // Celeste oscuro
        elevation: 2,
        title: const Text(
          'Tus Conversaciones',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Negrita
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: FutureBuilder<List<Message>>(
          future: _conversations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay conversaciones.'));
            }

            final conversations = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final msg = conversations[index];
                final contactId = msg.senderId == widget.userId ? msg.receiverId : msg.senderId;

                return Card(
                  color: const Color(0xFFE3F2FD), // Celeste suave
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[200],
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      'Chat con usuario $contactId',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      msg.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: msg.senderId == widget.userId
                          ? const TextStyle(fontWeight: FontWeight.bold) // Negrita si es tu mensaje
                          : null,
                    ),
                    trailing: Text(
                      _formatTime(msg.timestamp),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDetailScreen(
                            userId: widget.userId,
                            contactId: contactId,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}