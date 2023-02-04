// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/noGroup/nogroup.dart';
import 'package:join_create_group_functionality/screens/root/root.dart';
import 'package:provider/provider.dart';

import '../../states/current_user.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              CurrentUser currentUser =
                  Provider.of<CurrentUser>(context, listen: false);
              //call the signOut method.
              String returnString = await currentUser.signOut();
              if (returnString == 'success') {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => OurRoot()),
                    (route) => false);
              }
            },
            child: Text('Sign Out'),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OurNoGroup()));
              },
              child: Text('OurNoGroupPage'))
        ],
      )),
    );
  }
}
