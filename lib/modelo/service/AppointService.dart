import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:safechild/modelo/beans/Caregiver.dart';
import 'package:safechild/modelo/beans/ListCaregiver.dart';

import '../../config/ApiConfig.dart';

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

}