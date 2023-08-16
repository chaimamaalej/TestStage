import 'dart:math';
import 'package:flutter/material.dart';

class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        // Set the size of the whole widget
        width: 200,
        height: 200,
        child: Padding(
          // Adjust the padding around the CustomPaint widget
          padding: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.white,
              child: Center(
                child: Spiral(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Spiral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: SpiralPainter(),
      ),
    );
  }
}

class SpiralPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final double startRadius = 0.0;
    final double spacing = 0.2;
    final double rotationRate = 2.0;
    final int numberOfDots = 200;

    final Path path = Path();
    List<Offset> dots = generateDottedSpiral(numberOfDots, startRadius, spacing, rotationRate);

    path.moveTo(centerX + dots[0].dx, centerY + dots[0].dy);
    for (Offset dot in dots) {
      path.lineTo(centerX + dot.dx, centerY + dot.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  List<Offset> generateDottedSpiral(int numberOfDots, double startRadius, double spacing, double rotationRate) {
    List<Offset> dots = [];
    double angleIncrement = 2 * pi * rotationRate / numberOfDots;
    double radius = startRadius;

    for (int i = 0; i < numberOfDots; i++) {
      double angle = angleIncrement * i;
      double x = radius * cos(angle);
      double y = radius * sin(angle);
      dots.add(Offset(x, y));

      radius += spacing;
    }

    return dots;
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Spiral(),
        ),
      ),
    ),
  );
}