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

  Future<void> fetchIncomes() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> incomeData = await db.query('incomes');
    _incomes = incomeData;
    _totalIncome = _incomes.fold(0, (sum, item) => sum + (item['amount'] as double));
    notifyListeners();
  }

  Future<void> fetchExpenses() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> expenseData = await db.query('expenses');
    _expenses = expenseData;
    _totalExpenses = _expenses.fold(0, (sum, item) => sum + (item['amount'] as double));
    notifyListeners();
  }

  Future<void> addIncome(String title, double amount) async {
    final db = await DatabaseHelper().database;
    await db.insert('incomes', {
      'title': title,
      'amount': amount,
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
    return await _currencyService.fetchConversionRates();
  }

  Future<Map<String, double>> convertBalanceToCurrencies() async {
    final conversionRates = await getConversionRates();
    final balanceInEtb = this.balance; // Assuming the balance is in ETB
    
    // Convert ETB to USD
    double etbToUsdRate = conversionRates['USD'] ?? 1.0; // Get USD rate from conversion rates
    double balanceInUsd = balanceInEtb / etbToUsdRate; // Convert ETB to USD
    
    return {
      'EUR': _currencyService.convertAmount(balanceInUsd, conversionRates['EUR'] ?? 0.0),
      'GBP': _currencyService.convertAmount(balanceInUsd, conversionRates['GBP'] ?? 0.0),
      'USD': balanceInUsd, // USD is the base currency
      'JPY': _currencyService.convertAmount(balanceInUsd, conversionRates['JPY'] ?? 0.0),
    };
  }
}
