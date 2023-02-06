// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/utils/loanmanagement/evaluation.dart';

class LoanDisbursalPage extends StatefulWidget {
  final LoanApplication loanApplication;

  const LoanDisbursalPage(
      {Key? key,
      required this.loanApplication}) //changed this from @required to just required if any errors please check here.
      : super(key: key);

  @override
  _LoanDisbursalPageState createState() => _LoanDisbursalPageState();
}

class _LoanDisbursalPageState extends State<LoanDisbursalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Disbursal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Loan disbursed to ${widget.loanApplication.borrowerName} for ${widget.loanApplication.loanPurpose}',
              style: Theme.of(context).textTheme.headline1, //why headline 1
            ),
            SizedBox(height: 16.0),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                // Confirm loan disbursal by calling the server
                // ...
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
}
