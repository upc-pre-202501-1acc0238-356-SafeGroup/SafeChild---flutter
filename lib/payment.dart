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

//TODO: hacer dinamico el amount
  double amount = 4545;
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
        'amount': (int.parse(amountToBeCharge) * 100),
        //TODO: borrar al juntar el backend
        'reservationId': 2,
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

  paymentSheetInitialization(amountToBeCharge,currency) async
  {
    try {
      intentPaymentData = await makeIntentForPayment(amountToBeCharge, currency);

      if (intentPaymentData == null || intentPaymentData!['client_secret'] == null) {
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            content: Text("Error al crear el PaymentIntent. Revisa tu clave y conexión."),
          ),
        );
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          merchantDisplayName: "SafeChild merchant",
          paymentIntentClientSecret: intentPaymentData!['client_secret'].toString(),
          style: ThemeMode.system,
        )
      ).then((v){
        print(v);
      });

      showPaymentSheet();

    } catch(errorMsg,s){
        if(kDebugMode){
          print(s);
        }
      print(errorMsg.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await paymentSheetInitialization(
                    amount.round().toString(),
                    "USD"
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
            )

          ],
        ) ,
      ),
    );
  }
}
