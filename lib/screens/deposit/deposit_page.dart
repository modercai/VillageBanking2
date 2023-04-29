// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:join_create_group_functionality/utils/depositui.dart';

class CashDeposit extends StatefulWidget {
  CashDeposit({Key? key}) : super(key: key);

  @override
  _CashDepositState createState() => _CashDepositState();
}

class _CashDepositState extends State<CashDeposit> {
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

  void handlePaymentInitialization(
    String _textcontrollerAMOUNT,
    String _textcontrollerEMAIL,
  ) async {
    final Customer customer = Customer(
        name: "Flutterwave Developer",
        phoneNumber: "1234566677777",
        //include phonenumber here!!!!
        email: "$_textcontrollerEMAIL");
    final Flutterwave flutterwave = Flutterwave(
        context: context,
        publicKey: "FLWPUBK_TEST-14693cf2dbbeb37cdabafebf73023bce-X",
        currency: "ZMW",
        redirectUrl:
            "https://developer.flutterwave.com/docs/collecting-payments/standard/",
        txRef: _ref!,
        amount: _textcontrollerAMOUNT,
        customer: customer,
        paymentOptions: "ussd, card",
        customization: Customization(title: "My Payment"),
        isTestMode: true);

    final ChargeResponse response = await flutterwave.charge();
    if (response == null) {
      print('transaction failed!');
    } else {
      print(response.status);
      print(response.success);
    }
  }

  //bring up the dialog box for the transactions
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        handlePaymentInitialization(_textcontrollerAMOUNT.text,
                            _textcontrollerEMAIL.text);
                        Navigator.of(context)
                            .pop(); //here put reload and take to a new page to show the new balance
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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Deposit Cash'),
        backgroundColor: Colors.grey.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Deposit',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Text(
                    ' Money',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Choose Your Payment Method:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.black,
              ),
              Text(
                'Mobile Transfer',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: _newTransaction,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DepositUI(
                        depositIconPath: 'images/mtn-logo.png',
                        depositbottomText: 'MTN'),
                    DepositUI(
                        depositIconPath: 'images/airtel.png',
                        depositbottomText: 'Airtel'),
                    DepositUI(
                        depositIconPath: 'images/zamtel.png',
                        depositbottomText: 'Zamtel'),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Bank Transfer',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    DepositUI(
                        depositIconPath: 'images/paypal.png',
                        depositbottomText: 'Paypal'),
                    SizedBox(
                      height: 20,
                    ),
                    DepositUI(
                        depositIconPath: 'images/debit-card.png',
                        depositbottomText: 'Card Payments'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
