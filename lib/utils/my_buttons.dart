import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  final String iconPath;
  final String buttonText;
  const MyButtons({
    Key? key,
    required this.iconPath,
    required this.buttonText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 80,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 50, color: Colors.white, spreadRadius: 10)
            ]),
        child: Center(
          child: Image.asset(iconPath),
        ),
      ),
      SizedBox(height: 10),
      Text(
        buttonText,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
    ]);
  }
}
