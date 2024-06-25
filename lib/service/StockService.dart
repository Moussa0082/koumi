import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Monnaie.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/Unite.dart';
import 'package:koumi_app/models/ZoneProduction.dart';
import 'package:path/path.dart';

class StockService extends ChangeNotifier {
  static const String baseUrl = '$apiOnlineUrl/Stock';

  List<Stock> stockList = [];
  int page = 0;
  bool isLoading = false;
  int size = 4;
  bool hasMore = true;


  // List<dynamic> stockList = [];
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
    required Monnaie monnaie,
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
        'monnaie' : monnaie.toMap()
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || responsed.statusCode == 201 || responsed.statusCode == 202) {
        final donneesResponse = json.decode(responsed.body);
              Get.snackbar("Succès", "Produit ajouté avec succès",duration: Duration(seconds: 5));
        debugPrint('stock service ${donneesResponse.toString()}');
      } else {
           Get.snackbar("Erreur", "Une erreur s'est produite veuiller réessayer plus tard",duration: Duration(seconds: 5));
         
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
              debugPrint('stock service erreur $e');

      Get.snackbar("Erreur de connexion", "Une erreur s'est produite veuiller réessayer ultérieurement",duration: Duration(seconds: 5));
      // throw Exception(
      //     'Une erreur s\'est produite lors de l\'ajout de acteur : $e');
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
    required Monnaie monnaie
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
        'monnaie': monnaie.toMap()
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
                    Get.snackbar("Une erreur s'est produit", "Veuiller réessayer ultérieurement",duration: Duration(seconds: 3));
        print(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
                Get.snackbar("Erreur de connexion", "Veuiller réessayer ultérieurement",duration: Duration(seconds: 3));
      debugPrint("catch erreur : $e");
      print(
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



  

  Future<List<Stock>> fetchStock(String niveau3PaysActeur, {bool refresh = false}) async {
    if (isLoading == true) return [];
   
     isLoading = true;

    if (refresh) {
        stockList.clear();
       page = 0;
        hasMore = true;
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Stock/getStocksByPaysWithPagination?niveau3PaysActeur=$niveau3PaysActeur&page=${page}&size=${size}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
           hasMore = false;
        } else {
          List<Stock> newStocks = body.map((e) => Stock.fromMap(e)).toList();
          stockList.addAll(newStocks);
        }

        debugPrint("response body all stock with pagination ${page} par défilement soit ${stockList.length}");
       return stockList;
      } else {
        print('Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
        return [];
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des stocks: $e');
    } finally {
       isLoading = false;
    }
    return stockList;
  }



  Future<List<Stock>> fetchStockByCategorie(String idCategorie, String niveau3PaysActeur, {bool refresh = false}) async {
    if (isLoading == true) return [];

      isLoading = true;

    if (refresh) {
        stockList.clear();
       page = 0;
        hasMore = true;
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Stock/getAllStocksByCategorieAndPaysWithPagination?idCategorie=${idCategorie}&niveau3PaysActeur=$niveau3PaysActeur&page=$page&size=$size'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          
           hasMore = false;
        
        } else {
           List<Stock> newStocks = body.map((e) => Stock.fromMap(e)).toList();
          stockList.addAll(newStocks);
        }

        debugPrint("response body all stock by categorie and pays with pagination ${page} par défilement soit ${stockList.length}");
      } else {
        print('Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des stocks: $e');
    } finally {
      
       isLoading = false;
    }
    return stockList;
  }
  


  
   Future<List<Stock>> fetchProduitByCategorieProduitMagAndActeur(String idCategorie, String idMagasin, String idActeur) async {
    try {
      final response = await http.get(Uri.parse(
        
          '$baseUrl/categorieAndActeur/$idCategorie/$idMagasin/$idActeur'));

      if (response.statusCode == 200) {
                print("Fetching data all stock by id ,categorie, magasin and acteur");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        stockList = body
        // .where((stock) => stock['statutSotck'] == true)
        .map((e) => Stock.fromMap(e)).toList();
        // debugPrint(stockList.toString());
        return stockList;
      } else {
        debugPrint('Failed to load stock');
        return stockList = [];
      }
    } catch (e) {
      print('Error fetching stock by id ,categorie, magasin and acteur: $e');
    }
    return stockList = [];
  }

  
  Future<List<Stock>> fetchStockByMagasin(String idMagasin, String niveau3PaysActeur, {bool refresh = false}) async {
    if (isLoading == true) return [];
   
     isLoading = true;

    if (refresh) {
        stockList.clear();
       page = 0;
        hasMore = true;
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Stock/getStocksByPaysAndMagasinWithPagination?idMagasin=$idMagasin&niveau3PaysActeur=$niveau3PaysActeur&page=${page}&size=${size}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
           hasMore = false;
        } else {
          List<Stock> newStocks = body.map((e) => Stock.fromMap(e)).toList();
          stockList.addAll(newStocks);
        }

        debugPrint("response body all stock by magasin and pays with pagination ${page} par défilement soit ${stockList.length}");
       return stockList;
      } else {
        print('Échec de la requête stock cat mag pag avec le code d\'état: ${response.statusCode} |  ${response.body}');
        return [];
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des stocks: $e');
    } finally {
       isLoading = false;
    }
    return stockList;
  }



  Future<List<Stock>> fetchStockByCategorieAndMagasin(String idCategorieProduit, String idMagasin ,String niveau3PaysActeur,{bool refresh = false}) async {
    if (isLoading == true) return [];

      isLoading = true;

    if (refresh) {
        stockList.clear();
       page = 0;
        hasMore = true;
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Stock/getStocksByPaysAndMagasinAndCategorieProduitWithPagination?idCategorieProduit=${idCategorieProduit}&idMagasin=${idMagasin}&niveau3PaysActeur=$niveau3PaysActeur&page=$page&size=$size'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
           hasMore = false;
     
        } else {
           List<Stock> newStocks = body.map((e) => Stock.fromMap(e)).toList();
          stockList.addAll(newStocks);
        }

        debugPrint("response body all stock by pays and magasin and categorie with pagination ${page} par défilement soit ${stockList.length}");
      } else {
        print('Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des stocks: $e');
    } finally {
       isLoading = false;
    }
    return stockList;
  }
  


   
   Future<List<Stock>> fetchProduitByCategorieAndActeur(String idCategorie, String idActeur) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/categorieAndIdActeur/$idCategorie/$idActeur'));
       if (response.statusCode == 200) {
                    // await Future.delayed(Duration(seconds: 2));
                            print("Fetching data all stock by id categorie and id acteur");
          List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        stockList = body
        // .where((stock) => stock['statutSotck'] == true)
        .map((e) => Stock.fromMap(e)).toList();
        // debugPrint(stockList.toString());
      } else {
        print('Failed to load stock');
        return stockList = [];
      }
    } catch (e) {
      print('Error fetching stock by id categorie and id acteu: $e');
    }
    return stockList = [];
  }

   Future<List<Stock>> fetchStockByActeur(String idActeur,{bool refresh = false}) async {
    // if (_stockService.isLoading == true) return [];

      isLoading = true;

    if (refresh) {
        stockList.clear();
       page = 0;
        hasMore = true;
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Stock/getAllStocksByActeurWithPagination?idActeur=$idActeur&page=${page}&size=${size}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
           hasMore = false;
        } else {
           List<Stock> newIntrant = body.map((e) => Stock.fromMap(e)).toList();
          stockList.addAll(newIntrant);
        }

        debugPrint("response body all stock by acteur with pagination ${page} par défilement soit ${stockList.length}");
      } else {
        print('Échec de la requête stock ac avec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des stocks: $e');
    } finally {
       isLoading = false;
    }
    return stockList;
  }

    Future<List<Stock>> fetchStockByMagasinAndActeur(String idMagasin,String idActeur,{bool refresh = false}) async {
    // if (_stockService.isLoading == true) return [];

      isLoading = true;

    if (refresh) {
        stockList.clear();
       page = 0;
        hasMore = true;
    
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Stock/getAllStocksByMagasinAndActeurWithPagination?idMagasin=$idMagasin&idActeur=$idActeur&page=${page}&size=${size}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
           hasMore = false;
        } else {
           List<Stock> newStock = body.map((e) => Stock.fromMap(e)).toList();
          stockList.addAll(newStock);
        }

        debugPrint("response body all stock by acteur with pagination ${page} par défilement soit ${stockList.length}");
      } else {
        print('Échec de la requête  stoc pag ac avec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des stocks: $e');
    } finally {
       isLoading = false;
    }
    return stockList;
  }
 
    Future<List<Stock>> fetchStockByMagasinWithPagination(String idMagasin,{bool refresh = false }) async {
    if (isLoading) return [];

    
      isLoading = true;
    

    if (refresh) {
    
        stockList.clear();
        page = 0;
        hasMore = true;
     
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Stock/getAllStocksByMagasinWithPagination?idMagasin=$idMagasin&page=$page&size=$size'));

      if (response.statusCode == 200) {
        // debugPrint("url: $response");
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
         
            hasMore = false;
          
        } else {
          
            List<Stock> newStocks = body.map((e) => Stock.fromMap(e)).toList();
          stockList.addAll(newStocks);
          // page++;
          
        }

        debugPrint("response body  stock by magasin with pagination $page par défilement soit ${stockList.length}");
       return stockList;
      } else {
        print('Échec de la requête pag avec le code d\'état: ${response.statusCode} |  ${response.body}');
        return [];
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des stocks: $e');
    } finally {
     
        isLoading = false;
      
    }
    return stockList;
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



class StockController extends GetxController {
   List<Stock> stockListn = [];
   List<Stock> stockList1 = [];
   List<Stock> stockList2 = [];
  var isLoadingn = true.obs;
  var isLoading1 = true.obs;
  var isLoading2 = true.obs;
 


  void clearstockListn() {
    stockListn.clear();
  }

  
   void clearstockList1() {
    stockList1.clear();
  }


//    Future<void> fetchProduitByCategorieProduit(String idCategorie, String idMagasin, String idActeur) async {
//     try {
//       final response = await http.get(Uri.parse(
        
//           'https://koumi.ml/api-koumi/Stock/categorieAndMagasin/$idCategorie/$idMagasin/$idActeur'));
//           // 'http://10.0.2.2:9000/api-koumi/Stock/categorieProduit/$idCategorie/$idMagasin/$idActeur'));
//       if (response.statusCode == 200) {
//         final String jsonString = utf8.decode(response.bodyBytes);
//         List<dynamic> data = json.decode(jsonString);
//           stockListn = data
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
//         debugPrint("Produit : ${stockListn.map((e) => e.nomProduit)}");
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
//           'https://koumi.ml/api-koumi/Stock/categorieAndMagasin/$idCategorie/$idMagasin'));
//           // 'http://10.0.2.2:9000/api-koumi/Stock/categorieAndMagasin/$idCategorie/$idMagasin'));
//       if (response.statusCode == 200) {
//         final String jsonString = utf8.decode(response.bodyBytes);
//         List<dynamic> data = json.decode(jsonString);
//           await Future.delayed(Duration(seconds: 2));
//           stockList1 = data
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
//         debugPrint("Produit : ${stockList1.map((e) => e.nomProduit)}");
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
//           stockList2 = data
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
//         debugPrint("Produit : ${stockList2.map((e) => e.nomProduit)}");
//       } else {
//         throw Exception('Failed to load stock');
//       }
//     } catch (e) {
//       print('Error fetching stock: $e');
//     }
//   }

 }