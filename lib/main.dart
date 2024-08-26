import 'package:finance_tracker/screens/expense_list_screen.dart';
import 'package:finance_tracker/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'providers/finance_provider.dart';
import 'screens/income_screen.dart';
import 'screens/expense_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  // Ensure that the Flutter framework is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database settings for desktop platforms
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize the database helper
  final dbHelper = DatabaseHelper();

  // Optionally delete the existing database (for development/debugging purposes)
  // if (Platform.isAndroid || Platform.isIOS) {
  //   // Avoid deleting the database on mobile platforms
  //   await dbHelper.deleteDatabase();
  // }

  // Recreate the database
  await dbHelper.database;

  // Run the app
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
            backgroundColor: Colors.blueAccent, // Background color of the AppBar
            elevation: 4, // Elevation for shadow effect
            titleTextStyle: TextStyle(
              color: Colors.white, // Color of the AppBar title
              fontSize: 20, // Font size of the AppBar title
              fontWeight: FontWeight.bold, // Font weight of the AppBar title
            ),
            iconTheme: IconThemeData(
              color: Colors.white, // Color of the AppBar icons
            ),
          ),
        ),
        debugShowCheckedModeBanner: false, // Add this line to remove the DEBUG banner
        initialRoute: '/', // Set the initial route to the HomeScreen
        routes: {
          '/': (context) => ExpenseApp(),
          '/income': (context) => AddIncomeScreen(),
          '/expense': (context) => AddExpenseScreen(),
          '/viewexpenses': (context) => ExpenseListScreen(),
        },
      ),
    );
  }
}
