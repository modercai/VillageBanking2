// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code

import 'package:flutter/material.dart';

class DepositUI extends StatelessWidget {
  final String depositIconPath;
  final String depositbottomText;

  const DepositUI({
    Key? key,
    required this.depositIconPath,
    required this.depositbottomText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Center(
            child: Image.asset(depositIconPath),
          ),
        ),
        Text(
          depositbottomText,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
    SizedBox(height: 10);
  }
}
