import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;

import 'providers/finance_provider.dart';
import 'screens/income_screen.dart';
import 'screens/expense_screen.dart';
import 'screens/home_screen.dart';

void main() {
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
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
        initialRoute: '/', // Set the initial route to the IncomeScreen
        routes: {
          
          '/': (context) => HomeScreen(),
          '/income': (context) => IncomeScreen(),
          '/expense': (context) => ExpenseScreen(),
          // '/add_edit': (context) => AddEditItemScreen(),
        },
      ),
    );
  }
}
