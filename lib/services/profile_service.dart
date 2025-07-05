import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/ApiConfig.dart';
import '../models/tutor.dart';
import '../services/auth_state_provider.dart';
import '../blocs/auth/auth_state.dart';

class ProfileService {
  Future<Tutor?> fetchTutor(int tutorId) async {
    try {
      debugPrint('Intentando obtener tutor con ID: $tutorId');
      final authState = AuthStateProvider().getAuthState();
      String? token;

      if (authState is AuthAuthenticated) {
        token = authState.user.token;
        debugPrint('Token de autenticación obtenido');
      }

      if (token == null) {
        debugPrint('No se encontró token de autenticación');
        return null;
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tutors/$tutorId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      debugPrint('Respuesta obtener tutor: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        return Tutor.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      debugPrint('Error al obtener datos del tutor: $e');
      return null;
    }
  }

  Future<bool> updateTutor(int tutorId, Tutor tutor) async {
    try {
      final authState = AuthStateProvider().getAuthState();
      String? token;

      if (authState is AuthAuthenticated) {
        token = authState.user.token;
      }

      if (token == null) {
        return false;
      }

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/tutors/$tutorId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(tutor.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('Error al actualizar datos del tutor: $e');
      return false;
    }
  }
}