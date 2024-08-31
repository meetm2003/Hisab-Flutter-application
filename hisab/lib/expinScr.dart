import 'package:flutter/material.dart';
import 'package:hisab/expensesScr.dart';
import 'package:hisab/hisabHomeScreen.dart';
import 'package:hisab/incomeScr.dart';
import 'package:hisab/profileScr.dart';

class ExpensesIncomeScreen extends StatelessWidget {
  const ExpensesIncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const Hisabhomescreen()),
              );
            },
            child: const Text('Hisab'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                 Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Expenses'),
              Tab(text: 'Income'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ExpensesScreen(),
            IncomeScreen(),
          ],
        ),
      ),
    );
  }
}
