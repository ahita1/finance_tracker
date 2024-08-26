import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
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
        title: Text('Expense List'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _expensesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No expense data available'));
          }

          final expenses = snapshot.data!;
          return ListView(
            children: expenses.map((expense) {
              final title = expense['title'] ?? 'No Title';
              final amount = expense['amount']?.toStringAsFixed(2) ?? '0.00';
              final date = expense['date'] != null
                  ? DateTime.parse(expense['date']).toLocal()
                  : DateTime.now();
              final formattedDate = "${date.day}/${date.month}/${date.year}";

              return SpendItem(
                icon: Icons.money_off, // Use an appropriate icon
                title: title,
                date: formattedDate,
                amount: '- \$${amount}', // Negative for expenses
                paymentMethod: 'Unknown', // You can add paymentMethod field to your expense table if needed
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
