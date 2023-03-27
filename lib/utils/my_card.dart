import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final double balance;
  final double personalBalance;
  final String groupName;
  final Color color;

  const MyCard({
    Key? key,
    required this.balance,
    required this.groupName,
    required this.personalBalance,
    this.color = Colors.blue,
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
              'Group balance',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              'ZMW ${balance.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your Balance',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              'ZMW ${personalBalance.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Group Name:',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  groupName,
                  style: const TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
