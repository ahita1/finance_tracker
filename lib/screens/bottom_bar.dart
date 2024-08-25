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
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Income',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.money_off),
          label: 'Expenses',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Colors.blueAccent, // Background color of the BottomNavigationBar
      selectedItemColor: Colors.white, // Color of the selected item
      unselectedItemColor: Colors.white70, // Color of the unselected items
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Style for the selected label
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Style for unselected labels
      elevation: 10, // Shadow depth for the BottomNavigationBar
      type: BottomNavigationBarType.fixed, // Ensures that the bottom bar items are fixed
    );
  }
}
