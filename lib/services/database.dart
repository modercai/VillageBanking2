// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/models/users.dart';
import 'package:join_create_group_functionality/screens/createGroup/create_group.dart';



class OurDatabase {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<String> createUser(OurUser user) async {
    String retVal = 'error';

    try {
      await firebaseFirestore.collection('users').doc(user.uid).set({
        'fullName': user.fullName,
        'email': user.email,
        'dateCreated': Timestamp.now(),
      });
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser retVal = OurUser();

    try {
      DocumentSnapshot docSnapshot =
          await firebaseFirestore.collection('users').doc(uid).get();
      retVal.uid = uid;
      retVal.fullName = docSnapshot['fullName'];
      retVal.email = docSnapshot['email'];
      retVal.dateCreated = docSnapshot['dateCreated'];
      retVal.groupId = docSnapshot['groupId'];
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> getGroupName() async{
    String retVal = 'error';
    try {
      DocumentSnapshot documentSnapshot = await firebaseFirestore.collection('groups').doc().get();
      documentSnapshot['name'];
    } catch (e) {
      
    }
    return retVal;
  }


  

  Future<String> createGroup(String groupName,String userUid, int interestRate, Timestamp cycleStartDate) async {
    String retVal = 'error';
    List<String> members = [];

    try {
      members.add(userUid);
      DocumentReference documentReference =
          await firebaseFirestore.collection('groups').add({
        'name': groupName,
        'leader': userUid,
        'interestRate':interestRate,
        'members': members,
        'groupCreated': Timestamp.now(),
        'cycleStartDate':cycleStartDate,
      });

      await firebaseFirestore.collection('users').doc(userUid).update({
        'groupId': documentReference.id,
      });

      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  //for sparco payment
  Future<double> getCurrentBalanceFromDatabase(String userId) async {
    // make database query to retrieve user's current balance
    // for this example, we'll just return a hardcoded balance of $10.00
    return 10.0;
  }

  Future<void> updateBalanceInDatabase(String userId, double newBalance) async {
    // make database query to update user's balance
    // for this example, we'll just print the new balance
    print('New balance for $userId: \$$newBalance');
  }

  Future<String> joinGroup(String groupId, String userUid) async {
    String retVal = 'error';
    List<String> members = [];

    try {
      members.add(userUid);
      await firebaseFirestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayUnion(members),
      });

      await firebaseFirestore.collection('users').doc(userUid).update({
        'groupId': groupId,
      });
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }
  
Future<void> calculateLoanRepayment(String groupId, String memberId, double paymentAmount,context) async {
  // Step 1: Retrieve the interest rate and loan amount from the group's collection in Firebase
  final groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);
  final groupData = await groupRef.get();
  final interestRate = groupData.get('interestRate');

  //get the loan amount from the loan applications collections 
  final loanAmountRef = groupRef.collection('loan_applications').doc(memberId);
  final loanAmountData = await loanAmountRef.get();
  final loanAmount = loanAmountData.get('loanAmount');

  // Step 2: Calculate the interest on the loan using the interest rate and loan amount
  final interest = loanAmount * interestRate/100; 

  // Step 3: Calculate the total amount due by adding the interest to the loan amount
  final totalAmountDue = loanAmount + interest;

  // Step 4: Retrieve the user's payment history from the "loan_payments" sub-collection
  final memberRef = groupRef.collection('loan_payments').doc(memberId);
  final paymentHistory = await memberRef.collection('payments').get();

  // Step 5: Calculate the total amount paid by the user so far
  double totalPaidAmount = 0;
  for (final payment in paymentHistory.docs) {
    totalPaidAmount += payment.get('payment_amount');
  }

  // Step 6: Calculate the remaining balance by subtracting the total amount paid from the total amount due
  final remainingBalance = totalAmountDue - totalPaidAmount;

  // Step 7: Check if the remaining balance is greater than zero
 if (remainingBalance <= 0) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text("You cannot make any more payments until the remaining balance is replenished. Apply for another Loan Please"),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
    return;
  }else{
  // Step 7: Update the "user_transactions" sub-collection with the remaining balance
  await memberRef.update({'remaining_balance': remainingBalance,
  'loan_amount':loanAmount});
  }

  // Step 9: Add the new payment to the user's payment history
  await memberRef.collection('payments').add({
    'payment_amount': paymentAmount,
    'timestamp': DateTime.now(),
  });
}


Future<void> updateGroupTotalOnceLoanApproved(DocumentReference groupRef, double loanAmount,String groupId) async {
  try {
    // Get the current total from Firestore
    final totalDoc = await groupRef.collection('groups').doc(groupId).collection('total').doc('total').get();
    double currentTotal = totalDoc.get('total') ?? 0.0; // Handle the null case
    
    // Update the total by subtracting the loan amount
    double total = currentTotal - loanAmount;
    
    // Update the total in Firestore
    await groupRef.collection('total').doc('total').update({'total': total});
  } catch (e) {
    print('Failed to update group total: $e');
  }
}



Future<List<Map<String, dynamic>>> getPaymentHistory(String groupId,) async {
  final groupDoc = FirebaseFirestore.instance.collection('groups').doc(groupId);
  final loanPaymentsQuery = groupDoc.collection('loan_payments');

  final loanPaymentsSnapshot = await loanPaymentsQuery.get();
  final paymentHistory = <Map<String, dynamic>>[];

  for (final loanPaymentDoc in loanPaymentsSnapshot.docs) {
    final paymentsQuery = loanPaymentDoc.reference.collection('payments');
    final paymentsSnapshot = await paymentsQuery.get();

    for (final paymentDoc in paymentsSnapshot.docs) {
      final paymentData = paymentDoc.data();
      paymentData['loanPaymentId'] = loanPaymentDoc.id;
      paymentData['groupId'] = groupId;
      paymentHistory.add(paymentData);
    }
  }

  return paymentHistory;
}


Future<List<Map<String, dynamic>>> getApplicationHistory(String groupId) async {
  final groupDoc = FirebaseFirestore.instance.collection('groups').doc(groupId);
  final loanPaymentsQuery = groupDoc.collection('loan_applications');

  final loanPaymentsSnapshot = await loanPaymentsQuery.get();
  final paymentHistory = <Map<String, dynamic>>[];

    for (final paymentDoc in loanPaymentsSnapshot.docs) {
      final paymentData = paymentDoc.data();
      paymentData['loanPaymentId'] = loanPaymentsQuery.id;
      paymentData['groupId'] = groupId;
      paymentHistory.add(paymentData);
    }
     return paymentHistory;
  }

 
}

