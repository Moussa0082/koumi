import 'package:koumi_app/models/Stock.dart';

class CartItem {
  final Stock stock;
  int quantity;

  CartItem({required this.stock, this.quantity = 1});
}