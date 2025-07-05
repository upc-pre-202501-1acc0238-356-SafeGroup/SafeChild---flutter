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
        debugPrint('Token de autenticación obtenido: ${token?.substring(0, 10)}...');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/tutors/$tutorId');
      debugPrint('Enviando petición a: $url');

      // Simplificar los headers para peticiones GET
      final headers = <String, String>{};

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(url, headers: headers);

      debugPrint('Respuesta obtener tutor: ${response.statusCode}');
      debugPrint('Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Tutor.fromJson(jsonData);
      } else {
        debugPrint('Error en la respuesta del servidor: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error en fetchTutor: $e');
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

      final url = Uri.parse('${ApiConfig.baseUrl}/tutors/$tutorId');

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(tutor.toJson()),
      );

      debugPrint('Respuesta actualizar tutor: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('Error en updateTutor: $e');
      return false;
    }
  }

  Future<List<String>> fetchDistricts() async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/districts');

      final response = await http.get(url, headers: {
        'Accept': '*/*',
      });

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return List<String>.from(jsonData);
      } else {
        debugPrint('Error obteniendo distritos: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error en fetchDistricts: $e');
      return [];
    }
  }
}