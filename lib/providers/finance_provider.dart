import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../services/currency_service.dart';

class FinanceProvider with ChangeNotifier {
  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  List<Map<String, dynamic>> _incomes = [];
  List<Map<String, dynamic>> _expenses = [];
  String _currentCycle = _getCurrentBudgetCycle(); 

  final CurrencyService _currencyService = CurrencyService();

  double get totalIncome => _totalIncome;
  double get totalExpenses => _totalExpenses;

  double get balance => _totalIncome - _totalExpenses;

  List<Map<String, dynamic>> get incomes => _incomes;
  List<Map<String, dynamic>> get expenses => _expenses;
  String get currentCycle => _currentCycle;

  // Determine if the current budget cycle matches the system date
  bool get isCurrentCycle => _currentCycle == _getCurrentBudgetCycle();

  static String _getCurrentBudgetCycle() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}";
  }

  Future<void> setBudgetCycle(String cycle) async {
    _currentCycle = cycle;
    await fetchIncomes();
    await fetchExpenses();
  }

  Future<List<Map<String, dynamic>>> fetchIncomes({int limit = 10, int offset = 0}) async {
    try {
      final db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> incomeData = await db.query(
        'incomes',
        where: 'budget_cycle = ?',
        whereArgs: [_currentCycle],
        orderBy: 'date DESC', 
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _incomes = incomeData;
      } else {
        _incomes.addAll(incomeData);
      }
      _totalIncome =
          _incomes.fold(0, (sum, item) => sum + (item['amount'] as double));
      notifyListeners();
      return _incomes;
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchExpenses({int limit = 10, int offset = 0}) async {
    try {
      final db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> expenseData = await db.query(
        'expenses',
        where: 'budget_cycle = ?',
        whereArgs: [_currentCycle],
        orderBy: 'date DESC', 
        limit: limit,
        offset: offset,
      );
      if (offset == 0) {
        _expenses = expenseData;
      } else {
        _expenses.addAll(expenseData);
      }
      _totalExpenses =
          _expenses.fold(0, (sum, item) => sum + (item['amount'] as double));
      notifyListeners();
      return _expenses;
    } catch (e) {
      return [];
    }
  }

  Future<void> addIncome(
      String title, double amount, DateTime date, String category) async {
    final db = await DatabaseHelper().database;
    await db.insert('incomes', {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'budget_cycle': _currentCycle,
    });
    await fetchIncomes(); 
  }

  Future<void> addExpense(String title, double amount, DateTime date) async {
    final db = await DatabaseHelper().database;
    await db.insert('expenses', {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'budget_cycle': _currentCycle,
    });
    await fetchExpenses(); 
  }

  Future<void> startNewBudgetCycle() async {
    _currentCycle = _getCurrentBudgetCycle();
    await fetchIncomes();
    await fetchExpenses();
  }

  Future<Map<String, double>> getConversionRates() async {
    final rates = await _currencyService.fetchConversionRates();
    return rates;
  }

  Future<Map<String, double>> convertBalanceToCurrencies() async {
    final conversionRates = await getConversionRates();
    final balanceInEtb = this.balance;

    return {
      'EUR': _currencyService.convertAmount(
          balanceInEtb, conversionRates['EUR'] ?? 0.0),
      'GBP': _currencyService.convertAmount(
          balanceInEtb, conversionRates['GBP'] ?? 0.0),
      'USD': _currencyService.convertAmount(
          balanceInEtb, conversionRates['USD'] ?? 0.0),
      'JPY': _currencyService.convertAmount(
          balanceInEtb, conversionRates['JPY'] ?? 0.0),
    };
  }
}
