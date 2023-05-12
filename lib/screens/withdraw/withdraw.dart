import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:join_create_group_functionality/screens/home/home.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TransferForm extends StatefulWidget {
  @override
  _TransferFormState createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final _formKey = GlobalKey<FormState>();
  String? _accountNumber;
  String? _bank;
  double? _amount;
  String? _narration;
  String? _recipientName;
  String? _bankBranch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Transfer Form'),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Account Number'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter account number';
                }
                return null;
              },
              onSaved: (value) => _accountNumber = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Bank'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter bank name';
                }
                return null;
              },
              onSaved: (value) => _bank = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter amount';
                }
                return null;
              },
              onSaved: (value) => _amount = double.parse(value!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Narration'),
              onSaved: (value) => _narration = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Recipient Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter recipient name';
                }
                return null;
              },
              onSaved: (value) => _recipientName = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Bank Branch'),
              onSaved: (value) => _bankBranch = value,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Request For Transfer'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  saveToFirebase();
                  exportDataToCsv();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void saveToFirebase() async {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    String? groupId = currentUser.getCurrentUser.groupId;
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;

    DocumentReference userRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('user_transactions')
        .doc(userId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userRef);
      double currentBalance = userSnapshot['user_balance'] as double? ?? 0.0;
      double newBalance = currentBalance - _amount!;
      if (newBalance < 0) {
        throw 'Insufficient balance'; // Throw an error if the balance is negative
      }
      transaction.update(userRef, {'user_balance': newBalance});
      transaction.set(
          FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection('withdraws')
              .doc(userId),
          {
            'accountNumber': _accountNumber,
            'bank': _bank,
            'amount': _amount,
            'narration': _narration,
            'recipientName': _recipientName,
            'bankBranch': _bankBranch,
          });
    }).then((value) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Message!'),
              content: Text('Form succesfully submitted'),
              actions: <Widget>[
                MaterialButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => !Navigator.canPop(context),
                    );
                  },
                )
              ],
            );
          });
    }).catchError((error) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Message!'),
              content: Text('Form not Submitted please Try again later'),
              actions: <Widget>[
                MaterialButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  void exportDataToCsv() async {
    // Get the documents directory
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final filePath = '${documentsDirectory.path}/data.csv';

    // Get the current user and group ID
    final currentUser = Provider.of<CurrentUser>(context, listen: false);
    final groupId = currentUser.getCurrentUser.groupId;
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;

    // Query the database for withdraws
    final querySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('withdraws')
        .get();

    // Create CSV data from query results
    final csvData = <List<dynamic>>[];

    // Add column headers to CSV data
    csvData.add([
      'Account Number',
      'Bank',
      'Amount',
      'Narration',
      'Recipient Name',
      'Bank Branch'
    ]);

    // Loop through each document in the query snapshot and add its data to the CSV data
    querySnapshot.docs.forEach((doc) {
      final data = doc.data();
      csvData.add([
        data['accountNumber'],
        data['bank'],
        data['amount'],
        data['narration'],
        data['recipientName'],
        data['bankBranch'],
      ]);
    });

    // Write the CSV data to a file
    final csvString = const ListToCsvConverter().convert(csvData);
    final file = File(filePath);
    await file.writeAsString(csvString);

    // Upload the file to Firebase Storage
    final storage = FirebaseStorage.instance;
    final bucket = storage.ref().child('csv-files');
    final filename = DateTime.now().millisecondsSinceEpoch.toString() + '.csv';
    final task = bucket.child(filename).putFile(file);
    final snapshot = await task.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    // Delete the local copy of the CSV file
    await file.delete();

    print('File uploaded to $downloadUrl');
  }
}
