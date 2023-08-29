import 'dart:async';
import 'dart:math';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(StarGame());
}

class StarGame extends StatelessWidget {
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
        generateDottedStar(40, 140.0); // Initialize connectDots here
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
    // Check if the last and first dots are connected (forming a closed star)
    if (isNeighborDot(userDots.last, userDots.first)) {
      connectedDots++;
    }

    score = connectedDots ~/ 2; // Divide by 2 as each line connects two dots

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
        title: Text('Dot Connect Game - Star'),
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
    for (int i = 0; i < userDots.length - 1; i += 1) {
      canvas.drawLine(userDots[i], userDots[i + 1], dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

List<Offset> generateDottedStar(int numberOfDots, double radius) {
  List<Offset> dots = [];
  double centerX = 200.0; // Adjust this value to center the star horizontally
  double centerY = 200.0; // Adjust this value to center the star vertically

  // Calculate the angles between the dots in the star
  double angleIncrement = 2 * pi / 5;

  for (int i = 0; i < 5; i++) {
    double outerAngle = angleIncrement * i;
    double outerX = centerX + radius * cos(outerAngle);
    double outerY = centerY + radius * sin(outerAngle);
    dots.add(Offset(outerX, outerY));
    

    double innerAngle = outerAngle + angleIncrement / 2;
    double innerX = centerX + radius / 2 * cos(innerAngle);
    double innerY = centerY + radius / 2 * sin(innerAngle);
    dots.add(Offset(innerX, innerY));

    double middleAngle = outerAngle + innerAngle+ angleIncrement/3.5;
    double innerX2 = centerX + radius / 1.5 * cos(middleAngle);
    double innerY2 = centerY + radius / 1.5 * sin(middleAngle);
    dots.add(Offset(innerX2, innerY2));

    double middleAngle1 = outerAngle + innerAngle+ angleIncrement/1.4;
    double outerX2 = centerX + radius / 1.5 * cos(middleAngle1);
    double outerY2 = centerY + radius / 1.5 * sin(middleAngle1);
    dots.add(Offset(outerX2, outerY2));
  }

  return dots;
}
