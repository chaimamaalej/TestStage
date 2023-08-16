import 'dart:math';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(Circle());
}

class Circle extends StatelessWidget {
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
  Timer? timer;
  int secondsElapsed = 0;
  bool isDrawing = false;
  List<Offset> connectDots = []; // Move this line here
  int dotsConnected = 0;
  int totalConnectedDots = 0;


  @override
  void initState() {
    super.initState();
    connectDots =
        generateDottedCircle(20, 130.0); // Initialize connectDots here
  }

  void onUserDraw(Offset userDot) {
    if (!isDrawing) {
      isDrawing = true;
      startTimer();
    }
    for (int i = 0; i < connectDots.length; i++) {
      if ((userDot - connectDots[i]).distance < 25.0) {
        setState(() {
          userDots.add(connectDots[i]);
          totalConnectedDots++;
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
    
    if (dotsConnected == connectDots.length) {
      stopTimer();
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
    int dotsConnected =
        userDots.toSet().intersection(connectDots.toSet()).length;
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

class DotPainter extends CustomPainter {
  final List<Offset> connectDots;
  final List<Offset> userDots;
  final int score;

  DotPainter(this.connectDots, this.userDots, this.score);

  @override
  void paint(Canvas canvas, Size size) {
    Paint dotPaint = Paint()
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (Offset connectDot in connectDots) {
      if (userDots.contains(connectDot)) {
        dotPaint.color = Colors.red;
      } else {
        dotPaint.color = Colors.black;
      }
      canvas.drawCircle(connectDot, 5, dotPaint);
    }

    dotPaint.color = Colors.red; // Set color to red for the lines
    for (int i = 0; i < userDots.length - 1; i++) {
      canvas.drawLine(userDots[i], userDots[i + 1], dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

List<Offset> generateDottedCircle(int numberOfDots, double radius) {
  List<Offset> dots = [];
  double centerX = 200.0;
  double centerY = 200.0;

  for (int i = 0; i < numberOfDots; i++) {
    double angle = (2 * pi / numberOfDots) * i;
    double x = centerX + radius * cos(angle);
    double y = centerY + radius * sin(angle);
    dots.add(Offset(x, y));
  }

  return dots;
}
