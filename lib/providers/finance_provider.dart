import 'package:flutter/material.dart';

class FinanceProvider with ChangeNotifier {
  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  List<Map<String, dynamic>> _incomes = [];
  List<Map<String, dynamic>> _expenses = [];

  double get totalIncome => _totalIncome;
  double get totalExpenses => _totalExpenses;

  List<Map<String, dynamic>> get incomes => _incomes;
  List<Map<String, dynamic>> get expenses => _expenses;

  Future<void> addIncome(String title, double amount) async {
    _incomes.add({'title': title, 'amount': amount});
    _totalIncome += amount;
    notifyListeners();
  }

  Future<void> addExpense(String title, double amount, DateTime date) async {
    _expenses.add(
        {'title': title, 'amount': amount, 'date': date.toIso8601String()});
    _totalExpenses += amount;
    notifyListeners();
  }
}
