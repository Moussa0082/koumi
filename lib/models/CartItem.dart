// import 'package:koumi_app/models/Stock.dart';

// class CartItem {
//   final Stock stock;
//   int quantity;

//   CartItem({required this.stock, this.quantity = 1});
// }


import 'dart:convert';

import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/widgets/SnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCart {
  static final ShoppingCart _instance = ShoppingCart._internal();

  factory ShoppingCart() {
    return _instance;
  }

  ShoppingCart._internal();

  // Méthode pour ajouter un produit au panier
  Future<void> addToCart(Stock product) async {
    // Vérifier si le produit existe déjà dans le panier
    bool productExists = await _checkProductExistence(product);

    if (productExists) {
      // Afficher un message d'erreur si le produit existe déjà dans le panier
      Snack.error(titre: "Alerte",
        message:"Le produit existe déjà dans le panier"
      );
    } else {
      // Ajouter le produit au panier avec une quantité initiale de 1
      Map<String, dynamic> cartItem = {
        'idStock': product.idStock,
        'nomProduit': product.nomProduit,
        'prix': product.prix,
        'quantiteProduit': 1,
      };
      List<Map<String, dynamic>> cart = await _getCart();
      cart.add(cartItem);
      await _saveCart(cart);
      // Afficher un message de succès ou autre action après l'ajout au panier
      Snack.success(titre: "Succès",
        message:"Produit ajouté au panier"
      );
    }
  }

  // Méthode pour vérifier si le produit existe déjà dans le panier
  Future<bool> _checkProductExistence(Stock product) async {
    List<Map<String, dynamic>> cart = await _getCart();
    bool exists = cart.any((item) => item['idStock'] == product.idStock);
    return exists;
  }

  // Méthode pour récupérer le panier depuis les SharedPreferences
  Future<List<Map<String, dynamic>>> _getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartString = prefs.getString('cart') ?? '[]';
    List<Map<String, dynamic>> cart = List<Map<String, dynamic>>.from(jsonDecode(cartString));
    return cart;
  }

  // Méthode pour sauvegarder le panier dans les SharedPreferences
  Future<void> _saveCart(List<Map<String, dynamic>> cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartString = jsonEncode(cart);
    prefs.setString('cart', cartString);
  }
}
