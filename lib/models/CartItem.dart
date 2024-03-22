// import 'package:koumi_app/models/Stock.dart';

// class CartItem {
//   final Stock stock;
//   int quantity;

//   CartItem({required this.stock, this.quantity = 1});
// }


import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/widgets/SnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCart  extends ChangeNotifier{
 List<Stock> _cartItems = [];

  Future<List<Stock>> loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartString = prefs.getString('cart') ?? '[]';
    List<dynamic> cartJson = jsonDecode(cartString);
    _cartItems = cartJson.map((item) => Stock.fromJson(item)).toList();
    return _cartItems;
  }

  // Méthode pour ajouter un produit au panier
  // Future<void> addToCart(Stock product) async {
  //   // Vérifier si le produit existe déjà dans le panier
  //   bool productExists = await _checkProductExistence(product);

  //   if (productExists) {
  //     // Afficher un message d'erreur si le produit existe déjà dans le panier
  //     Snack.error(
  //       titre: "Alerte",
  //       message: "Le produit existe déjà dans le panier",
  //     );
  //   } else {
  //     // Ajouter le produit au panier avec une quantité initiale de 1
  //     List<Stock> cart = await loadCartItems();
  //     cart.add(product);
  //     await _saveCart(cart);
  //     // Afficher un message de succès ou autre action après l'ajout au panier
  //     Snack.success(
  //       titre: "Succès",
  //       message: "Produit ajouté au panier",
  //     );
  //   }
  //   loadCartItems();
  //   applyChanges();
  // }
Future<void> addToCart(Stock product) async {
  // Vérifier si le produit existe déjà dans le panier
  bool productExists = await _checkProductExistence(product);

  if (productExists) {
    // Afficher un message d'erreur si le produit existe déjà dans le panier
    Snack.error(
      titre: "Alerte",
      message: "Le produit existe déjà dans le panier",
    );
  } else {
    // Créer un CartItem à partir des propriétés du produit
    Stock cartItem = Stock(
      idStock: product.idStock!,
      nomProduit: product.nomProduit!,
      photo: product.photo ?? '', // Utiliser l'image du produit s'il existe, sinon une chaîne vide
      quantiteStock: 1, // Quantité initiale de 1
    );

    // Ajouter le CartItem au panier
    List<Stock> cart = await loadCartItems();
    cart.add(cartItem);
    await _saveCart(cart);

    // Afficher un message de succès après l'ajout au panier
    Snack.success(
      titre: "Succès",
      message: "Produit ajouté au panier",
    );
  }

  // Charger à nouveau les éléments du panier
  loadCartItems();
  applyChanges();
}



  // Méthode pour vérifier si le produit existe déjà dans le panier
  Future<bool> _checkProductExistence(Stock product) async {
List<Stock> cart = await loadCartItems();
    bool exists = cart.any((item) => item.idStock == product.idStock);
    return exists;  
    }

  // Méthode pour sauvegarder le panier dans les SharedPreferences
  Future<void> _saveCart(List<Stock> cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartString = jsonEncode(cart);
    prefs.setString('cart', cartString);
    loadCartItems();
  }


  applyChanges() {
    notifyListeners();
  }

  }
