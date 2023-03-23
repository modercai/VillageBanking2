// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/createGroup/create_group.dart';
import 'package:join_create_group_functionality/screens/joinGroup/join_group.dart';

class OurNoGroup extends StatelessWidget {
  const OurNoGroup({super.key});

  void joinGroup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OurJoinGroup(),
      ),
    );
  }

  void createGroup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OurCreateGroup(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to the Village Banking App',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                  'Please join or create a group to get started with village banking'),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      joinGroup(context);
                    },
                    child: Text('Join'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      createGroup(context);
                    },
                    child: Text('Create'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
