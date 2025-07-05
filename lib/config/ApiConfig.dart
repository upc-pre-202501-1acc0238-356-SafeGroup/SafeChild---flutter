class ApiConfig {
  // Base URL for the API
  // Si usas web
  // static const String baseUrl = 'http://localhost:8080/api/v1';
  // Si usas emulador de Android
  // static const String baseUrl = 'http://10.0.2.2:8080/api/v1';
  // Para producción
  static const String baseUrl = 'https://safechild-lastdeploy-a8ahd7ccc8b4cjb3.canadacentral-01.azurewebsites.net/api/v1';

  // Authentication endpoints (IAM)
  static const String signUp = '$baseUrl/authentication/sign-up';
  static const String signIn = '$baseUrl/authentication/sign-in';

  // Función para crear URLs de recursos
  static String resource(String path) => '$baseUrl$path';

}