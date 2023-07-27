import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.white,
              child: Center(
                child: CustomPaint(
                  // Set the size to be a square (equal width and height)
                  size: Size(50, 50),
                  painter: TrianglePainter(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}




class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
