import 'package:flutter/material.dart';
import 'package:hisab/expensesScr.dart';
import 'package:hisab/hisabHomeScreen.dart';
import 'package:hisab/incomeScr.dart';

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
                // Add your logic for the profile button here
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
