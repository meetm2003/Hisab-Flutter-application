import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hisab/services.dart';
import 'package:hisab/trans.dart';
import 'package:intl/intl.dart';
import 'expinScr.dart';

class Hisabhomescreen extends StatefulWidget {
  const Hisabhomescreen({super.key});

  @override
  HisabhomescreenState createState() => HisabhomescreenState();
}

class HisabhomescreenState extends State<Hisabhomescreen> {
  final DatabaseService _databaseService = DatabaseService();
  final List<Trans> _transactions = [];
  double money_you_have = 0.0;
  int? _selectedMonth;
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeListeners();
  }

  void _onFilterChanged() {
    setState(() {
      // This will rebuild the UI with the updated filter selections.
    });
  }

  void _initializeListeners() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference transactionRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(user.uid)
          .child('incomes');

      DatabaseReference transactionRef2 = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(user.uid)
          .child('expenses');

      transactionRef.onValue.listen((event) {
        _initializeData();
      });

      transactionRef2.onValue.listen((event) {
        _initializeData();
      });
    }
  }

  Future<void> _initializeData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      money_you_have = await _databaseService.getMoneyYouHave(user.uid);

      final expenses =
          await _databaseService.fetchTransactions(user.uid, false);

      final incomes = await _databaseService.fetchTransactions(user.uid, true);
      setState(() {
        _transactions.clear();
        _transactions.addAll(expenses);
        _transactions.addAll(incomes);
        _transactions.sort((a, b) => b.date.compareTo(a.date));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hisab'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExpensesIncomeScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                DropdownButton<int>(
                  hint: const Text("Select Month"),
                  value: _selectedMonth,
                  items: [
                    const DropdownMenuItem<int>(
                      value: null,
                      child: Text("All Months"),
                    ),
                    ...List.generate(12, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text(
                            DateFormat.MMMM().format(DateTime(0, index + 1))),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    _selectedMonth = value;
                    _onFilterChanged();
                  },
                ),
                const SizedBox(width: 16),
                DropdownButton<int>(
                  hint: const Text("Select Year"),
                  value: _selectedYear,
                  items: [
                    const DropdownMenuItem<int>(
                      value: null, // Represents "No Month" or deselection
                      child: Text("All years"),
                    ),
                    ...List.generate(50, (index) {
                      int year = DateTime.now().year - index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    _selectedYear = value;
                    _onFilterChanged();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildTransactionSections(),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryRow('Total Income:', _calculateTotalIncome()),
                _buildSummaryRow('Total Expenses:', _calculateTotalExpenses()),
                _buildSummaryRow('Money Saved:', _calculateSL(money_you_have)),
                const Divider(),
                _buildSummaryRow('Total:', _calculateTotal(), isTotal: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTransactionSections() {
    final groupedTransactions = _groupTransactionsByDate();

    return groupedTransactions.entries.map((entry) {
      String date = DateFormat('yyyy-MM-dd').format(entry.key);
      List<Trans> transactions = entry.value;
      if ((_selectedMonth == null || entry.key.month == _selectedMonth) &&
          (_selectedYear == null || entry.key.year == _selectedYear)) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            ...transactions.map((transaction) {
              return GestureDetector(
                onLongPress: () {
                  _showEditDeleteMenu(transaction);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transaction.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Rs. ${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color:
                              transaction.isIncome ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(
              height: 15,
            ),
          ],
        );
      } else {
        return Container();
      }
    }).toList();
  }

  Map<DateTime, List<Trans>> _groupTransactionsByDate() {
    final Map<DateTime, List<Trans>> grouped = {};
    for (var transaction in _transactions) {
      DateTime date = DateTime(
          transaction.date.year, transaction.date.month, transaction.date.day);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(transaction);
    }
    return grouped;
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 16,
            ),
          ),
          Text(
            'Rs. ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: amount < 0 ? Colors.red : Colors.green,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 16,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalIncome() {
    return _transactions
        .where((transaction) =>
            transaction.isIncome &&
            (_selectedMonth == null ||
                transaction.date.month == _selectedMonth) &&
            (_selectedYear == null || transaction.date.year == _selectedYear))
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double _calculateTotalExpenses() {
    return _transactions
        .where((transaction) =>
            !transaction.isIncome &&
            (_selectedMonth == null ||
                transaction.date.month == _selectedMonth) &&
            (_selectedYear == null || transaction.date.year == _selectedYear))
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double _calculateTotal() {
    return _calculateTotalIncome() - _calculateTotalExpenses();
  }

  double _calculateSL(double moneyYouHave) {
    double SL = 0.0;
    double dailyExpenses = 0.0;
    int datesCount = 0;

    // Sort transactions by date
    final filteredTransactions = _transactions
        .where((transaction) =>
            (_selectedMonth == null ||
                transaction.date.month == _selectedMonth) &&
            (_selectedYear == null || transaction.date.year == _selectedYear))
        .toList();
    filteredTransactions.sort((a, b) => a.date.compareTo(b.date));

    DateTime? currentDate;
    bool hasExpensesOnDate = false;

    for (var transaction in filteredTransactions) {
      if (currentDate == null || transaction.date != currentDate) {
        if (currentDate != null && hasExpensesOnDate) {
          SL -= dailyExpenses;
          datesCount++;
        }

        dailyExpenses = 0.0;
        hasExpensesOnDate = false;
        currentDate = transaction.date;
      }

      if (!transaction.isIncome) {
        dailyExpenses += transaction.amount;
        hasExpensesOnDate = true;
      }
    }

    if (hasExpensesOnDate) {
      SL -= dailyExpenses;
      datesCount++;
    }

    SL = moneyYouHave * datesCount + SL;

    return SL;
  }

  void _showEditDeleteMenu(Trans transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an action'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editTransaction(transaction);
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTransaction(transaction);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editTransaction(Trans transaction) {
    final TextEditingController nameController =
        TextEditingController(text: transaction.name);
    final TextEditingController amountController =
        TextEditingController(text: transaction.amount.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateTransactionInDatabase(transaction, nameController.text,
                    double.parse(amountController.text));
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTransaction(Trans transaction) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle the case where the user is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    // Determine if the transaction is an income or expense
    String transactionType = transaction.isIncome ? 'incomes' : 'expenses';

    DatabaseReference transactionRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(user.uid)
        .child(transactionType)
        .child(transaction.transactionId); // Use the correct identifier

    transactionRef.remove();
  }

  void _updateTransactionInDatabase(
      Trans transaction, String newNote, double newAmount) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle the case where the user is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    // Determine if the transaction is an income or expense
    String transactionType = transaction.isIncome ? 'incomes' : 'expenses';

    DatabaseReference transactionRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(user.uid)
        .child(transactionType)
        .child(transaction.transactionId); // Use the correct identifier

    transactionRef.update({
      'amount': newAmount,
      'name': newNote,
      'date': transaction.date.toIso8601String(),
    });
  }
}
