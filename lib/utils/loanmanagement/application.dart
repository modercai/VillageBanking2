// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/home/home.dart';
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

   Future<double> getRemainingBalance() async {
    final user = FirebaseAuth.instance.currentUser!;
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    String? groupId = currentUser.getCurrentUser.groupId;
    final userId = user.uid;

    final docSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('loan_payments')
        .doc(userId)
        .get();

    if (docSnapshot.exists) {
      return docSnapshot.data()!['remaining_balance'] ?? 0.0;
    }

    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text('Apply for Loan'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    // Retrieve remaining balance
                    final remainingBalance = await getRemainingBalance();

                    // Check if remaining balance is less than zero
                    if (remainingBalance > 0) {
                      showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('Message'),
      content: Text('Cannot apply for a loan. Finish paying the current loan.'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  },
);

                      return;
                    }

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

                  }
                },
                child: Text('Submit'),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
