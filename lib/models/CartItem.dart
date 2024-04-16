
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/widgets/SnackBar.dart';
import 'package:provider/provider.dart';

// Modèle de panier
class CartItem {
  final Stock? stock;
  final Intrant? intrant;
  int quantiteIntrant;
  int quantiteStock;
  CartItem({ this.stock, this.intrant, this.quantiteIntrant = 1, this.quantiteStock = 1});

}

// class CartItemIntrant {
//   final Intrant intrant;
//   int quantiteIntrant;
//   CartItemIntrant({required this.intrant,  this.quantiteIntrant = 1});

// }