import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/ApiConfig.dart';
import '../models/tutor.dart';

class ProfileService {
  Future<Tutor?> fetchTutor(int tutorId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tutors/$tutorId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Tutor.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error al obtener datos del tutor: $e');
      return null;
    }
  }

  Future<bool> updateTutor(int tutorId, Tutor tutor) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/tutors/$tutorId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tutor.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error al actualizar datos del tutor: $e');
      return false;
    }
  }
}