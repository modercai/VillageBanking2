import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class PaymentInitialization extends StatefulWidget {
  PaymentInitialization({Key? key}) : super(key: key);

  @override
  _PaymentInitializationState createState() => _PaymentInitializationState();
}

class _PaymentInitializationState extends State<PaymentInitialization> {
  bool _isIncome = false;
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerEMAIL = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void handlePaymentInitialization() async {
    // retrieve user's current balance from database
    double currentBalance = await getCurrentBalanceFromDatabase('user123');

    // create transaction
    double amount = 1.0;
    String transactionReference = 'd2f7e01f-2ee2-4e1d-bfa5-58c38a93aa56';
    String itemName = 'Item Name';
    String currency = 'USD';
    String firstName = 'Mundia';
    String lastName = 'Mwala';
    String email = 'mundia@getsparco.com';
    String phone = '0961453688';
    String publicKey = '2fbf182c6fc14500b28fdc8c83eab734';

    // check if user has enough balance
    if (currentBalance >= amount) {
      // make payment
      var headers = {'Content-Type': 'application/json'};
      var request = await HttpClient().postUrl(
          Uri.parse('https://checkout.sparco.io/gateway/api/v1/checkout'));
      request.headers.set('Content-Type', 'application/json');
      request.write(json.encode({
        "transactionName": itemName,
        "amount": amount,
        "currency": currency,
        "transactionReference": transactionReference,
        "customerFirstName": firstName,
        "customerLastName": lastName,
        "customerEmail": email,
        "customerPhone": phone,
        "merchantPublicKey": publicKey
      }));
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        // update user's balance in database
        await updateBalanceInDatabase('user123', currentBalance + amount);
        print('Payment successful!');
      } else {
        print('Payment failed: ${response.statusCode} - $responseBody');
      }
    } else {
      print('Insufficient funds');
    }
  }

  Future<double> getCurrentBalanceFromDatabase(String userId) async {
    // make database query to retrieve user's current balance
    // for this example, we'll just return a hardcoded balance of $10.00
    return 10.0;
  }

  Future<void> updateBalanceInDatabase(String userId, double newBalance) async {
    // make database query to update user's balance
    // for this example, we'll just print the new balance
    print('New balance for $userId: \$$newBalance');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
