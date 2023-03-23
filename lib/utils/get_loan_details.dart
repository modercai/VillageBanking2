import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetLoanDetails extends StatelessWidget {
  final String? documentId;

  const GetLoanDetails({
    Key? key,
    this.documentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference loans =
        FirebaseFirestore.instance.collection('loan_applications');
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
