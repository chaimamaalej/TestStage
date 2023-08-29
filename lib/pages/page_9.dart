import 'dart:math';
import 'package:flutter/material.dart';

class Page9 extends StatelessWidget {
  const Page9({Key? key}) : super(key: key);

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
                child: Star(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Star extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: StarPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;
    final double centerX = halfWidth;
    final double centerY = halfHeight;

    final double outerRadius = halfWidth;
    final double innerRadius = halfWidth / 2;
    final double rotation = -pi / 2;
    final double step = pi / 5;

    final Path path = Path();
    for (int i = 0; i < 5; i++) {
      double angle = rotation + i * 2 * step;
      double outerX = centerX + outerRadius * cos(angle);
      double outerY = centerY + outerRadius * sin(angle);
      double innerAngle = angle + step;
      double innerX = centerX + innerRadius * cos(innerAngle);
      double innerY = centerY + innerRadius * sin(innerAngle);
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
