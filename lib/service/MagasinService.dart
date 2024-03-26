import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';



class MagasinService extends ChangeNotifier{

    // static const String baseUrl = 'https://koumi.ml/api-koumi/Magasin';
    static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/Magasin';


  Future<void> creerMagasin({
    required String nomMagasin,
    required String contactMagasin,
    required String localiteMagasin,
    File? photo,
    required Acteur acteur,
    required Niveau1Pays niveau1Pays,
  }) async {
    try {
      //    // Convertir chaque TypeActeur en un objet JSON et les ajouter à une liste JSON
      // List<String> typeActeurJsonList = typeActeur.map((typeActeur) => typeActeur.toJson()).toList();

    //    // Convertir chaque TypeActeur en un objet JSON et les ajouter à une liste JSON
    // List<String> typeActeurJsonList = typeActeur.map((typeActeur) => typeActeur.toJson()).toList();

      var requete = http.MultipartRequest('POST', Uri.parse('$baseUrl/addMagasin'));

      if (photo != null) {
        requete.files.add(http.MultipartFile(
            'image',
            photo.readAsBytes().asStream(),
            photo.lengthSync(),
            filename: basename(photo.path)));
      }
 
      requete.fields['magasin'] = jsonEncode({
           'nomMagasin': nomMagasin,
      'contactMagasin': contactMagasin,
      'localiteMagasin': localiteMagasin,
      'photo': "",
      'acteur': acteur.toMap(),
      'niveau1Pays': niveau1Pays.toMap()
      });
 
      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || responsed.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint('magasin service ${donneesResponse.toString()}');
      } else {
            final errorMessage = json.decode(utf8.decode(responsed.bodyBytes))['message'];
        throw Exception(
            ' ${errorMessage}' );
      }
    } catch (e) {
      throw Exception(
          'Une erreur s\'est produite lors de l\'ajout du magasin : $e');
    }
  }


   

     Future<void> updateMagasin(
      {
        required String idMagasin,
        required String nomMagasin,
    required String contactMagasin,
    required String localiteMagasin,
     File? photo,
    required Acteur acteur,
    required Niveau1Pays niveau1Pays,
      }) async {
        try{
    var requete = http.MultipartRequest(
          'PUT', Uri.parse('$baseUrl/update/$idMagasin'));

      if (photo != null) {
        requete.files.add(http.MultipartFile(
            'image', photo.readAsBytes().asStream(), photo.lengthSync(),
            filename: basename(photo.path)));
      }

      requete.fields['magasin'] = jsonEncode({

          'idMagasin': idMagasin,
          'nomMagasin': nomMagasin,
      'contactMagasin': contactMagasin,
      'localiteMagasin': localiteMagasin,
      'photo': photo,
      'acteur': acteur.toMap(),
      'niveau1Pays': niveau1Pays.toMap()
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || responsed.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint('magasin service ${donneesResponse.toString()}');
      } else {
        final errorMessage =
            json.decode(utf8.decode(responsed.bodyBytes))['message'];
        throw Exception(' ${errorMessage}');
      }
    } catch (e) {
      throw Exception(
          'Une erreur s\'est produite lors de l\'ajout du magasin : $e');
    }
  }

  

  Future<void> deleteMagasin(String idMagasin) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$idMagasin'));
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la suppression avec le code: ${response.statusCode}");
    }
  }

  Future<void> activerMagasin(String idMagasin) async {
    final response = await http.put(Uri.parse("$baseUrl/activer/$idMagasin"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de l'activation avec le code: ${response.statusCode}");
    }
  }

  Future<void> desactiverMagasin(String idMagasin) async {
    final response =
        await http.put(Uri.parse("$baseUrl/desactiver/$idMagasin"));
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
