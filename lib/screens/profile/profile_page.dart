// ignore_for_file: use_build_context_synchronously, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/profile/cycle/cycle.dart';
import 'package:join_create_group_functionality/screens/profile/helpsupport/help.dart';
import 'package:join_create_group_functionality/screens/profile/members/members.dart';
import 'package:join_create_group_functionality/screens/root/root.dart';
import 'package:join_create_group_functionality/utils/loanmanagement/evaluation.dart';
import 'package:join_create_group_functionality/utils/loanmanagement/repayment.dart';
import 'package:join_create_group_functionality/utils/new_loan_repayment.dart';
import 'package:join_create_group_functionality/utils/profile_list_item/profile_list_items.dart';
import 'package:provider/provider.dart';

import '../../states/current_user.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  String? username;

  @override
  void initState() {
    super.initState();
    retrieveUsername(); // Call the method to retrieve the username
  }

  void retrieveUsername() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userSnapshot.exists) {
        setState(() {
          username = userSnapshot['fullName'];
        });
      }
    } catch (error) {
      // Handle any potential errors here
      print('Error retrieving username: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 100,
            backgroundColor: Colors.grey[300],
            backgroundImage: AssetImage('images/beauty.png'),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            'Hi ${username ?? ''}',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                child: ProfileListItem(iconData: Icons.logout, text: 'Logout'),
                onTap: () async {
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
              ),
              SizedBox(
                height: 10,
              ),
              
                 GestureDetector(
                   child: ProfileListItem(
                      iconData: Icons.people, text: 'Group Members'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Members()));
                      },
                 ),
              
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: ProfileListItem(
                    iconData: Icons.cyclone, text: 'Cycle Details'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CountdownTimerWidget()));
                },
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelpSupportPage()));
                },
                child: ProfileListItem(iconData: Icons.help, text: 'help & support')),
            ],
          ),
        ],
      )),
    );
  }
}
