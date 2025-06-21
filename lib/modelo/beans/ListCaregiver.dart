import 'package:safechild/modelo/beans/Caregiver.dart';

class ListCaregiver {

  static List<Caregiver>  listCaregivers(List<dynamic> listJson) {
    List<Caregiver> listCaregiver = [];

    if(listJson!= null) {
      for (var item in listJson) {
        final caregiver = Caregiver.fromJson(item);
        listCaregiver.add(caregiver);
      }
    }

    return listCaregiver;
  }
}