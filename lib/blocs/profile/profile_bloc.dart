import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safechild/blocs/profile/profile_event.dart';
import 'package:safechild/blocs/profile/profile_state.dart';
import 'package:safechild/repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<ProfileFetched>(_onProfileFetched);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
  }

  Future<void> _onProfileFetched(
      ProfileFetched event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final tutor = await profileRepository.fetchTutor(event.tutorId);
      if (tutor != null) {
        emit(ProfileLoaded(tutor));
      } else {
        emit(const ProfileError('No se pudo cargar el perfil'));
      }
    } catch (e) {
      emit(ProfileError('Error al cargar el perfil: ${e.toString()}'));
    }
  }

  Future<void> _onProfileUpdateRequested(
      ProfileUpdateRequested event,
      Emitter<ProfileState> emit,
      ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      try {
        final success = await profileRepository.updateTutor(event.tutorId, event.tutor);
        if (success) {
          emit(ProfileUpdateSuccess(event.tutor));
          emit(ProfileLoaded(event.tutor));
        } else {
          emit(const ProfileError('Error al actualizar datos'));
          emit(currentState);
        }
      } catch (e) {
        emit(ProfileError('Error: ${e.toString()}'));
        emit(currentState);
      }
    }
  }
}