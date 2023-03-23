// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, use_build_context_synchronously

import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:http/http.dart' as http;
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';

class OurDepositPage extends StatefulWidget {
  const OurDepositPage({Key? key}) : super(key: key);

  @override
  State<OurDepositPage> createState() => _OurDepositPageState();
}

class _OurDepositPageState extends State<OurDepositPage> {
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

  //text controller for grabbing user input
  bool _isIncome = false;
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerEMAIL = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void handlePaymentInitialization(
    String textcontrollerAMOUNT,
    String textcontrollerEMAIL,
  ) async {
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
        paymentOptions: "ussd, card",
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
              content: Text(response.status.toString()),
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
      final user = FirebaseAuth.instance.currentUser!;
       // get an instance of the currentUser from firebase.
       CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    String? groupId = currentUser.getCurrentUser.groupId;// get the state of the user and retrieve the group id from there.
double amount = double.parse(textcontrollerAMOUNT) ;
final userId = user.uid;
String email = textcontrollerEMAIL;
String description = _textcontrollerITEM.text;
bool isIncome = _isIncome;

FirebaseFirestore.instance
  .collection('groups')
  .doc(groupId)
  .collection('transactions')
  .doc(userId)
  .get()
  .then((documentSnapShot) {
    if (documentSnapShot.exists) {
      final currentAmount = documentSnapShot.data()!['amount']; 
      final newAmount = currentAmount + amount;
      FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('transactions')
        .doc(userId)
        .update({'amount': newAmount});
    } else {
      // Create a new document with the user ID and transaction amount
      FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('transactions')
        .doc(userId)
        .set({
          'amount': amount,
          'email': email,
          'item': description,
          'deposit': isIncome,
          'timestamp': Timestamp.now(),
        });
    }
});

      // Navigate to a new page to show the new balance
      Navigator.pushReplacementNamed(context, '/');

      print(response.status.toString());
      // Show an error message
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(''),
              content: Text(response.status.toString()),
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
    }
  }

//bring up the dialog box
  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('N E W  T R A N S A C T I O N'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Deposit'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          Text('Withdraw'),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Email?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter Number';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerEMAIL,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //make sure to get the email of the user here
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Description',
                              ),
                              controller: _textcontrollerITEM,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: Text('Enter', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        handlePaymentInitialization(_textcontrollerAMOUNT.text,
                            _textcontrollerEMAIL.text);
                        // get form field values
                        
                        //here put reload and take to a new page to show the new balance.
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Make Transactions',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/mtn-logo.png'),
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/airtel.png'),
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/zamtel.png'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/paypal.png'),
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/debit-card.png'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 170,
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.deepPurple[100]),
                      child: TextButton(
                          onPressed: _newTransaction,
                          child: Text(
                            'Deposit&WithDraw',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
