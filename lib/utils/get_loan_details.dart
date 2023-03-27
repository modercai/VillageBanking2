// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';

class GetLoanDetails extends StatelessWidget {
  final String? documentId;

  const GetLoanDetails({
    Key? key,
    this.documentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Provider.of<CurrentUser>(context,listen: false);
    String? groupId = currentUser.getCurrentUser.groupId;
    CollectionReference loans =
        FirebaseFirestore.instance.collection('groups').doc(groupId).collection('loan_applications');
    return FutureBuilder<DocumentSnapshot>(
      future: loans.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['borrowerName']}');
        }
        return Text('loading....');
      }),
    );
  }
}
