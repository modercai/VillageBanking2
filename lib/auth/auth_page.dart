import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/login/login.dart';
import 'package:join_create_group_functionality/screens/signup/signup.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;
  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return OurLogin(
        showRegistrationPage: toggleScreens,
      );
    } else {
      return OurRegisterPage(showLoginPage: toggleScreens);
    }
  }
}
