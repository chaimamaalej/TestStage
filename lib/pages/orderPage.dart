import 'package:flutter/material.dart';
import 'package:geometry2/models/shop.dart';
import 'package:geometry2/pages/page_1.dart';
import 'package:geometry2/pages/page_2.dart';
import 'package:geometry2/pages/page_3.dart';
import 'package:geometry2/pages/page_4.dart';
import 'package:geometry2/pages/page_5.dart';
import 'package:geometry2/pages/page_6.dart';
import 'package:provider/provider.dart';

import '../models/figures.dart';
import 'figures/circle.dart';
import 'figures/square.dart';
import 'figures/star.dart';
import 'figures/triangle.dart';

class OrderPage extends StatefulWidget {
    @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int level = 1;
  int score = 0;
  Color? backgroundColor = Colors.deepPurple[200]; // Default background color

  final List<Color> colorChoices = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.deepPurple[200]!,
  ];

  int currentColorIndex = 4; // Index of the default color in the colorChoices list

  void changeBackgroundColor() {
    setState(() {
      currentColorIndex = (currentColorIndex + 1) % colorChoices.length;
      backgroundColor = colorChoices[currentColorIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Buttons to choose background color
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colorChoices.map((color) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      backgroundColor = color;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: color,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16),
                  ),
                  child: SizedBox(),
                );
              }).toList(),
            ),
          ),

          // Display level and score at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level: $level',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Score: $score',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),

          // Pages on the same row
          Container(
            height: 150, // Adjust the height as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Triangle(),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Page1(),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Circle(),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Page2(),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Square(),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Page3(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Page4, Page5, Page6 below Page1
          Container(
            height: 150, // Adjust the height as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StarGame(),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Page4(),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Triangle(),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Page5(),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Triangle(),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Page6(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // dot indicators
          // (Place the SmoothPageIndicator here as needed)
        ],
      ),
    );
  }
  
}
