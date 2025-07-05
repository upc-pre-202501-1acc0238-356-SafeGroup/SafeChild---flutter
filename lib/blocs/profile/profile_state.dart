import 'package:equatable/equatable.dart';
import 'package:safechild/models/tutor.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Tutor tutor;

  const ProfileLoaded(this.tutor);

  @override
  List<Object> get props => [tutor];
}

class ProfileUpdateSuccess extends ProfileState {
  final Tutor tutor;

  const ProfileUpdateSuccess(this.tutor);

  @override
  List<Object> get props => [tutor];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}