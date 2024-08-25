import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch expenses when the screen is initialized
    Provider.of<FinanceProvider>(context, listen: false).fetchExpenses();
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text;
      final double amount = double.tryParse(_amountController.text) ?? 0.0;
      final DateTime enteredDate = DateTime.now();

      // Add expense and handle the result
      Provider.of<FinanceProvider>(context, listen: false)
          .addExpense(title, amount, enteredDate)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Expense added successfully!')),
        );
        _titleController.clear();
        _amountController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Expense Tracker'),
      //   backgroundColor: theme.appBarTheme.backgroundColor,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Displaying the total expense at the top
            Consumer<FinanceProvider>(
              builder: (context, financeProvider, child) {
                return Text(
                  'Total Expenses: \$${financeProvider.totalExpenses.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor, // Use primary color
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            // Expense Form
            _buildExpenseForm(),
            SizedBox(height: 20),
            // Displaying expenses in a list
            Expanded(
              child: Consumer<FinanceProvider>(
                builder: (context, financeProvider, child) {
                  return ListView.builder(
                    itemCount: financeProvider.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = financeProvider.expenses[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            expense['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Date: ${DateTime.parse(expense['date']).toLocal().toString().split(' ')[0]}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: Text(
                            '\$${expense['amount'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor, // Use primary color
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildExpenseForm() {
  final theme = Theme.of(context); // Get the current theme

  return Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 2.0), // Use primary color
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _amountController,
          decoration: InputDecoration(
            labelText: 'Amount',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 2.0), // Use primary color
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _saveExpense,
          child: Text('Add Expense'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Use primary color
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Set text color to white
            ),
          ),
        ),
      ],
    ),
  );
}

}
