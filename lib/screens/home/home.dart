// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_cast

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:join_create_group_functionality/screens/calculator/simple_interest_calculator.dart';
import 'package:join_create_group_functionality/screens/deposit/deposit_page.dart';
import 'package:join_create_group_functionality/screens/deposit/new_deposit_page.dart';
import 'package:join_create_group_functionality/screens/noGroup/nogroup.dart';
import 'package:join_create_group_functionality/screens/payment_history/tabbed_appbar/history_appbar.dart';
import 'package:join_create_group_functionality/screens/profile/profile_page.dart';
import 'package:join_create_group_functionality/screens/statistics/stats.dart';
import 'package:join_create_group_functionality/screens/withdraw/withdraw.dart';
import 'package:join_create_group_functionality/services/database.dart';
import 'package:join_create_group_functionality/splashScreen/splash.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:join_create_group_functionality/utils/loanmanagement/application.dart';
import 'package:join_create_group_functionality/utils/loanmanagement/evaluation.dart';
import 'package:join_create_group_functionality/utils/my_buttons.dart';
import 'package:join_create_group_functionality/utils/my_card.dart';
import 'package:join_create_group_functionality/utils/my_list_tiles.dart';
import 'package:join_create_group_functionality/utils/new_loan_repayment.dart';
import 'package:join_create_group_functionality/utils/second_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = PageController();
  final user = FirebaseAuth.instance.currentUser!;
  

  double _getTransactionsTotal(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> transactionsDocs) {
    double total = 0.0;
    if (transactionsDocs.isNotEmpty) {
      for (final transactionDoc in transactionsDocs) {
        final amount = transactionDoc.get('total');
        total += amount;
      }
    }
    return total;
  }
 
  final userDocs = FirebaseFirestore.instance.collection('users').doc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return CashDeposit();
            }));
          },
          child: Icon(
            Icons.chat,
            size: 40,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.home,
                size: 40,
              ),
              GestureDetector(
                onTap: (() {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return SettingsPage();
                  }));
                }),
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              ),
            ],
          ),
        )),
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'My',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' Groups',
                            style: TextStyle(fontSize: 28),
                          ),
                        ],
                      ),
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'create/join',
                              style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[400]),
                              child: Icon(Icons.add),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OurNoGroup()));
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: PageView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Scaffold(
                        backgroundColor: Colors.grey[300],
                        body: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('groups')
                                .where('members', arrayContains: user.uid)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final groupDocs = snapshot.data!.docs;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: groupDocs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  CurrentUser currentUser =
                                      Provider.of<CurrentUser>(context,
                                          listen: false);
                                  String? groupId =
                                      currentUser.getCurrentUser.groupId!;

                                  final groupDoc = groupDocs[index];

                                  return StreamBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                    stream: groupDoc.reference
                                        .collection('total')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            userTransactionSnapshot) {
                                      if (!userTransactionSnapshot.hasData) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                      final userTransactionDocs =
                                          userTransactionSnapshot.data!.docs;
                                      final total = _getTransactionsTotal(
                                          userTransactionDocs);

                                      return StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                        stream: groupDoc.reference
                                            .collection('user_transactions')
                                            .doc(currentUser.getCurrentUser
                                                .uid) // Replace '12345' with the ID of the document you want to retrieve
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<
                                                    DocumentSnapshot<
                                                        Map<String, dynamic>>>
                                                transactionSnapshot) {
                                          if (!transactionSnapshot.hasData) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }

                                          final transactionDocs =
                                              transactionSnapshot.data!;

                                          double userAmount = 0.0;
                                          // Provide a default value
                                          if (transactionDocs.exists) {
                                            final transactionDoc =
                                                transactionDocs;
                                            final userBalance =
                                                transactionDoc['user_balance'];
                                            if (userBalance != null) {
                                              userAmount = userBalance
                                                  as double; // Handle the null case
                                            }
                                          }

                                          return Row(
                                            children: [
                                              MyCard(
                                                  balance: total,
                                                  groupName:
                                                      groupDoc.get('name'),
                                                  personalBalance: userAmount),
                                              StreamBuilder<
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>>>(
                                                stream: groupDoc.reference
                                                    .collection('loan_payments')
                                                    .doc(currentUser
                                                        .getCurrentUser.uid)
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot<
                                                                Map<String,
                                                                    dynamic>>>
                                                        snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }

                                                  final loanPaymentsDoc =
                                                      snapshot.data!;
                                                  if (!loanPaymentsDoc.exists) {
                                                    return MySecondCard(
                                                      remainingBalance: 0.0,
                                                      amountPaid: 0.0,
                                                    );
                                                  } else {
                                                    final loanPaymentsData =
                                                        loanPaymentsDoc.data()!;
                                                    if (loanPaymentsData
                                                        .isEmpty) {
                                                      return MySecondCard(
                                                        remainingBalance: 0.0,
                                                        amountPaid: 0.0,
                                                      );
                                                    } else {
                                                      final remainingBalance =
                                                          loanPaymentsData[
                                                                      'remaining_balance']
                                                                  as double? ??
                                                              0.0;
                                                      final paidAmount =
                                                          loanPaymentsData[
                                                                      'loan_amount']
                                                                  as double? ??
                                                              0.0;
                                                      return MySecondCard(
                                                        remainingBalance:
                                                            remainingBalance,
                                                        amountPaid: paidAmount,
                                                      );
                                                    }
                                                  }
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            }),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return OurDepositPage();
                            }));
                          }),
                          child: MyButtons(
                            iconPath: 'images/deposit.png',
                            buttonText: 'save',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoanApplicationPage()));
                          },
                          child: MyButtons(
                            iconPath: 'images/signing.png',
                            buttonText: 'apply',
                          ),
                        ),
                        GestureDetector(
                          onTap: (() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return SIForm();
                            }));
                          }),
                          child: MyButtons(
                            iconPath: 'images/calculator.png',
                            buttonText: 'calculator',
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return LoanPaymentForm();
                            }));
                          }),
                          child: MyButtons(
                            iconPath: 'images/cash-withdrawal.png',
                            buttonText: 'repay',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoanEvaluationPage()));
                          },
                          child: MyButtons(
                            iconPath: 'images/checklist.png',
                            buttonText: 'evaluate',
                          ),
                        ),
                        GestureDetector(
                          onTap: (() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return TransferForm();
                            }));
                          }),
                          child: MyButtons(
                            iconPath: 'images/withdraw.png',
                            buttonText: 'WithDraw',
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                     CurrentUser currentUser =
                    Provider.of<CurrentUser>(context, listen: false);
                    String? groupId = currentUser.getCurrentUser.groupId;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentHistoryReport(groupId: groupId!)));
                  },
                  child: MyListTile(
                      imagePath: 'images/pie-chart.png',
                      boldText: 'statistics',
                      normalText: 'transactions and payments'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyTabbedAppBar()));
                  },
                  child: MyListTile(
                      imagePath: 'images/money-bag.png',
                      boldText: 'transactions',
                      normalText: 'history'),
                )
              ],
            ),
          ),
        ),
      );
    
  }
}
