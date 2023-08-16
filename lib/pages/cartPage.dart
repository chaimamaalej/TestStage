import 'package:flutter/material.dart';
import 'package:geometry2/components/figure_tile.dart';
import 'package:provider/provider.dart';

import '../models/figures.dart';
import '../models/shop.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  // remove drink from cart
  void removeFromCart(Items figures){
    Provider.of<BubbleTeaShop>(context, listen: false).removeFromCart(figures);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BubbleTeaShop>(builder: (context, value, child) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            //heading
            const Text(
              'Your Cart',
              style: TextStyle(fontSize: 20),
            ),

            //list of cart items
            Expanded(
              child: ListView.builder(
                itemCount: value.cart.length,
                itemBuilder: (context, index) {
                  //get individual drink in cart first
                  Items figures = value.cart[index];

                  //return as a nice tile
                  return FiguresTile(
                    figures: figures, 
                    onTap: () => removeFromCart(figures), 
                    trailing: Icon(Icons.delete),
                    );
                },
              ),
            ),

            //pay button
            MaterialButton(
              child: Text(
                'PAY',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () {},
            )
          ],
        ),
      ),
    ),);
  }
}
