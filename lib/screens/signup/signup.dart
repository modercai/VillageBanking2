// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/home/home.dart';
import 'package:join_create_group_functionality/screens/root/root.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';

class OurRegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  OurRegisterPage({
    Key? key,
    required this.showLoginPage,
  }) : super(key: key);

  @override
  _OurRegisterPageState createState() => _OurRegisterPageState();
}

class _OurRegisterPageState extends State<OurRegisterPage> {
  final _confirmPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
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
                  'Hello!',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  'Enter your details below to register',
                  style: TextStyle(fontSize: 20),
                ),
                //fumane field

                SizedBox(
                  height: 20,
                ),

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
                        controller: _fullNameController,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Full Name'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
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
                  height: 20,
                ),

                //confirm password

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
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Confirm Password'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                //signup button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: () {
                      if (_passwordController.text ==
                          _confirmPasswordController.text) {
                        _signUpUser(
                            _emailController.text,
                            _passwordController.text,
                            _fullNameController.text,
                            context);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child:_isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ):
                         Center(
                          child: Text(
                            'Sign Up',
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
                    Text('Already a Member?',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: Text(
                        ' Login Now',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

void _signUpUser(String email, String password, String fullName, BuildContext context) async {
  CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);

  // Validate input fields
  if (fullName.isEmpty) {
    _showErrorDialog(context, 'Please enter your full name.');
    return;
  }

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

  if (password.length < 6) {
    _showErrorDialog(context, 'Password must be at least 6 characters long.');
    return;
  }

  if (password != _confirmPasswordController.text) {
    _showErrorDialog(context, 'Passwords do not match.');
    return;
  }

  setState(() {
      _isLoading = true;
    });

  try {
    String returnString = await currentUser.sigUpUser(email, password, fullName);
    if (returnString == 'success') {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => OurRoot()));
    } else {
      _showErrorDialog(context, 'An error occurred while registering. Please try again later.');
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
