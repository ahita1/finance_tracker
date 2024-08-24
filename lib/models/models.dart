class Income {
  final int id;
  final String source;
  final double amount;
  final DateTime date;

  Income({required this.id, required this.source, required this.amount, required this.date});

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      source: json['source'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}

class Expense {
  final int id;
  final String description;
  final double amount;
  final DateTime date;

  Expense({required this.id, required this.description, required this.amount, required this.date});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      description: json['description'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}
