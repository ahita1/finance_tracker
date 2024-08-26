import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/finance_provider.dart';
import 'spend_item.dart'; // Import the SpendItem widget

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  late Future<List<Map<String, dynamic>>> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _expensesFuture = Provider.of<FinanceProvider>(context, listen: false).fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense List',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        centerTitle: true,
        backgroundColor: Colors.blue, // Background color
        iconTheme: IconThemeData(
          color: Colors.white, // Set icon color to white
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _expensesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No expense data available for this budget cycle'));
          }

          final expenses = snapshot.data!;
          return ListView(
            children: expenses.map((expense) {
              final title = expense['title'] ?? 'No Title';
              final amount = (expense['amount'] as double?)?.toStringAsFixed(2) ?? '0.00';
              final date = expense['date'] != null
                  ? DateTime.parse(expense['date']).toLocal()
                  : DateTime.now();
              final formattedDate = "${date.day}/${date.month}/${date.year}";

              return SpendItem(
                icon: Icons.money_off, // Use an appropriate icon
                title: title,
                date: formattedDate,
                amount: 'ETB $amount', // Prefix with ETB
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
