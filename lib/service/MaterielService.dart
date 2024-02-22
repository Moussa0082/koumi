import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Materiel.dart';
import 'package:path/path.dart';


class MaterielService extends ChangeNotifier {
  static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/Materiel';

  List<Materiel> materielList = [];

  Future<void> creerMateriel({
    required String prix,
    required String nom,
    required String description,
    File? photoMateriel,
    required String localisation,
    required String etatMateriel,
    required Acteur acteur,
  }) async {
    try {
      var requete = http.MultipartRequest('POST', Uri.parse('$baseUrl/addMateriel'));

      if (photoMateriel != null) {
        requete.files.add(http.MultipartFile('image',
            photoMateriel.readAsBytes().asStream(), photoMateriel.lengthSync(),
            filename: basename(photoMateriel.path)));
      }

      requete.fields['materiel'] = jsonEncode({
        'prix':prix,
        'nom':nom,
        'description':description,
        'photoMateriel':"",
        'localisation': localisation,
        'etatMateriel':etatMateriel,
        'acteur':acteur.toMap(),
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

Future<void> updateMateriel({
  required String idMateriel,
    required String prix,
    required String nom,
    required String description,
    File? photoMateriel,
    required String localisation,
    required String etatMateriel,
    required Acteur acteur,
  }) async {
    try {
      var requete =
          http.MultipartRequest('PUT', Uri.parse('$baseUrl/update/$idMateriel'));

      if (photoMateriel != null) {
        requete.files.add(http.MultipartFile('image',
            photoMateriel.readAsBytes().asStream(), photoMateriel.lengthSync(),
            filename: basename(photoMateriel.path)));
      }

      requete.fields['materiel'] = jsonEncode({
        'idMateriel':idMateriel,
        'prix': prix,
        'nom': nom,
        'description': description,
        'photoMateriel': "",
        'localisation': localisation,
        'etatMateriel': etatMateriel,
        'acteur': acteur.toMap(),
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

  Future<List<Materiel>> fetchMateriel() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      materielList = body.map((item) => Materiel.fromMap(item)).toList();
      debugPrint(response.body);
      return materielList;
    } else {
      materielList = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<List<Materiel>> fetchMaterielByActeur(String idActeur) async {
    final response =
        await http.get(Uri.parse('$baseUrl/readByActeur/$idActeur'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      materielList = body.map((item) => Materiel.fromMap(item)).toList();
      debugPrint(response.body);
      return materielList;
    } else {
      materielList = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<void> deleteMateriel(String idMateriel) async {
    final response =
        await http.delete(Uri.parse("$baseUrl/delete/$idMateriel"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la suppression avec le code: ${response.statusCode}");
    }
  }

  Future<void> activerMateriel(String idMateriel) async {
    final response = await http.post(Uri.parse("$baseUrl/activer/$idMateriel"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de l'activation avec le code: ${response.statusCode}");
    }
  }

  Future<void> desactiverMateriel(String idMateriel) async {
    final response =
        await http.post(Uri.parse("$baseUrl/desactiver/$idMateriel"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();

      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la desactivation avec le code: ${response.statusCode}");
    }
  }

  void applyChange() {
    notifyListeners();
  }
}
