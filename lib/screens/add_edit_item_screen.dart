import 'package:flutter/material.dart';

class AddEditItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit Item'),
      ),
      body: Center(
        child: Text('Form to add or edit an income or expense item will be here'),
      ),
    );
  }
}
