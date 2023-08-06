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
      width: 100,
      height: 100,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: SpiralPainter(),
            ),
          ),
        ],
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
      ..strokeWidth = 2.0; // Increase the stroke width for a thicker line

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final double startRadius = 0.0;
    final double spacing = 1.0;
    final double rotationRate = 2.0;
    final int numberOfDots = 100;

    final Path path = Path();
    List<Offset> dots = generateDottedSpiral(numberOfDots, startRadius, spacing, rotationRate);

    path.moveTo(centerX, centerY);
    for (Offset dot in dots) {
      path.lineTo(dot.dx, dot.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  List<Offset> generateDottedSpiral(int numberOfDots, double startRadius, double spacing, double rotationRate) {
    List<Offset> dots = [];
    double centerX = 200.0; // Adjust this value to center the spiral horizontally
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


