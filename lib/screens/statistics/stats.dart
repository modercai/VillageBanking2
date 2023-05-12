// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/services/database.dart';

class PaymentHistoryReport extends StatefulWidget {
  final String groupId;

  PaymentHistoryReport({required this.groupId});

  @override
  _PaymentHistoryReportState createState() => _PaymentHistoryReportState();
}

class _PaymentHistoryReportState extends State<PaymentHistoryReport> {
  List<Map<String, dynamic>> paymentHistory = [];
  List<Map<String, dynamic>> applicationHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    paymentHistory = await OurDatabase().getPaymentHistory(widget.groupId);
    applicationHistory = await OurDatabase().getApplicationHistory(widget.groupId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('History Report'),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: paymentHistory.isEmpty && applicationHistory.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text('Number of Payments: ${paymentHistory.length}'),
                  Text('Total Amount of Payments: ${_calculateTotalPaymentAmount(paymentHistory)}'),
                  Text('Average Payment Amount: ${_calculateAveragePaymentAmount(paymentHistory)}'),
                  SizedBox(height: 32),
                  Text(
                    'Loan Application',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text('Number of Loan Applications: ${applicationHistory.length}'),
                  Text('Total Amount of Loans: ${_calculateTotalLoanAmount(applicationHistory)}'),
                  Text('Average Loan Amount: ${_calculateAverageLoanAmount(applicationHistory)}'),
                ],
              ),
            ),
    );
  }

  String _calculateTotalPaymentAmount(List<Map<String, dynamic>> history) {
    double totalAmount = 0.0;
    for (final item in history) {
      final amount = item['payment_amount'] ?? 0.0;
      totalAmount += amount;
    }
    return 'ZMW ${totalAmount.toStringAsFixed(2)}';
  }

   String _calculateTotalLoanAmount(List<Map<String, dynamic>> history) {
    double totalAmount = 0.0;
    for (final item in history) {
      final amount = item['loanAmount'] ?? 0.0;
      totalAmount += amount;
    }
    return 'ZMW ${totalAmount.toStringAsFixed(2)}';
  }

  String _calculateAveragePaymentAmount(List<Map<String, dynamic>> history) {
    double totalAmount = 0.0;
    for (final item in history) {
      final amount = item['payment_amount'] ?? 0.0;
      totalAmount += amount;
    }
    final averageAmount = totalAmount / history.length;
    return 'ZMW ${averageAmount.toStringAsFixed(2)}';
  }

   String _calculateAverageLoanAmount(List<Map<String, dynamic>> history) {
    double totalAmount = 0.0;
    for (final item in history) {
      final amount = item['loanAmount'] ?? 0.0;
      totalAmount += amount;
    }
    final averageAmount = totalAmount / history.length;
    return 'ZMW ${averageAmount.toStringAsFixed(2)}';
  }

}
