import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Token en duro
    const token = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmcmNnMjQyNCIsImlhdCI6MTc1MDMwMzU0MCwiZXhwIjoxNzUwOTA4MzQwfQ.TLv4GuzO2PM66GHRNSxjTEKisjDHmQ7T-UJB1eOrznI';

    options.headers['Authorization'] = token;

    // Continua con la solicitud
    return handler.next(options);
  }
}