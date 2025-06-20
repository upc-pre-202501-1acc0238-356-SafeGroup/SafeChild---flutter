import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../viewmodels/AuthViewModel.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  // Monto mínimo: 0.50 USD (50 centavos)
  double amount = 4.55; // Cambia este valor para probar
  Map<String, dynamic>? intentPaymentData;

  showPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pago realizado con éxito')),
      );
      setState(() {
        intentPaymentData = null;
      });
    } on StripeException catch (error) {
      if (kDebugMode) {
        print('StripeException: $error');
      }
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text('El pago fue cancelado'),
        ),
      );
    } catch (errorMsg) {
      if (kDebugMode) {
        print(errorMsg.toString());
      }
    }
  }

  makeIntentForPayment(amountToBeCharge, currency) async {
    try {
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      final token = authVM.user?.token;
      if (token == null) {
        throw Exception('No autenticado');
      }

      int amountCents = (double.parse(amountToBeCharge) * 100).round();
      if (amountCents < 50) {
        throw Exception('El monto mínimo es 0.50 USD');
      }

      Map<String, dynamic> paymentInfo = {
        'currency': currency,
        'amount': amountCents,
        'reservationId': 2, // Cambia esto según tu lógica
      };

      var response = await http.post(
        Uri.parse(dotenv.env['URL_BACKEND_LOCAL']!),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(paymentInfo),
      );

      if (response.statusCode != 200) {
        throw Exception("Stripe error: ${response.statusCode}, ${response.body}");
      }
      return jsonDecode(response.body);
    } catch (errorMsg) {
      if (kDebugMode) {
        print(errorMsg.toString());
      }
      rethrow;
    }
  }

  paymentSheetInitialization(amountToBeCharge, currency) async {
    try {
      intentPaymentData = await makeIntentForPayment(amountToBeCharge, currency);

      if (intentPaymentData == null || intentPaymentData!['client_secret'] == null) {
        throw Exception('No se pudo obtener el client_secret');
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: intentPaymentData!['client_secret'],
          merchantDisplayName: 'SafeChild',
        ),
      );

      showPaymentSheet();
    } catch (errorMsg, s) {
      if (kDebugMode) {
        print(errorMsg);
        print(s);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pago'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xFF0EA5AA),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await paymentSheetInitialization(
                  amount.toStringAsFixed(2),
                  "USD",
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Make Payment",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
              label: Text('Volver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0EA5AA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}