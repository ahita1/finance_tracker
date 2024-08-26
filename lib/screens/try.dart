import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/providers/finance_provider.dart';
import 'spend_item.dart'; // Import the SpendItem widget

class IncomeListScreen extends StatefulWidget {
  @override
  _IncomeListScreenState createState() => _IncomeListScreenState();
}

class _IncomeListScreenState extends State<IncomeListScreen> {
  late Future<List<Map<String, dynamic>>> _incomesFuture;

  @override
  void initState() {
    super.initState();
    _incomesFuture = Provider.of<FinanceProvider>(context, listen: false).fetchIncomes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income List'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _incomesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No income data available'));
          }

          final incomes = snapshot.data!;
          return Expanded(
            child: ListView(
              children: incomes.map((income) {
                final title = income['title'] ?? 'No Title';
                final amount = income['amount']?.toStringAsFixed(2) ?? '0.00';
                final category = income['category'] ?? 'No Category';
                final date = income['date'] != null
                    ? DateTime.parse(income['date']).toLocal()
                    : DateTime.now();
                final formattedDate = "${date.day}/${date.month}/${date.year}";

                return SpendItem(
                  icon: Icons.monetization_on, // Use a generic icon or update based on your requirements
                  title: title,
                  date: formattedDate,
                  amount: '\$${amount}',
                  paymentMethod: category, // Assuming 'category' is used as payment method
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
