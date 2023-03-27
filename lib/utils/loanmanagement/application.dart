import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';

import '../../models/loanapplication.dart';

class LoanApplicationPage extends StatefulWidget {
  @override
  _LoanApplicationScreenState createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _borrowerNameController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _loanPurposeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for Loan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _borrowerNameController,
                decoration: InputDecoration(labelText: 'Borrower Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the borrower name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _loanAmountController,
                decoration: InputDecoration(labelText: 'Loan Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the loan amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _loanPurposeController,
                decoration: InputDecoration(labelText: 'Loan Purpose'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the loan purpose';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Create a new loan application object from the form data
                    final loanApplication = LoanApplication(
                      borrowerName: _borrowerNameController.text,
                      loanAmount: double.parse(_loanAmountController.text),
                      loanPurpose: _loanPurposeController.text,
                      status: 'PENDING',
                    );

                    final user = FirebaseAuth.instance.currentUser!;
                    CurrentUser currentUser = Provider.of<CurrentUser>(context,listen: false);
                    String? groupId = currentUser.getCurrentUser.groupId;
                    final userId = user.uid;

                    // Save the loan application to Firestore
                    FirebaseFirestore.instance.collection('groups').doc(groupId)
                        .collection('loan_applications').doc(userId)
                        .set(loanApplication.toMap());

                    // Clear the form fields
                    _borrowerNameController.clear();
                    _loanAmountController.clear();
                    _loanPurposeController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Loan application submitted'),
                      ),
                    );
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
