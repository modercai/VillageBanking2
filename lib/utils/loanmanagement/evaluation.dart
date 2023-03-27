import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/home/home.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:join_create_group_functionality/utils/get_loan_details.dart';
import 'package:provider/provider.dart';

class LoanEvaluationPage extends StatefulWidget {
  @override
  _LoanEvaluationPageState createState() => _LoanEvaluationPageState();
}

class _LoanEvaluationPageState extends State<LoanEvaluationPage> {
  List<LoanApplication>? _loanApplications;
  bool isClickable = true;
  bool _isEvaluated = false;


  @override
  void initState() {
    super.initState();
    _loadLoanApplications();
  }

  void _loadLoanApplications() async {
    CurrentUser currentUser = Provider.of<CurrentUser>(context,listen: false);
    String? groupId = currentUser.getCurrentUser.groupId;
    // Get a reference to the loan applications collection in Firebase Firestore
    CollectionReference loanApplicationsRef =
        FirebaseFirestore.instance.collection('groups').doc(groupId).collection('loan_applications');

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

// Evaluate loan based on the criteria that the amount is less or equal to a certain amount(this criteria has to be changed though)
  void _evaluateLoan(LoanApplication loanApplication) async {

    //get an instance of the user from the database

    
    CurrentUser currentUser = Provider.of<CurrentUser>(context,listen: false);
    String? groupId = currentUser.getCurrentUser.groupId;


    // Get a reference to the loan application document in Firebase Firestore
    DocumentReference loanApplicationRef = FirebaseFirestore.instance.
        collection('groups').doc(groupId).collection('loan_applications')
        .doc(loanApplication.id);

    // Convert the loan amount to a number
    double loanAmount = loanApplication.loanAmount!;

    // Update the status of the loan application based on your evaluation criteria
    String status = loanAmount <= 5000 ? 'APPROVED' : 'DECLINED';

    // Update the loan application document in Firebase Firestore with the new status
    await loanApplicationRef.update({'status': status});

    //get an instance of the current user from the database
    final user = FirebaseAuth.instance.currentUser!;
    final userId = user.uid;

    // Disburse the loan amount if it was approved
  if (status == 'APPROVED') {
    // Get a reference to the transaction document in Firebase Firestore
    DocumentReference transactionRef = FirebaseFirestore.instance.collection('groups').doc(groupId)
        .collection('user_transactions')
        .doc('IJwbasJ5NCcizqKf6Jeu');

    // Get the user's current balance
    DocumentSnapshot userSnapshot = await transactionRef.get();
    double currentBalance = userSnapshot['user_balance'].toDouble();

    // Calculate the new balance after disbursement
    double newBalance =  currentBalance + loanAmount;

    // Update the user's balance in Firebase Firestore
    await transactionRef.update({'user_balance': newBalance});
  }

    // Reload the loan applications list to reflect the updated status
    _loadLoanApplications();
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
      appBar: AppBar(
        title: Text('Loan Evaluation'),
      ),
      body: _loanApplications == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return ListView.builder(
                itemCount: _loanApplications?.length,
                itemBuilder: (context, index) {
                  LoanApplication loanApplication = _loanApplications![index];
                  return ListTile(
                    title: GetLoanDetails(
                      documentId: loanApplication.id!,
                    ),
                    subtitle: Text(loanApplication.loanPurpose!),
                    trailing:
                        _buildLoanApplicationStatus(loanApplication.status!),
                    onTap: () {
                      if(!isClickable){   
                        return;
                      }
                      isClickable = false;
                      if(!_isEvaluated){
                        _isEvaluated = true;
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
                      }
                      //evaluate the loan applications
                      _evaluateLoan(loanApplication);
                    },
                  );
                },
              );
            }),
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
