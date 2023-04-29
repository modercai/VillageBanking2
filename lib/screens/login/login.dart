// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/forgotpassword/forgot_password.dart';
import 'package:join_create_group_functionality/screens/home/home.dart';
import 'package:join_create_group_functionality/screens/root/root.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';

enum LoginType {
  email,
  google,
}

class OurLogin extends StatefulWidget {
  final VoidCallback showRegistrationPage;

  const OurLogin({
    Key? key,
    required this.showRegistrationPage,
  }) : super(key: key);

  @override
  State<OurLogin> createState() => _OurLoginState();
}

class _OurLoginState extends State<OurLogin> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _isLoading = false;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                //logo if posssible

                //greeting text
                Text(
                  'Hello Again!',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 20),
                ),

                SizedBox(
                  height: 20,
                ),

                //email/phone field

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Email'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //password field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Password'),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ForgotPasswordPage()));
                        },
                        child: Text(
                          'forgot password?',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                //signinn button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child:  
                      GestureDetector(
                        onTap: () {
                          _logInUser(LoginType.email, _emailController.text,
                              _passwordController.text, context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: _isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ):
                            Center(
                              child: Text(
                                'Sign In',
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                  
                  ),
                
                SizedBox(
                  height: 20,
                ),

                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text('Not a Member?',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: widget.showRegistrationPage,
                      child: Text(
                        ' Register Now',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
/*
                //google signIn button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  child: GestureDetector(
                    onTap: () {
                      _logInUser(
                        LoginType.google,
                        "",
                        "",
                        context,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16)),
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('images/images.jpeg'),
                            Row(
                              children: [
                                Text(
                                  'Sign',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 17),
                                ),
                                Text('In',
                                    style: TextStyle(
                                        color: Colors.yellow.shade600,
                                        fontSize: 17)),
                                Text('With',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 17)),
                                Text('Google',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 17)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,*/
              ],
            ),
          ),
        ),
      ),
    );
  }


void _logInUser(
    LoginType type, String email, String password, BuildContext context) async {
  CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);

    if (email.isEmpty) {
    _showErrorDialog(context, 'Please enter your email.');
    return;
  }

  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
    _showErrorDialog(context, 'Please enter a valid email address.');
    return;
  }

  if (password.isEmpty) {
    _showErrorDialog(context, 'Please enter a password.');
    return;
  }

  setState(() {
      _isLoading = true;
    });

  try {
    String returnString;

    switch (type) {
      case LoginType.email:
        returnString = await currentUser.logInUserWithEmail(email, password);
        break;
      case LoginType.google:
        returnString = await currentUser.logInUserWithGoogle();
        break;
    }

    if (returnString == 'success') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => OurRoot()));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text('An error occurred while logging in. Enter correct login credentials or check connectivity.'),
              ));
    }
  } catch (e) {
    _showErrorDialog(context, e.toString());
  }
  setState(() {
      _isLoading = false;
    });
 
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
}