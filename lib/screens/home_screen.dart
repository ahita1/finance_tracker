import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../models/income.dart';
import '../models/expense.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final financeProvider = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          financeProvider.getIncomes(),
          financeProvider.getExpenses(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final incomes = snapshot.data![0] as List<Income>;
            final expenses = snapshot.data![1] as List<Expense>;

            // Ensure initial value is a double
            final totalIncome = incomes.fold(0.0, (sum, item) => sum + item.amount);
            final totalExpense = expenses.fold(0.0, (sum, item) => sum + item.amount);
            final balance = totalIncome - totalExpense;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Income: \$${totalIncome.toStringAsFixed(2)}'),
                  Text('Total Expense: \$${totalExpense.toStringAsFixed(2)}'),
                  Text('Balance: \$${balance.toStringAsFixed(2)}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/income');
                    },
                    child: Text('Manage Income'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/expense');
                    },
                    child: Text('Manage Expense'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
