import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';



class Withdraw extends StatefulWidget {
  Withdraw({Key? key}) : super(key: key);

  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {

 final _formKey = GlobalKey<FormState>();
  final _paymentAmountController = TextEditingController();
  String? _ref;

  void setRef() {
    Random random = Random();
    int numbers = random.nextInt(2000);
    if (Platform.isAndroid) {
      setState(() {
        _ref = "VillageBankingAndroid123$numbers";
      });
    } else {
      setState(() {
        _ref = "VillageBankingIOS123$numbers";
      });
    }
  }

  @override
  void initState() {
    setRef();
    super.initState();
  }


  void _submitForm(String textcontrollerAMOUNT, String textcontrollerEMAIL) async {
  if (_formKey.currentState!.validate()) {
    final withdraw_amount = double.parse(_paymentAmountController.text.trim()) * -1;

    final user = FirebaseAuth.instance.currentUser!;
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    String? groupId = currentUser.getCurrentUser.groupId;
    final userId = user.uid;

    try {
      // Initialize payment
      final Customer customer = Customer(
          name: "Flutterwave Developer",
          phoneNumber: "",
          //include phonenumber here!!!!
          email: textcontrollerEMAIL);
      final Flutterwave flutterwave = Flutterwave(
          context: context,
          publicKey: "FLWPUBK_TEST-14693cf2dbbeb37cdabafebf73023bce-X",
          currency: "ZMW",
          redirectUrl:
              "https://developer.flutterwave.com/docs/collecting-payments/standard/",
          txRef: _ref!,
          amount: textcontrollerAMOUNT,
          customer: customer,
          paymentOptions: "card",
          customization: Customization(title: "My Payment"),
          isTestMode: true);

      final ChargeResponse response = await flutterwave.charge();
      if (response.status == 'transaction cancelled') {
        print(response.status.toString());
        // Show an error message
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Message'),
                content: Text('transaction ${response.status}'),
                actions: <Widget>[
                  MaterialButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else {
        // Add the loan payment document to the loan_payments collection

        await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .collection('withdraw')
            .doc(userId)
            .set({
          'withdraw_amount': withdraw_amount,
          'payment_date': Timestamp.now(),
        });
       
        // Show a success message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Withdraw successfull'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error adding Loan Payment: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}


  
  @override
  Widget build(BuildContext context) {

   return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Add Loan Payment'),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _paymentAmountController,
              decoration: InputDecoration(labelText: 'Payment Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a withdraw amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid payment amount';
                }
                return null;
              },
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _submitForm(
                    _paymentAmountController.text, "malatefriday12@gmail.com");
              },
              child: Text('Add Loan Payment'),
            ),
          ],
        ),
      ),
    );
  }}