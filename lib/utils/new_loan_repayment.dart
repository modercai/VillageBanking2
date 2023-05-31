// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:join_create_group_functionality/services/database.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';

class LoanPaymentForm extends StatefulWidget {
  @override
  _LoanPaymentFormState createState() => _LoanPaymentFormState();
}

class _LoanPaymentFormState extends State<LoanPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _paymentAmountController = TextEditingController();
  String? _ref;
  bool _isLoading = false;


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

    @override
  void dispose() {
    _paymentAmountController.dispose();
    // Cancel any active work here
    super.dispose();
  }


  void _submitForm(
      String textcontrollerAMOUNT, String textcontrollerEMAIL) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final payment_amount = double.parse(_paymentAmountController.text.trim());

      final user = FirebaseAuth.instance.currentUser!;
      CurrentUser currentUser =
          Provider.of<CurrentUser>(context, listen: false);
      String? groupId = currentUser.getCurrentUser.groupId;
      final userId = user.uid;

      try {
        // Initialize payment
        final Customer customer = Customer(
            name: "Flutterwave Developer",
            phoneNumber: "0962604525",
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
        if (response.status == 'cancelled') {
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
              setState(() {
                _isLoading = false;
              });
        } else {
          //calculate loan repayments and update the database

          await OurDatabase().calculateLoanRepayment(
              groupId!, userId, payment_amount, context);
              
          await FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection('total')
              .doc('total')
              .update({
            'total': FieldValue.increment(payment_amount),
          });

          // Show a success message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Loan payment added successfully'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _isLoading = false;
                      });
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
              title: Text('Error adding Loan Payment: ''please check connectivity or report problem'),
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
        body: Stack(
          children: [
            Form(
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
                        return 'Please enter a payment amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid payment amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading
                    ? null
                    :() async {
                      _submitForm(_paymentAmountController.text,
                          "testmode@email.com");
                    },
                    child: Text('Add Loan Payment'),
                  ),
                ],
              ),
            ),
            Visibility(
          visible: _isLoading,
          child: Center(
            child: CircularProgressIndicator(),
        ))],
        ));
  }
}
