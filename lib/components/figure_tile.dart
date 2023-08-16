import 'package:flutter/material.dart';

import '../models/figures.dart';

class FiguresTile extends StatelessWidget {
  final Items figures;
  void Function()? onTap;
  final Widget trailing;
  FiguresTile({
    Key? key,
    required this.figures,
    required this.onTap,
    required this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 250, 250, 251).withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(figures.name),
              leading: Image.asset(figures.imagePath),
              trailing: trailing,
            ),
          ),
        ],
      ),
    );
  }
}
