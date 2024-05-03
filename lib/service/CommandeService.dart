import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Commande.dart';
import 'package:koumi_app/models/CommandeAvecStocks.dart';
import 'package:koumi_app/models/Stock.dart';


 class CommandeService{

    final String baseUrl = 'https://koumi.ml/api-koumi/commande/'; // Replace with your API URL
    // final String baseUrl = 'http://10.0.2.2:9000/api-koumi/commande/'; // Replace with your API URL
        List<Commande> commande = [];



  Future<List<Commande>> fetchCommandeByActeur(String idActeur) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/getAllCommandeByActeur/${idActeur}'));
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {

               List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        commande = body
        // .where((commande) => commande['statutCommande'] == true)
        .map((e) => Commande.fromMap(e)).toList();
      } else {
        debugPrint("erreur lors de la recuperation des  commande pour l'\ acteur $idActeur");
      }
    } catch (e) {
      print('Error catch fetching commande for acteur $idActeur: $e');
    }
        return commande = [];
        
  }
  
  Future<List<Commande>> fetchCommandeByActeurProprietaire(String acteurProprietaire) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/getAllCommandeByActeurProprietaire/${acteurProprietaire}'));
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {

               List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        commande = body
        .where((commande) => commande['statutCommande'] == true)
        .map((e) => Commande.fromMap(e)).toList();
      } else {
        debugPrint("erreur lors de la recuperation des  commande pour l'\ acteur proprietaire $acteurProprietaire");
      }
    } catch (e) {
      print('Error catch fetching commande for acteur proprietaire $acteurProprietaire: $e');
    }
        return commande = [];
        
  }



  Future<List<Commande>> fetchAllCommande() async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/getAllCommande'));
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {

               List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        commande = body
        .map((e) => Commande.fromMap(e)).toList();
      } else {
        debugPrint("erreur lors de la recuperation des  commandes");
      }
    } catch (e) {
      print('Error fetching all commandes : $e');
    }
        return commande = [];
        
  }


//    Future<void> ajouterStocksACommandes() async {
//     try {
//       // Map cart items to stocks and intrants
//       List<Stock> stocks = [];
//       List<Intrant> intrants = [];

//       for (CartItem cartItem in cartItems) {
//         if (cartItem.stock != null) {
//           stocks.add(Stock(
//             idStock: cartItem.stock!.idStock,
//             quantiteStock: cartItem.quantiteStock.toDouble(),
//           ));
//         }

//         if (cartItem.intrant != null) {
//           intrants.add(Intrant(
//             idIntrant: cartItem.intrant!.idIntrant,
//             quantiteIntrant: cartItem.intrant!.quantiteIntrant!.toDouble(),
//           ));
//         }
//       }

//       // Prepare the Commande object
//       Acteur acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;

//       // Create CommandeAvecStocks object
//       CommandeAvecStocks commandeAvecStocks = CommandeAvecStocks(
//         acteur: acteur,
//         stocks: stocks,
//         intrants: intrants,
//         quantitesDemandees: stocks.map((stock) => stock.quantiteStock!).toList(),
//         quantitesIntrants: intrants.map((intrant) => intrant.quantiteIntrant!).toList(),
//       );
//  final response = await http.post(
//     Uri.parse(baseUrl),
//     headers: {"Content-Type": "application/json"},
//     body:  jsonEncode(commandeAvecStocks.toJson()),
//   );

//       if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Commande passé avec succès.'),
//           ),
//         );
//         print('Commande ajoutée avec succès. ${response.body}');
//         return await json.decode(json.encode(response.body));   
//         // jsonDecode(response.body);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//                 'Une erreur est survenue. Veuillez réessayer ultérieurement.'),
//           ),
//         );
//         print('Erreur lors de l\'ajout de la commande: ${response.body}');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               'Une erreur est survenue. Veuillez réessayer ultérieurement.'),
//         ),
//       );
//       print('Erreur lors de l\'envoi de la requête: $e');
//     }
//   }
  




 }