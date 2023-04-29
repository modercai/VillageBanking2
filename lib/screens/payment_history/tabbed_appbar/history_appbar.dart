import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/payment_history/application_history.dart';
import 'package:join_create_group_functionality/screens/payment_history/repayment_history.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';

class MyTabbedAppBar extends StatefulWidget {
  @override
  _MyTabbedAppBarState createState() => _MyTabbedAppBarState();
}

class _MyTabbedAppBarState extends State<MyTabbedAppBar> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Repayments'),
    Tab(text: 'Deposits'),
    Tab(text: 'Applications'),
  ];

  @override
  Widget build(BuildContext context) { 
    Widget retVal;
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[200],
          title: const Text('History'),
          bottom: TabBar(
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: myTabs.map(
            (Tab tab) {
              switch (tab.text) {
            case 'Repayments':
              CurrentUser currentUser =
                  Provider.of<CurrentUser>(context, listen: false);
              String? groupId = currentUser.getCurrentUser.groupId;
              return PaymentHistoryScreen(groupId: groupId!);
            case 'Applications':
              CurrentUser currentUser =
                  Provider.of<CurrentUser>(context, listen: false);
              String? groupId = currentUser.getCurrentUser.groupId;
              return ApplicationHistoryScreen(groupId: groupId!);
              //include for the Deposits here and print to the 
            default:
              return Container();
              }
  }).toList(),
        ),
      ),
    );
  }
}
