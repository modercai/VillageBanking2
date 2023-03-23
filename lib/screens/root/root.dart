import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/auth/auth_page.dart';
import 'package:join_create_group_functionality/screens/home/home.dart';
import 'package:join_create_group_functionality/screens/noGroup/nogroup.dart';
import 'package:join_create_group_functionality/splashScreen/splash.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';

enum AuthStatus {
  unknown,
  notLoggedIn,
  notInGroup,
  inGroup,
}

class OurRoot extends StatefulWidget {
  const OurRoot({super.key});

  @override
  State<OurRoot> createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus authStatus = AuthStatus.unknown;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    String returnString = await currentUser.onStartUp();
    if (returnString == 'success') {
      if (currentUser.getCurrentUser.groupId != null) {
        print(currentUser);
        setState(() {
          authStatus = AuthStatus.inGroup;
        });
      } else {
        setState(() {
          authStatus = AuthStatus.notInGroup;
        });
      }
    } else {
      setState(() {
        authStatus = AuthStatus.notLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal;

    switch (authStatus) {
      case AuthStatus.unknown:
        retVal = SplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        retVal = AuthPage();
        break;
      case AuthStatus.notInGroup:
        retVal = OurNoGroup();
        break;
      case AuthStatus.inGroup:
        //take user to the home screen if they belong to a group.(decide if this is the best option before making it final)
        retVal = HomePage();
        break;
    }
    return retVal;
  }
}
