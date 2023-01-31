// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/root/root.dart';
import 'package:join_create_group_functionality/services/database.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';

class OurCreateGroup extends StatefulWidget {
  const OurCreateGroup({Key? key}) : super(key: key);

  @override
  State<OurCreateGroup> createState() => _OurCreateGroupState();
}

class _OurCreateGroupState extends State<OurCreateGroup> {
  void createGroup(BuildContext context, String groupName) async {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    String returnString = await OurDatabse()
        .createGroup(groupName, currentUser.getCurrentUser.uid!);
    if (returnString == 'success') {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurRoot(),
          ),
          (route) => false);
    }
  }

  final createGroupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: SafeArea(
          child: Column(children: [
            //textformfield
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: createGroupController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Group Name',
                    ),
                  ),
                ),
              ),
            ),
            //button to go the page
            ElevatedButton(
              onPressed: () => createGroup(context, createGroupController.text),
              child: Text('Create'),
            ),
          ]),
        ),
      ),
    );
  }
}
