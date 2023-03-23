import 'package:flutter/material.dart';

import '../models/loanapplication.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loanApplication = ModalRoute.of(context)!.settings.arguments as LoanApplication;
    return Scaffold(
      appBar: AppBar(title: Text('Loan History')),
      body: Center(
        child: Text('Loan ID: ${loanApplication.borrowerName}\nEvaluation: ${loanApplication.status}'),
      ),
    );
  }
}
