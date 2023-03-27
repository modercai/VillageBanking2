// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MySecondCard extends StatelessWidget {
  final double remainingBalance;
  final double amountPaid;
  final Color color;

  const MySecondCard({
    Key? key,
    required this.remainingBalance,
    required this.amountPaid,
    this.color = Colors.lightBlueAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const Text(
              'Remaining Balance',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            Text(
              'ZMW ${remainingBalance.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
            const SizedBox(height: 10),
            const Text(
              'Last Paid Amount',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            Text(
              'ZMW ${amountPaid.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
