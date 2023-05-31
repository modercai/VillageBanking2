import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('FAQ'),
            leading: Icon(Icons.help),
            onTap: () {
              // TODO: Implement FAQ functionality
            },
          ),
          ListTile(
            title: Text('Contact Us'),
            leading: Icon(Icons.mail),
            onTap: () {
              // TODO: Implement Contact Us functionality
            },
          ),
          ListTile(
            title: Text('Report a Problem'),
            leading: Icon(Icons.warning),
            onTap: () {
              // TODO: Implement Report a Problem functionality
            },
          ),
          ListTile(
            title: Text('Terms and Conditions'),
            leading: Icon(Icons.description),
            onTap: () {
              // TODO: Implement Terms and Conditions functionality
            },
          ),
        ],
      ),
    );
  }
}
