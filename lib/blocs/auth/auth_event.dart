import 'package:equatable/equatable.dart';
import 'package:safechild/models/tutor.dart';
import 'package:safechild/models/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;

  const AuthLoginRequested(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String username;
  final String password;
  final Tutor tutor;

  const AuthRegisterRequested(this.username, this.password, this.tutor);

  @override
  List<Object> get props => [username, password, tutor];
}

class AuthUpdateTutorRequested extends AuthEvent {
  final Tutor tutor;

  const AuthUpdateTutorRequested(this.tutor);

  @override
  List<Object> get props => [tutor];
}

class AuthLogoutRequested extends AuthEvent {}