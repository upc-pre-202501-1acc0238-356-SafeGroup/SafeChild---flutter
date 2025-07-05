import 'package:safechild/models/tutor.dart';
import 'package:safechild/services/profile_service.dart';

class ProfileRepository {
  final ProfileService _profileService;

  ProfileRepository({ProfileService? profileService})
      : _profileService = profileService ?? ProfileService();

  Future<Tutor?> fetchTutor(int tutorId) async {
    return await _profileService.fetchTutor(tutorId);
  }

  Future<bool> updateTutor(int tutorId, Tutor tutor) async {
    return await _profileService.updateTutor(tutorId, tutor);
  }
}