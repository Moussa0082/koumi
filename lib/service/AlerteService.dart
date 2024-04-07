import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Alertes.dart';
import 'package:path/path.dart';

class AlertesService extends ChangeNotifier {
  // static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/alertes';
  static const String baseUrl = 'https://koumi.ml/api-koumi/alertes';

  List<Alertes> alertesList = [];

  Future<void> creerAlertes({
      required String titreAlerte,
      required String descriptionAlerte,
      File? audioAlerte,
      File? photoAlerte,
      File? videoAlerte,
      }) async {
    try {
      var requete = http.MultipartRequest('POST', Uri.parse('$baseUrl/create'));

      if (audioAlerte != null) {
        requete.files.add(http.MultipartFile('audio',
            audioAlerte.readAsBytes().asStream(), audioAlerte.lengthSync(),
            filename: basename(audioAlerte.path)));
      }
      if (photoAlerte != null) {
        requete.files.add(http.MultipartFile('image',
            photoAlerte.readAsBytes().asStream(), photoAlerte.lengthSync(),
            filename: basename(photoAlerte.path)));
      }
      if (videoAlerte != null) {
        requete.files.add(http.MultipartFile('video',
            videoAlerte.readAsBytes().asStream(), videoAlerte.lengthSync(),
            filename: basename(videoAlerte.path)));
      }

      requete.fields['alerte'] = jsonEncode({
        'titreAlerte': titreAlerte,
        'descriptionAlerte': descriptionAlerte,
        'audioAlerte': '',
        'photoAlerte': '',
        'videoAlerte': '',
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || responsed.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint('acteur service ${donneesResponse.toString()}');
      } else {
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Une erreur s\'est produite lors de l\'ajout de Alertes : $e');
    }
  }

  static Future<void> updateAlertes(
      {required String idAlerte,
      required String titreAlerte,
      required String descriptionAlerte,
      File? audioAlerte,
      File? photoAlerte,
      File? videoAlerte,
    }) async {
    try {
      var requete =
          http.MultipartRequest('PUT', Uri.parse('$baseUrl/update/$idAlerte'));

      if (audioAlerte != null) {
        requete.files.add(http.MultipartFile('audio',
            audioAlerte.readAsBytes().asStream(), audioAlerte.lengthSync(),
            filename: basename(audioAlerte.path)));
      }
      if (photoAlerte != null) {
        requete.files.add(http.MultipartFile('image',
            photoAlerte.readAsBytes().asStream(), photoAlerte.lengthSync(),
            filename: basename(photoAlerte.path)));
      }
      if (videoAlerte != null) {
        requete.files.add(http.MultipartFile('video',
            videoAlerte.readAsBytes().asStream(), videoAlerte.lengthSync(),
            filename: basename(videoAlerte.path)));
      }

      requete.fields['alerte'] = jsonEncode({
        'idAlerte':idAlerte,
        'titreAlerte': titreAlerte,
        'descriptionAlerte': descriptionAlerte,
        'audioAlerte': '',
        'photoAlerte': '',
        'videoAlerte': '',
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || responsed.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint('acteur service ${donneesResponse.toString()}');
      } else {
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Une erreur s\'est produite lors de la modification : $e');
    }
  }

  Future<List<Alertes>> fetchAlertes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/read'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Fetching data");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        alertesList = body.map((e) => Alertes.fromMap(e)).toList();
        debugPrint(alertesList.toString());
        return alertesList;
      } else {
        alertesList = [];
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future deleteAlertes(String idAlertes) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$idAlertes'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future activerAlertes(String idAlertes) async {
    final response = await http.delete(Uri.parse('$baseUrl/enable/$idAlertes'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future desactiverAlertes(String idAlertes) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/disable/$idAlertes'));

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