import 'package:flutter/material.dart';
import '../models/figures.dart';

class FiguresTile extends StatelessWidget {
  final Items figures;
  void Function()? onTap;
  FiguresTile({
    Key? key,
    required this.figures,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 250, 251).withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              figures.name,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
