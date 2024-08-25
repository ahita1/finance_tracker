import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';

class IncomeScreen extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch incomes when the screen is initialized
    Provider.of<FinanceProvider>(context, listen: false).fetchIncomes();
  }

  void _saveIncome() {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      double amount = double.tryParse(_amountController.text) ?? 0.0;

      Provider.of<FinanceProvider>(context, listen: false)
          .addIncome(title, amount)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Income added successfully!')),
        );
        _titleController.clear();
        _amountController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Displaying the total income at the top
            Consumer<FinanceProvider>(
              builder: (context, financeProvider, child) {
                return Text(
                  'Total Income: \$${financeProvider.totalIncome.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
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
                    onPressed: _saveIncome,
                    child: Text('Add Income'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Display incomes in a table
            Expanded(
              child: Consumer<FinanceProvider>(
                builder: (context, financeProvider, child) {
                  return ListView.builder(
                    itemCount: financeProvider.incomes.length,
                    itemBuilder: (context, index) {
                      final income = financeProvider.incomes[index];
                      return ListTile(
                        title: Text(income['title']),
                        trailing: Text('\$${income['amount'].toStringAsFixed(2)}'),
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
}