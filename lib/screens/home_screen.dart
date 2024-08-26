import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import 'bottom_bar.dart';
import 'income_screen.dart';
import 'expense_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FinanceProvider(),
      child: ExpenseApp(),
    ),
  );
}

class ExpenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      debugShowCheckedModeBanner: false,
      home: ExpensePage(),
    );
  }
}

class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  int _selectedIndex = 1; // Default to 'Home' tab

  Future<Map<String, double>>? _convertedBalancesFuture;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      AddIncomeScreen(),
      _buildHomePage(),
      AddExpenseScreen(),
    ]);

    // Fetch data initially
    final financeProvider =
        Provider.of<FinanceProvider>(context, listen: false);
    financeProvider.fetchIncomes();
    financeProvider.fetchExpenses();

    _convertedBalancesFuture = _fetchConvertedBalances();
  }

  Future<Map<String, double>> _fetchConvertedBalances() async {
    final financeProvider =
        Provider.of<FinanceProvider>(context, listen: false);
    return await financeProvider.convertBalanceToCurrencies();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomePage() {
    return Consumer<FinanceProvider>(
      builder: (context, financeProvider, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[100],
                  ),
                  padding: EdgeInsets.all(2),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Income',
                              amount:
                                  '${financeProvider.totalIncome.toStringAsFixed(2)} Birr',
                              color: Colors.green,
                              icon: Icons.arrow_downward,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Expense',
                              amount:
                                  '${financeProvider.totalExpenses.toStringAsFixed(2)} Birr',
                              color: Colors.red,
                              icon: Icons.arrow_upward,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Total Balance You Have',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${financeProvider.balance.toStringAsFixed(2)} Birr',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FutureBuilder<Map<String, double>>(
                        future: _convertedBalancesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                  'Failed to load currency conversion data'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: Text('No conversion data available'),
                            );
                          } else {
                            final convertedBalances = snapshot.data!;
                            return Container(
                              height: 200,
                              child: ListView(
                                children: _buildCurrencyConversionCards(
                                    convertedBalances),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

Widget _buildStatCard({
  required String title,
  required String amount,
  required Color color,
  required IconData icon,
}) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  amount,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Map<String, String> currencySymbols = {
    'USD': '\$',  // US Dollar
    'EUR': '€',   // Euro
    'GBP': '£',   // British Pound
    'JPY': '¥',   // Japanese Yen
    'ETB': 'ብር',  // Ethiopian Birr
    // Add more currencies as needed
  };

  List<Widget> _buildCurrencyConversionCards(Map<String, double> convertedBalances) {
    return convertedBalances.entries.map((entry) {
      String currencyCode = entry.key;
      double value = entry.value;
      
      // Use the currency code to get the appropriate symbol
      String symbol = currencySymbols[currencyCode] ?? currencyCode; // Default to the currency code if no symbol is found

      return Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: Text(
            symbol,
            style: TextStyle(
              fontSize: 24, // Adjust size as needed
            ),
          ),
          title: Text('$currencyCode Balance'),
          trailing: Text(
            '$symbol${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 4.0,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
