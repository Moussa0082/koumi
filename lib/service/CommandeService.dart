import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Commande.dart';
import 'package:koumi_app/models/CommandeAvecStocks.dart';
import 'package:koumi_app/models/DetailCommande.Dart';
import 'package:koumi_app/models/Stock.dart';


 class CommandeService extends ChangeNotifier{



      final String baseUrl = '$apiOnlineUrl/commande'; // Replace with your API URL
    // final String baseUrl = 'http://10.0.2.2:9000/api-koumi/commande'; // Replace with your API URL
            List<Commande> commandeList = [];


   Future<List<Commande>> fetchCommandeByActeur(String idActeur) async {
    try {
    final response = await http.get(Uri.parse('$baseUrl/getAllCommandeByActeur/${idActeur}'));
    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
      print("succes commande fetch by acteur qui a commandé");
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
       commandeList = body
          .map((e) => Commande.fromMap(e))
          .toList();
      // debugPrint("res:  ${response.body}");
      return commandeList; // Renvoyer la liste de commandes
    } else {
      debugPrint("erreur lors de la recuperation des  commande pour l'\ acteur $idActeur");
      // Si la réponse n'est pas un statut 200, renvoyer une liste vide
      return  commandeList = [];
    }
  } catch (e) {
    print('Error catch fetching commande for acteur $idActeur: $e');
    // En cas d'erreur, renvoyer une liste vide
    return commandeList = [];
  }
}
  
    Future<String> confirmerLivraison(String idDetailCommande, double quantiteLivree) async {
    final url = Uri.parse('$baseUrl/confirmerLivraison/$idDetailCommande/$quantiteLivree');

    try {
      final response = await http.put(url);

      if (response.statusCode == 200) {
        return json.decode(response.body)["message"];
      } else {
        throw Exception('Erreur lors de la confirmation de la commande: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la requête: $e');
    }
  }



   Future<String> getDetailCountByCommandeId(String commandeId) async {
    final url = Uri.parse('$baseUrl/$commandeId/details/count');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Erreur lors de la récupération du nombre de détails: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la requête: $e');
    }
  }




  
  Future<List<Commande>> fetchCommandeByActeurProprietaire(String acteurProprietaire) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/getAllCommandeByActeurProprietaire/${acteurProprietaire}'));
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {

     print("succes commande fetch by proprietaire");
               List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        commandeList = body
        // .where((commande) => commande['statutCommande'] == true)
        .map((e) => Commande.fromMap(e)).toList();
        return commandeList;
      } else {
        debugPrint("erreur lors de la recuperation des  commande pour l'\ acteur proprietaire $acteurProprietaire");
       return commandeList = [];
      }
    } catch (e) {
      print('Error catch fetching commande for acteur proprietaire $acteurProprietaire: $e');
    }
        return commandeList = [];
        
  }


 
  Future<List<DetailCommande>> fetchDetailsByCommandeId(String commandeId) async {
    final response = await http.get(Uri.parse('$baseUrl/$commandeId/details'));

    if (response.statusCode == 200) {
     List<dynamic> body = json.decode(response.body);
      print(' details fetch avec succes');
      print(' details fetch avec succes body ${response.body}');
        List<DetailCommande> details = body.map((dynamic item) => DetailCommande.fromJson(item)).toList();
        return details;
    } else {
      throw Exception('Failed to load details');
    }
  }



  Future<List<Commande>> fetchAllCommande() async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/getAllCommande'));
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {

               List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        commandeList = body
        .map((e) => Commande.fromMap(e)).toList();
        return commandeList;
      } else {
        debugPrint("erreur lors de la recuperation des  commandes");
         return commandeList = [];
      }
    } catch (e) {
      print('Error fetching all commandes : $e');
    }
        return commandeList = [];
        
  }

 void applyChange() {
    notifyListeners();
  }


   Future enableCommande(String id) async {
    final response = await http.put(Uri.parse('$baseUrl/$id/enable'));

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
      applyChange();
    } else {
      // Get.snackbar("Erreur", "Une erreur s'est produite veuiller réessayer ultérieurement",duration: Duration(seconds: 3));
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      // throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future disableCommane(String id) async {
    final response = await http.put(Uri.parse('$baseUrl/$id/disable'));

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
      applyChange();
    } else {
      // Get.snackbar("Erreur", "Une erreur s'est produite veuiller réessayer ultérieurement",duration: Duration(seconds: 3));
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      // throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
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