import 'dart:async';
import 'dart:math';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Square());
}

class Square extends StatelessWidget {
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
        generateDottedSquare(6, 200.0);// Initialize connectDots here
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
    timer = null;
  }


  bool isNeighborDot(Offset p1, Offset p2) {
    for (int i = 0; i < connectDots.length; i++) {
      if ((p1 - connectDots[i]).distance < 10.0 &&
          (p2 - connectDots[i]).distance < 10.0) {
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    stopTimer();
    setState(() {
      isDrawing = false;
      dotsConnected=0;
      userDots.clear();
      score = 0;
      secondsElapsed = 0;
      totalConnectedDots=0;
    });
  }

  @override
  Widget build(BuildContext context) {
    dotsConnected = userDots.toSet().intersection(connectDots.toSet()).length;
    percentage = dotsConnected * 100 / connectDots.length;


    return Scaffold(
      appBar: AppBar(
        title: Text('Dot Connect Game - Square'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          if (!isDrawing) {
            setState(() {
              isDrawing = true; // Start drawing
           });
          }
          if ((timer == null) && (dotsConnected != connectDots.length)) {
            startTimer();
          }
          onUserDraw(details.localPosition);
        },
        onPanEnd: (details) {
          setState(() {
            isDrawing = false;
            // Reset drawing state
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

List<Offset> generateDottedSquare(int numberOfDots, double sideLength) {
  List<Offset> dots = [];
  double startX = 100.0;
  double startY = 100.0;

  // Top side dots
  for (int i = 0; i < numberOfDots; i++) {
    double fraction = i / (numberOfDots - 1);
    double x = startX + sideLength * fraction;
    dots.add(Offset(x, startY));
  }

  // Right side dots
  for (int i = 1; i < numberOfDots; i++) {
    double fraction = i / (numberOfDots - 1);
    double y = startY + sideLength * fraction;
    dots.add(Offset(startX + sideLength, y));
  }

  // Bottom side dots
  for (int i = numberOfDots - 2; i >= 0; i--) {
    double fraction = i / (numberOfDots - 1);
    double x = startX + sideLength * fraction;
    dots.add(Offset(x, startY + sideLength));
  }

  // Left side dots
  for (int i = numberOfDots - 2; i > 0; i--) {
    double fraction = i / (numberOfDots - 1);
    double y = startY + sideLength * fraction;
    dots.add(Offset(startX, y));
  }

  return dots;
}
