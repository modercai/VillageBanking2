// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:join_create_group_functionality/models/users.dart';


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

  /*Future<String> applyForLoan(Loan loan) async {
    String retVal = 'error';

    try {
      await firebaseFirestore.collection('users').doc()
    } catch (e) {}
  }*/

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


  

  Future<String> createGroup(String groupName,String userUid) async {
    String retVal = 'error';
    List<String> members = [];

    try {
      members.add(userUid);
      DocumentReference documentReference =
          await firebaseFirestore.collection('groups').add({
        'name': groupName,
        'leader': userUid,
        'members': members,
        'groupCreated': Timestamp.now(),
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
  //

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

Future<void> calculateLoanRepayment(String groupId, String memberId, double paymentAmount) async {
  // Step 1: Retrieve the interest rate and loan amount from the group's collection in Firebase
  final groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);
  final groupData = await groupRef.get();
  final interestRate = groupData.get('interest_rate');

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

  // Step 7: Update the "user_transactions" sub-collection with the remaining balance
  await memberRef.update({'remaining_balance': remainingBalance});

  // Step 8: Add the new payment to the user's payment history
  await memberRef.collection('payments').add({
    'payment_amount': paymentAmount,
    'timestamp': DateTime.now(),
  });
}



}
