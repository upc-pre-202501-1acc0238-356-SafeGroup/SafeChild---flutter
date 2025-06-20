import 'package:flutter/material.dart';
import '../modelo/beans/User.dart';
import '../modelo/beans/Tutor.dart';
import '../modelo/service/AuthService.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? user;
  int? tutorId;
  String? error;

  Future<bool> register(String username, String password, Tutor tutor) async {
    error = null;
    user = await _authService.signUp(username, password);
    if (user == null) {
      error = 'Error al registrar usuario';
      notifyListeners();
      return false;
    }
    tutorId = await _authService.createTutor(tutor);
    if (tutorId == null) {
      error = 'Error al crear tutor';
      notifyListeners();
      return false;
    }
    notifyListeners();
    return true;
  }

  Future<bool> login(String username, String password) async {
    user = await _authService.signIn(username, password);
    error = user == null ? 'Credenciales incorrectas' : null;
    notifyListeners();
    return user != null;
  }

  Future<bool> updateTutor(Tutor tutor) async {
    if (tutorId == null) {
      error = 'No se encontró el ID del tutor';
      notifyListeners();
      return false;
    }
    final ok = await _authService.updateTutor(tutorId!, tutor);
    if (!ok) error = 'Error al actualizar datos';
    notifyListeners();
    return ok;
  }
}