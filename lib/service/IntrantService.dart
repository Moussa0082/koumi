import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Forme.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/models/Monnaie.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:path/path.dart';

class IntrantService extends ChangeNotifier {
  // static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/intrant';
  static const String baseUrl = '$apiOnlineUrl/intrant';

  List<Intrant> intrantList = [];
    int page = 0;
  bool isLoading = false;
  int size = 4;
  bool hasMore = true;

  Future<void> creerIntrant(
      {required String nomIntrant,
      required double quantiteIntrant,
      required String descriptionIntrant,
      required int prixIntrant,
      required String dateExpiration,
      File? photoIntrant,
      required Acteur acteur,
      required Forme forme,
      required String unite,
      required CategorieProduit categorieProduit,
      required Monnaie monnaie,
      }) async {
    try {
      var requete = http.MultipartRequest('POST', Uri.parse('$baseUrl/create'));

      if (photoIntrant != null) {
        requete.files.add(http.MultipartFile('image',
            photoIntrant.readAsBytes().asStream(), photoIntrant.lengthSync(),
            filename: basename(photoIntrant.path)));
      }

      requete.fields['intrant'] = jsonEncode({
        'nomIntrant': nomIntrant,
        'quantiteIntrant': quantiteIntrant,
        'prixIntrant': prixIntrant,
        'dateExpiration': dateExpiration,
        'categorieProduit': categorieProduit.toMap(),
        'descriptionIntrant': descriptionIntrant,
        'unite' : unite,
        'photoIntrant': "",
        'acteur': acteur.toMap(),
        'forme' : forme.toMap(),
        'monnaie':monnaie.toMap()
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);
      debugPrint('intrant avant if ${json.decode(responsed.body)}');
      if (response.statusCode == 200 || responsed.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint('intrant service ${donneesResponse.toString()}');
      } else {
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Une erreur s\'est produite lors de l\'ajout de acteur : $e');
    }
  }

  Future<void> updateIntrant({
    required String idIntrant,
    required String nomIntrant,
    required double quantiteIntrant,
    required String descriptionIntrant,
    required int prixIntrant,
    required String dateExpiration,
    File? photoIntrant,
    required String unite,
    required Acteur acteur,
    required Monnaie monnaie,
  }) async {
    try {
      var requete =
          http.MultipartRequest('PUT', Uri.parse('$baseUrl/update/$idIntrant'));

      if (photoIntrant != null) {
        requete.files.add(http.MultipartFile('image',
            photoIntrant.readAsBytes().asStream(), photoIntrant.lengthSync(),
            filename: basename(photoIntrant.path)));
      }

      requete.fields['intrant'] = jsonEncode({
        'idIntrant': idIntrant,
        'nomIntrant': nomIntrant,
        'quantiteIntrant': quantiteIntrant,
        'prixIntrant': prixIntrant,
        'dateExpiration': dateExpiration,
        'descriptionIntrant': descriptionIntrant,
        'photoIntrant': "",
        'unite': unite,
        'acteur': acteur.toMap(),
        'monnaie': monnaie.toMap()
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || responsed.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint('intrant service ${donneesResponse.toString()}');
      } else {
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
      throw Exception('Une erreur s\'est produite lors de l\'ajout  : $e');
    }
  }

  
 


   Future<List<Intrant>> fetchIntrant({bool refresh = false }) async {
    if (isLoading) return [];

      isLoading = true;

    if (refresh) {
    
        intrantList.clear();
        page = 0;
        hasMore = true;
     
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/intrant/getAllIntrantsWithPagination?page=$page&size=$size'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
         
            hasMore = false;
          
        } else {
          
            List<Intrant> newIntrant = body.map((e) => Intrant.fromMap(e)).toList();
          intrantList.addAll(newIntrant);
          // page++;
          
        }

        debugPrint("response body all intrant with pagination $page par défilement soit ${intrantList.length}");
       return intrantList;
      } else {
        print('Échec de la requête intrant pag avec le code d\'état: ${response.statusCode} |  ${response.body}');
        return [];
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des intrants: $e');
    } finally {
     
        isLoading = false;
      
    }
    return intrantList;
  }


   Future<List<Intrant>> fetchIntrantByCategorieWithPagination(String idCategorie,{bool refresh = false }) async {
    if (isLoading) return [];

      isLoading = true;
    
    if (refresh) {
    
        intrantList.clear();
        page = 0;
        hasMore = true;
     
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/intrant/getAllIntrantsByCategorieWithPagination?idCategorie=$idCategorie&page=$page&size=$size'));

      if (response.statusCode == 200) {
        // debugPrint("url: $response");
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
         
            hasMore = false;
          
        } else {
          
            List<Intrant> newIntrants = body.map((e) => Intrant.fromMap(e)).toList();
          intrantList.addAll(newIntrants);
          // page++;
          
        }

        debugPrint("response body intrant by categorie with pagination $page par défilement soit ${intrantList.length}");
       return intrantList;
      } else {
        print('Échec de la requête intrant cat avec le code d\'état: ${response.statusCode} |  ${response.body}');
        return [];
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des intrants: $e');
    } finally {
     
        isLoading = false;
      
    }
    return intrantList;
  }
  
   Future<List<Intrant>> fetchIntrantByActeurWithPagination(String idActeur,{bool refresh = false }) async {
    if (isLoading) return [];

      isLoading = true;
    
    if (refresh) {
    
        intrantList.clear();
        page = 0;
        hasMore = true;
     
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/intrant/getAllIntrantsByActeurWithPagination?idActeur=$idActeur&page=$page&size=$size'));

      if (response.statusCode == 200) {
        // debugPrint("url: $response");
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
         
            hasMore = false;
          
        } else {
          
            List<Intrant> newIntrants = body.map((e) => Intrant.fromMap(e)).toList();
          intrantList.addAll(newIntrants);
          // page++;
          
        }

        debugPrint("response body intrant by acteur with pagination $page par défilement soit ${intrantList.length}");
       return intrantList;
      } else {
        print('Échec de la requête intrant act avec le code d\'état: ${response.statusCode} |  ${response.body}');
        return [];
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des intrants: $e');
    } finally {
     
        isLoading = false;
      
    }
    return intrantList;
  }


  
  Future deleteIntrant(String idIntrant) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$idIntrant'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future activerIntrant(String idActeur) async {
    final response = await http.put(Uri.parse('$baseUrl/enable/$idActeur'));

    if (response.statusCode == 200 || response.statusCode == 202) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future desactiverIntrant(String idIntrant) async {
    final response = await http.put(Uri.parse('$baseUrl/disable/$idIntrant'));

    if (response.statusCode == 200 || response.statusCode == 202) {
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
