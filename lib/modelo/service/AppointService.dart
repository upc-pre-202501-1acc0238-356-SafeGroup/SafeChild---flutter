import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:safechild/modelo/beans/Caregiver.dart';
import 'package:safechild/modelo/beans/ListCaregiver.dart';

import '../../config/ApiConfig.dart';

class AppointService{

  static Future<List<Caregiver>> getCaregivers() async{

    final response = await http.get(
      Uri.parse(ApiConfig.getCaregivers),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body);
      final AllCaregivers = ListCaregiver.listCaregivers(jsonList['content']);
      return AllCaregivers;
    } else {
      throw Exception('Failed to load caregivers');
    }



  }

}