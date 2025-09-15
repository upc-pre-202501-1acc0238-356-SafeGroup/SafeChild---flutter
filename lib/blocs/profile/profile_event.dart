import 'package:equatable/equatable.dart';
import 'package:safechild/models/tutor.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileFetched extends ProfileEvent {
  final int tutorId;

  const ProfileFetched(this.tutorId);

  @override
  List<Object> get props => [tutorId];
}

class ProfileUpdateRequested extends ProfileEvent {
  final int tutorId;
  final Tutor tutor;

  const ProfileUpdateRequested(this.tutorId, this.tutor);

  @override
  List<Object> get props => [tutorId, tutor];
}