import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Vehicule.dart';
import 'package:path/path.dart';

class VehiculeService extends ChangeNotifier {
  static const String baseUrl = 'http://10.0.2.2:9000/vehicule';

  List<Vehicule> vehiculeList = [];

Future<void> addVehicule({
    required String nomVehicule,
    required String capaciteVehicule,
    File? photoVehicule,
    required Acteur acteur
  }) async {
    var addvehicules = jsonEncode({
      'idVehicule': null,
      'nomVehicule': nomVehicule,
      'capaciteVehicule': capaciteVehicule,
      'acteur' : acteur.toMap(),
    });

    final response = await http.post(Uri.parse("$baseUrl/create"),
        headers: {'Content-Type': 'application/json'}, body: addvehicules);
    debugPrint(addvehicules.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

Future<void> updateVehicule({
    required String idVehicule,
    required String nomVehicule,
    required String capaciteVehicule,
    File? photoVehicule,
    required Acteur acteur
  }) async {
    var addvehicules = jsonEncode({
      'idVehicule': idVehicule,
      'nomVehicule': nomVehicule,
      'capaciteVehicule': capaciteVehicule,
      'acteur' : acteur.toMap(),
    });

    final response = await http.put(Uri.parse("$baseUrl/update/$idVehicule"),
        headers: {'Content-Type': 'application/json'}, body: addvehicules);
    debugPrint(addvehicules.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

  Future<List<Vehicule>> fetchVehicule() async {
    final response = await http.get(Uri.parse('$baseUrl/read'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      vehiculeList = body.map((item) => Vehicule.fromMap(item)).toList();
      debugPrint(response.body);
      return vehiculeList;
    } else {
      vehiculeList = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<void> deleteVehicule(String idVehicule) async {
    final response =
        await http.delete(Uri.parse("$baseUrl/delete/$idVehicule"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la suppression avec le code: ${response.statusCode}");
    }
  }

  Future<void> activerVehicule(String idVehicule) async {
    final response =
        await http.delete(Uri.parse("$baseUrl/enable/$idVehicule"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de l'activation avec le code: ${response.statusCode}");
    }
  }

  Future<void> desactiverVehicule(String idVehicule) async {
    final response =
        await http.delete(Uri.parse("$baseUrl/disable/$idVehicule"));
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
