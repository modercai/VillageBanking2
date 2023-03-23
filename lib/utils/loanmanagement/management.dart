import 'package:flutter/material.dart';

class LoanManagementPage extends StatefulWidget {
  @override
  _LoanManagementPageState createState() => _LoanManagementPageState();
}

class _LoanManagementPageState extends State<LoanManagementPage> {
  List<Loan> loans = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Management'),
      ),
      body: ListView.builder(
        itemCount: loans.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(loans[index].borrowerName!),
            subtitle: Text('Loan Amount: \$${loans[index].loanAmount}'),
            trailing: Text('Status: ${loans[index].status}'),
            onTap: () {
              // Navigate to the loan detail page
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the loan application page
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Loan {
  int? id;
  String? borrowerName;
  double? loanAmount;
  String? status;

  Loan({
    this.id,
    this.borrowerName,
    this.loanAmount,
    this.status,
  });
}
