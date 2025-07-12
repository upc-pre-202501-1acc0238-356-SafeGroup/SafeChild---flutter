import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Base URL for the API

  //static const String baseUrl = 'https://safechild-lastdeploy-a8ahd7ccc8b4cjb3.canadacentral-01.azurewebsites.net/api/v1';
  static const String baseUrl = 'http://192.168.18.21:8093/api/v1';

  // Authentication endpoints (IAM)
  static const String signUp = '$baseUrl/authentication/sign-up';
  static const String signIn = '$baseUrl/authentication/sign-in';
  static const String reservationsAPIUrl = '$baseUrl/reservations';

  // Función para crear URLs de recursos
  static String resource(String path) => '$baseUrl$path';

  // Caregiver endpoints
  static const String getCaregivers = '$baseUrl/caregiver';

  // Caregiver schedule endpoints
  static const String getSchedule = '$baseUrl/schedules/caregiver';

  // Reservation endpoints
  static const String reservation = '$baseUrl/reservations';


}