import 'dart:convert';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CartItem.dart';
import 'package:koumi_app/models/Commande.dart';
import 'package:koumi_app/models/CommandeAvecStocks.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/CartProvider.dart';
import 'package:koumi_app/service/CommandeService.dart';
import 'package:koumi_app/widgets/CartListItem.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:koumi_app/widgets/SnackBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Panier extends StatefulWidget {
  Panier({super.key});

  @override
  State<Panier> createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  // int itemCount = widget.cartItems?.length ?? 0;

  //  List<Stock> _cartItems = [];
  //  List<Stock> cartItemss = [];
  List<CartItem> cartItems = [];
  String currency = "FCFA";

  late Acteur acteur = Acteur();
  late List<CartItem> cartItem;
  bool isLoading = false;

  String? email = "";
  bool isExist = false;

  // void verify() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   email = prefs.getString('emailActeur');
  //   if (email != null) {
  //     // Si l'email de l'acteur est présent, exécute checkLoggedIn
  //     acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
  //     cartItems = Provider.of<CartProvider>(context, listen: false).cartItems;
  //     setState(() {
  //       isExist = true;
  //     });
  //   } else {
  //     setState(() {
  //       isExist = false;
  //     });
  //   }
  // }


  Future<void> ajouterStocksACommandes(CommandeAvecStocks commandeAvecStocks) async {
  final String apiUrl = 'http://10.0.2.2:9000/api-koumi/commande/add';

  try {
    // Récupérez les informations de l'acteur connecté depuis votre application Flutter
    // Assurez-vous que vous avez ces informations disponibles, peut-être stockées dans un Provider ou un autre mécanisme de gestion d'état


    // Ajoutez l'acteur connecté à la commande
    commandeAvecStocks.commande!.acteur = acteur;

    final response = await http.post(
      Uri.tryParse(apiUrl)!,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'commande': commandeAvecStocks.commande?.toJson(),
        'stocks': commandeAvecStocks.stocks?.map((stock) => stock.toJson()).toList(),
        'intrants': commandeAvecStocks.intrants?.map((intrant) => intrant.toJson()).toList(),
        'quantitesDemandees': commandeAvecStocks.quantitesDemandees,
        'quantitesIntrants': commandeAvecStocks.quantitesIntrants,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
      return json.decode(response.body);
    } else {
      print('Failed to add stocks to order ${response.body.toString()} ');
    }
  } catch (e) {
    print('Failed to add stocks to order: $e');
  }
}


  _createCommande() async {
    // Get the current cart items
   // Map each CartItem to a Stock object
  List<Stock> stocks = cartItems.map((cartItem) {
  if (cartItem.stock != null) {
    return Stock(
      idStock: cartItem.stock!.idStock,
      quantiteStock: cartItem.quantiteStock.toDouble(),
    );
  } else {
    // Handle the case when stock is null
    // For example, return a default Stock object or throw an exception
    // Here, I'm returning a default Stock object with idStock as 0
    return Stock(idStock: null, quantiteStock: 0);
  }
}).toList();

// Map each CartItem to an Intrant object
List<Intrant> intrants = cartItems.map((cartItem) {
  if (cartItem.intrant != null) {
    return Intrant(
      idIntrant: cartItem.intrant!.idIntrant,
      quantiteIntrant: cartItem.quantiteStock.toDouble(),
    );
  } else {
    // Handle the case when intrant is null
    // For example, return a default Intrant object or throw an exception
    // Here, I'm returning a default Intrant object with idIntrant as 0
    return Intrant(idIntrant: null, quantiteIntrant: 0);
  }
}).toList();

    // // Map each CartItem to a Stock object
    // List<Stock> stocks = cartItems.map((cartItem) {
    //   return Stock(
    //     idStock:
    //         cartItem.stock!.idStock, // Assuming stock is a property in CartItem
    //     quantiteStock: cartItem.quantiteStock
    //         .toDouble(), // Assuming quantiteStock is of type double
    //   );
    // }).toList();
    // // Map each CartItem to a Intrant object
    // List<Intrant> intrants = cartItems.map((cartItem) {
    //   return Intrant(
    //     idIntrant:
    //         cartItem.intrant!.idIntrant, // Assuming stock is a property in CartItem
    //     quantiteIntrant: cartItem.quantiteStock
    //         .toDouble(), // Assuming quantiteStock is of type double
    //   );
    // }).toList();

    // Prepare the Commande object
    // Acteur acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    
    // commande.acteur = acteur;

    // Create CommandeAvecStocks object
    Commande commande =  Commande(acteur: acteur);
    CommandeAvecStocks commandeAvecStocks = CommandeAvecStocks(
      commande: commande,
      stocks: stocks,
      intrants: intrants,
      quantitesDemandees: stocks.map((stock) => stock.quantiteStock!).toList(),
      quantitesIntrants: intrants.map((intrant) => intrant.quantiteIntrant!).toList(),
    );

    // Convert to JSON
    // String jsonData = jsonEncode(commandeAvecStocks);

    // Make the HTTP request
    // final url = 'https://koumi.ml/api-koumi/commande/add';
    final url = 'http://10.0.2.2:9000/api-koumi/commande/add';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body:  jsonEncode(commandeAvecStocks),
      );

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        // Commande ajoutée avec succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Commande passé avec succès.'),
          ),
        );
        print('Commande ajoutée avec succès. ${response.body}');
        return response;
      }  else {
        // Autre erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Une erreur est survenue. Veuillez réessayer ultérieurement.'),
          ),
        );
      }
      print('Erreur lors de l\'ajout de la commande: ${response.body}');
    } catch (e) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Une erreur est survenue. Veuillez réessayer ultérieurement.'),
        ),
      );
      setState(() {
        isLoading = false;
      });
      print('Erreur lors de l\'envoi de la requête: $e');
    }
  }

  void _handleButtonPress() async {
    // Afficher l'indicateur de chargement
    setState(() {
      isLoading = true;
    });

    await _createCommande().then((_) {
      // Cacher l'indicateur de chargement lorsque votre fonction est terminée
      setState(() {
        isLoading = false;
      });
    });
  }

   

 


  @override
  void initState() {
    super.initState();
    // verify();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text("Panier", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          centerTitle: true,
          actions: [
            Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                        return badges.Badge(
                          position:
                              badges.BadgePosition.bottomEnd(bottom: 1, end: 1),
                          badgeContent: Text(
                            cartProvider.cartItems.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.local_mall),
                            iconSize: 25,
                            onPressed: () {},
                          ),
                        );
                      },
                    ),
          ],
        ),
        // backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Column(
            children: [
     
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 80, top: 20),
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          final List<CartItem> cartItems =
                              cartProvider.cartItems;
                          

                          if (cartItems.isEmpty) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Image.asset('assets/images/notif.jpg'),
                                      const SizedBox(
                                        height: 10,
                                      ),
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
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final cartItem = cartItems[index];
                              return Dismissible(
                                key: Key(cartItem.isStock == true ? cartItem.stock!.idStock! : cartItem.intrant!.idIntrant!),
                                // Use a unique key for each item
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .removeCartItem(index);
                                },
                                child: GestureDetector(
                                  onTap: () {

                                  },
                                  child: CartListItem(
                                    cartItem: cartItem,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Container()),
                            cartProvider.cartItems.isEmpty
                                ? SizedBox()
                                : ElevatedButton(
                                    onPressed: () {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .clearCart();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      "Vider panier",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ],
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Prix Total:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Expanded(child: Container()),
                            Text(
                              '${cartProvider.totalPrice.toInt()}F',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Prepare the JSON payload
                              if (cartProvider.cartItems.isNotEmpty) {
                                _handleButtonPress();
//                                  List<Stock> stocks = cartItems.map((cartItem) {
//   if (cartItem.stock != null) {
//     return Stock(
//       idStock: cartItem.stock!.idStock,
//       quantiteStock: cartItem.quantiteStock.toDouble(),
//     );
//   } else {
//     // Handle the case when stock is null
//     // For example, return a default Stock object or throw an exception
//     // Here, I'm returning a default Stock object with idStock as 0
//     return Stock(idStock: null, quantiteStock: 0);
//   }
// }).toList();

// // Map each CartItem to an Intrant object
// List<Intrant> intrants = cartItems.map((cartItem) {
//   if (cartItem.intrant != null) {
//     return Intrant(
//       idIntrant: cartItem.intrant!.idIntrant,
//       quantiteIntrant: cartItem.quantiteStock.toDouble(),
//     );
//   } else {
//     // Handle the case when intrant is null
//     // For example, return a default Intrant object or throw an exception
//     // Here, I'm returning a default Intrant object with idIntrant as 0
//     return Intrant(idIntrant: null, quantiteIntrant: 0);
//   }
// }).toList();

//     // Prepare the Commande object
//     // Create CommandeAvecStocks object
   
//    Commande commande = Commande();
//     CommandeAvecStocks commandeAvecStocks = CommandeAvecStocks(
//       commande: commande,
//       stocks: stocks,
//       intrants: intrants,
//       quantitesDemandees: stocks.map((stock) => stock.quantiteStock!).toList(),
//       quantitesIntrants: intrants.map((intrant) => intrant.quantiteIntrant!).toList(),
//     );
//        commandeAvecStocks.commande?.acteur = acteur;

//                                 ajouterStocksACommandes(
//                                   commandeAvecStocks
//                                   ).then((value) => {

//                                   });

                              } else {
                                Snack.error(
                                    titre: "Alerte",
                                    message:
                                        "Veuiller ajouté au moins 1 produit à votre panier");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              elevation: 10,
                            ),
                            child: const Text('Commander',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
