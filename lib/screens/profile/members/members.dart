// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';

class Members extends StatefulWidget {
  Members({Key? key}) : super(key: key);

  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  List<String> members = [];

  @override
  void initState() {
    super.initState();

    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    String? groupId = currentUser.getCurrentUser.groupId;

    // Retrieve the list of members from the group document
    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId!) // Replace with the ID of the current group document
        .get()
        .then((groupSnapshot) {
      setState(() {
        members = List<String>.from(groupSnapshot.data()!['members']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group Members'),backgroundColor: Colors.deepPurple[200],),
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: members.isNotEmpty
                ? ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(members[index])
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return ListTile(
                              title: Text(
                                snapshot.data!['fullName'] as String,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            );
                          } else {
                            return SizedBox(
                              height: 40,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No members in this group',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
