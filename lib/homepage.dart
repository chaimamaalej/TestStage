import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geometry2/components/bottom_nav_bar.dart';
import 'package:geometry2/pages/cartPage.dart';
import 'package:geometry2/pages/informationPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex=0;
  void navigateBottomBar(int newIndex){
    setState(() {
      _selectedIndex = newIndex;
    });
  }

  final List<Widget> _pages = [

    const InformationPage(),

    const CartPage(),
  
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 162, 233, 223),
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Text(
            //including username 
            "Let's play Name !",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'GloriaHallelujah',
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: _pages[_selectedIndex],
        ),
      ],
    ),
  );
  }

}