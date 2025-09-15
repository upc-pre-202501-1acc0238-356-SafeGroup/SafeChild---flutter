import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safechild/config/ApiConfig.dart';
import '../models/ReservationDataModel.dart';

class ReservationRepository {
  static Future<List<ReservationDataModel>> fetchReservation(String token, int tutorId) async {
    var client = http.Client();
    List<ReservationDataModel> reservations = [];

    // Construir la URL correctamente
    final url = '${ApiConfig.reservationsAPIUrl}/tutor/$tutorId';

    print("Fetching reservations from URL: $url"); // Debug
    print("Using token: ${token.substring(0, 20)}..."); // Debug (solo parte del token)

    try {
      var response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Response status code: ${response.statusCode}"); // Debug
      print("Response headers: ${response.headers}"); // Debug

      if (response.statusCode == 200) {
        print("Response body: ${response.body}"); // Debug

        // Verificar si la respuesta está vacía
        if (response.body.isEmpty) {
          print("Empty response body");
          return [];
        }

        dynamic result = jsonDecode(response.body);

        // Manejar diferentes tipos de respuesta
        if (result is List) {
          for (var item in result) {
            try {
              ReservationDataModel reservation =
              ReservationDataModel.objJson(item as Map<String, dynamic>);
              reservations.add(reservation);
            } catch (e) {
              print('Error parsing reservation item: $e');
              print('Problematic item: $item');
            }
          }
        } else if (result is Map && result.containsKey('data')) {
          // Si la respuesta viene en un wrapper con 'data'
          List data = result['data'] as List;
          for (var item in data) {
            try {
              ReservationDataModel reservation =
              ReservationDataModel.objJson(item as Map<String, dynamic>);
              reservations.add(reservation);
            } catch (e) {
              print('Error parsing reservation item: $e');
              print('Problematic item: $item');
            }
          }
        } else {
          print('Unexpected response format: ${result.runtimeType}');
          print('Response content: $result');
        }

        print("Successfully parsed ${reservations.length} reservations"); // Debug
        return reservations;

      } else if (response.statusCode == 404) {
        print('No reservations found for tutorId: $tutorId');
        return [];
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch reservations: ${response.statusCode} - ${response.body}');
      }

    } catch (e) {
      print('Error fetching reservations: $e');
      // Re-lanzar la excepción para que el Bloc pueda manejarla
      rethrow;
    } finally {
      client.close();
    }
  }
}