import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Income',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.money_off),
          label: 'Expenses',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor:
          Colors.blueAccent, 
      selectedItemColor: Colors.white, 
      unselectedItemColor: Colors.white70, 
      selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal), 
      elevation: 10, 
      type: BottomNavigationBarType
          .fixed,
    );
  }
}
