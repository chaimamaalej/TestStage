import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
   MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
    padding: const EdgeInsets.only(bottom: 25.0),
    child: GNav(
      onTabChange: (value) => onTabChange!(value),
      mainAxisAlignment: MainAxisAlignment.center,
      activeColor: Colors.white,
      color: Colors.grey[300],
      tabActiveBorder: Border.all(color: Colors.white),
      gap: 8,
      tabs: const [
        GButton(
          icon: Icons.home,
          text: 'Home',
        ),
        GButton(
          icon: Icons.games,
          text: 'Played',
        ),
      ],
    ),);
  }
}
