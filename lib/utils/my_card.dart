// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final double groupBalance;
  final double personalBalance;
  final String groupName;
  final color; 

  const MyCard({
    Key? key,
    required this.groupBalance,
    required this.groupName,
    required this.personalBalance,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 300,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              'Group Balance',
              style: TextStyle(color: Colors.white,fontSize: 15),
            ),
            
            Text(
              'ZMW ' + groupBalance.toStringAsFixed(2),
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Personal Balance',
              style: TextStyle(color: Colors.white,fontSize: 15),),
            Text('ZMW ' + personalBalance.toStringAsFixed(2),
            style: TextStyle(color: Colors.white,fontSize: 25),),
             SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GroupName:',
                  style: TextStyle(color: Colors.white,fontSize: 15),
                ),
                Text(
                  groupName,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
