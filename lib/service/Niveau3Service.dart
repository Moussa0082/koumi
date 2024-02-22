import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Niveau2Pays.dart';
import 'package:koumi_app/models/Niveau3Pays.dart';

class Niveau3Service extends ChangeNotifier {
  static const String baseUrl = 'https://koumi.ml/api-koumi/niveau3Pays';
  // static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/niveau3Pays';

  List<Niveau3Pays> niveauList = [];

  Future<void> addNiveau3Pays({
    required String nomN3,
    required String descriptionN3,
    required Niveau2Pays niveau2pays,
  }) async {
    var addPays = jsonEncode({
      'idNiveau3Pays': null,
      'nomN3': nomN3,
      'descriptionN3': descriptionN3,
      'niveau2pays': niveau2pays.toMap()
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

  Future<void> updateNiveau3Pays({
    required String idNiveau3Pays,
    required String nomN3,
    required String descriptionN3,
    required Niveau2Pays niveau2pays,
  }) async {
    var addPays = jsonEncode({
      'idNiveau3Pays': idNiveau3Pays,
      'nomN3': nomN3,
      'descriptionN3': descriptionN3,
      'niveau2pays': niveau2pays.toMap()
    });

    final response = await http.post(Uri.parse("$baseUrl/update/$idNiveau3Pays"),
        headers: {'Content-Type': 'application/json'}, body: addPays);
    debugPrint(addPays.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

  Future<List<Niveau3Pays>> fetchNiveau3Pays() async {
    final response = await http.get(Uri.parse('$baseUrl/read'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      niveauList = body.map((item) => Niveau3Pays.fromMap(item)).toList();
      debugPrint(response.body);
      return niveauList;
    } else {
      niveauList = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<List<Niveau3Pays>> fetchNiveau3ByNiveau2(String idNiveau2Pays) async {
    final response = await http.get(
        Uri.parse('$baseUrl/listeNiveau3PaysByIdNiveau2Pays/$idNiveau2Pays'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      niveauList = body.map((item) => Niveau3Pays.fromMap(item)).toList();
      debugPrint(response.body);
      return niveauList;
    } else {
      niveauList = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<void> deleteNiveau3Pays(String idNiveau3Pays) async {
    final response =
        await http.delete(Uri.parse("$baseUrl/delete/$idNiveau3Pays"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la suppression avec le code: ${response.statusCode}");
    }
  }

  Future<void> activerNiveau3(String idNiveau3Pays) async {
    final response =
        await http.put(Uri.parse("$baseUrl/activer/$idNiveau3Pays"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de l'activation avec le code: ${response.statusCode}");
    }
  }

  Future<void> desactiverNiveau3Pays(String idNiveau3Pays) async {
    final response =
        await http.put(Uri.parse("$baseUrl/desactiver/$idNiveau3Pays"));
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
