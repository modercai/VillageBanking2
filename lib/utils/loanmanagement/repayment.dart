import 'package:flutter/material.dart';

class LoanRepaymentPage extends StatefulWidget {
  final Loan loan;

  LoanRepaymentPage({Key? key, required this.loan})
      : super(
            key:
                key); //changede this from @required to just required if any errors please check here.

  @override
  _LoanRepaymentPageState createState() => _LoanRepaymentPageState();
}

class _LoanRepaymentPageState extends State<LoanRepaymentPage> {
  final _formKey = GlobalKey<FormState>();
  late double _repaymentAmount;

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
                    // Submit loan repayment to the server
                    // ...
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
