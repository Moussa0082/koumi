import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:koumi_app/models/CartItem.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/screens/DetailProduits.dart';
import 'package:koumi_app/widgets/CustomText.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:koumi_app/widgets/SnackBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Panier extends StatefulWidget{
    

   Panier({super.key});

  @override
  State<Panier> createState() => _PanierState();
}

class _PanierState extends State<Panier> {


    // int itemCount = widget.cartItems?.length ?? 0;

    

   List<Stock> _cartItems = [];
   List<Stock> cartItems = [];

   late Future<List<Stock>> cart ;

  Future<List<Stock>> getListe() async {
  List<Stock> cartItems = await ShoppingCart().loadCartItems();
  setState(() {
    cart = Future.value(cartItems);
  });
  debugPrint("Nombre de produits: ${cartItems.length}");
  return cartItems;
  }

//  Future<List<Stock>> getListe() async {
//   List<Stock> cartItems = await ShoppingCart().loadCartItems();
//   // setState(() {
//   //   cart = Future.value(cartItems);
//   // });
//                                    setState(
//                                           () {
//                                         cart =cartItems as Future<List<Stock>>;
                                             
//                                       });
//   debugPrint("Nombre de produits: ${cartItems.length}");
//   return cartItems;
// }


  @override
  void initState() {
    super.initState();
    // _loadCartItems();
    cart = getListe();
  }

  // Future<void> _loadCartItems() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String cartString = prefs.getString('cart') ?? '[]';
  //   List<Map<String, dynamic>> cart = List<Map<String, dynamic>>.from(jsonDecode(cartString));
  //   setState(() {
  //     _cartItems = cart;
  //   });
  // }
  void _loadCartItems() async {
  List<Stock> cart = await ShoppingCart().loadCartItems();
  // Faites quelque chose avec la liste des produits récupérée, par exemple :
  setState(() {
    _cartItems = cart;
  });
}


 void _removeFromCart(int index) async {
  List<Stock> cart = await ShoppingCart().loadCartItems();
    setState(() {
    cartItems[index].quantiteStock = (_cartItems[index].quantiteStock as int) + 1;
    
  });
  if(cartItems[index].quantiteStock as int < 1){
    
  cart.removeAt(index); // Supprimer l'élément du panier
  }
  await ShoppingCart().saveCart(cart); // Sauvegarder le panier mis à jour

  // Mettre à jour les préférences partagées
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('cart', jsonEncode(cart.map((stock) => stock.toJson()).toList()));

  // Afficher un message de succès ou autre action après la suppression de l'élément du panier
  Snack.success(
    titre: "Succès",
    message: "Produit supprimé du panier",
  );
}


 void _incrementQuantity(int index) {
  setState(() {
    _cartItems[index].quantiteStock = (_cartItems[index].quantiteStock as int) + 1;
    
  });
  _saveCart();
}

  void _decrementQuantity(int index) {
    if (_cartItems[index].quantiteStock!.toInt() >= 1) {
      setState(() {
    _cartItems[index].quantiteStock = (_cartItems[index].quantiteStock as int) - 1;
      });
      _saveCart();
    } else {
      // Si la quantité est égale à 1, supprimer le produit du panier
      setState(() {
        _cartItems.removeAt(index);
      });
      ShoppingCart().loadCartItems(); // Charger à nouveau les éléments du panier après la mise à jour
    }
     Snack.success(
    titre: "Succès",
    message: "Produit supprimé du panier",
  );
  }



  // void _incrementQuantity(int index) {
  //   setState(() {
  //     _cartItems[index].quantiteStock ++;
  //   });
  //   _saveCart();
  // }

//  void _decrementQuantity(int index) {
//   if (_cartItems[index]['quantiteProduit'] >= 1) {
//     setState(() {
//       _cartItems[index]['quantiteProduit']--;
//     });
//     _saveCart();
//   } else {
//     // Si la quantité est égale à 1, supprimer le produit du panier
//     setState(() {
//       _cartItems.removeAt(index);
      
//     });
//     _saveCart();
//       _loadCartItems(); // Charger à nouveau les éléments du panier après la mise à jour

//   }
// }


  Future<void> _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartString = jsonEncode(_cartItems);
    prefs.setString('cart', cartString);
  }

  @override
  Widget build(BuildContext context) {

    // Calcul du total des produits
 // Calcul du total des produits
// num total = 0;
// _cartItems.forEach((item) {
//   total += item['prix'] * item['quantiteProduit'];
// });

// Calcul du total final incluant les frais de livraison
// num totalWithDelivery = total + 1000;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
        centerTitle:true,
      ),
      body:
Consumer<ShoppingCart>(
        builder: (context, card, child) {
          return FutureBuilder(
            future: cart,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } 
               if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset('assets/images/notif.jpg'),
                      SizedBox(height: 10),
                      Text(
                        'Panier vide erreur',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              } 
               if (snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset('assets/images/notif.jpg'),
                      SizedBox(height: 10),
                      Text(
                        'Panier vide',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              } 
              else {
             cartItems = snapshot.data!;
                return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    Stock item = cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Get.to(DetailProduits());
                          },
                          child: ListTile(
                            leading: Image.asset("assets/images/mang.jpg"),
                            title: Text(item.nomProduit ?? ''),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                              onPressed: () => _removeFromCart(index),
                              // onPressed: () => _decrementQuantity(index),
                                    ),
                                    Text('${item.quantiteStock!.toInt() ?? 0}', style: TextStyle(fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: Icon(Icons.add),
                onPressed: () => null
                                ),
                // onPressed: () => _incrementQuantity(index)                                    ),
                                  ],
                                ),
                                Text('${item.prix ?? 0} FCFA', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic))
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    
//                     }
//   });
// })
      //   Container(
      //        padding: EdgeInsets.all(20),
      //        decoration: BoxDecoration(
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 2,
      //       blurRadius: 5,
      //       offset: Offset(0, -3),
      //     ),
      //   ],
      //   color: Colors.white,
      //        ),
      //        child: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Text('Total'),
      //         Text('$total FCFA'),
      //       ],
      //     ),
      //     SizedBox(height: 10),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Text('Frais de livraison'),
      //         Text('1000 FCFA'),
      //       ],
      //     ),
      //     SizedBox(height: 20),
      //     ElevatedButton(
      //       onPressed: () {
      //         // Logique pour le paiement
      //       },
      //       child: Text('Payer'),
      //     ),
      //   ],
      //        ),
      //      ),
    );
  }

}