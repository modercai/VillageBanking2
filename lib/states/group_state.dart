import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/models/group.dart';


class CurrentGroup extends ChangeNotifier{
  OurGroup currentGroup = OurGroup();

  OurGroup get getCurrentUser => currentGroup;
  FirebaseAuth auth = FirebaseAuth.instance;

  
}