// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:join_create_group_functionality/models/group.dart';
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

  final TextEditingController interestRateController = TextEditingController();
  final createGroupController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {

    final DateTime? picked = await DatePicker.showDateTimePicker(context,showTitleActions: true);
    if(picked != null && picked != _selectedDate){
      setState(() {
        _selectedDate = picked;
      });
    }
  }


  void createGroup(BuildContext context, String groupName,int interestRate, Timestamp cycleStartDate ) async {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    String returnString = await OurDatabase()
        .createGroup(groupName, currentUser.getCurrentUser.uid!,interestRate, cycleStartDate);
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

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: SafeArea(
          child: ListView(children: [
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
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: interestRateController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Interest rate',
                      
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text(DateFormat.yMMMd("en_US").format(_selectedDate)),
            TextButton(onPressed: () => _selectDate(context), child: Text('Choose Start Of Cycle')),

            //button to go the page
            ElevatedButton(
              onPressed: () {
                OurGroup group = OurGroup();
                  group.cycleStartDate = Timestamp.fromDate(_selectedDate);
                
                createGroup(context, createGroupController.text,int.parse(interestRateController.text),group.cycleStartDate!);},
              child: Text('Create'),
            ),
          ]),
        ),
      ),
    );
  }
}