import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/ApiConfig.dart';
import '../models/caregiver.dart';
import '../models/listCaregiver.dart';
import '../models/schedule.dart';

class AppointService{

  static Future<List<Caregiver>> getCaregivers() async {
    print('Llamando a getCaregivers');
    final response = await http.get(
      Uri.parse(ApiConfig.getCaregivers),
      headers: {'Content-Type': 'application/json'},
    );
    print('Respuesta recibida: ${response.statusCode}');
    if (response.statusCode == 200) {
      try {
        final jsonList = json.decode(response.body);
        print('JSON recibido: $jsonList');
        final caregivers = ListCaregiver.listCaregivers(jsonList);
        print('Caregivers parseados: $caregivers');
        return caregivers ?? [];
      } catch (e, stack) {
        print('Error al parsear JSON: $e');
        print(stack);
        return [];
      }
    } else {
      return [];
    }
  }

  Future<List<Schedule>> getSchedulesByCaregiverId(int caregiverId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.getSchedule}/$caregiverId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body);
      return (jsonList as List)
          .map((e) => Schedule.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }

}