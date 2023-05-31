import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:join_create_group_functionality/states/group_state.dart';
import 'package:provider/provider.dart';
import 'dart:async';


class CountdownTimerWidget extends StatefulWidget {
  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  Timer? _timer;
  DateTime? _cycleStartDate;
  Duration? _countdownDuration;

  @override
  void initState() {
    super.initState();
    // Fetch cycle start date from Firestore
    _fetchCycleStartDate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void cycleStartApplicationNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: 'Cycle Started',
          body:
              'The Cycle has Started, you can now start saving! Thank you.'),
    );
  }

   void cycleEndApplicationNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: 'Cycle Ended',
          body:
              'The Cycle has Ended, Thank you for using the village banking application, kindly wait for the start of the new cycle to start saving.'),
    );
  }

  void _fetchCycleStartDate() {
    CurrentUser currentUser = Provider.of<CurrentUser>(context ,listen: false);
    String? groupId = currentUser.getCurrentUser.groupId;
    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        final cycleStartDateTimestamp =
            snapshot.data()!['cycleStartDate'] as Timestamp?;
        if (cycleStartDateTimestamp != null) {
          _cycleStartDate = cycleStartDateTimestamp.toDate();
          _startCountdown();
        }
      }
    });
  }

  void _startCountdown() {
    if (_cycleStartDate == null) return;

    final now = DateTime.now();
    final cycleEndDate = _cycleStartDate!.add(Duration(days: 180));
    if (now.isBefore(cycleEndDate)) {
      _countdownDuration = cycleEndDate.difference(now);
      _timer = Timer.periodic(Duration(seconds: 1), (_) {
        setState(() {
          _countdownDuration = cycleEndDate.difference(DateTime.now());
        });
        if (_countdownDuration!.inSeconds <= 0) {
          _timer?.cancel();
          cycleEndApplicationNotification();
        }
      });
      cycleStartApplicationNotification();
    }
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '$days days, $hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cycle Durations'),backgroundColor: Colors.deepPurple[200],),
      body: Center(
        child: Container(
          child: _countdownDuration != null
              ? Text(
                  'Days to Next Cycle: ${_formatDuration(_countdownDuration!)}',
                  style: TextStyle(fontSize: 20),
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}

