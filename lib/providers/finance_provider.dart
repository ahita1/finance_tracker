  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;

  class FinanceProvider with ChangeNotifier {
    List<Map<String, dynamic>> _incomeItems = [];
    List<Map<String, dynamic>> _expenseItems = [];
    double _balance = 1000.0; // Set initial balance in ETB
    double _usdToEurRate = 0.0;
    double _usdToCadRate = 0.0;
    double _usdToGbpRate = 0.0;
    double _etbToUsdRate = 0.0; // ETB to USD conversion rate

    List<Map<String, dynamic>> get incomeItems => _incomeItems;
    List<Map<String, dynamic>> get expenseItems => _expenseItems;
    double get balance => _balance;

    FinanceProvider() {
      _fetchData();
      _fetchExchangeRates();
    }

    Future<void> _fetchData() async {
      // Placeholder data fetching logic
      _incomeItems = [
        {'amount': 50.0},
        {'amount': 30.0}
      ]; // Example data
      _expenseItems = [
        {'amount': 20.0},
        {'amount': 10.0}
      ]; // Example data
      _calculateBalance();

      // Test currency conversion
      print('Balance in ETB: $_balance');
      print('Converted to USD: ${convertToUsd(_balance)}');
      print('Converted to CAD: ${convertToCad(_balance)}');
      print('Converted to EUR: ${convertToEur(_balance)}');
      print('Converted to GBP: ${convertToGbp(_balance)}');

      notifyListeners();
    }
Future<void> _fetchExchangeRates() async {
  try {
    final response = await http.get(Uri.parse('https://api.currencyfreaks.com/v2.0/rates/latest?apikey=c63d2795da3d42f3ab978753d9b3070c'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Exchange Rates Data: $data'); // Debugging output

      if (data['rates'] != null) {
        var rates = data['rates'];

        // Get the ETB to USD rate
        _etbToUsdRate = 1 / (double.tryParse(rates['USD'] ?? '1.0') ?? 1.0);

        // Calculate other rates based on ETB to USD
        _usdToEurRate = double.tryParse(rates['EUR'] ?? '0.0') ?? 0.0 * _etbToUsdRate;
        _usdToCadRate = double.tryParse(rates['CAD'] ?? '0.0') ?? 0.0 * _etbToUsdRate;
        _usdToGbpRate = double.tryParse(rates['GBP'] ?? '0.0') ?? 0.0 * _etbToUsdRate;

        print('ETB to USD Rate: $_etbToUsdRate'); // Debugging output
        print('USD to EUR Rate based on ETB: $_usdToEurRate'); // Debugging output
        print('USD to CAD Rate based on ETB: $_usdToCadRate'); // Debugging output
        print('USD to GBP Rate based on ETB: $_usdToGbpRate'); // Debugging output
      } else {
        print('No rates field found in response');
      }
    } else {
      print('Failed to load exchange rates: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Exception occurred while fetching exchange rates: $e');
  }

  notifyListeners();
}

    void _calculateBalance() {
      double incomeTotal = _incomeItems.fold(0.0, (sum, item) => sum + item['amount']);
      double expenseTotal = _expenseItems.fold(0.0, (sum, item) => sum + item['amount']);
      _balance = incomeTotal - expenseTotal;
    }

    Future<void> addItem(String type, Map<String, dynamic> item) async {
      if (type == 'income') {
        _incomeItems.add(item);
      } else if (type == 'expense') {
        _expenseItems.add(item);
      }
      _calculateBalance();
      notifyListeners();
    }

    Future<void> updateItem(String type, int index, Map<String, dynamic> item) async {
      if (type == 'income') {
        _incomeItems[index] = item;
      } else if (type == 'expense') {
        _expenseItems[index] = item;
      }
      _calculateBalance();
      notifyListeners();
    }

    Future<void> deleteItem(String type, int index) async {
      if (type == 'income') {
        _incomeItems.removeAt(index);
      } else if (type == 'expense') {
        _expenseItems.removeAt(index);
      }
      _calculateBalance();
      notifyListeners();
    }

    Map<String, dynamic> getItem(String type, int index) {
      if (type == 'income') {
        return _incomeItems[index];
      } else {
        return _expenseItems[index];
      }
    }

    double convertToUsd(double amount) {
      return amount * _etbToUsdRate; // Conversion from ETB to USD
    }

    double convertToCad(double amount) {
      double usdAmount = convertToUsd(amount);
      return usdAmount * _usdToCadRate; // Conversion from USD to CAD
    }

    double convertToEur(double amount) {
      double usdAmount = convertToUsd(amount);
      return usdAmount * _usdToEurRate; // Conversion from USD to EUR
    }

    double convertToGbp(double amount) {
      double usdAmount = convertToUsd(amount);
      return usdAmount * _usdToGbpRate; // Conversion from USD to GBP
    }
  }
