import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/models/CartItem.dart';
import 'package:koumi_app/models/Stock.dart';


class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(Stock product, int quantity, String selectedVariant) {
    var existingCartItem = _cartItems.firstWhereOrNull(
      (item) => item.stock.idStock == product.idStock,
    );

    if (existingCartItem != null) {
      existingCartItem.quantiteStock += quantity;
    } else {
      _cartItems.add(CartItem(stock: product, quantiteStock: quantity));
    }

    notifyListeners();
  }

  int getProductQuantity(int productId) {
    int quantity = 0;
    for (CartItem item in _cartItems) {
      if (item.stock.idStock == productId) {
        quantity += item.quantiteStock;
      }
    }
    return quantity;
  }

  int get cartCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantiteStock);
  }

  double get totalPrice {
    return _cartItems.fold(
        0.0, (sum, item) => sum + (item.stock.prix! * item.quantiteStock));
  }

  void updateCartItemQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index].quantiteStock = newQuantity;
      notifyListeners();
    }
  }

  void increaseCartItemQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index].quantiteStock++;
      notifyListeners();
    }
  }

  void decreaseCartItemQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      if (_cartItems[index].quantiteStock > 1) {
        _cartItems[index].quantiteStock--;
        notifyListeners();
      } else {
        // If the quantity is 1, remove the item from the cart
        _cartItems.removeAt(index);
        notifyListeners();
      }
    }
  }

  void removeCartItem(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  List<CartItem> getCartItemsList() {
    return List<CartItem>.from(_cartItems);
  }
}