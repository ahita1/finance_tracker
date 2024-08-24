import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import './bottom_bar.dart';
import './income_screen.dart'; // Import IncomeScreen
import './expense_screen.dart'; // Import ExpenseScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final financeProvider = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home/Root Screen
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Income: \$${financeProvider.totalIncome.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Expenses: \$${financeProvider.totalExpenses.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Balance: \$${financeProvider.balance.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Balance in EUR: €${financeProvider.convertToEur(financeProvider.balance).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Balance in GBP: £${financeProvider.convertToGbp(financeProvider.balance).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
          ),
          // Income Screen
          IncomeScreen(),
          // Expenses Screen
          ExpenseScreen(),
        ],
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
