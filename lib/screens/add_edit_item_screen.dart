// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/finance_provider.dart';

// class AddEditItemScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final args = ModalRoute.of(context)!.settings.arguments as Map?;
//     final index = args?['index'] as int?;
//     final type = args?['type'] as String; // 'income' or 'expense'
//     final provider = Provider.of<FinanceProvider>(context);
//     final isEditing = index != null;

//     final nameController = TextEditingController(
//       text: isEditing ? provider.getItem(type, index!)['name'] : '',
//     );
//     final amountController = TextEditingController(
//       text: isEditing ? provider.getItem(type, index!)['amount'].toString() : '',
//     );

//     return Scaffold(
//       appBar: AppBar(title: Text(isEditing ? 'Edit Item' : 'Add Item')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: type == 'income' ? 'Source' : 'Description'),
//             ),
//             TextField(
//               controller: amountController,
//               decoration: InputDecoration(labelText: 'Amount'),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 final name = nameController.text;
//                 final amount = double.tryParse(amountController.text) ?? 0;

//                 if (isEditing) {
//                   provider.updateItem(type, index!, {'name': name, 'amount': amount});
//                 } else {
//                   provider.addItem(type, {'name': name, 'amount': amount});
//                 }

//                 Navigator.pop(context);
//               },
//               child: Text(isEditing ? 'Update Item' : 'Add Item'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
