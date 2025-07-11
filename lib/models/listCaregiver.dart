import 'caregiver.dart';

class ListCaregiver {
  static List<Caregiver> listCaregivers(dynamic jsonList) {
    if (jsonList == null) return [];
    if (jsonList is List) {
      return jsonList.map((e) => Caregiver.fromJson(e)).toList();
    }
    return [];
  }
}