import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:path/path.dart';

class ActeurService extends ChangeNotifier {
  // static const String baseUrl = 'https://koumi.ml/api-koumi/acteur';
  static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/acteur';

  List<Acteur> acteurList = [];

  Future<void> creerActeur({
    required String nomActeur,
    required String adresseActeur,
    required String telephoneActeur,
    required String whatsAppActeur,
    String? latitude,
    String? longitude,
    String? niveau3PaysActeur,
    required String localiteActeur,
    required String emailActeur,
    List<TypeActeur>? typeActeur,
    List<Speculation>? speculations,
    File? photoSiegeActeur,
    File? logoActeur,
    required String password,
  }) async {
    try {
      //    // Convertir chaque TypeActeur en un objet JSON et les ajouter à une liste JSON
      // List<String> typeActeurJsonList = typeActeur.map((typeActeur) => typeActeur.toJson()).toList();
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

      //acteur
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
        'speculations': speculations,
        'typeActeur': typeActeur, // Convertir chaque objet TypeActeur en map
        'photoSiegeActeur': "",
        'logoActeur': "",
        'password': password,
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || responsed.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint('acteur service ${donneesResponse.toString()}');
      } else {
        final errorMessage =
            json.decode(utf8.decode(responsed.bodyBytes))['message'];
        throw Exception(' ${errorMessage}');
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
    required List<Speculation> speculations,
    File? photoSiegeActeur,
    File? logoActeur,
    required String password,
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
        'idActeur': idActeur,
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
        'speculations': speculations.toList(),
        'photoSiegeActeur': "",
        'logoActeur': "",
        'password': password,
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

  static Future<String> sendOtpCodeEmail(
      String emailActeur, BuildContext context) async {
    final url = Uri.parse('$baseUrl/sendOtpCodeEmail?emailActeur=$emailActeur');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Si la réponse est réussie, renvoyer le message de réussite
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Succès'),
              content: Text("Code envoyé avec succès"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        debugPrint("Code envoyé par mail : ${response.body} ");
        return response.body;
      } else {
        // Si la réponse n'est pas réussie, lancer une exception avec le message d'erreur
        debugPrint("Non envoyé : ${response.statusCode} ");
        final Map<String, dynamic> body = json.decode(response.body);
        final String errorMessage = body['message'] ?? 'Code non envoyé.';
        // Afficher une alerte d'erreur avec le message spécifique
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text(errorMessage),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        throw Exception('Failed to verify email: ${response.statusCode}');
      }
    } catch (e) {
      // Gérer les erreurs de requête HTTP
      debugPrint("Erreur catch non envoyé : ${e} ");

      // Afficher une alerte d'erreur avec le message spécifique
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text("Une erreur s'est produite veuilez reéssayer !"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      throw Exception('Failed to verify email: $e');
    }
  }

  static Future<String> sendOtpCodeWhatsApp(
      String whatsAppActeur, BuildContext context) async {
    final url = Uri.parse(
        '$baseUrl/sendOtpCodeWhatsApp?whatsAppActeur=$whatsAppActeur');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        debugPrint("Envoyé : ${response.body} ");
        // Si la réponse est réussie, renvoyer le message de réussite

        // Afficher une alerte d'erreur avec le message spécifique
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Succès'),
              content: Text("Code envoyé avec succès"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        return response.body;
      } else {
        // Si la réponse n'est pas réussie, lancer une exception avec le message d'erreur
        debugPrint("Non envoyé : ${response.statusCode} ");
        final Map<String, dynamic> body = json.decode(response.body);
        final String errorMessage = body['message'] ?? 'Code non envoyé.';
        // Afficher une alerte d'erreur avec le message spécifique
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text(errorMessage),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        throw Exception('Failed to send code : ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Erreur catch non envoyé : ${e} ");
      // Gérer les erreurs de requête HTTP

      // Afficher une alerte d'erreur avec le message spécifique
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text("Une erreur s'est produite veuillez reéssayer !"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      throw Exception('Failed to send code: $e');
    }
  }

  static Future<void> verifyOtpCodeWhatsApp(
      String whatsAppActeur, String resetToken, BuildContext context) async {
    final Uri url = Uri.parse(
        '$baseUrl/verifierOtpCodeWhatsApp?whatsAppActeur=$whatsAppActeur&resetToken=$resetToken');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Afficher une alerte de succès
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Succès'),
              content: Text('Le code a été vérifié avec succès.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 400 || response.statusCode == 500) {
        // Extraire le message d'erreur du corps de la réponse
        final Map<String, dynamic> body = json.decode(response.body);
        final String errorMessage = body['message'] ?? 'Le code est incorrect.';

        // Afficher une alerte d'erreur avec le message spécifique
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text(errorMessage),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Afficher une alerte pour d'autres erreurs
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text(
                  'Une erreur est survenue lors de la vérification du code.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Afficher une alerte pour les erreurs de connexion
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur de connexion'),
            content: Text('Une erreur est survenue lors de la connexion .'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  static Future<void> verifyOtpCodeEmail(
      String emailActeur, String resetToken, BuildContext context) async {
    final Uri url = Uri.parse(
        '$baseUrl/verifierOtpCodeEmail?emailActeur=$emailActeur&resetToken=$resetToken');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Afficher une alerte de succès
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Succès'),
              content: Text('Le code a été vérifié avec succès.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 400 || response.statusCode == 500) {
        // Extraire le message d'erreur du corps de la réponse
        final Map<String, dynamic> body = json.decode(response.body);
        final String errorMessage = body['message'] ?? 'Le code est incorrect.';

        // Afficher une alerte d'erreur avec le message spécifique
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text(errorMessage),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Afficher une alerte pour d'autres erreurs
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text(
                  'Une erreur est survenue lors de la vérification du code.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Afficher une alerte pour les erreurs de connexion
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur de connexion'),
            content: Text('Une erreur est survenue lors de la connexion .'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  static Future<void> resetPasswordEmail(
      String emailActeur, String password) async {
    final Uri url = Uri.parse(
        '$baseUrl/resetPasswordEmail?emailActeur=$emailActeur&password=$password');

    try {
      final response = await http.put(url);

      if (response.statusCode == 200) {
        // Mot de passe réinitialisé avec succès
        debugPrint("Succès email password update: ${response.statusCode}");
      } else if (response.statusCode == 500) {
        // Erreur serveur
        debugPrint(
            "Erreur email password update echouer : ${response.statusCode}");
      } else {
        throw Exception(
            'Une erreur est survenue lors de la réinitialisation du mot de passe');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue : $e');
    }
  }

//   static Future<Map<String, dynamic>> resetPasswordEmail(String email, String password) async {
//   // Endpoint URL
//   String url = '$baseUrl/resetPasswordEmail';

//   // Request body
//   Map<String, String> body = {
//     'email': email,
//     'password': password,
//   };

//   // Sending PUT request
//   http.Response response = await http.put(Uri.parse(url), body: body);

//   // Parsing response
//   if (response.statusCode == 200) {
//     // If the request is successful, return the response body
//     return {"success": true, "data": response.body};
//   } else {
//     // If there is an error, throw an exception
//     throw Exception('Failed to reset password: ${response.statusCode}');
//   }
// }

  static Future<void> resetPasswordWhatsApp(
      String whatsAppActeur, String password) async {
    final Uri url = Uri.parse(
        '$baseUrl/resetPasswordWhatsApp?whatsAppActeur=$whatsAppActeur&password=$password');

    try {
      final response = await http.put(url);

      if (response.statusCode == 200) {
        // Mot de passe réinitialisé avec succès
        debugPrint(
            "Succès whats App password update réussi : ${response.statusCode}");
      } else if (response.statusCode == 500) {
        // Erreur serveur
        debugPrint(
            "Erreur whats App password update echoué : ${response.statusCode}");
      } else {
        throw Exception(
            'Une erreur est survenue lors de la réinitialisation du mot de passe');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue : $e');
    }
  }

  Future<List<Acteur>> fetchActeur() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/read'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        print("body ${body.toString()}");
        acteurList = body.map((e) => Acteur.fromMap(e)).toList();
        print("acteur ${acteurList.toString()}");
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

  Future<List<Acteur>> fetchActeurByTypeActeur(String id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/listeByTypeActeur/$id'));

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
    final response = await http.put(Uri.parse('$baseUrl/enable/$idActeur'));

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future desactiverActeur(String idActeur) async {
    final response = await http.put(Uri.parse('$baseUrl/disable/$idActeur'));

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<Acteur> addTypesToActeur(
      String idActeur, List<TypeActeur> typeActeurs) async {
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
    try {
      final Uri uri = Uri.parse(
          '$baseUrl/sendMessageWathsappToActeurByTypeActeurs?message=$message&libelles=${libelles.join(',')}');

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception(
            'Impossible d\'envoyer le message ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Échec de l\'envoi du message WhatsApp : $e');
    }
  }

  Future<void> sendEmailToActeurByTypeActeur(
      String message, List<String> libelles, String sujet) async {
    try {
      final Uri uri = Uri.parse(
          '$baseUrl/sendEmailToActeurByTypeActeur?message=$message&libelles=${libelles.join(',')}&sujet=$sujet');

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception(
            'Impossible d\'envoyer le message ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Échec de l\'envoi du message WhatsApp : $e');
    }
  }

  void applyChange() {
    notifyListeners();
  }
}
