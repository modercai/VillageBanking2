import 'package:flutter/material.dart';

class LoanMonitoringPage extends StatelessWidget {
  final List<Loan> loans;

  LoanMonitoringPage({Key? key, required this.loans})
      : super(
            key:
                key); //changede this from @required to just required if any errors please check here.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Monitoring'),
      ),
      body: ListView.builder(
        itemCount: loans.length,
        itemBuilder: (context, index) {
          final loan = loans[index];
          return Card(
            child: ListTile(
              title: Text(loan.borrowerName!),
              subtitle: Text('Loan Amount: ${loan.loanAmount}'),
              trailing: Text('Remaining Amount: ${loan.remainingAmount}'),
              onTap: () {
                // Show loan details when the user taps on a loan
                // ...
              },
            ),
          );
        },
      ),
    );
  }
}

class Loan {
  final String? id;
  final String? borrowerName;
  final double? loanAmount;
  final String? loanPurpose;
  final double? remainingAmount;

  Loan({
    this.id,
    this.borrowerName,
    this.loanAmount,
    this.loanPurpose,
    this.remainingAmount,
  });
}
