import 'package:flutter/material.dart';

import 'figures.dart';

class BubbleTeaShop extends ChangeNotifier{

  final List<Figures> _shop = [

    Figures(
      name: "Figures",
      imagePath: "lib/images/triangle.png", ),
  ];

  final List<Figures> _userCart = [];

  List<Figures> get shop => _shop;

  List<Figures> get cart => _userCart;

  void addToCart(Figures figures){
    _userCart.add(figures);
    notifyListeners();
  }

  void removeFromCart(Figures figures){
    _userCart.remove(figures);
    notifyListeners();
  }
}