// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/finance_provider.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final financeProvider = Provider.of<FinanceProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Finance Tracker'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Balance: \$${financeProvider.balance.toStringAsFixed(2)}',
//               style: Theme.of(context).textTheme.headline5,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Balance in EUR: €${financeProvider.convertToEur(financeProvider.balance).toStringAsFixed(2)}',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Balance in GBP: £${financeProvider.convertToGbp(financeProvider.balance).toStringAsFixed(2)}',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               children: [
//                 ListTile(
//                   title: Text('Income'),
//                   onTap: () {
//                     Navigator.pushNamed(context, '/income');
//                   },
//                 ),
//                 ListTile(
//                   title: Text('Expenses'),
//                   onTap: () {
//                     Navigator.pushNamed(context, '/expense');
//                   },
//                 ),
//                 // Add more ListTiles for additional features
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
