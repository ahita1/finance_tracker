import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import './bottom_bar.dart';
import './income_screen.dart';
import './expense_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  Map<String, double> convertedBalances = {};
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _fetchAndConvertBalance();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _controller.forward().then((_) => _controller.reverse());
    });
  }

  Future<void> _fetchAndConvertBalance() async {
    setState(() {
      isLoading = true;
    });

    try {
      final financeProvider = Provider.of<FinanceProvider>(context, listen: false);
      convertedBalances = await financeProvider.convertBalanceToCurrencies();
    } catch (e) {
      print('Failed to convert currency: $e');
      convertedBalances = {
        'EUR': 0.0,
        'GBP': 0.0,
        'USD': 0.0,
        'JPY': 0.0,
      };
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final financeProvider = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(financeProvider),
          IncomeScreen(),
          ExpenseScreen(),
        ],
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeContent(FinanceProvider financeProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        _buildBalanceCard('Total Income', 'ETB ${financeProvider.totalIncome.toStringAsFixed(2)}'),
                        _buildBalanceCard('Total Expenses', 'ETB ${financeProvider.totalExpenses.toStringAsFixed(2)}'),
                        _buildBalanceCard('Balance', 'ETB ${financeProvider.balance.toStringAsFixed(2)}'),
                        SizedBox(height: 16),
                        _buildConvertedBalanceCard('Balance in EUR', '€${convertedBalances['EUR']?.toStringAsFixed(2) ?? '0.00'}'),
                        _buildConvertedBalanceCard('Balance in GBP', '£${convertedBalances['GBP']?.toStringAsFixed(2) ?? '0.00'}'),
                        _buildConvertedBalanceCard('Balance in USD', '\$${convertedBalances['USD']?.toStringAsFixed(2) ?? '0.00'}'),
                        _buildConvertedBalanceCard('Balance in JPY', '¥${convertedBalances['JPY']?.toStringAsFixed(2) ?? '0.00'}'),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(String title, String amount) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildConvertedBalanceCard(String title, String amount) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}
