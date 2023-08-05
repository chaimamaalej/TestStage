import 'package:flutter/material.dart';
import 'package:geometry2/models/shop.dart';
import 'package:provider/provider.dart';

import '../components/figure_tile.dart';
import '../models/figures.dart';
import 'orderPage.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => _CartPageState();
}

class _CartPageState extends State<InformationPage> {
  void goToOrderPage(Figures figures) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderPage(
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BubbleTeaShop>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Text(
                "Figures",
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 10),

              // list of cart items
              Expanded(
                child: ListView.builder(
                  itemCount: value.shop.length,
                  itemBuilder: (context, index) {
                    Figures individualFigure = value.shop[index];

                    return FiguresTile(
                      figures: individualFigure,
                      onTap: () => goToOrderPage(individualFigure),
                      trailing: Icon(Icons.arrow_forward),
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
