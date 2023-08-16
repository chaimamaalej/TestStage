import 'package:flutter/material.dart';

import 'figures.dart';

class BubbleTeaShop extends ChangeNotifier{

  final List<Items> _shop = [

    Items(
      name: "Let's play",
      imagePath: "lib/images/triangle.png", ),
    Items(
      name: "Reviews",
      imagePath: "lib/images/triangle.png", ),

  ];

  final List<Items> _userCart = [];

  List<Items> get shop => _shop;

  List<Items> get cart => _userCart;

  void addToCart(Items figures){
    _userCart.add(figures);
    notifyListeners();
  }

  void removeFromCart(Items figures){
    _userCart.remove(figures);
    notifyListeners();
  }
}