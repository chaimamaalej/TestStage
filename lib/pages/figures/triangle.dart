import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geometry2/pages/figures/circle.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:quickalert/quickalert.dart';

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
  bool isDrawing = false;
  List<Offset> connectDots = [];
  int dotsConnected = 0;
  Timer? timer;
  int secondsElapsed = 0;
  double percentage = 0.00;
  int totalConnectedDots = 0;
  int neighborDots = 0;
  bool correctTriangleFormed = false;
  late AudioPlayer audioPlayer;
  String audioFilePath =
      'assets/mixkit-a-happy-child-532.mp3'; // Replace with the actual path

  @override
  void initState() {
    super.initState();
    connectDots = generateDottedTriangle(20, 200.0);
    audioPlayer = AudioPlayer();
    print('Audio player initialized');
  }

  void playAudio() async {
    int result = await audioPlayer.play(audioFilePath, isLocal: true);

    if (result == 1) {
      // Success
      print('Audio playing');
    } else {
      // Error
      print('Error playing audio');
    }
  }

  @override
  void dispose() {
    audioPlayer
        .dispose(); // Dispose of the audio player when the widget is disposed
    super.dispose();
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
        if (isNeighborDot(userDots.last, userDots[userDots.length - 2])) {
          neighborDots++; // Increment neighborDots count if connected to a neighbor
        } else {
          neighborDots--; // Decrement neighborDots count if not connected to a neighbor
        }
        setState(() {
          score++;
        });
        checkScore(); // Call checkScore after each successful connection
        break;
      }
    }
    // Check if the dots connected by the user form a correct triangle
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
      _showDialog(context);
    }
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Congratulations!"),
          content: Text("You did great, well done!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Next"),
            ),
          ],
        );
      },
    );
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
      dotsConnected = 0;
      userDots.clear();
      score = 0;
      secondsElapsed = 0;
      totalConnectedDots = 0;
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
                    Text(
                      'neighbordots: $neighborDots',
                      style: TextStyle(fontSize: 24),
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
}
