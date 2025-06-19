import 'package:dio/dio.dart';

import 'auth_interceptor.dart';

class ApiService {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.1.2:8080/api/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ))
    ..interceptors.add(AuthInterceptor());

  static Future<Dio> getInstance() async {
    return dio;
  }
}
