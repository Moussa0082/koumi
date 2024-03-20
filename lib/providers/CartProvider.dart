// import 'package:flutter/material.dart';
// import 'package:koumi_app/models/CartItem.dart';

// class CartProvider extends ChangeNotifier {
//   List<CartItem> _cartItems = [];

//   List<CartItem> get cartItems => _cartItems;

//   void addToCart(CartItem cartItem) {
//     _cartItems.add(cartItem);
//     notifyListeners();
//   }

//   void removeCartItem(CartItem cartItem) {
//     _cartItems.remove(cartItem);
//     notifyListeners();
//   }

//   void updateCartItemQuantity(CartItem cartItem, int incrementAmount) {
//     final index = _cartItems.indexOf(cartItem);
//     if (index != -1) {
//       _cartItems[index].quantity += incrementAmount;
//       notifyListeners();
//     }
//   }
// }