import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geometry2/pages/figures/circle.dart';

void main() {
  runApp(Triangle());
}

class Triangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Offset> userDots = [];
  int score = 0;

  final List<Offset> connectDots = generateDottedTriangle(20, 150.0);

  void onUserDraw(Offset userDot) {
    for (int i = 0; i < connectDots.length; i++) {
      if ((userDot - connectDots[i]).distance < 25.0) {
        setState(() {
          userDots.add(connectDots[i]);
        });
        break;
      }
    }
    checkScore();
  }
void checkScore() {
    int connectedDots = 0;
    for (int i = 0; i < userDots.length - 1; i++) {
      if (isNeighborDot(userDots[i], userDots[i + 1])) {
        connectedDots++;
      }
    }
    // Check if the last and first dots are connected (forming a closed circle)
    if (isNeighborDot(userDots.last, userDots.first)) {
      connectedDots++;
    }

    score = connectedDots;
  }

  bool isNeighborDot(Offset p1, Offset p2) {
    for (int i = 0; i < connectDots.length; i++) {
      if ((p1 - connectDots[i]).distance < 25.0 && (p2 - connectDots[i]).distance < 25.0) {
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    setState(() {
      userDots.clear();
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    int dotsConnected = userDots.toSet().intersection(connectDots.toSet()).length;
    double percentage = dotsConnected * 100 / connectDots.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dot Connect Game'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          onUserDraw(details.localPosition);
        },
        onPanEnd: (details) {
          // Reset the dots after the user completes a drawing
          setState(() {
            userDots.clear();
          });
        },
        child: Stack(
          children: [
            CustomPaint(
              painter: DotPainter(connectDots, userDots, score),
              child: Container(),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Score: $score',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      'nb: ${dotsConnected}/${connectDots.length}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Percentage: ${percentage.toStringAsFixed(2)}%',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: resetGame,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

List<Offset> generateDottedTriangle(int numberOfDots, double sideLength) {
  List<Offset> dots = [];
  double centerX = 200.0;
  double centerY = 200.0;

  // Calculate the height of the equilateral triangle
  double height = sideLength * sqrt(3) / 2;

  // Calculate the coordinates of the three vertices of the triangle
  double x1 = centerX;
  double y1 = centerY - height / 2;
  double x2 = centerX - sideLength / 2;
  double y2 = centerY + height / 2;
  double x3 = centerX + sideLength / 2;
  double y3 = centerY + height / 2;

  // Add the vertices of the triangle to the list of dots
  dots.add(Offset(x1, y1));
  dots.add(Offset(x2, y2));
  dots.add(Offset(x3, y3));

  // If there are more than three dots, we can add additional dots to fill the triangle
  if (numberOfDots > 3) {
    int extraDots = numberOfDots - 14;
    double dx1 = (x2 - x1) / (extraDots + 1);
    double dy1 = (y2 - y1) / (extraDots + 1);
    double dx2 = (x3 - x2) / (extraDots + 1);
    double dy2 = (y3 - y2) / (extraDots + 1);
    double dx3 = (x1 - x3) / (extraDots + 1);
    double dy3 = (y1 - y3) / (extraDots + 1);

    for (int i = 1; i <= extraDots; i++) {
      double x12 = x1 + dx1 * i;
      double y12 = y1 + dy1 * i;
      double x23 = x2 + dx2 * i;
      double y23 = y2 + dy2 * i;
      double x31 = x3 + dx3 * i;
      double y31 = y3 + dy3 * i;

      dots.add(Offset(x12, y12));
      dots.add(Offset(x23, y23));
      dots.add(Offset(x31, y31));
    }
  }

  return dots;
}