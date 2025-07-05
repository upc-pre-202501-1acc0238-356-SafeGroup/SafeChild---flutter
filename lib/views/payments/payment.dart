import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  double amount = 4.55;
  Map<String, dynamic>? intentPaymentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0EA5AA),
      appBar: AppBar(
        backgroundColor: Color(0xFF0EA5AA),
        elevation: 0,
        title: Text('Pagos', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Monto a pagar: \$${amount.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD0D9DB),
                foregroundColor: Colors.black87,
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () async {
                await makeIntentForPayment(amount.toString(), 'USD');
                if (intentPaymentData != null) {
                  await showPaymentSheet();
                }
              },
              child: Text('Realizar Pago'),
            ),
          ],
        ),
      ),
    );
  }

  showPaymentSheet() async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: intentPaymentData!['clientSecret'],
          style: ThemeMode.dark,
          merchantDisplayName: "SafeChild",
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Pago completado con éxito!'),
          backgroundColor: Colors.green,
        ),
      );
    } on StripeException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.error.localizedMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (errorMsg) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $errorMsg'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  makeIntentForPayment(amountToBeCharge, currency) async {
    try {
      // Aquí obtenemos el token del AuthBloc en lugar de AuthViewModel
      final authState = context.read<AuthBloc>().state;
      String? token;

      if (authState is AuthAuthenticated) {
        token = authState.user.token;
      }

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
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(paymentInfo),
      );

      if (response.statusCode == 200) {
        intentPaymentData = json.decode(response.body);
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar el pago: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }
}