import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/ApiConfig.dart';
import '../beans/User.dart';
import '../beans/Tutor.dart';

class AuthService {
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

  Future<User?> signUp(String username, String password, List<String> roles) async {
    final response = await http.post(
      Uri.parse(ApiConfig.signUp),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password, 'roles': roles}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  // Flujo de registro de tutor
  Future<bool> registerTutor(Tutor tutor) async {
    // 1. Login previo (sign in)
    final user = await signIn(tutor.email, tutor.password);
    if (user == null) return false;

    // 2. Crear tutor
    final tutorRes = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/tutors'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tutor.toJson()),
    );
    if (tutorRes.statusCode != 200 && tutorRes.statusCode != 201) return false;
    final tutorJson = jsonDecode(tutorRes.body);
    final tutorId = tutorJson['id'];

    // 3. Crear perfil
    final profileRes = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/profiles'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({}),
    );
    if (profileRes.statusCode != 200 && profileRes.statusCode != 201) return false;
    final profileId = jsonDecode(profileRes.body)['id'];

    // 4. Asociar perfil al tutor (PUT)
    final updatedTutor = Map<String, dynamic>.from(tutorJson);
    updatedTutor['profileId'] = profileId;
    final updateRes = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/tutors/$tutorId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedTutor),
    );
    return updateRes.statusCode == 200 || updateRes.statusCode == 201;
  }
}