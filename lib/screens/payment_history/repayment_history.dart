import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/services/database.dart';
import 'package:intl/intl.dart';


class PaymentHistoryScreen extends StatefulWidget {
  final String groupId;

  PaymentHistoryScreen({required this.groupId});

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  late Future<List<Map<String, dynamic>>> paymentHistoryFuture;

  @override
  void initState() {
    super.initState();
    paymentHistoryFuture = OurDatabase().getPaymentHistory(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: paymentHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Failed to retrieve payment history.'));
          }

          final paymentHistory = snapshot.data!;

          if (paymentHistory.isEmpty) {
            return Center(child: Text('No payment history found.'));
          }

          return ListView.builder(
            itemCount: paymentHistory.length,
            itemBuilder: (context, index) {
              final paymentData = paymentHistory[index];
              final paymentAmount = paymentData['payment_amount'] as num;
              final paymentTimestamp = paymentData['timestamp'] as Timestamp;
              final paymentDate = DateFormat.yMd().add_jm().format(paymentTimestamp.toDate());

              return ListTile(
                title: Text('Payment of  ZMW ${paymentAmount.toStringAsFixed(2)}'),
                subtitle: Text(paymentDate),
              );
            },
          );
        },
      ),
    );
  }
}
