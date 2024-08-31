import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hisab/custom_textfield.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController rupeeController = TextEditingController();
    final TextEditingController dateController = TextEditingController(
      text: DateTime.now().toLocal().toString().split(' ')[0],
    );

     final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

    Future<void> _addIncome() async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String incomeName = nameController.text.trim();
        double incomeAmount = double.parse(rupeeController.text.trim());
        String date = dateController.text.trim();

        // Create a new income entry
        Map<String, dynamic> incomeData = {
          'name': incomeName,
          'amount': incomeAmount,
          'date': date,
        };

        // Push the income data to the database under the user's node
        await _databaseRef
            .child('users')
            .child(user.uid)
            .child('incomes')
            .push()
            .set(incomeData);

        // Optionally, show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Income added successfully')),
        );

        // Clear the text fields
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
            hint: 'Income Name',
            color: Colors.green,
            controller: nameController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: 'Income Amount (Rs.)',
            color: Colors.green,
            controller: rupeeController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: 'Date',
            color: Colors.green,
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
                  _addIncome();
                },
                child: const Text(
                  'Add Income',
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