import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/models/CartItem.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/widgets/SnackBar.dart';


class CartProvider extends ChangeNotifier {
  final List<CartItem> cartItems = [];

  List<CartItem> get cartItem => cartItems;

  void addToCart(Stock product, int quantity, String selectedVariant) {
    var existingCartItem = cartItem.firstWhereOrNull(
      (item) => item.stock.idStock == product.idStock,
    );

    if (existingCartItem != null) {
      // existingCartItem.quantiteStock += quantity;
    Snack.error(titre:"Alerte", message:existingCartItem.stock.nomProduit! + " existe déjà au panier");
    } else {
      cartItem.add(CartItem(stock: product, quantiteStock: quantity));
    Snack.success(titre:"Alerte", message:product.nomProduit! + " a été ajouté au panier");

    }

    notifyListeners();
  }

  int getProductQuantity(int productId) {
    int quantity = 0;
    for (CartItem item in cartItem) {
      if (item.stock.idStock == productId) {
        quantity += item.quantiteStock;
      }
    }
    return quantity;
  }

  int get cartCount {
    return cartItem.fold(0, (sum, item) => sum + item.quantiteStock);
  }

  double get totalPrice {
    return cartItem.fold(
        0.0, (sum, item) => sum + (item.stock.prix! * item.quantiteStock));
  }

  void updateCartItemQuantity(int index, int newQuantity) {
    if (index >= 0 && index < cartItem.length) {
      cartItem[index].quantiteStock = newQuantity;
      notifyListeners();
    }
  }

  void increaseCartItemQuantity(int index) {
    if (index >= 0 && index < cartItem.length) {
      cartItem[index].quantiteStock++;
      notifyListeners();
    }
  }

  void decreaseCartItemQuantity(int index) {
    if (index >= 0 && index < cartItem.length) {
      if (cartItem[index].quantiteStock > 1) {
        cartItem[index].quantiteStock--;
        notifyListeners();
      } else {
        // If the quantity is 1, remove the item from the cart
        cartItem.removeAt(index);
        notifyListeners();
      }
    }
  }

  void removeCartItem(int index) {
    if (index >= 0 && index < cartItem.length) {
      cartItem.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    cartItem.clear();
    notifyListeners();
  }

  List<CartItem> getCartItemsList() {
    return List<CartItem>.from(cartItem);
  }
}