import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safechild/blocs/auth/auth_event.dart';
import 'package:safechild/blocs/auth/auth_state.dart';
import 'package:safechild/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthUpdateTutorRequested>(_onAuthUpdateTutorRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthLoginRequested(
      AuthLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signIn(event.username, event.password);
      if (user != null && user.token != null) {
        // Obtener el tutorId usando el ID del usuario
        final tutorId = await _getTutorIdFromUserId(user.id);
        emit(AuthAuthenticated(user, tutorId: tutorId));
      } else {
        emit(const AuthUnauthenticated('Credenciales incorrectas o token no válido'));
      }
    } catch (e) {
      emit(AuthError('Error al iniciar sesión: ${e.toString()}'));
    }
  }

  Future<int?> _getTutorIdFromUserId(int userId) async {
    // Asumimos que el ID del tutor es el mismo que el ID del usuario
    return userId;
  }



  Future<void> _onAuthRegisterRequested(
      AuthRegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signUp(event.username, event.password);
      if (user != null) {
        final tutorId = await authRepository.createTutor(event.tutor);
        if (tutorId != null) {
          emit(AuthAuthenticated(user, tutorId: tutorId));
        } else {
          emit(const AuthError('Error al crear tutor'));
        }
      } else {
        emit(const AuthError('Error al registrar usuario'));
      }
    } catch (e) {
      emit(AuthError('Error en el registro: ${e.toString()}'));
    }
  }

  Future<void> _onAuthUpdateTutorRequested(
      AuthUpdateTutorRequested event,
      Emitter<AuthState> emit,
      ) async {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      final tutorId = currentState.tutorId;

      if (tutorId == null) {
        emit(const AuthError('No se encontró el ID del tutor'));
        return;
      }

      try {
        final success = await authRepository.updateTutor(tutorId, event.tutor);
        if (success) {
          emit(AuthTutorUpdated());
          emit(currentState); // Restaura el estado autenticado
        } else {
          emit(const AuthError('Error al actualizar datos'));
          emit(currentState); // Restaura el estado autenticado
        }
      } catch (e) {
        emit(AuthError('Error: ${e.toString()}'));
        emit(currentState); // Restaura el estado autenticado
      }
    }
  }

  void _onAuthLogoutRequested(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) {
    emit(AuthUnauthenticated());
  }
}