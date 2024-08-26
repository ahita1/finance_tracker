import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../services/currency_service.dart';

class FinanceProvider with ChangeNotifier {
  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  List<Map<String, dynamic>> _incomes = [];
  List<Map<String, dynamic>> _expenses = [];
  String _currentCycle = _getCurrentBudgetCycle();  // Current budget cycle

  final CurrencyService _currencyService = CurrencyService();

  double get totalIncome => _totalIncome;
  double get totalExpenses => _totalExpenses;

  double get balance => _totalIncome - _totalExpenses;

  List<Map<String, dynamic>> get incomes => _incomes;
  List<Map<String, dynamic>> get expenses => _expenses;
  String get currentCycle => _currentCycle;

  // Method to get the current budget cycle in the format "YYYY-MM"
  static String _getCurrentBudgetCycle() {
    final now = DateTime.now();
    return "${now.year}-${now.month}";
  }

  // Fetch incomes for the current budget cycle
  Future<List<Map<String, dynamic>>> fetchIncomes() async {
    try {
      final db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> incomeData = await db.query(
        'incomes',
        where: 'budget_cycle = ?',
        whereArgs: [_currentCycle],
      );
      print('Fetched incomes: $incomeData');  // Debug statement
      _incomes = incomeData;
      _totalIncome = _incomes.fold(0, (sum, item) => sum + (item['amount'] as double));
      notifyListeners();
      return _incomes;
    } catch (e) {
      print('Error fetching incomes: $e');  // Debug statement
      return [];
    }
  }

  // Fetch expenses for the current budget cycle
  Future<List<Map<String, dynamic>>> fetchExpenses() async {
    try {
      final db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> expenseData = await db.query(
        'expenses',
        where: 'budget_cycle = ?',
        whereArgs: [_currentCycle],
      );
      print('Fetched expenses: $expenseData');  // Debug statement
      _expenses = expenseData;
      _totalExpenses = _expenses.fold(0, (sum, item) => sum + (item['amount'] as double));
      notifyListeners();
      return _expenses;
    } catch (e) {
      print('Error fetching expenses: $e');  // Debug statement
      return [];
    }
  }

  // Add a new income with the current budget cycle
  Future<void> addIncome(String title, double amount, DateTime date, String category) async {
    final db = await DatabaseHelper().database;
    await db.insert('incomes', {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'budget_cycle': _currentCycle,  // Store the current budget cycle
    });
    await fetchIncomes(); // Refresh the list after adding
    notifyListeners(); // Notify listeners to update balance
  }

  // Add a new expense with the current budget cycle
  Future<void> addExpense(String title, double amount, DateTime date) async {
    final db = await DatabaseHelper().database;
    await db.insert('expenses', {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'budget_cycle': _currentCycle,  // Store the current budget cycle
    });
    await fetchExpenses(); // Refresh the list after adding
    notifyListeners(); // Notify listeners to update balance
  }

  // Start a new budget cycle (typically called at the beginning of a new month)
  Future<void> startNewBudgetCycle() async {
    _currentCycle = _getCurrentBudgetCycle(); // Update the current budget cycle
    await fetchIncomes();
    await fetchExpenses();
  }

  // Fetches currency conversion rates
  Future<Map<String, double>> getConversionRates() async {
    final rates = await _currencyService.fetchConversionRates();
    return rates;
  }

  // Converts the balance to other currencies based on conversion rates
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
