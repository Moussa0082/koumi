import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:path/path.dart';

class ActeurService extends ChangeNotifier {
  static const String baseUrl = 'http://10.0.2.2:9000/acteur';

  List<Acteur> acteurList = [];

  static Future<void> creerActeur({
    required String nomActeur,
    required String adresseActeur,
    required String telephoneActeur,
    required String whatsAppActeur,
    String? latitude,
    String? longitude,
    required String niveau3PaysActeur,
    required String localiteActeur,
    required String emailActeur,
    required String filiereActeur,
    required List<TypeActeur> typeActeur,
    File? photoSiegeActeur,
    File? logoActeur,
    required String passWord,
    required String maillonActeur,
  }) async {
    try {
      var requete = http.MultipartRequest('POST', Uri.parse('$baseUrl/create'));

      if (photoSiegeActeur != null) {
        requete.files.add(http.MultipartFile(
            'image1',
            photoSiegeActeur.readAsBytes().asStream(),
            photoSiegeActeur.lengthSync(),
            filename: basename(photoSiegeActeur.path)));
      }

      if (logoActeur != null) {
        requete.files.add(http.MultipartFile('image2',
            logoActeur.readAsBytes().asStream(), logoActeur.lengthSync(),
            filename: basename(logoActeur.path)));
      }

      requete.fields['acteur'] = jsonEncode({
        'nomActeur': nomActeur,
        'adresseActeur': adresseActeur,
        'telephoneActeur': telephoneActeur,
        'whatsAppActeur': whatsAppActeur,
        'latitude': latitude,
        'longitude': longitude,
        'niveau3PaysActeur': niveau3PaysActeur,
        'localiteActeur': localiteActeur,
        'emailActeur': emailActeur,
        'filiereActeur': filiereActeur,
        'typeActeur': typeActeur.toList(),
        'photoSiegeActeur': "",
        'logoActeur': "",
        'passWord': passWord,
        'maillonActeur': maillonActeur,
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
          'Une erreur s\'est produite lors de l\'ajout de acteur : $e');
    }
  }

  static Future<void> updateActeur({
    required String idActeur,
    required String nomActeur,
    required String adresseActeur,
    required String telephoneActeur,
    required String whatsAppActeur,
    String? latitude,
    String? longitude,
    required String niveau3PaysActeur,
    required String localiteActeur,
    required String emailActeur,
    required String filiereActeur,
    required List<TypeActeur> typeActeur,
    File? photoSiegeActeur,
    File? logoActeur,
    required String passWord,
    required String maillonActeur,
  }) async {
    try {
      var requete =
          http.MultipartRequest('PUT', Uri.parse('$baseUrl/update/$idActeur'));

      if (photoSiegeActeur != null) {
        requete.files.add(http.MultipartFile(
            'image1',
            photoSiegeActeur.readAsBytes().asStream(),
            photoSiegeActeur.lengthSync(),
            filename: basename(photoSiegeActeur.path)));
      }

      if (logoActeur != null) {
        requete.files.add(http.MultipartFile('image2',
            logoActeur.readAsBytes().asStream(), logoActeur.lengthSync(),
            filename: basename(logoActeur.path)));
      }

      requete.fields['acteur'] = jsonEncode({
        'idActeur' : idActeur,
        'nomActeur': nomActeur,
        'adresseActeur': adresseActeur,
        'telephoneActeur': telephoneActeur,
        'whatsAppActeur': whatsAppActeur,
        'latitude': latitude,
        'longitude': longitude,
        'niveau3PaysActeur': niveau3PaysActeur,
        'localiteActeur': localiteActeur,
        'emailActeur': emailActeur,
        'filiereActeur': filiereActeur,
        'typeActeur': typeActeur.toList(),
        'photoSiegeActeur': "",
        'logoActeur': "",
        'passWord': passWord,
        'maillonActeur': maillonActeur,
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
          'Une erreur s\'est produite lors de la modification de acteur : $e');
    }
  }

  Future<List<Acteur>> fetchActeur() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/read'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Fetching data");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        acteurList = body.map((e) => Acteur.fromMap(e)).toList();
        debugPrint(acteurList.toString());
        return acteurList;
      } else {
        acteurList = [];
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future deleteActeur(String idActeur) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$idActeur'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future activerActeur(String idActeur) async {
    final response = await http.delete(Uri.parse('$baseUrl/enable/$idActeur'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future desactiverActeur(String idActeur) async {
    final response = await http.delete(Uri.parse('$baseUrl/disable/$idActeur'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<Acteur> addTypesToActeur(String idActeur, List<TypeActeur> typeActeurs) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addTypesToActeur/$idActeur'),
      body: json.encode(typeActeurs.map((type) => type.toJson()).toList()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Acteur.fromJson(json.decode(response.body));
    } else {
      throw Exception('Impossibke d\'ajouter un type ');
    }
  }

  Future<void> sendMailToAllUser(
      String email, String subject, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send-email-to-all-user'),
      body:
          json.encode({'email': email, 'subject': subject, 'message': message}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Impossible envoyé le message ${response.statusCode}');
    }
  }

  Future<void> sendMailToAllUserChoose(
      String email, String subject, String message, String libelle) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send-email-to-all-choose'),
      body: json.encode({
        'email': email,
        'subject': subject,
        'message': message,
        'libelle': libelle
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Impossible envoyé le message ${response.statusCode}');
    }
  }

  Future<void> sendMailToAllUserCheckedChoose(String email, String subject,
      String message, List<String> libelles) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send-email-to-all-checked-choose'),
      body: json.encode({
        'email': email,
        'subject': subject,
        'message': message,
        'libelles': libelles
      }),
      headers: {'Content-Type': 'application/json'},
    );

   if (response.statusCode != 200) {
      throw Exception('Impossible envoyé le message ${response.statusCode}');
    }
  }

  Future<void> sendMessageToActeurByTypeActeur(
      String message, List<String> libelles) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sendMessageWathsappToActeurByTypeActeur'),
      body: json.encode({'message': message, 'libelles': libelles}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Impossible envoyé le message ${response.statusCode}');
    }
  }

  
  void applyChange() {
    notifyListeners();
  }
}
