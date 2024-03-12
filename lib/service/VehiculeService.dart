import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeVoiture.dart';
import 'package:koumi_app/models/Vehicule.dart';
import 'package:path/path.dart';

class VehiculeService extends ChangeNotifier {
  // static const String baseUrl = 'https://koumi.ml/api-koumi/vehicule';
  static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/vehicule';

  List<Vehicule> vehiculeList = [];

  Future<void> addVehicule(
      {required String nomVehicule,
      required String capaciteVehicule,
      required Map<String, int> prixParDestination,
      required String etatVehicule,
      required String localisation,
      File? photoVehicule,
      required TypeVoiture typeVoiture,
      required Acteur acteur}) async {
    try {
      var requete = http.MultipartRequest('POST', Uri.parse('$baseUrl/create'));

      if (photoVehicule != null) {
        requete.files.add(http.MultipartFile('image',
            photoVehicule.readAsBytes().asStream(), photoVehicule.lengthSync(),
            filename: basename(photoVehicule.path)));
      }

      requete.fields['vehicule'] = jsonEncode({
        'prixParDestination': prixParDestination,
        'nomVehicule': nomVehicule,
        'etatVehicule': etatVehicule,
        'localisation': localisation,
        'capaciteVehicule': capaciteVehicule,
        'typeVoiture':typeVoiture.toMap(),
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
      throw Exception('Une erreur s\'est produite lors de l\'ajout  : $e');
    }
  }

  Future<void> updateVehicule(
      {required String idVehicule,
      required String nomVehicule,
      required String capaciteVehicule,
    required Map<String, int> prixParDestination,
      required String etatVehicule,
      required String localisation,
      File? photoVehicule,
      required TypeVoiture typeVoiture,
      required Acteur acteur}) async {
    try {
      var requete = http.MultipartRequest(
          'PUT', Uri.parse('$baseUrl/update/$idVehicule'));

      if (photoVehicule != null) {
        requete.files.add(http.MultipartFile('image',
            photoVehicule.readAsBytes().asStream(), photoVehicule.lengthSync(),
            filename: basename(photoVehicule.path)));
      }

      requete.fields['vehicule'] = jsonEncode({
        'idVehicule': idVehicule,
        'prixParDestination': prixParDestination,
        'nomVehicule': nomVehicule,
        'etatVehicule': etatVehicule,
        'localisation': localisation,
        'capaciteVehicule': capaciteVehicule,
        'typeVoiture': typeVoiture.toMap(),
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

  Future<List<Vehicule>> fetchVehicule() async {
    final response = await http.get(Uri.parse('$baseUrl/read'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint(response.body.toString());
      vehiculeList = body.map((item) => Vehicule.fromMap(item)).toList();
      debugPrint(response.body);
      return vehiculeList;
    } else {
      vehiculeList = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<List<Vehicule>> fetchVehiculeByTypeVehicule(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/listeVehiculeByType/$id'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint(response.body.toString());
      vehiculeList = body.map((item) => Vehicule.fromMap(item)).toList();
      debugPrint(response.body);
      return vehiculeList;
    } else {
      vehiculeList = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<List<Vehicule>> fetchVehiculeByActeur(String id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/listeVehiculeByActeur/$id'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint(response.body.toString());
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

  Future activerVehicules(String id) async {
    final response = await http.put(Uri.parse('$baseUrl/enable/$id'));

    if (response.statusCode == 200 || response.statusCode == 202) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future desactiverVehicules(String id) async {
    final response = await http.put(Uri.parse('$baseUrl/disable/$id'));

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
