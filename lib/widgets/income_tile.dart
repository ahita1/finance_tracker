import 'package:flutter/material.dart';
import '../models/income.dart';

class IncomeTile extends StatelessWidget {
  final Income income;

  IncomeTile({required this.income});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(income.source),
      subtitle: Text('\$${income.amount}'),
      trailing: Text(income.date.toLocal().toString()),
    );
  }
}
