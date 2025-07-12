import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Base URL for the API
  // Si usas web
  // static const String baseUrl = 'http://localhost:8080/api/v1';
  // Si usas emulador de Android
  // static const String baseUrl = 'http://10.0.2.2:8080/api/v1';
  // Para producción
  static const String baseUrl = 'http://192.168.18.21:8093/api/v1';

  // Authentication endpoints (IAM)
  static const String signUp = '$baseUrl/authentication/sign-up';
  static const String signIn = '$baseUrl/authentication/sign-in';
  static const String reservationsAPIUrl = '$baseUrl/reservations';

  // Función para crear URLs de recursos
  static String resource(String path) => '$baseUrl$path';


  static final envBaseUrl  = '${dotenv.env['URL_BACKEND_PRODUCTION']}/api/v1';
  //static final envBaseUrl  = 'http://192.168.18.21:8093/api/v1';



  //static final String reservationsAPIUrl = '$envBaseUrl + /reservations';

  // Caregiver endpoints
  static const String getCaregivers = '$baseUrl/caregiver';

  // Caregiver schedule endpoints
  static const String getSchedule = '$baseUrl/schedules/caregiver';

  // Reservation endpoints
  static const String reservation = '$baseUrl/reservations';


}