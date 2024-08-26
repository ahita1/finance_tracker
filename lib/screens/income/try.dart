import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/providers/finance_provider.dart';

class IncomeListScreen extends StatefulWidget {
  @override
  _IncomeListScreenState createState() => _IncomeListScreenState();
}

class _IncomeListScreenState extends State<IncomeListScreen> {
  late Future<List<Map<String, dynamic>>> _incomesFuture;

  @override
  void initState() {
    super.initState();
    _incomesFuture =
        Provider.of<FinanceProvider>(context, listen: false).fetchIncomes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Income List',
          style: TextStyle(color: Colors.white), // Set title color to white
        ),
        centerTitle: true,
        backgroundColor: Colors.blue, // Original color blue
        iconTheme: IconThemeData(
          color: Colors.white, // Set icon color to white
        ),
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
          return ListView(
            padding: EdgeInsets.all(16.0),
            children: incomes.map((income) {
              final title = income['title'] ?? 'No Title';
              final amount = income['amount']?.toStringAsFixed(2) ?? '0.00';
              final category = income['category'] ?? 'No Category';
              final date = income['date'] != null
                  ? DateTime.parse(income['date']).toLocal()
                  : DateTime.now();
              final formattedDate = "${date.day}/${date.month}/${date.year}";

              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: Icon(Icons.monetization_on,
                      color: Colors.blue, size: 40), // Blue icon
                  title: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    '$category',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${amount} ETB', // Amount with currency symbol on the right
                        style: TextStyle(
                          color: Colors.blue, // Blue amount text
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
