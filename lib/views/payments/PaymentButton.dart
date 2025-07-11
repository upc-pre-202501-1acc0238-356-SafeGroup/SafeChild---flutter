import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class Paymentbutton extends StatefulWidget {
  final int reservationId;
  final double amount;
  final String currency;

  const Paymentbutton({
    Key? key,
    required this.reservationId,
    this.amount = 100.0,
    this.currency = 'USD',
  }) : super(key: key);

  @override
  State<Paymentbutton> createState() => _PaymentbuttonState();
}

class _PaymentbuttonState extends State<Paymentbutton> {
  Map<String, dynamic>? intentPaymentData;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD0D9DB),
        foregroundColor: Colors.black87,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: () async {
        await _paymentSheetInitialization(
          widget.amount.round().toString(),
          widget.currency,
          widget.reservationId,
        );
      },
      child: const Text("Pagar", style: TextStyle(color: Colors.white)),
    );
  }

  Future<void> _paymentSheetInitialization(String amount, String currency, int reservationId) async {
    try {
      intentPaymentData = await _makeIntentForPayment(amount, currency, reservationId);

      if (intentPaymentData == null || intentPaymentData!['client_secret'] == null) {
        _showDialog("Error al crear el PaymentIntent. Revisa tu clave y conexión.");
        return;
      }

      final paymentId = intentPaymentData?['payment_id'];
      if (paymentId == null) throw Exception("payment_id no encontrado en la respuesta.");

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          merchantDisplayName: "SafeChild merchant",
          paymentIntentClientSecret: intentPaymentData!['client_secret'],
          style: ThemeMode.system,
        ),
      );

      await _showPaymentSheet();
      await Future.delayed(const Duration(seconds: 2));
      await _paymentStatusActualization(paymentId);
    } catch (e, s) {
      if (kDebugMode) print(s);
      print("❌ Error en paymentSheetInitialization: $e");
    }
  }

  Future<void> _showPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      intentPaymentData = null;
    } on StripeException catch (e) {
      _showDialog("Pago cancelado.");
      if (kDebugMode) print("StripeException: $e");
    } catch (e) {
      _showDialog("Error: $e");
      if (kDebugMode) print("Error en showPaymentSheet: $e");
    }
  }

  Future<Map<String, dynamic>?> _makeIntentForPayment(String amount, String currency, int reservationId) async {
    try {
      final Map<String, dynamic> paymentInfo = {
        'currency': currency,
        'reservation': reservationId,
      };

      final response = await http.post(
        Uri.parse("${dotenv.env['URL_BACKEND_PRODUCTION']}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(paymentInfo),
      );

      if (response.statusCode != 200) {
        throw Exception("Stripe error: ${response.statusCode}, ${response.body}");
      }

      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) print("❌ Error en makeIntentForPayment: $e");
      return null;
    }
  }

  Future<void> _paymentStatusActualization(int paymentId) async {
    try {
      final baseUrl = dotenv.env['URL_BACKEND_LOCAL'];

      final paymentResponse = await http.get(Uri.parse("$baseUrl/$paymentId"));
      if (paymentResponse.statusCode != 200) throw Exception("Error al obtener el Payment");

      final paymentData = jsonDecode(paymentResponse.body);
      final stripePaymentId = paymentData['stripePaymentId'];
      if (stripePaymentId == null || stripePaymentId.isEmpty) throw Exception("stripePaymentId vacío.");

      final stripeIntentResponse = await http.get(Uri.parse("$baseUrl/paymentIntent/$stripePaymentId"));
      if (stripeIntentResponse.statusCode != 200) throw Exception("Error en PaymentIntent");

      final stripeData = jsonDecode(stripeIntentResponse.body);
      final stripeStatus = stripeData['status'].toString().toUpperCase();

      final updateResponse = await http.put(
        Uri.parse("$baseUrl/status/$paymentId"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"paymentStatus": stripeStatus}),
      );

      if (updateResponse.statusCode == 200) {
        _showSnackBar("✅ Pago confirmado exitosamente.", Colors.green);
      } else {
        _showSnackBar("⚠️ No se pudo actualizar el estado: ${updateResponse.body}", Colors.red);
      }
    } catch (e) {
      if (kDebugMode) print("❌ Error al actualizar estado: $e");
      _showSnackBar("❌ Error al actualizar el estado del pago", Colors.red);
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(content: Text(message)),
    );
  }

  void _showSnackBar(String message, Color color) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: color),
      );
    }
  }
}
