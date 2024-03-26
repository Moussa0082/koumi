// // import 'package:koumi_app/models/Stock.dart';

// // class CartItem {
// //   final Stock stock;
// //   int quantity;

// //   CartItem({required this.stock, this.quantity = 1});
// // }


// import 'dart:convert';
// import 'package:flutter/material.dart';

// import 'package:koumi_app/models/Stock.dart';
// import 'package:koumi_app/widgets/SnackBar.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ShoppingCart  extends ChangeNotifier{
//  List<Stock> cartItems = List.empty(growable: true);

//   late SharedPreferences prefs;



//   Future<List<Stock>> loadCartItems() async {
//     prefs = await SharedPreferences.getInstance();
//     List<String>? cartString = prefs.getStringList('cart');
//     if(cartString != null) {

//     cartItems = cartString.map((cart) => Stock.fromJson(json.decode(cart))).toList();
//     debugPrint("data load"   + cartString.toString());
//     // debugPrint("data l" + cartItems.map((e) => e.nomProduit!).toString());
//     }else{
//     debugPrint("data null");

//     }
//     applyChanges();
  
//     return cartItems;
//   }




//    Future<void> addToCart(Stock product) async {
//   // Vérifier si le produit existe déjà dans le panier
//   bool productExists = await _checkProductExistence(product);

//   if (productExists) {
//     // Afficher un message d'erreur si le produit existe déjà dans le panier
//     Snack.error(
//       titre: "Alerte",
//       message: "Le produit existe déjà dans le panier",
//     );
//   } else {
//     // Créer un CartItem à partir des propriétés du produit
//     Stock cartItem = Stock(
//       idStock: product.idStock!,
//       nomProduit: product.nomProduit!,
//       prix: product.prix!,
//       photo: product.photo ?? '', // Utiliser l'image du produit s'il existe, sinon une chaîne vide
//       quantiteStock: 1, // Quantité initiale de 1
//     );
//     // Ajouter le CartItem au panier
//     List<Stock> cart = await loadCartItems();
//     cart.add(cartItem);
//     await saveCart(cart).then((value) => {
//         Snack.success(
//       titre: "Succès",
//       message: "Produit ajouté au panier",
//     )
//     });
//     // debugPrint("data s" + cart.map((e) => e.nomProduit!).toString());

//     // Afficher un message de succès après l'ajout au panier
  
//   }
//     // debugPrint("data after" + cartItems.map((e) => e.nomProduit!).toString());
//   loadCartItems();
//   // Charger à nouveau les éléments du panier
//   applyChanges();
// }




//   // Méthode pour vérifier si le produit existe déjà dans le panier
//   Future<bool> _checkProductExistence(Stock product) async {
//     List<Stock> cart = await loadCartItems();
//     bool exists = cart.any((item) => item.idStock == product.idStock);
//     return exists;  
//     }

//      void removeFromCart(int index) {
//     cartItems.removeAt(index);
//     notifyListeners();
//   }

//     void clearCart() {
//     cartItems.clear();
//     prefs.remove('cart');
//     notifyListeners();
//   }


// Future<void> saveCart(List<Stock> stock) async {
  
//   List<String> cartString = stock.map((stock) => jsonEncode(stock.toJson())).toList();
//   prefs.setStringList('cart', cartString);
//       debugPrint("data list" + cartString.toString());

// }

//   applyChanges() {
//     notifyListeners();
//   }

//   }











import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/widgets/SnackBar.dart';
import 'package:provider/provider.dart';

// Modèle de panier
class CartItem {
  final Stock stock;
  int quantiteStock;
  CartItem({required this.stock,  this.quantiteStock = 1});
  // List<Stock> cartItems = [];

  // // Ajouter un produit au panier
  // void addToCart(Stock product) {
  //       Stock cartItem = Stock(
  //     idStock: product.idStock!,
  //     nomProduit: product.nomProduit!,
  //     prix: product.prix!,
  //     photo: product.photo ?? '', // Utiliser l'image du produit s'il existe, sinon une chaîne vide
  //     quantiteStock: 1, // Quantité initiale de 1
  //   );
  //    if (cartItems.contains(cartItem)) {
  //     // Afficher un message snack si le produit existe dé  
  //     Snack.error(titre: "Alerte", message: product.nomProduit! + " existe déjà au panier");
  //   }else{

  //   cartItems.add(cartItem);
  //   notifyListeners();
  //     Snack.success(titre: "Succès", message: product.nomProduit! + " ajouté au panier");
  //   }
  // }

  // // Supprimer un produit du panier
  // void removeFromCart(Stock product) {
  //   cartItems.remove(product);
  //   notifyListeners();
  // }

  // // Obtenir la liste des produits dans le panier
  // List<Stock> get cartItem => cartItems;
}