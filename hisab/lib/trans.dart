class Trans {
  final String transactionId; // Unique identifier
  final String name;
  final double amount;
  final bool isIncome;
  final DateTime date;

  Trans({
    required this.transactionId,
    required this.name,
    required this.amount,
    required this.isIncome,
    required this.date,
  });
}
