import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/Unite.dart';
import 'package:koumi_app/models/ZoneProduction.dart';
import 'package:path/path.dart';

class StockService extends ChangeNotifier {
  static const String baseUrl = 'https://koumi.ml/api-koumi/Stock';
  // static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/Stock';

  List<Stock> stockList = [];
  // List<dynamic> stockListe = [];
  // addStock

   Future<void> creerStock({
    required String nomProduit,
    required String formeProduit,
    required String origineProduit,
    required String prix,
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
      var requete = http.MultipartRequest('POST', Uri.parse('$baseUrl/addStock'));

      if (photo != null) {
        requete.files.add(http.MultipartFile(
            'image', photo.readAsBytes().asStream(), photo.lengthSync(),
            filename: basename(photo.path)));
      }

      requete.fields['stock'] = jsonEncode({
        'nomProduit': nomProduit,
        'formeProduit': formeProduit,
        'origineProduit': origineProduit,
        'prix': prix,
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

      if (response.statusCode == 200 || responsed.statusCode == 201 || responsed.statusCode == 202) {
        final donneesResponse = json.decode(responsed.body);
              Get.snackbar("Succès", "Produit ajouté avec succès",duration: Duration(seconds: 3));
        debugPrint('stock service ${donneesResponse.toString()}');
      } else {
          //  Get.snackbar("Erreur", "Une erreur s'est produite veuiller réessayer plus tard",duration: Duration(seconds: 3));
         
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
              debugPrint('stock service erreur $e');

      Get.snackbar("Erreur", "Une erreur s'est produite veuiller réessayer ultérieurement",duration: Duration(seconds: 3));
      throw Exception(
          'Une erreur s\'est produite lors de l\'ajout de acteur : $e');
    }
  }

   Future<void> updateStock({
    required String idStock,
    required String nomProduit,
    required String formeProduit,
    required String prix,
    required String origineProduit,
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
        'idStock': idStock,
        'nomProduit': nomProduit,
        'formeProduit': formeProduit,
        'origineProduit': origineProduit,
        'prix': prix,
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

      if (response.statusCode == 200 || responsed.statusCode == 201 || responsed.statusCode == 202) {
        Get.snackbar("Succès", "Produit modifier avec succès",duration: Duration(seconds: 3));
        final donneesResponse = json.decode(responsed.body);
        debugPrint('stock service update ${donneesResponse.toString()}');
      } else {
          //  Get.snackbar("Erreur", "Une erreur s'est produite veuiller réessayer ultérieurement",duration: Duration(seconds: 3));
        final errorMessage =
            json.decode(utf8.decode(responsed.bodyBytes))['message'];
                    debugPrint(' erreur : ${errorMessage}');
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
                Get.snackbar("Erreur", "Une erreur s'est produite veuiller réessayer ultérieurement",duration: Duration(seconds: 3));
      debugPrint("catch erreur : $e");
      throw Exception(
          'Une erreur s\'est produite lors de la modification du produit : $e');
    }
  }

  Future<List<Stock>> fetchStockBySpeculation(
      String idSpeculation) async {
    final response = await http
        .get(Uri.parse('$baseUrl/getAllStocksBySpeculation/$idSpeculation'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      stockList = body.map((item) => Stock.fromMap(item)).toList();
      debugPrint(response.body);
      return stockList;
    } else {
      stockList = [];

      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
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
     Get.snackbar("Erreur", "Une erreur s'est produite veuiller réessayer ultérieurement",duration: Duration(seconds: 3));
      throw Exception(
          'Impossible de mettre à jour la quantite : ${response.statusCode}');
    }
  }

  Future<List<Stock>> fetchStock() async {
    try {
      final response =
          await http.get(Uri.parse('https://koumi.ml/api-koumi/Stock/getAllStocks'));
          // await http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Stock/getAllStocks'));

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {

        List<dynamic> body = jsonDecode(response.body);
        debugPrint("response body ${body.toString()}");
        stockList = body
      // where((stock) => stock['statutSotck'] == true)
        .map((e) => Stock.fromMap(e)).toList();
        debugPrint("stockList all ${stockList.toList()}");
        return stockList;
      } else {
        stockList = [];
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(response.body)["message"]);
      }
    } catch (e) {
      print(
          'Une erreur s\'est produite lors de la récupération des stocks: $e');
      // throw Exception(e.toString());
              return stockList;
    }
  
  }

  Future<List<Stock>> fetchStockByActeur(String id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/getAllStocksByActeurs/$id'));

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        print("Fetching data all stocks by acteur");
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
            print('Error fetching magasins : $e');
      // throw Exception(e.toString());
    }
        return stockList;
  }


  
   Future<List<Stock>> fetchProduitByCategorieProduitMagAndActeur(String idCategorie, String idMagasin, String idActeur) async {
    try {
      final response = await http.get(Uri.parse(
        
          'https://koumi.ml/api-koumi/Stock/categorieAndActeur/$idCategorie/$idMagasin/$idActeur'));
          // 'http://10.0.2.2:9000/api-koumi/Stock/categorieAndActeur/$idCategorie/$idMagasin/$idActeur'));
      if (response.statusCode == 200) {
                print("Fetching data all stock by id ,categorie, magasin and acteur");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        stockList = body
        // .where((stock) => stock['statutSotck'] == true)
        .map((e) => Stock.fromMap(e)).toList();
        debugPrint(stockList.toString());
        return stockList;
      } else {
        stockList = [];
        debugPrint('Failed to load stock');
      }
    } catch (e) {
      print('Error fetching stock: $e');
    }
    return stockList;
  }

  Future<List<Stock>> fetchProduitByCategorieAndMagasin(String idCategorie, String idMagasin) async {
    try {
      final response = await http.get(Uri.parse(
          'https://koumi.ml/api-koumi/Stock/categorieAndMagasin/$idCategorie/$idMagasin'));
          // 'http://10.0.2.2:9000/api-koumi/Stock/categorieAndMagasin/$idCategorie/$idMagasin'));
      if (response.statusCode == 200) {
                print("Fetching data all stock by id categorie and id magasin");
          List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        stockList = body
        .where((stock) => stock['statutSotck'] == true)
        .map((e) => Stock.fromMap(e)).toList();
        debugPrint(stockList.toString());
      } else {
        debugPrint('Failed to load stock');
      }
    } catch (e) {
      print('Error fetching stock: $e');
    }
    return stockList;
  }


   
   Future<List<Stock>> fetchProduitByCategorieAndActeur(String idCategorie, String idActeur) async {
    try {
      final response = await http.get(
          Uri.parse('https://koumi.ml/api-koumi/Stock/categorieAndIdActeur/$idCategorie/$idActeur'));
          // Uri.parse('http://10.0.2.2:9000/api-koumi/Stock/categorieAndIdActeur/$idCategorie/$idActeur'));
       if (response.statusCode == 200) {
                    // await Future.delayed(Duration(seconds: 2));
                            print("Fetching data all stock by id categorie and id acteur");
          List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        stockList = body
        // .where((stock) => stock['statutSotck'] == true)
        .map((e) => Stock.fromMap(e)).toList();
        debugPrint(stockList.toString());
      } else {
        throw Exception('Failed to load stock');
      }
    } catch (e) {
      print('Error fetching stock: $e');
    }
    return stockList;
  }

   Future<List<Stock>> fetchProduitByCategorie(String id) async {
    try {
      final response = await http.get(
          Uri.parse('https://koumi.ml/api-koumi/Stock/categorieProduit/$id'));
          // Uri.parse('http://10.0.2.2:9000/api-koumi/Stock/categorieProduit/$id'));
       if (response.statusCode == 200) {
                print("Fetching data all stock by id categorie produit");
          List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        stockList = body
        .where((stock) => stock['statutSotck'] == true)
        .map((e) => Stock.fromMap(e)).toList();
        debugPrint(stockList.toString());
        return stockList;
      } else {
        stockList = [];
        throw Exception('Failed to load stock');
      }
    } catch (e) {
      print('Error fetching stock: $e');
    }
    return stockList;
  }


  Future<List<Stock>> fetchStockByMagasin(String id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/getAllStocksByIdMagasin/$id'));

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        print("Fetching data all stock by id magasin");
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

  Future deleteStock(String id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/deleteStocks/$id'));

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
      applyChange();
    } else {
      // Get.snackbar("Erreur", "Une erreur s'est produite veuiller réessayer ultérieurement",duration: Duration(seconds: 3));
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future activerStock(String id) async {
    final response = await http.put(Uri.parse('$baseUrl/activer/$id'));

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
      applyChange();
    } else {
      // Get.snackbar("Erreur", "Une erreur s'est produite veuiller réessayer ultérieurement",duration: Duration(seconds: 3));
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future desactiverStock(String id) async {
    final response = await http.put(Uri.parse('$baseUrl/desactiver/$id'));

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
      applyChange();
    } else {
      // Get.snackbar("Erreur", "Une erreur s'est produite veuiller réessayer ultérieurement",duration: Duration(seconds: 3));
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  void applyChange() {
    notifyListeners();
  }
}



// class StockController extends GetxController {
//    List<Stock> stockListen = [];
//    List<Stock> stockListe1 = [];
//    List<Stock> stockListe2 = [];
//   var isLoadingn = true.obs;
//   var isLoading1 = true.obs;
//   var isLoading2 = true.obs;
 


//   void clearStockListen() {
//     stockListen.clear();
//   }

  
//    void clearStockListe1() {
//     stockListe1.clear();
//   }


//    Future<void> fetchProduitByCategorieProduit(String idCategorie, String idMagasin, String idActeur) async {
//     try {
//       final response = await http.get(Uri.parse(
        
//           'https://koumi.ml/api-koumi/Stock/categorieAndMagasin/$idCategorie/$idMagasin/$idActeur'));
//           'http://10.0.2.2:9000/api-koumi/Stock/categorieProduit/$idCategorie/$idMagasin/$idActeur'));
//       if (response.statusCode == 200) {
//         final String jsonString = utf8.decode(response.bodyBytes);
//         List<dynamic> data = json.decode(jsonString);
//           stockListen = data
//               .where((stock) => stock['statutSotck'] == true)
//               .map((item) => Stock(
//                     idStock: item['idStock'] as String,
//                     nomProduit: item['nomProduit'] as String,
//                     photo: item['photo'] ?? '',
//                     quantiteStock: item['quantiteStock'] ?? 0,
//                     prix: item['prix'] ?? 0,
//                     formeProduit: item['formeProduit'] as String,
//                     typeProduit: item['typeProduit'] as String,
//                     descriptionStock: item['descriptionStock'] as String,
//                     speculation: Speculation(
//                       idSpeculation: item['speculation']['idSpeculation'], 
//                       codeSpeculation: item['speculation']['codeSpeculation'], 
//                       nomSpeculation: item['speculation']['nomSpeculation'],
//                        descriptionSpeculation: item['speculation']['descriptionSpeculation'], 
//                        statutSpeculation: item['speculation']['statutSpeculation'],
//                         ),
//                         acteur:Acteur(
//                         idActeur:item['acteur']['idActeur'],
//                         nomActeur:item['acteur']['nomActeur'],
//                         ),
//                        unite: Unite(
//                         nomUnite: item['unite']['nomUnite'],
//                         sigleUnite: item['unite']['sigleUnite'],
//                         description: item['unite']['description'],
//                         statutUnite: item['unite']['statutUnite'],
//                        ), 
//                   ))
//               .toList();
//         isLoadingn.value = false;
//         update();
//         debugPrint("Produit : ${stockListen.map((e) => e.nomProduit)}");
//       } else {
//         debugPrint('Failed to load stock');
//       }
//     } catch (e) {
//       print('Error fetching stock: $e');
//     }
//   }

//   Future<void> fetchProduitByCategorieAndMagasin(String idCategorie, String idMagasin) async {
//     try {
//       final response = await http.get(Uri.parse(
//           // 'https://koumi.ml/api-koumi/Stock/categorieAndMagasin/$idCategorie/$idMagasin'));
//           'http://10.0.2.2:9000/api-koumi/Stock/categorieAndMagasin/$idCategorie/$idMagasin'));
//       if (response.statusCode == 200) {
//         final String jsonString = utf8.decode(response.bodyBytes);
//         List<dynamic> data = json.decode(jsonString);
//           await Future.delayed(Duration(seconds: 2));
//           stockListe1 = data
//               .where((stock) => stock['statutSotck'] == true)
//               .map((item) => Stock(
//                     idStock: item['idStock'] as String,
//                     nomProduit: item['nomProduit'] as String,
//                     photo: item['photo'] ?? '',
//                     quantiteStock: item['quantiteStock'] ?? 0,
//                     prix: item['prix'] ?? 0,
//                     formeProduit: item['formeProduit'] as String,
//                     typeProduit: item['typeProduit'] as String,
//                     descriptionStock: item['descriptionStock'] as String,
//                     speculation: Speculation(
//                       idSpeculation: item['speculation']['idSpeculation'], 
//                       codeSpeculation: item['speculation']['codeSpeculation'], 
//                       nomSpeculation: item['speculation']['nomSpeculation'],
//                        descriptionSpeculation: item['speculation']['descriptionSpeculation'], 
//                        statutSpeculation: item['speculation']['statutSpeculation'],
//                         ),
//                         acteur:Acteur(
//                         idActeur:item['acteur']['idActeur'],
//                         nomActeur:item['acteur']['nomActeur'],
//                         ),
//                        unite: Unite(
//                         nomUnite: item['unite']['nomUnite'],
//                         sigleUnite: item['unite']['sigleUnite'],
//                         description: item['unite']['description'],
//                         statutUnite: item['unite']['statutUnite'],
//                        ), 
//                   ))
//               .toList();
//        isLoadingn.value = false;
//          update();
//         debugPrint("Produit : ${stockListe1.map((e) => e.nomProduit)}");
//       } else {
//         debugPrint('Failed to load stock');
//       }
//     } catch (e) {
//       print('Error fetching stock: $e');
//     }
//   }


   
//  //Non implementé en spring api
//    void fetchProduitByCategorieAndActeur(String idCategorie, String idActeur) async {
//     try {
//       final response = await http.get(
//           Uri.parse('https://koumi.ml/api-koumi/Stock/categorieAndIdActeur/$idCategorie/$idActeur'));
//           // Uri.parse('http://10.0.2.2:9000/api-koumi/Stock/categorieAndIdActeur/$idCategorie/$idActeur'));
//        if (response.statusCode == 200) {
//         final String jsonString = utf8.decode(response.bodyBytes);
//         List<dynamic> data = json.decode(jsonString);
//                     await Future.delayed(Duration(seconds: 2));
//           stockListe2 = data
//               // .where((stock) => stock['statutSotck'] == true)
//               .map((item) => Stock(
//                     idStock: item['idStock'] as String,
//                     nomProduit: item['nomProduit'] as String,
//                     photo: item['photo'] ?? '',
//                     quantiteStock: item['quantiteStock'] ?? 0,
//                     prix: item['prix'] ?? 0,
//                     statutSotck: item['statutSotck'] as bool,
//                     origineProduit: item['origineProduit'] as String,
//                     formeProduit: item['formeProduit'] as String,
//                     typeProduit: item['typeProduit'] as String,
//                     descriptionStock: item['descriptionStock'] as String,
//                     speculation: Speculation(
//                       idSpeculation: item['speculation']['idSpeculation'], 
//                       codeSpeculation: item['speculation']['codeSpeculation'], 
//                       nomSpeculation: item['speculation']['nomSpeculation'],
//                        descriptionSpeculation: item['speculation']['descriptionSpeculation'], 
//                        statutSpeculation: item['speculation']['statutSpeculation'],
//                         ),
//                         acteur:Acteur(
//                         idActeur:item['acteur']['idActeur'],
//                         nomActeur:item['acteur']['nomActeur'],
//                         ),
//                        unite: Unite(
//                         nomUnite: item['unite']['nomUnite'],
//                         sigleUnite: item['unite']['sigleUnite'],
//                         description: item['unite']['description'],
//                         statutUnite: item['unite']['statutUnite'],
//                        ), 
//                        magasin:Magasin(
//                         idMagasin:item['magasin']['idMagasin'],
//                         nomMagasin:item['magasin']['nomMagasin'],
//                         statutMagasin:item['magasin']['statutMagasin'],
//                        ),
//                        zoneProduction: ZoneProduction(
//                         idZoneProduction: item['zoneProduction']['idZoneProduction'],
//                         nomZoneProduction: item['zoneProduction']['nomZoneProduction'],
//                        ),
//                   ))
//               .toList();
//               isLoading2.value = false;
//         debugPrint("Produit : ${stockListe2.map((e) => e.nomProduit)}");
//       } else {
//         throw Exception('Failed to load stock');
//       }
//     } catch (e) {
//       print('Error fetching stock: $e');
//     }
//   }

//  }