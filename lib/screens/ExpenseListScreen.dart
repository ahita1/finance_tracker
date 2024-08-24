import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';

class ExpenseListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense List'),
      ),
      body: Consumer<FinanceProvider>(
        builder: (context, financeProvider, child) {
          final expenses = financeProvider.expenses;
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              final title = expense['title'];
              final amount = expense['amount'];
              final date = DateTime.parse(expense['date']);

              return ListTile(
                title: Text(title),
                subtitle: Text(
                    'Amount: \$${amount.toStringAsFixed(2)}\nDate: ${date.toLocal()}'),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
