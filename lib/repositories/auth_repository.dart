import 'package:safechild/models/tutor.dart';
import 'package:safechild/models/user.dart';
import 'package:safechild/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<User?> signIn(String username, String password) async {
    return await _authService.signIn(username, password);
  }

  Future<User?> signUp(String username, String password) async {
    return await _authService.signUp(username, password);
  }

  Future<int?> createTutor(Tutor tutor) async {
    return await _authService.createTutor(tutor);
  }

  Future<bool> updateTutor(int tutorId, Tutor tutor) async {
    return await _authService.updateTutor(tutorId, tutor);
  }
}