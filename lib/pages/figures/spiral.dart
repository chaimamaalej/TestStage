import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(SpiralPage());
  print("Your message here");
}

class SpiralPage extends StatelessWidget {
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
  bool isDrawing = false;
  List<Offset> connectDots = []; // Move this line here
  int dotsConnected = 0;
  Timer? timer;
  int secondsElapsed = 0;
  double percentage = 0.00;
  int totalConnectedDots = 0;

  @override
  void initState() {
    super.initState();
    connectDots =
        generateDottedSpiral(30, 20.0, 5.0, 2.0); // Initialize connectDots here
  }

  void onUserDraw(Offset userDot) {
    if (!isDrawing) {
      isDrawing = true;
      startTimer();
    }

    for (int i = 0; i < connectDots.length; i++) {
      if ((userDot - connectDots[i]).distance < 10.0) {
        setState(() {
          userDots.add(connectDots[i]);
          totalConnectedDots++; // Increment total connected dots
        });
        setState(() {
          score++;
        });
        checkScore(); // Call checkScore after each successful connection
        break;
      }
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        secondsElapsed += 100; // Increment by 100 milliseconds
      });
    });
  }

  void resetTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    startTimer();
  }

  void checkScore() {
    Set<Offset> connectedSet = userDots.toSet();

    bool allDotsConnected = true;
    for (Offset dot in connectDots) {
      if (!connectedSet.contains(dot)) {
        allDotsConnected = false;
        break;
      }
    }

    if (allDotsConnected) {
      stopTimer();
    } else {
      dotsConnected = connectedSet.length;
    }
  }

  void stopTimer() {
    timer?.cancel();
    
  }

  bool isNeighborDot(Offset p1, Offset p2) {
    for (int i = 0; i < connectDots.length; i++) {
      if ((p1 - connectDots[i]).distance < 25.0 &&
          (p2 - connectDots[i]).distance < 25.0) {
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    stopTimer();
    setState(() {
      userDots.clear();
      score = 0;
      secondsElapsed = 0;
      isDrawing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    dotsConnected = userDots.toSet().intersection(connectDots.toSet()).length;
    percentage = dotsConnected * 100 / connectDots.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dot Connect Game'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          if (!isDrawing) {
            setState(() {
              isDrawing = true; // Start drawing
              startTimer();
            });
          }
          onUserDraw(details.localPosition);
        },
        onPanEnd: (details) {
          setState(() {
            isDrawing = false; // Reset drawing state
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
                    Text(
                      'Time Elapsed: ${secondsElapsed / 1000} seconds',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Drawing: $isDrawing',
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

  List<Offset> generateDottedSpiral(int numberOfDots, double startRadius,
      double spacing, double rotationRate) {
    List<Offset> dots = [];
    double centerX =
        200.0; // Adjust this value to center the spiral horizontally
    double centerY = 200.0; // Adjust this value to center the spiral vertically

    double angleIncrement = 2 * pi * rotationRate / numberOfDots;
    double radius = startRadius;

    for (int i = 0; i < numberOfDots; i++) {
      double angle = angleIncrement * i;
      double x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);
      dots.add(Offset(x, y));

      radius += spacing;
    }

    return dots;
  }
}

class DotPainter extends CustomPainter {
  final List<Offset> connectDots;
  final List<Offset> userDots;
  final int score;

  DotPainter(this.connectDots, this.userDots, this.score);

  @override
  void paint(Canvas canvas, Size size) {
    Paint dotPaint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.butt;

    for (Offset connectDot in connectDots) {
      if (userDots.contains(connectDot)) {
        dotPaint.color = Colors.red;
      } else {
        dotPaint.color = Colors.black;
      }
      canvas.drawCircle(connectDot, 5, dotPaint);
    }

    dotPaint.color = Colors.red; // Set color to red for the lines
    for (int i = 0; i < userDots.length - 1; i += 2) {
      canvas.drawLine(userDots[i], userDots[i + 1], dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
