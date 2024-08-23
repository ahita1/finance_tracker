import 'package:flutter/material.dart';

class IncomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Income'),
      ),
      body: Center(
        child: Text('List of incomes will be displayed here'),
      ),
    );
  }
}
