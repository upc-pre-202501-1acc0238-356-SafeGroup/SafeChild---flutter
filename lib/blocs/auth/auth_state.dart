import 'package:equatable/equatable.dart';
import 'package:safechild/models/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final int? tutorId;

  const AuthAuthenticated(this.user, {this.tutorId});

  @override
  List<Object?> get props => [user, tutorId];
}

class AuthUnauthenticated extends AuthState {
  final String? error;

  const AuthUnauthenticated([this.error]);

  @override
  List<Object?> get props => [error];
}

class AuthRegistrationSuccess extends AuthState {}

class AuthTutorUpdated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}