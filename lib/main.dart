import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import for FFI support
import 'providers/finance_provider.dart';
import 'screens/home_screen.dart';
import 'screens/income_screen.dart';
import 'screens/expense_screen.dart';
import 'screens/add_edit_item_screen.dart';

void main() {
  // Initialize sqflite_common_ffi
  sqfliteFfiInit(); // Initialize FFI support for sqflite
  databaseFactory = databaseFactoryFfi; // Use FFI-based databaseFactory

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FinanceProvider()),
      ],
      child: MaterialApp(
        title: 'Finance Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
        routes: {
          '/income': (context) => IncomeScreen(),
          '/expense': (context) => ExpenseScreen(),
          '/add_edit': (context) => AddEditItemScreen(),
        },
      ),
    );
  }
}
