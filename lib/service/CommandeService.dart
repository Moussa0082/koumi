import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Commande.dart';
import 'package:koumi_app/models/CommandeAvecStocks.dart';
import 'package:koumi_app/models/Stock.dart';


 class CommandeService{

    // final String apiUrl = 'https://koumi.ml/api-koumi/commande/'; // Replace with your API URL
    final String apiUrl = 'http://10.0.2.2:9000/api-koumi/commande/'; // Replace with your API URL


Future<Commande> createCommande(CommandeAvecStocks commandeAvecStocks) async {
    final url = '$apiUrl/add';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(commandeAvecStocks.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("succes " + data);
      return Commande.fromJson(data);
    } else {
      throw Exception('Erreur lors de la création de commande. Status code: ${response.statusCode}');
    }
  }


  Future<Map<String, dynamic>> ajouterStocksACommande(CommandeAvecStocks commandeAvecStocks) async {
    final String apiUrl = 'http://10.0.2.2/api-koumi/commande/add';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'commande': commandeAvecStocks.commande.toJson(),
          'stocks': commandeAvecStocks.stocks.map((stock) => stock.toJson()).toList(),
          'intrants': commandeAvecStocks.intrants!.map((intrant) => intrant.toJson()).toList(),
          'quantitesDemandees': commandeAvecStocks.quantitesDemandees,
          'quantitesIntrants': commandeAvecStocks.quantitesIntrants,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add stocks to order');
      }
    } catch (e) {
      throw Exception('Failed to add stocks to order: $e');
    }
  }

 Future<void> makeCommand(List<String> idStocks, Commande commande) async {

  // Create a Commande object

  // Create a list of Stock objects based on the idStocks list
  final List<Stock> stocks = idStocks.map((idStock) => Stock(idStock: idStock)).toList();

  // Create a CommandeAvecStocks object
  final commandeAvecStocks = CommandeAvecStocks(
    commande: commande,
    stocks: stocks,
    quantitesDemandees: List.filled(stocks.length, 1), // Assuming all quantities are 1 for now
  );

  try {
    final response = await http.post(
      Uri.parse(apiUrl + '/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(commandeAvecStocks.toJson()), // Convert CommandeAvecStocks to JSON
    );

    if (response.statusCode == 200) {
      print('Commande ajoutée avec succès.: ${response.body}');

    } else {
      print('Erreur lors de l\'ajout de la commande: ${response.body}');
    }
  } catch (e) {
    print('Exception lors de l\'envoi de la commande: $e');
  }
}


 }