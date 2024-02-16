import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/models/Niveau2Pays.dart';
import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/models/SousRegion.dart';
import 'package:path/path.dart';

class Niveau2Service extends ChangeNotifier {
  static const String baseUrl = 'http://10.0.2.2:9000/niveau2Pays';

  List<Niveau2Pays> niveauList = [];

  Future<void> addNiveau2Pays({
    required String nomN2,
    required String descriptionN2,
    required Niveau1Pays niveau1pays,
  }) async {
    var addPays = jsonEncode({
      'idNiveau2Pays': null,
      'nomN1': nomN2,
      'descriptionN2': descriptionN2,
      'niveau1pays': niveau1pays.toMap()
    });

    final response = await http.post(Uri.parse("$baseUrl/create"),
        headers: {'Content-Type': 'application/json'}, body: addPays);
    debugPrint(addPays.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

  Future<void> updateNiveau2Pays({
    required String idNiveau2Pays,
    required String nomN2,
    required String descriptionN2,
    required Niveau1Pays niveau1pays,
  }) async {
    var addPays = jsonEncode({
      'idNiveau2Pays': idNiveau2Pays,
      'nomN2': nomN2,
      'descriptionN2': descriptionN2,
      'niveau1Pays': niveau1pays.toMap()
    });

    final response = await http.put(Uri.parse("$baseUrl/update/$idNiveau2Pays"),
        headers: {'Content-Type': 'application/json'}, body: addPays);
    debugPrint(addPays.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

  Future<List<Niveau2Pays>> fetchNiveau2Pays() async {
    final response = await http.get(Uri.parse('$baseUrl/read'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      niveauList = body.map((item) => Niveau2Pays.fromMap(item)).toList();
      debugPrint(response.body);
      return niveauList;
    } else {
      niveauList = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<List<Niveau2Pays>> fetchNiveau2ByNiveau1(String idNiveau1Pays) async {
    final response =
        await http.get(Uri.parse('$baseUrl/listeNiveau2PaysByIdNiveau1Pays/$idNiveau1Pays'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      niveauList = body.map((item) => Niveau2Pays.fromMap(item)).toList();
      debugPrint(response.body);
      return niveauList;
    } else {
      niveauList = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<void> deleteNiveau2Pays(String idNiveau2Pays) async {
    final response =
        await http.delete(Uri.parse("$baseUrl/delete/$idNiveau2Pays"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la suppression avec le code: ${response.statusCode}");
    }
  }

  Future<void> activerNiveau2(String idNiveau2Pays) async {
    final response =
        await http.delete(Uri.parse("$baseUrl/activer/$idNiveau2Pays"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de l'activation avec le code: ${response.statusCode}");
    }
  }

  Future<void> desactiverNiveau2Pays(String idNiveau2Pays) async {
    final response =
        await http.delete(Uri.parse("$baseUrl/desactiver/$idNiveau2Pays"));
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