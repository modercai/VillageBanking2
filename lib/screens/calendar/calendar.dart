// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CycleCalendar extends StatelessWidget {
  final DateTime cycleStartDate;
  final DateTime cycleEndDate;
  final List<DateTime> importantDates;

  CycleCalendar({required this.cycleStartDate, required this.cycleEndDate, required this.importantDates});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      children: [
        TableRow(
          children: [
            TableCell(
              child: Text('Cycle Start: ${DateFormat('MMM d, y').format(cycleStartDate)}'),
            ),
            TableCell(
              child: Text('Cycle End: ${DateFormat('MMM d, y').format(cycleEndDate)}'),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Text('Important Dates:'),
            ),
            TableCell(
              child: SizedBox(),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Column(
                children: importantDates.map((date) {
                  return Text(DateFormat('MMM d, y').format(date));
                }).toList(),
              ),
            ),
            TableCell(
              child: SizedBox(),
            ),
          ],
        ),
      ],
    );
  }
}
