import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../services/currency_service.dart';

class FinanceProvider with ChangeNotifier {
  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  List<Map<String, dynamic>> _incomes = [];
  List<Map<String, dynamic>> _expenses = [];

  final CurrencyService _currencyService = CurrencyService();

  double get totalIncome => _totalIncome;
  double get totalExpenses => _totalExpenses;

  double get balance => _totalIncome - _totalExpenses;

  List<Map<String, dynamic>> get incomes => _incomes;
  List<Map<String, dynamic>> get expenses => _expenses;

  Future<List<Map<String, dynamic>>> fetchIncomes() async {
    print('Fetching incomes...');
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> incomeData = await db.query('incomes');
    print('Fetched Incomes: $incomeData'); // Debug print
    _incomes = incomeData;
    _totalIncome = _incomes.fold(0, (sum, item) => sum + (item['amount'] as double));
    notifyListeners();
    return _incomes;
  }

  Future<List<Map<String, dynamic>>> fetchExpenses() async {
    print('Fetching expenses...');
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> expenseData = await db.query('expenses');
    print('Fetched Expenses: $expenseData'); // Debug print
    _expenses = expenseData;
    _totalExpenses = _expenses.fold(0, (sum, item) => sum + (item['amount'] as double));
    notifyListeners();
    return _expenses;
  }

  Future<void> addIncome(String title, double amount, DateTime date, String category) async {
    final db = await DatabaseHelper().database;
    await db.insert('incomes', {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
    });
    await fetchIncomes(); // Refresh the list after adding
  }

  Future<void> addExpense(String title, double amount, DateTime date) async {
    final db = await DatabaseHelper().database;
    await db.insert('expenses', {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
    });
    await fetchExpenses(); // Refresh the list after adding
  }

  Future<Map<String, double>> getConversionRates() async {
    final rates = await _currencyService.fetchConversionRates();
    print('Conversion Rates: $rates'); // Log the API response
    return rates;
  }

  Future<Map<String, double>> convertBalanceToCurrencies() async {
    final conversionRates = await getConversionRates();
    final balanceInEtb = this.balance; // Balance is in ETB
    
    // Convert ETB to other currencies
    return {
      'EUR': _currencyService.convertAmount(balanceInEtb, conversionRates['EUR'] ?? 0.0),
      'GBP': _currencyService.convertAmount(balanceInEtb, conversionRates['GBP'] ?? 0.0),
      'USD': _currencyService.convertAmount(balanceInEtb, conversionRates['USD'] ?? 0.0),
      'JPY': _currencyService.convertAmount(balanceInEtb, conversionRates['JPY'] ?? 0.0),
    };
  }
}
