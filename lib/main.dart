import 'package:finance_tracker/screens/expense/expense_list_screen.dart';
import 'package:finance_tracker/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'providers/finance_provider.dart';
import 'screens/income/income_screen.dart';
import 'screens/expense/expense_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/intro_screen/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  final dbHelper = DatabaseHelper();
  await dbHelper.database;
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
          appBarTheme: AppBarTheme(
            backgroundColor:
                Colors.blueAccent, 
            elevation: 4, 
            titleTextStyle: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold, 
            ),
            iconTheme: IconThemeData(
              color: Colors.white, 
            ),
          ),
        ),
        debugShowCheckedModeBanner:
            false, 
        initialRoute: '/', 
        routes: {
          '/': (context) => IntoScreen(),
          '/expp': (context) => HomeScreen(),
          '/income': (context) => AddIncomeScreen(),
          '/expense': (context) => AddExpenseScreen(),
          '/viewexpenses': (context) => ExpenseListScreen(),
        },
      ),
    );
  }
}
