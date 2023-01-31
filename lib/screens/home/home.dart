// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/noGroup/nogroup.dart';
import 'package:join_create_group_functionality/screens/root/root.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Column(
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
          ),
        ),
      ),
    );
  }
}
