import 'package:flutter/material.dart';

class LoanApplicationPage extends StatefulWidget {
  @override
  _LoanApplicationPageState createState() => _LoanApplicationPageState();
}

class _LoanApplicationPageState extends State<LoanApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  late String _borrowerName;
  late double _loanAmount;
  late String _loanPurpose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Application'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Borrower Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the borrower name';
                  }
                  return null;
                },
                onSaved: (value) => _borrowerName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Loan Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the loan amount';
                  }
                  return null;
                },
                onSaved: (value) => _loanAmount = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Loan Purpose'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the loan purpose';
                  }
                  return null;
                },
                onSaved: (value) => _loanPurpose = value!,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Submit the loan application to the server
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
