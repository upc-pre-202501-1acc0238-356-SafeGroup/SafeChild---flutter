import 'package:flutter/material.dart';
import '../modelo/beans/Caregiver.dart';
import '../modelo/service/AppointService.dart';

class ServiceViewModel extends ChangeNotifier {
  List<Caregiver> caregivers = [];

  Future<void> fetchCaregivers() async {
    caregivers = await AppointService.getCaregivers();
    notifyListeners();
  }
}