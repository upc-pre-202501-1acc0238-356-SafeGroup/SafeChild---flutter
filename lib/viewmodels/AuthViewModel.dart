import 'package:flutter/material.dart';
import '../modelo/beans/User.dart';
import '../modelo/beans/Tutor.dart';
import '../modelo/service/AuthService.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? user;
  String? error;

  Future<bool> login(String username, String password) async {
    user = await _authService.signIn(username, password);
    error = user == null ? 'Credenciales incorrectas' : null;
    notifyListeners();
    return user != null;
  }

  Future<bool> register(String username, String password, List<String> roles) async {
    user = await _authService.signUp(username, password, roles);
    error = user == null ? 'Error al registrar' : null;
    notifyListeners();
    return user != null;
  }

  Future<bool> registerTutor(Tutor tutor) async {
    error = null;
    final ok = await _authService.registerTutor(tutor);
    if (!ok) error = 'Error al registrar. Intenta de nuevo.';
    notifyListeners();
    return ok;
  }
}