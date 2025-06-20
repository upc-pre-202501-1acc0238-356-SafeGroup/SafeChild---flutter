import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/ApiConfig.dart';
import '../beans/User.dart';
import '../beans/Tutor.dart';

class AuthService {
  Future<User?> signUp(String username, String password) async {
    final response = await http.post(
      Uri.parse(ApiConfig.signUp),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password, 'roles': ['TUTOR']}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<User?> signIn(String username, String password) async {
    final response = await http.post(
      Uri.parse(ApiConfig.signIn),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<int?> createTutor(Tutor tutor) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/tutors'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tutor.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return json['id'];
    }
    return null;
  }

  Future<bool> updateTutor(int tutorId, Tutor tutor) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/tutors/$tutorId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tutor.toJson()),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}