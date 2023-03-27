// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final payment_amount = double.parse(_paymentAmountController.text.trim());

      final user = FirebaseAuth.instance.currentUser!;
      CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
      String? groupId = currentUser.getCurrentUser.groupId;
      final userId = user.uid;

      try {
        // Add the loan payment document to the loan_payments collection
        await FirebaseFirestore.instance.collection('groups').doc(groupId).collection('loan_payments').doc(userId).set({
          'payment_amount': payment_amount,
          'payment_date': Timestamp.now(),
        });

        // Update the member's loan balance by subtracting the repayment amount from the current loan balance
        /*final memberRef =
            FirebaseFirestore.instance.collection('user_transactions').doc(userId);//members collection
        final memberSnapshot = await memberRef.get();
        final currentBalance = memberSnapshot.data()!['loan_balance'];*/
        await OurDatabase().calculateLoanRepayment(groupId!, userId, payment_amount);

        await FirebaseFirestore.instance.collection('groups').doc(groupId).collection('transactions').doc(userId).update({
          'amount': FieldValue.increment(payment_amount),
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loan payment added successfully')),//add a dialog message and send user to the other page.
        );
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding loan payment: $e')),// do the same here
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Loan Payment')),
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
              onPressed: _submitForm,
              child: Text('Add Loan Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
