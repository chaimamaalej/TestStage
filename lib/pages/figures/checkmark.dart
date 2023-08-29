import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geometry2/pages/figures/circle.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:quickalert/quickalert.dart';

void main() {
  runApp(Checkmark());
}

class Checkmark extends StatelessWidget {
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
  String audioFilePath = 'assets/mixkit-a-happy-child-532.mp3'; // Replace with the actual path

  @override
  void initState() {
    super.initState();
    connectDots = generateDottedCheckmark(20, 200.0);
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

  List<Offset> generateDottedCheckmark(int numberOfDots, double size) {
  List<Offset> dots = [];
  double centerX = 200.0;
  double centerY = 290.0;

  // Calculate the coordinates for the checkmark shape
  double x1 = centerX - size / 7;
  double y1 = centerY + size / 7;
  double x2 = centerX - size / 3;
  double y2 = centerY - size / 3;
  double x3 = centerX + size / 2;
  double y3 = centerY - size / 2;
  double x4 = x1 + (x2 - x1) / 2;
  double y4 = y1 + (y2 - y1) / 2;
  double x5 = x1 + (x3 - x1) / 2;
  double y5 = y1 + (y3 - y1) / 2;

  // Add the vertices of the checkmark to the list of dots
  dots.add(Offset(x1, y1));
  dots.add(Offset(x2, y2));
  dots.add(Offset(x3, y3));

  // If there are more dots needed, you can add additional dots to refine the shape
  if (numberOfDots > 3) {
    dots.add(Offset(x4,y4));
    dots.add(Offset(x5,y5));
    dots.add(Offset(x4 + (x2 - x4) / 2, y4 + (y2 - y4) / 2));
    dots.add(Offset(x1 + (x4 - x1) / 2, y4 + (y1 - y4) / 2));
    dots.add(Offset(x1 + (x5 - x1) / 2, y5 + (y1 - y5) / 2));
    dots.add(Offset(x5 + (x3 - x5) / 2, y5 + (y3 - y5) / 2));
  }

  return dots;
}
}