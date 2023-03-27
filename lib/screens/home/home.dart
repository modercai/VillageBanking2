// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/deposit/deposit_page.dart';
import 'package:join_create_group_functionality/screens/deposit/new_deposit_page.dart';
import 'package:join_create_group_functionality/screens/noGroup/nogroup.dart';
import 'package:join_create_group_functionality/screens/profile/profile_page.dart';
import 'package:join_create_group_functionality/splashScreen/splash.dart';
import 'package:join_create_group_functionality/utils/loanmanagement/application.dart';
import 'package:join_create_group_functionality/utils/my_buttons.dart';
import 'package:join_create_group_functionality/utils/my_card.dart';
import 'package:join_create_group_functionality/utils/my_list_tiles.dart';
import 'package:join_create_group_functionality/utils/second_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = PageController();
  final user = FirebaseAuth.instance.currentUser!;

  double _getTransactionsTotal(
      QuerySnapshot<Map<String, dynamic>> transactionsSnapshot) {
    double total = 0.0;
    final transactionsDocs = transactionsSnapshot.docs;
    for (final transactionDoc in transactionsDocs) {
      final amount = transactionDoc.get('amount');
      total += amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[400]),
                        child: GestureDetector(
                          child: Icon(Icons.add),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OurNoGroup()));
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(color: Colors.grey,),
                  child: PageView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Scaffold(
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
                                final groupDoc = groupDocs[index];
                                return StreamBuilder<
                                    QuerySnapshot<Map<String, dynamic>>>(
                                  stream: groupDoc.reference
                                      .collection('transactions')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<
                                              QuerySnapshot<
                                                  Map<String, dynamic>>>
                                          snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox.shrink();
                                    }
                                    final transactionsSnapshot = snapshot.data!;
                                    final total = _getTransactionsTotal(
                                        transactionsSnapshot);
                                    return Row(
                                      children: [
                                        MyCard(
                                            balance: total,
                                            groupName: groupDoc.get('name'),
                                            personalBalance: 0.0),
                                        StreamBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                          stream: groupDoc.reference
                                              .collection('loan_payments')
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<
                                                      QuerySnapshot<
                                                          Map<String, dynamic>>>
                                                  snapshot) {
                                            if (!snapshot.hasData) {
                                              return const SizedBox.shrink();
                                            }
                                            final loanPaymentsDocs =
                                                snapshot.data!.docs;
                                            // Retrieve the latest loan payment document
                                            final latestLoanPaymentDoc =
                                                loanPaymentsDocs.last;
                                            // Get the remaining balance field from the document
                                            final remainingBalance =
                                                latestLoanPaymentDoc
                                                    .get('remaining_balance');
                                                    final paidAmount =
                                                latestLoanPaymentDoc
                                                    .get('payment_amount');
                                            return MySecondCard(
                                              remainingBalance:
                                                  remainingBalance,
                                              amountPaid:
                                                  paidAmount,
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  effect:
                      ExpandingDotsEffect(activeDotColor: Colors.grey.shade600),
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
                            buttonText: 'Transact',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoanApplicationPage()));
                          },
                          child: MyButtons(
                            iconPath: 'images/cash-withdrawal.png',
                            buttonText: 'Apply',
                          ),
                        ),
                        GestureDetector(
                          onTap: (() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return SplashScreen();
                            }));
                          }),
                          child: MyButtons(
                            iconPath: 'images/calculator.png',
                            buttonText: 'Calculator',
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 25,
                ),
                MyListTile(
                    imagePath: 'images/pie-chart.png',
                    boldText: 'Statistics',
                    normalText: 'Transactions and Payments'),
                MyListTile(
                    imagePath: 'images/money-bag.png',
                    boldText: 'Transactions',
                    normalText: 'History')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
