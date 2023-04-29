import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoanRepaymentPage extends StatefulWidget {
  final Loan loan;
  final String groupId;

  LoanRepaymentPage({
    Key? key,
    required this.loan,
    required this.groupId,
  }) : super(key: key);

  @override
  _LoanRepaymentPageState createState() => _LoanRepaymentPageState();
}

class _LoanRepaymentPageState extends State<LoanRepaymentPage> {
  final _formKey = GlobalKey<FormState>();
  late double _repaymentAmount;
  late double _interestRate;

  @override
  void initState() {
    super.initState();
    // Retrieve interest rate for the group from Firebase
    FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
           _interestRate = documentSnapshot['interestRate'] as double;
          // specify type of 'interestRate' property as double
        });
      } else {
        print('Group does not exist');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Repayment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Repayment Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a repayment amount';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Repayment amount must be greater than 0';
                  }
                  return null;
                },
                onSaved: (value) {
                  _repaymentAmount = double.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              TextButton(
                child: Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Calculate total repayment amount
                    double totalRepaymentAmount =
                        _repaymentAmount * widget.loan.remainingAmount!;
                    // Calculate interest
                    double interest = widget.loan.loanAmount! * _interestRate;
                    // Calculate new remaining amount
                    double newRemainingAmount =
                        widget.loan.remainingAmount! - _repaymentAmount;
                    // Update remaining amount in Firebase
                    FirebaseFirestore.instance
                        .collection('groups')
                        .doc(widget.groupId)
                        .collection('borrowers')
                        .doc(widget.loan.id)
                        .set({'remainingAmount': newRemainingAmount});
                    // Navigate back to loan details page
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Loan {
  final String? id;
  final String? borrowerName;
  final double? loanAmount;
  final String? loanPurpose;
  final double? remainingAmount;

  Loan({
    this.id,
    this.borrowerName,
    this.loanAmount,
    this.loanPurpose,
    this.remainingAmount,
  });
}
