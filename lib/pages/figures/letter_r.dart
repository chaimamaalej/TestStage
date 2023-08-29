import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geometry2/pages/figures/circle.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:quickalert/quickalert.dart';

void main() {
  runApp(LettreR());
}

class LettreR extends StatelessWidget {
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
    connectDots = generateDottedLetterR(11, 200.0);
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

  List<Offset> generateDottedLetterR(int numberOfDots, double sideLength) {
  List<Offset> dots = [];
  double startX = 150.0;
  double startY = 150.0;
  double height = sideLength * sqrt(3) / 2;

  // Left side dots
  for (int i = numberOfDots ; i > 0; i--) {
    double fraction = i / (numberOfDots - 2);
    double y = startY + sideLength * fraction;
    dots.add(Offset(startX, y));
  }

// Right diagonal dots
  for (int i = 0; i < numberOfDots-7; i++) {
    double fraction = i / (numberOfDots - 1);
    double x = startX + sideLength * fraction;
    double y = startY;
    dots.add(Offset(x, y));
  }

// Right diagonal dots
  for (int i = 0; i < numberOfDots-8; i++) {
    double fraction = i / (numberOfDots - 1);
    double x = startX + sideLength * fraction +20;
    double y = startY+111;
    dots.add(Offset(x, y));
  }
  
  // Diagonal line of dots
  for (int i = 0; i < numberOfDots - 6; i++) {
    double x = startX + sideLength * i / (numberOfDots - 3);
    double y = startY + sideLength * i / (numberOfDots - 4)+110;
    dots.add(Offset(x+20, y+20));
  }

  for (int i = numberOfDots-2; i > 6; i--) {
    double angle = pi * (2*i / (numberOfDots -3));
    double x = startX + sideLength / 2 + cos(angle) * (sideLength-145)-40;
    double y = startY + sideLength / 2 + sin(angle) * (sideLength-145)-45;
    dots.add(Offset(x, y));
  }

  // Add a few extra dots to refine the shape
  if (numberOfDots > 5) {
    // dots.add(Offset(x1 + (x2 - x1) / 2, y1 + (y2 - y1) / 2));
    // dots.add(Offset(x2 + (x3 - x2) / 2, y2 + (y3 - y2) / 2));
    // Add more extra dots if desired
  }
  
  // Add a few extra dots to refine the shape
  if (numberOfDots > 5) {
    // dots.add(Offset(x1 + (x2 - x1) / 2, y1 + (y2 - y1) / 2));
    // dots.add(Offset(x2 + (x3 - x2) / 2, y2 + (y3 - y2) / 2));
    // Add more extra dots if desired
  }

  return dots;
}

}