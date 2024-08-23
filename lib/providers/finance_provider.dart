import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/income.dart';
import '../models/expense.dart';
import '../services/database_helper.dart';

class FinanceProvider with ChangeNotifier {
  // Add your state management logic here
  
  Future<List<Income>> getIncomes() async {
    final db = await DatabaseHelper.instance.database;
    // Fetch data from the database
    return [];
  }

  Future<List<Expense>> getExpenses() async {
    final db = await DatabaseHelper.instance.database;
    // Fetch data from the database
    return [];
  }
}
