import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/Unite.dart';
import 'package:koumi_app/models/ZoneProduction.dart';
import 'package:path/path.dart';

class StockService extends ChangeNotifier {
  // static const String baseUrl = 'https://koumi.ml/api-koumi/Stock';
  static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/Stock';

  List<Stock> stockList = [];
  List<dynamic> stockListe = [];
  // addStock

  static Future<void> creerStock({
    required String nomProduit,
    required String formeProduit,
    required String dateProduction,
    required String quantiteStock,
    required String typeProduit,
    required String descriptionStock,
    File? photo,
    required ZoneProduction zoneProduction,
    required Speculation speculation,
    required Unite unite,
    required Magasin magasin,
    required Acteur acteur,
  }) async {
    try {
      var requete = http.MultipartRequest('POST', Uri.parse('$baseUrl/create'));

      if (photo != null) {
        requete.files.add(http.MultipartFile(
            'image', photo.readAsBytes().asStream(), photo.lengthSync(),
            filename: basename(photo.path)));
      }

      requete.fields['stock'] = jsonEncode({
        'nomProduit': nomProduit,
        'formeProduit': formeProduit,
        'dateProduction': dateProduction,
        'quantiteStock': int.tryParse(quantiteStock),
        'typeProduit': typeProduit,
        'descriptionStock': descriptionStock,
        'photo': "",
        'zoneProduction': zoneProduction.toMap(),
        'speculation': speculation.toMap(),
        'unite': unite.toMap(),
        'magasin': magasin.toMap(),
        'acteur': acteur.toMap(),
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || responsed.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint('stock service ${donneesResponse.toString()}');
      } else {
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Une erreur s\'est produite lors de l\'ajout de acteur : $e');
    }
  }

  static Future<void> updateStock({
    required String idStock,
    required String nomProduit,
    required String formeProduit,
    required String dateProduction,
    required String quantiteStock,
    required String typeProduit,
    required String descriptionStock,
    File? photo,
    required ZoneProduction zoneProduction,
    required Speculation speculation,
    required Unite unite,
    required Magasin magasin,
    required Acteur acteur,
  }) async {
    try {
      var requete = http.MultipartRequest(
          'PUT', Uri.parse('$baseUrl/updateStock/$idStock'));

      if (photo != null) {
        requete.files.add(http.MultipartFile(
            'image', photo.readAsBytes().asStream(), photo.lengthSync(),
            filename: basename(photo.path)));
      }

      requete.fields['stock'] = jsonEncode({
        'nomProduit': nomProduit,
        'formeProduit': formeProduit,
        'dateProduction': dateProduction,
        'quantiteStock': int.tryParse(quantiteStock),
        'typeProduit': typeProduit,
        'descriptionStock': descriptionStock,
        'photo': "",
        'zoneProduction': zoneProduction.toMap(),
        'speculation': speculation.toMap(),
        'unite': unite.toMap(),
        'magasin': magasin.toMap(),
        'acteur': acteur.toMap(),
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || responsed.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint('stock service ${donneesResponse.toString()}');
      } else {
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Une erreur s\'est produite lors de l\'ajout de acteur : $e');
    }
  }

  Future<Stock> updateQuantiteStock(Stock stock, String id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/updateQuantiteStock/$id'),
      body: json.encode(stock.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Stock.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Impossible de mettre à jour la quantite : ${response.statusCode}');
    }
  }

  Future<List<Stock>> fetchStock() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:9000/Stock/getAllStocks'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Fetching data for: ${response.statusCode}");

        List<dynamic> body = jsonDecode(response.body);
        debugPrint("response body ${body.toString()}");
        stockList = body.map((e) => Stock.fromMap(e)).toList();
        debugPrint("stockList ${stockList.toString()}");
        return stockList;
      } else {
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(response.body)["message"]);
      }
    } catch (e) {
      print(
          'Une erreur s\'est produite lors de la récupération des stocks: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<Stock>> fetchStockByActeur(String idActeur) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/getAllStocksByActeurs/$idActeur'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Fetching data");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        stockList = body.map((e) => Stock.fromMap(e)).toList();
        debugPrint(stockList.toString());
        return stockList;
      } else {
        stockList = [];
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Stock>> fetchStockByMagasin(String idMagasin) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/getAllStocksByIdMagasin/$idMagasin'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Fetching data");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        stockList = body.map((e) => Stock.fromMap(e)).toList();
        debugPrint(stockList.toString());
        return stockList;
      } else {
        stockList = [];
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future deleteStock(String idStock) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/deleteStocks/$idStock'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future activerStock(String idActeur) async {
    final response = await http.post(Uri.parse('$baseUrl/activer/$idActeur'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future desactiverStock(String idStock) async {
    final response = await http.post(Uri.parse('$baseUrl/desactiver/$idStock'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  void applyChange() {
    notifyListeners();
  }
}
