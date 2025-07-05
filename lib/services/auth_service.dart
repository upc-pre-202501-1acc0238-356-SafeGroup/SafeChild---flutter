import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/ApiConfig.dart';
import '../models/user.dart';
import '../models/tutor.dart';

class AuthService {
  Future<User?> signUp(String username, String password) async {
    try {
      debugPrint('Intentando registrarse en: ${ApiConfig.signUp}');
      final response = await http.post(
        Uri.parse(ApiConfig.signUp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password, 'roles': ['TUTOR']}),
      );
      debugPrint('Respuesta de registro: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return User.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      debugPrint('Error en signUp: $e');
      return null;
    }
  }

  Future<User?> signIn(String username, String password) async {
    try {
      debugPrint('Intentando iniciar sesión en: ${ApiConfig.signIn}');
      final response = await http.post(
        Uri.parse(ApiConfig.signIn),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      debugPrint('Respuesta de login: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return User.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      debugPrint('Error en signIn: $e');
      return null;
    }
  }

  Future<int?> createTutor(Tutor tutor) async {
    try {
      final endpoint = '${ApiConfig.baseUrl}/tutors';
      debugPrint('Creando tutor en: $endpoint');
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tutor.toJson()),
      );
      debugPrint('Respuesta crear tutor: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return json['id'];
      }
      return null;
    } catch (e) {
      debugPrint('Error en createTutor: $e');
      return null;
    }
  }

  Future<bool> updateTutor(int tutorId, Tutor tutor) async {
    try {
      final endpoint = '${ApiConfig.baseUrl}/tutors/$tutorId';
      debugPrint('Actualizando tutor en: $endpoint');
      final response = await http.put(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tutor.toJson()),
      );
      debugPrint('Respuesta actualizar tutor: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Error en updateTutor: $e');
      return false;
    }
  }
}