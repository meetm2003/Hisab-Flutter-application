import 'package:firebase_database/firebase_database.dart';
import 'package:hisab/trans.dart';

class DatabaseService {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  Future<double> getMoneyYouHave(String uid) async {
    final DataSnapshot snapshot = await _databaseRef
        .child('users')
        .child(uid)
        .child('money_you_have')
        .get();

    if (snapshot.exists) {
      return double.parse(snapshot.value.toString());
    } else {
      return 0.0; // Default value if money_you_have doesn't exist
    }
  }

  Future<List<Trans>> fetchTransactions(String userUid, bool isIncome) async {
    final DatabaseReference ref =
        _databaseRef.child('users').child(userUid).child(isIncome ? 'incomes' : 'expenses');
    final DataSnapshot snapshot = await ref.get();

    final List<Trans> transactions = [];
    if (snapshot.exists) {
      for (var child in snapshot.children) {
        final dateStr = child.child('date').value.toString();
        final amount = double.parse(child.child('amount').value.toString());
        final name = child.child('name').value.toString();
        final id = child.key!;

        transactions.add(Trans(
          transactionId: id,
          name: name,
          amount: amount,
          isIncome: isIncome,
          date: DateTime.parse(dateStr),
        ));
      }
    }
    return transactions;
  }
}
