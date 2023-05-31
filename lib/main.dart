// ignore_for_file: prefer_const_constructors
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/root/root.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(channelKey: 'key1', channelName: 'villageBanking', channelDescription: 'Notifications for village banking application',enableVibration: true),
  ],);
  await Firebase.initializeApp();
  runApp(const MyApp());
}
  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {    
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OurRoot(),
      ),
    );
  }
}
