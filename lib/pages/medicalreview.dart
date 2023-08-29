import 'package:flutter/material.dart';

class MedicalReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Reviews'),
      ),
      body: Center(
        child: Text(
          'Medical Reviews',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
