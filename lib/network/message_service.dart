import 'package:dio/dio.dart';
import '../models/message.dart';
import 'api_service.dart';

class MessageService {
  Future<List<Message>> getMessagesBetweenUsers(int senderId, int receiverId) async {
    try {
      final dio = await ApiService.getInstance();
      final response = await dio.get('/messages/$senderId/$receiverId');
      List data = response.data;
      return data.map((json) => Message.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error al obtener mensajes entre usuarios: $e');
      throw Exception('Error al obtener mensajes');
    }
  }

  Future<void> sendMessage(Message message) async {
    try {
      final dio = await ApiService.getInstance();
      await dio.post('/messages/send', data: message.toJson());
    } catch (e) {
      print('❌ Error al enviar mensaje: $e');
      throw Exception('Error al enviar mensaje');
    }
  }

  Future<List<Message>> getConversationListForUser(int userId) async {
    try {
      final dio = await ApiService.getInstance();
      final response = await dio.get('/messages/chats/$userId');
      List data = response.data;
      return data.map((json) => Message.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error al obtener conversaciones: $e');
      throw Exception('Error al obtener conversaciones');
    }
  }
}

