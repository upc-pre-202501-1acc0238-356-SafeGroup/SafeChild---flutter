import 'package:dio/dio.dart';

class ApiService {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8080/api/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  static Future<Dio> getInstance() async {
    return dio;
  }
}
