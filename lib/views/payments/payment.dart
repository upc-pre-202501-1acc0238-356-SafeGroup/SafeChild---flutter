import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0EA5AA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD0D9DB),
                foregroundColor: Colors.black87,
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () async {
                await paymentSheetInitialization(
                    amount.round().toString(),
                    "USD"
                );
              },
              child: const Text(
                "Make Payment",
                style: TextStyle(color: Colors.white),
              ),
            )

          ],
        ) ,
      ),
    );
  }
//TODO: hacer dinamico el amount
  Map<String,dynamic>? intentPaymentData;

  showPaymentSheet() async
  {
    try{
      await Stripe.instance.presentPaymentSheet().then((value){
        intentPaymentData = null;
      }).onError((errorMsg,sTrace){
        if(kDebugMode){
          print(sTrace);
        }
        print(errorMsg.toString() + sTrace.toString());
      });

      print("Intentando crear showPaymentSheet...");


    }
    on StripeException catch(error){
      if(kDebugMode){
        print(error);
      }
      showDialog(
          context: context,
          builder: (c)=> AlertDialog(
            content: Text("Cancelled"),
          ));
    }
    catch(errorMsg){
      if(kDebugMode){
        print(errorMsg);
      }
      print(errorMsg.toString());
    }
  }


  makeIntentForPayment(amountToBeCharge, currency) async
  {
    try {
      Map<String, dynamic> paymentInfo = {
        'currency': currency,
        'reservation': 1,
      };

      var response = await http.post(
        //   Uri.parse("http://192.168.18.21:8093/api/v1/payments"),
        Uri.parse("${dotenv.env['URL_BACKEND_LOCAL']}"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(paymentInfo),
      );

      if (response.statusCode != 200) {
        throw Exception("Stripe error: ${response.statusCode}, ${response.body}");
      }
      print("response = " + response.body);
      return jsonDecode(response.body);


    } catch(errorMsg){
      if(kDebugMode){
        print(errorMsg);
      }
      print(errorMsg.toString());
    }
  }

  Future<void> paymentStatusActualization(int paymentId) async {
    try {
      // 1. Obtener los datos del Payment desde tu backend
      final paymentResponse = await http.get(
        //    Uri.parse("http://192.168.18.21:8090/api/v1/payments/$paymentId"),
        Uri.parse("${dotenv.env['URL_BACKEND_LOCAL']}/$paymentId"),
      );

      if (paymentResponse.statusCode != 200) {
        throw Exception("Error al obtener el Payment: ${paymentResponse.body}");
      }

      final paymentData = jsonDecode(paymentResponse.body);
      final stripePaymentId = paymentData['stripePaymentId'];

      if (stripePaymentId == null || stripePaymentId.isEmpty) {
        throw Exception("stripePaymentId no encontrado.");
      }

      final stripeIntentResponse = await http.get(
        //Uri.parse("http://192.168.18.21:8090/api/v1/payments/paymentIntent/$stripePaymentId"),
        Uri.parse("${dotenv.env['URL_BACKEND_LOCAL']}/paymentIntent/$stripePaymentId"),
      );

      if (stripeIntentResponse.statusCode != 200) {
        throw Exception("Error al consultar el PaymentIntent: ${stripeIntentResponse.body}");
      }

      final stripeData = jsonDecode(stripeIntentResponse.body);
      final stripeStatus = stripeData['status'].toString().toUpperCase();

      final updateResponse = await http.put(
        // Uri.parse("http://192.168.18.21:8090/api/v1/payments/status/$paymentId"),
        Uri.parse("${dotenv.env['URL_BACKEND_LOCAL']}/status/$paymentId"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "paymentStatus": stripeStatus,
        }),
      );


      if (updateResponse.statusCode == 200) {
        print("✅ Estado actualizado correctamente en el backend.");

        // 👇 Aquí muestra el SnackBar al usuario
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Pago realizado y confirmado exitosamente."),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        print("❌ Error al actualizar el estado en el backend: ${updateResponse.body}");

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("⚠️ No se pudo actualizar el estado del pago: ${updateResponse.body}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }


      if (updateResponse.statusCode == 200) {
        print("✅ Estado actualizado correctamente en el backend.");
      } else {
        print("❌ Error al actualizar el estado en el backend: ${updateResponse.body}");
      }
    } catch (e) {
      print("❌ Error en el flujo de actualización de estado: $e");
    }
  }




  paymentSheetInitialization(amountToBeCharge, currency) async {
    try {
      intentPaymentData = await makeIntentForPayment(amountToBeCharge, currency);

      if (intentPaymentData == null || intentPaymentData!['client_secret'] == null) {
        showDialog(
          context: context,
          builder: (c) => const AlertDialog(
            content: Text("Error al crear el PaymentIntent. Revisa tu clave y conexión."),
          ),
        );
        return;
      }

      final paymentId = intentPaymentData?['payment_id'];
      if (paymentId == null) {
        throw Exception("payment_id no encontrado en la respuesta.");
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          merchantDisplayName: "SafeChild merchant",
          paymentIntentClientSecret: intentPaymentData!['client_secret'],
          style: ThemeMode.system,
        ),
      );

      await showPaymentSheet(); // usa await aquí para esperar finalización
      await Future.delayed(const Duration(seconds: 3)); // pequeña espera por seguridad
      await paymentStatusActualization(paymentId);

    } catch (error, s) {
      if (kDebugMode) print(s);
      print("❌ Error en paymentSheetInitialization: $error");
    }
  }



}
