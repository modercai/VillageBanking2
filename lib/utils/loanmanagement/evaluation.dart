// ignore_for_file: dead_code

import 'package:flutter/material.dart';

class LoanEvaluationPage extends StatefulWidget {
  @override
  _LoanEvaluationPageState createState() => _LoanEvaluationPageState();
}

class _LoanEvaluationPageState extends State<LoanEvaluationPage> {
  late List<LoanApplication> _loanApplications;

  @override
  void initState() {
    super.initState();
    _loadLoanApplications();
  }

  void _loadLoanApplications() async {
    // Load the loan applications from the server
    setState(() {
      _loanApplications = [
        LoanApplication(
          id: '1',
          borrowerName: 'John Doe',
          loanAmount: 5000.0,
          loanPurpose: 'Home renovation',
          status: LoanApplicationStatus.PENDING,
        ),
        LoanApplication(
          id: '2',
          borrowerName: 'Jane Doe',
          loanAmount: 10000.0,
          loanPurpose: 'Small business start-up',
          status: LoanApplicationStatus.APPROVED,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Evaluation'),
      ),
      body: _loanApplications == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _loanApplications.length,
              itemBuilder: (context, index) {
                LoanApplication loanApplication = _loanApplications[index];
                return ListTile(
                  title: Text(loanApplication.borrowerName!),
                  subtitle: Text(loanApplication.loanPurpose!),
                  trailing:
                      _buildLoanApplicationStatus(loanApplication.status!),
                  onTap: () {
                    // Navigate to the loan application detail screen
                  },
                );
              },
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
}
