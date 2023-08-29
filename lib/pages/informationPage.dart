import 'package:flutter/material.dart';
import 'package:geometry2/models/shop.dart';
import 'package:provider/provider.dart';

import '../components/figure_tile.dart';
import '../models/figures.dart';
import 'games.dart';
import 'medicalreview.dart';


class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => _CartPageState();
}

class _CartPageState extends State<InformationPage> {
  void goToOrderPage(Items figures) {
  if (figures.name == "Let's play") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamesPage(),
      ),
    );
  } else if (figures.name == "Medical Review") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicalReviewPage(), // Replace with the actual MedicalReviewPage widget
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Consumer<BubbleTeaShop>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              

              const SizedBox(height: 80),

              // list of cart items
              Expanded(
                child: ListView.builder(
                  itemCount: value.shop.length,
                  itemBuilder: (context, index) {
                    Items individualFigure = value.shop[index];

                    return FiguresTile(
                      figures: individualFigure,
                      onTap: () => goToOrderPage(individualFigure),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
