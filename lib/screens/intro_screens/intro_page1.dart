import 'package:flutter/material.dart';

class IntroPageOne extends StatelessWidget {
  const IntroPageOne({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: Center(
        child: Text('page 1'),
      ),
    );
  }
}
