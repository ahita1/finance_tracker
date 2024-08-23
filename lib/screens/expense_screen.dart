import 'package:flutter/material.dart';

class ExpenseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Expenses'),
      ),
      body: Center(
        child: Text('List of expenses will be displayed here'),
      ),
    );
  }
}
