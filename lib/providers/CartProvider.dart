import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/models/CartItem.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/widgets/SnackBar.dart';


class CartProvider extends ChangeNotifier {
  final List<CartItem> cartItems = [];

  List<CartItem> get cartItem => cartItems;

  void addToCart(Stock product, int quantity, String selectedVariant) {
    var existingCartItem = cartItem.firstWhereOrNull(
      (item) => item.stock!.idStock == product.idStock,
    );

    if (existingCartItem != null) {
      // existingCartItem.quantiteStock += quantity;
    Snack.error(titre:"Alerte", message:existingCartItem.stock!.nomProduit! + " existe déjà au panier");
    } else {
      cartItem.add(CartItem(stock: product, quantiteStock: quantity));
    Snack.success(titre:"Alerte", message:product.nomProduit! + " a été ajouté au panier");

    }

    notifyListeners();
  }

  int getProductQuantity(int productId) {
    int quantity = 0;
    for (CartItem item in cartItem) {
      if (item.stock!.idStock == productId) {
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
        0.0, (sum, item) => sum + (item.stock!.prix! * item.quantiteStock));
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


  // List<CartItem> get cartItemInt => cartItemInt;

  // void addToCartInt(Intrant intrant, int quantity, String selectedVariant) {
  //   var existingCartItemInt = cartItemInt.firstWhereOrNull(
  //     (item) => item.intrant!.idIntrant == intrant.idIntrant,
  //   );

  //   if (existingCartItemInt != null) {
  //     // existingCartItem.quantiteStock += quantity;
  //   Snack.error(titre:"Alerte", message:existingCartItemInt.intrant!.nomIntrant + " existe déjà au panier");
  //   } else {
  //     cartItemInt.add(CartItem(intrant: intrant, quantiteIntrant: quantity));
  //   Snack.success(titre:"Alerte", message:intrant.nomIntrant + " a été ajouté au panier");

  //   }

  //   notifyListeners();
  // }

  // int getIntrantQuantity(int intrantId) {
  //   int quantity = 0;
  //   for (CartItem item in cartItemInt) {
  //     if (item.intrant!.idIntrant == intrantId) {
  //       quantity += item.quantiteIntrant;
  //     }
  //   }
  //   return quantity;
  // }

  // int get cartCountInt {
  //   return cartItemInt.fold(0, (sum, item) => sum + item.quantiteIntrant);
  // }

  // double get totalPriceInt {
  //   return cartItemInt.fold(
  //       0.0, (sum, item) => sum + (item.intrant!.prixIntrant * item.quantiteIntrant));
  // }

  // void updateCartItemQuantityInt(int index, int newQuantity) {
  //   if (index >= 0 && index < cartItemInt.length) {
  //     cartItemInt[index].quantiteIntrant = newQuantity;
  //     notifyListeners();
  //   }
  // }

  // void increaseCartItemQuantityInt(int index) {
  //   if (index >= 0 && index < cartItemInt.length) {
  //     cartItemInt[index].quantiteIntrant++;
  //     notifyListeners();
  //   }
  // }

  // void decreaseCartItemQuantityInt(int index) {
  //   if (index >= 0 && index < cartItemInt.length) {
  //     if (cartItemInt[index].quantiteIntrant > 1) {
  //       cartItemInt[index].quantiteIntrant--;
  //       notifyListeners();
  //     } else {
  //       // If the quantity is 1, remove the item from the cart
  //       cartItemInt.removeAt(index);
  //       notifyListeners();
  //     }
  //   }
  // }

  // void removeCartItemInt(int index) {
  //   if (index >= 0 && index < cartItemInt.length) {
  //     cartItemInt.removeAt(index);
  //     notifyListeners();
  //   }
  // }

  // void clearCartInt() {
  //   cartItemInt.clear();
  //   notifyListeners();
  // }

  // List<CartItem> getCartItemsListInt() {
  //   return List<CartItem>.from(cartItemInt);
  // }
}