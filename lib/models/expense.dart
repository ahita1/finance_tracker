class Expense {
  final int id;
  final String description;
  final double amount;
  final DateTime date;

  Expense({required this.id, required this.description, required this.amount, required this.date});

  // Add methods to convert to/from JSON if needed
}
