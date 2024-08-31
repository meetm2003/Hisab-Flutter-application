import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hisab/custom_textfield.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController rupeeController = TextEditingController();
    final TextEditingController dateController = TextEditingController(
      text: DateTime.now().toLocal().toString().split(' ')[0],
    );

    final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

    Future<void> _addExpense() async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String expenseName = nameController.text.trim();
        double expenseAmount = double.parse(rupeeController.text.trim());
        String date = dateController.text.trim();

        Map<String, dynamic> expenseData = {
          'name': expenseName,
          'amount': expenseAmount,
          'date': date,
        };

        await _databaseRef
            .child('users')
            .child(user.uid)
            .child('expenses')
            .push()
            .set(expenseData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added successfully')),
        );

        nameController.clear();
        rupeeController.clear();
        dateController.text = DateTime.now().toLocal().toString().split(' ')[0];
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CustomTextField(
            hint: 'Expense Name',
            color: Colors.blue,
            controller: nameController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: 'Expense Amount (Rs.)',
            color: Colors.blue,
            controller: rupeeController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: 'Date',
            color: Colors.blue,
            controller: dateController,
            isDatePicker: true,
          ),
          const SizedBox(height: 16),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  _addExpense();
                },
                child: const Text(
                  'Add Expense',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}