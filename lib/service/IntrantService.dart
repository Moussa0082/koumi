import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:path/path.dart';


class IntrantService extends ChangeNotifier {
  static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/intrant';

  List<Intrant> intrantList = [];

  Future<void> creerIntrant({
    required String nomIntrant,
    required String quantiteIntrant,
    required String descriptionIntrant,
    File? photoIntrant,
    required Acteur acteur,
  }) async {
    try {
      var requete = http.MultipartRequest('POST', Uri.parse('$baseUrl/create'));

      if (photoIntrant != null) {
        requete.files.add(http.MultipartFile(
            'image',
            photoIntrant.readAsBytes().asStream(),
            photoIntrant.lengthSync(),
            filename: basename(photoIntrant.path)));
      }

      requete.fields['intrant'] = jsonEncode({
        'nomIntrant':nomIntrant,
        'quantiteIntrant' : quantiteIntrant,
        'descriptionIntrant': descriptionIntrant,
        'photoIntrant': "",
        'acteur': acteur.toMap()
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
      throw Exception(
          'Une erreur s\'est produite lors de l\'ajout de acteur : $e');
    }
  }

    Future<void> updateIntrant({
    required String idIntrant,
    required String nomIntrant,
    required String quantiteIntrant,
    required String descriptionIntrant,
    File? photoIntrant,
    required Acteur acteur,
  }) async {
    try {
      var requete = http.MultipartRequest('PUT', Uri.parse('$baseUrl/update/$idIntrant'));

      if (photoIntrant != null) {
        requete.files.add(http.MultipartFile('image',
            photoIntrant.readAsBytes().asStream(), photoIntrant.lengthSync(),
            filename: basename(photoIntrant.path)));
      }

      requete.fields['intrant'] = jsonEncode({
        'idIntrant' : idIntrant,
        'nomIntrant': nomIntrant,
        'quantiteIntrant': int.tryParse(quantiteIntrant),
        'descriptionIntrant': descriptionIntrant,
        'photoIntrant': "",
        'acteur': acteur.toMap()
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
      throw Exception(
          'Une erreur s\'est produite lors de l\'ajout de acteur : $e');
    }
  }

   Future<List<Intrant>> fetchIntrant() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/read'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Fetching data");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        intrantList = body.map((e) => Intrant.fromMap(e)).toList();
        debugPrint(intrantList.toString());
        return intrantList;
      } else {
        intrantList = [];
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

    Future<List<Intrant>> fetchIntrantByActeur(String idActeur) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/listeIntrantByActeur/$idActeur'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Fetching data");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        intrantList = body.map((e) => Intrant.fromMap(e)).toList();
        debugPrint(intrantList.toString());
        return intrantList;
      } else {
        intrantList = [];
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
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
    final response = await http.post(Uri.parse('$baseUrl/activer/$idActeur'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future desactiverIntrant(String idIntrant) async {
    final response = await http.post(Uri.parse('$baseUrl/desactiver/$idIntrant'));

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
