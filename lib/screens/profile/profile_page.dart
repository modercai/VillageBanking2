// ignore_for_file: use_build_context_synchronously, prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/noGroup/nogroup.dart';
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
  Loan loan = Loan(
  id: 'ABC123',
  borrowerName: 'John Doe',
  loanAmount: 1000.0,
  loanPurpose: 'Business investment',
  remainingAmount: 800.0,
);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'HI',
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
              // ignore: prefer_const_constructors
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: ProfileListItem(
                    iconData: Icons.person_add, text: 'No Group Page'),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoanPaymentForm()));
                },
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: ProfileListItem(
                    iconData: Icons.money, text: 'Loan Evaluation'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoanEvaluationPage()));
                },
              ),
              SizedBox(
                height: 10,
              ),
              ProfileListItem(iconData: Icons.settings, text: 'settings'),
              SizedBox(
                height: 10,
              ),
              ProfileListItem(iconData: Icons.help, text: 'help & support'),
            ],
          ),
        ],
      )),
    );
  }
}
