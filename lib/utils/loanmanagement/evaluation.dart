// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:join_create_group_functionality/utils/get_loan_details.dart';
import 'package:provider/provider.dart';

class LoanEvaluationPage extends StatefulWidget {
  @override
  _LoanEvaluationPageState createState() => _LoanEvaluationPageState();
}

class _LoanEvaluationPageState extends State<LoanEvaluationPage> {
  List<LoanApplication>? _loanApplications;
  bool _isEvaluated = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLoanApplications();
  }
  
  //push notification for when the loan is approved
  void loanApprovedNotification() async {
    await AwesomeNotifications().createNotification(content: NotificationContent(id: 1, channelKey: 'key1',title: 'Loan Evaluation',body: 'Your Loan has been approved succesfully check your balance to comfirm'),);
  }

  void _loadLoanApplications() async {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    String? groupId = currentUser.getCurrentUser.groupId;
    // Get a reference to the loan applications collection in Firebase Firestore
    CollectionReference loanApplicationsRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('loan_applications');

    // Load the loan applications from Firebase Firestore
    QuerySnapshot querySnapshot = await loanApplicationsRef.get();
    setState(() {
      _loanApplications = querySnapshot.docs
          .map((doc) => LoanApplication(
                id: doc.id,
                borrowerName: doc['borrowerName'],
                loanAmount: (doc['loanAmount']).toDouble(),
                loanPurpose: doc['loanPurpose'],
                status: _getStatusFromString(doc['status']),
              ))
          .toList();
    });
  }

  void _evaluateLoan(LoanApplication loanApplication) async {
    setState(() {
      _isLoading = true; // <-- set isLoading to true
    });

     //get an instance of the user from the database
  CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
  String? groupId = currentUser.getCurrentUser.groupId;
  final user = FirebaseAuth.instance.currentUser;
  final userId = user!.uid;


  // Check if the current user is the leader of the group
  bool isLeader = false;
  DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
      .collection('groups')
      .doc(groupId)
      .get();
  if (groupSnapshot.exists) {
    String leaderId = groupSnapshot.get('leader');
    isLeader = leaderId == currentUser.getCurrentUser.uid;
  }

    // Check if the loan status is "PENDING"
    if (loanApplication.status == LoanApplicationStatus.PENDING && isLeader) {
      //get an instance of the user from the database
      CurrentUser currentUser =
          Provider.of<CurrentUser>(context, listen: false);
      String? groupId = currentUser.getCurrentUser.groupId;


      // Get a reference to the loan application document in Firebase Firestore
      DocumentReference loanApplicationRef = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('loan_applications')
          .doc(loanApplication.id);

      // Convert the loan amount to a number
      double loanAmount = loanApplication.loanAmount!;

      // Get a reference to the transaction document in Firebase Firestore
      DocumentReference totalTransactionRef = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('total')
          .doc('total');

      // Get the user's current balance
      DocumentSnapshot userSnapshot = await totalTransactionRef.get();
      double currentTotalBalance = userSnapshot['total']?.toDouble() ?? 0;

      // Check if the current balance is greater than or equal to the loan amount
      if (currentTotalBalance >= loanAmount) {
        // Update the status of the loan application based on your evaluation criteria
        String status = loanAmount <= 5000 ? 'APPROVED' : 'DECLINED';

        // Update the loan application document in Firebase Firestore with the new status
        await loanApplicationRef.update({'status': status});

        // Disburse the loan amount if it was approved

        if (status == 'APPROVED') {

          setState(() {
      _isLoading = false; // <-- set isLoading to true
    });
          // Subtract the loan amount from the current balance to get the new balance
          double newTotalBalance = currentTotalBalance - loanAmount;

          // Update the transaction document in Firebase Firestore with the new balance
          await totalTransactionRef.update({'total': newTotalBalance});
          // Get a reference to the transaction document in Firebase Firestore
          DocumentReference transactionRef = FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection('user_transactions')
              .doc(loanApplication.id);

          // Get the user's current balance
          DocumentSnapshot userSnapshot = await transactionRef.get();
          if (userSnapshot.exists) {
            double currentBalance = userSnapshot['user_balance'].toDouble();

            // Calculate the new balance after disbursement
            double newBalance = currentBalance + loanAmount;

            // Update the user's balance in Firebase Firestore
            await transactionRef.update({'user_balance': newBalance});
          } else {
            double currentBalance = 0.0;
            await transactionRef.set({'user_balance': currentBalance});
          }
          //set the loan Amount in loan_payments collection
//set the loan Amount in loan_payments collection
          DocumentReference loanPaymentRef = FirebaseFirestore.instance.collection('groups').doc(groupId)
              .collection('loan_payments')
              .doc(loanApplication.id);
          await loanPaymentRef.set({'loan_amount': loanAmount});


 //initilize new loan payment when the status of the loan is approved

          
 // Step 1: Retrieve the interest rate and loan amount from the group's collection in Firebase
  final groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);
  final groupData = await groupRef.get();
  final interestRate = groupData.get('interestRate');

  //get the loan amount from the loan applications collections 
  final loanAmountRef = groupRef.collection('loan_applications').doc(loanApplication.id);
  final loanAmountData = await loanAmountRef.get();
  final evaLoanAmount = loanAmountData.get('loanAmount');

  // Step 2: Calculate the interest on the loan using the interest rate and loan amount
  final interest = evaLoanAmount * interestRate/100; 

  // Step 3: Calculate the total amount due by adding the interest to the loan amount
  final totalAmountDue = loanAmount + interest;

  // Step 4: Retrieve the user's payment history from the "loan_payments" sub-collection
  final memberRef = groupRef.collection('loan_payments').doc(loanApplication.id);
 
  // Step 7: Update the "user_transactions" sub-collection with the remaining balance
  await memberRef.set({'remaining_balance': totalAmountDue,
  'loan_amount':loanAmount});
  
          // Reload the loan applications list to reflect the updated status
          _loadLoanApplications();
          setState(() {
            _isLoading = false; // <-- set isLoading to false
          });
    loanApprovedNotification();
        }
      } else {
        // Show an error message to the user
        showDialog(
            context: context,
            builder: (BuildContext) {
              return AlertDialog(
                title: Text('Insufficient Group Balance'),
                content: Text(
                    'Sorry, you do not have enough funds in your Group account to approve this loan.'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'))
                ],
              );
            });
            setState(() {
            _isLoading = false; // <-- set isLoading to false
          });
      }
    } else if(!isLeader){
      showDialog(
          context: context,
          builder: (BuildContext) {
            return AlertDialog(
              title: Text('Loan Evaluation'),
              content: Text(
                  'Only Group Admin Can Evaluate Loans'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'))
                    
              ],
            );
          });
    }
     else {
      showDialog(
          context: context,
          builder: (BuildContext) {
            return AlertDialog(
              title: Text('Loan Evaluation'),
              content: Text(
                  'Loan is Either Approved or Declined check status and tell user to apply again'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'))
              ],
            );
          });
    }
  }

  LoanApplicationStatus _getStatusFromString(String statusString) {
    if (statusString == 'PENDING') {
      return LoanApplicationStatus.PENDING;
    } else if (statusString == 'APPROVED') {
      return LoanApplicationStatus.APPROVED;
    } else if (statusString == 'DECLINED') {
      return LoanApplicationStatus.DECLINED;
    }
    throw Exception('Unknown status: $statusString');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text('Loan Evaluation'),
      ),
      body: Stack(
        children: [
          _loanApplications == null
              ? Center(child: CircularProgressIndicator())
              : FutureBuilder(builder:
                  (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return ListView.builder(
                    itemCount: _loanApplications?.length,
                    itemBuilder: (context, index) {
                      LoanApplication loanApplication =
                          _loanApplications![index];
                      return ListTile(
                          title: GetLoanDetails(
                            documentId: loanApplication.id!,
                          ),
                          subtitle: Text(loanApplication.loanPurpose!),
                          trailing: _buildLoanApplicationStatus(
                              loanApplication.status!),
                          onTap: () {
                            _evaluateLoan(loanApplication);
                          }

                          //evaluate the loan applications

                          );
                    },
                  );
                }),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget? _buildLoanApplicationStatus(LoanApplicationStatus status) {
    switch (status) {
      case LoanApplicationStatus.PENDING:
        return Text('Pending');
      case LoanApplicationStatus.APPROVED:
        return Text('Approved');
      case LoanApplicationStatus.DECLINED:
        return Text('Declined');
    }
    return null;
  }
}

enum LoanApplicationStatus { PENDING, APPROVED, DECLINED }

class LoanApplication {
  final String? id;
  final String? borrowerName;
  final double? loanAmount;
  final String? loanPurpose;
  final LoanApplicationStatus? status;

  LoanApplication({
    this.id,
    this.borrowerName,
    this.loanAmount,
    this.loanPurpose,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'borrowerName': borrowerName,
      'loanAmount': loanAmount,
      'loanPurpose': loanPurpose,
      'status': status,
    };
  }
}
