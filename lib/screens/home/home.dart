// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:join_create_group_functionality/screens/deposit/deposit_page.dart';
import 'package:join_create_group_functionality/screens/profile/profile_page.dart';
import 'package:join_create_group_functionality/utils/loanmanagement/application.dart';
import 'package:join_create_group_functionality/utils/loanmanagement/disbursal.dart';
import 'package:join_create_group_functionality/utils/loanmanagement/evaluation.dart';
import 'package:join_create_group_functionality/utils/loanmanagement/management.dart';
import 'package:join_create_group_functionality/utils/my_buttons.dart';
import 'package:join_create_group_functionality/utils/my_card.dart';
import 'package:join_create_group_functionality/utils/my_list_tiles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = PageController();
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
                        child: Icon(Icons.add),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 200,
                  child: PageView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    children: [
                      MyCard(
                        balance: 200.256,
                        GroupName: 'Fridays',
                        color: Colors.deepPurple[300],
                      ),
                      MyCard(
                        balance: 5075.56,
                        GroupName: 'Malates',
                        color: Colors.pink[300],
                      ),
                      MyCard(
                        balance: 1056.23,
                        GroupName: 'Kamulis',
                        color: Colors.green[300],
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
                              return CashDeposit();
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
                        MyButtons(
                          iconPath: 'images/calculator.png',
                          buttonText: 'Calculator',
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
                SizedBox(
                  height: 25,
                ),
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
