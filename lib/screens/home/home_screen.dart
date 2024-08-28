import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/finance_provider.dart';
import 'bottom_bar.dart';
import '../income/income_screen.dart';
import '../expense/expense_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FinanceProvider(),
      child: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
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
  int _selectedIndex = 1;
  Future<Map<String, double>>? _convertedBalancesFuture;
  final List<Widget> _pages = [];
  late FinanceProvider _financeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _financeProvider = Provider.of<FinanceProvider>(context, listen: false);
    _financeProvider.addListener(_onFinanceDataChanged);

    _pages.addAll([
      AddIncomeScreen(),
      _buildHomePage(),
      AddExpenseScreen(),
    ]);

    _financeProvider.fetchIncomes();
    _financeProvider.fetchExpenses();

    _fetchAndUpdateConvertedBalances();
  }

  void _onFinanceDataChanged() {
    _fetchAndUpdateConvertedBalances();
  }

  Future<void> _fetchAndUpdateConvertedBalances() async {
    setState(() {
      _convertedBalancesFuture = _fetchConvertedBalances();
    });
  }

  Future<Map<String, double>> _fetchConvertedBalances() async {
    return await _financeProvider.convertBalanceToCurrencies();
  }

  @override
  void dispose() {
    _financeProvider.removeListener(_onFinanceDataChanged);
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _pickYearMonth(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: firstDayOfMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: "Select Year and Month",
      selectableDayPredicate: (DateTime val) => val.day == 1,
    );

    if (pickedDate != null) {
      final String selectedCycle = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}";
      _financeProvider.setBudgetCycle(selectedCycle);
    }
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _pickYearMonth(context),
                          ),
                          Text(
                            'Budget Cycle: ${financeProvider.currentCycle}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          SizedBox(width: 48),
                        ],
                      ),
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
                        'Your Remaining Balance',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                          fontFamily: 'Roboto',
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 20),
                      Container(
                        width: 140,
                        height: 140,
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
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      FutureBuilder<Map<String, double>>(
                        future: _convertedBalancesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Failed to load currency conversion data'),
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Text('No conversion data available'),
                            );
                          } else {
                            final convertedBalances = snapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 4 / 3,
                                children: _buildCurrencyConversionCards(convertedBalances),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(height: 20),
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
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'ETB': 'ብር'
  };

  List<Widget> _buildCurrencyConversionCards(
      Map<String, double> convertedBalances) {
    return convertedBalances.entries.map((entry) {
      String currencyCode = entry.key;
      double value = entry.value;

      String symbol = currencySymbols[currencyCode] ?? currencyCode;

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Colors.lightBlueAccent.withOpacity(0.6),
              Colors.lightBlue.withOpacity(0.6)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withOpacity(0.8),
              child: Text(
                symbol,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$currencyCode Balance',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '$symbol${value.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
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
