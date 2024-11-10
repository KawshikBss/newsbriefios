import 'package:flutter/material.dart';
import 'package:newsbriefapp/data/nav_data.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentTabIndex;
  final Function handleTabChange;
  const CustomBottomNavigation(
      {super.key,
      required this.currentTabIndex,
      required this.handleTabChange});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: (value) {
          if (value == 0) {
            Navigator.pushReplacementNamed(context, '/main');
          }
          handleTabChange(value);
        },
        currentIndex: currentTabIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color(0xFF9C9C9C),
        items: [
          for (var item in navList)
            BottomNavigationBarItem(icon: item.icon, label: item.name)
        ]);
  }
}
