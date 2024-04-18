import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:provider/provider.dart';



class MagasinService extends ChangeNotifier{

    // static const String baseUrl = 'https://koumi.ml/api-koumi/Magasin';
    static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/Magasin';
    List<Magasin> magasin = [];
 
  Future<void> creerMagasin({
    required String nomMagasin,
    required String contactMagasin,
    required String localiteMagasin,
    File? photo,
    required Acteur acteur,
    required Niveau1Pays niveau1Pays
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

   Future<List<Magasin>> fetchMagasinByRegion(String id) async {
    try {
      final response = await http.get(Uri.parse(
          // 'https://koumi.ml/api-koumi/Magasin/getAllMagasinByPays/${id}'));
          'http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByPays/${id}'));
      if (response.statusCode == 200) {
  // final String jsonString = utf8.decode(response.bodyBytes);
  //       List<dynamic> data = json.decode(jsonString);
               List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        magasin = body.where((magasin) => magasin['statutMagasin'] == true)
        .map((e) => Magasin.fromMap(e)).toList();
      // magasin = data.map((item) => Magasin.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load magasins for region $id');
      }
    } catch (e) {
      print('Error fetching magasins for region $id: $e');
    }
        return magasin;
        
  }

   Future<List<Magasin>> fetchMagasinByRegionAndActeur(String idActeur, String idNiveau1Pays) async {
    // try {
      final response = await http.get(Uri.parse(
          // 'https://koumi.ml/api-koumi/Magasin/getAllMagasinByPays/${idActeur}/${idNiveau1Pays}'));
          'http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByActeurAndNiveau1Pays/$idActeur/$idNiveau1Pays'));
      if (response.statusCode == 200 || response.statusCode == 201 ||  response.statusCode == 202) {
  // final String jsonString = utf8.decode(response.bodyBytes);
  //       List<dynamic> data = json.decode(jsonString);
          print("Fetching data succès");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        magasin = body.map((e) => Magasin.fromMap(e)).toList();
                debugPrint("Succes : idActeur : $idActeur , idNiveau1Pays : $idNiveau1Pays , : liste ${magasin.toString()}");
                  applyChange();
      // magasin = data.map((item) => Magasin.fromMap(item)).toList();
      
      } else {
        magasin = [];
        // throw Exception('Failed to load magasins for region $idNiveau1Pays');
      }
    // } catch (e) {
      //  return magasin;
    //   print('Error fetching magasins for acteur $idActeur et region $idNiveau1Pays: $e');
    //       throw Exception(" erreur catch ");
    //       // throw Exception(" erreur catch :  ${e.toString()}");

    // }
         return magasin;
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

 class MagasinController extends GetxController {
   List<Magasin> magasinListe = [];
   List<Magasin> magasinListe1 = [];
  // var magasinListe = <Magasin>[].obs;
  var isLoading = true.obs;
  var isLoading1 = true.obs;
  //  var  idActeur, idNiveau1Pays = "";
  String id = "";
  

    //  static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/Magasin';

   
      // var id = Get.parameters["id"];

    Future<void> fetchMagasinByRegion(String id) async {


      try {
      //  var url = 'https://koumi.ml/api-koumi/Magasin/getAllMagasinByPays/$id';
      // String url = 'http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByPays/${id}';

     final response = await http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByPays/$id'));
    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
       print("reponse 1: ${response.statusCode}");
      // final String jsonString = utf8.decode(response.bodyBytes);
      //   List<dynamic> data = json.decode(jsonString);
          List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
         debugPrint("data succes : ${body.toString()}");
          magasinListe = body
          .where((magasin) => magasin['statutMagasin'] == true)
                           .map((item) => Magasin(
                    nomMagasin: item['nomMagasin'] ?? 'Nom du magasin manquant',
                    idMagasin: item['idMagasin'] ?? 'ID du magasin manquant',
                    contactMagasin:
                        item['contactMagasin'] ?? 'Contact manquant',
                    photo: item['photo'] ?? '',
                    // ou utilisez une URL par défaut
                    acteur: Acteur(
                      idActeur: item['acteur']['idActeur'] ?? 'manquant',
                      nomActeur: item['acteur']['nomActeur'] ?? ' manquant',
                      // Autres champs de l'acteur...
                    ),
                    niveau1Pays: Niveau1Pays(
                      idNiveau1Pays: item['niveau1Pays']['idNiveau1Pays'] ?? 'manquant',
                      nomN1: item['niveau1Pays']['nomN1'] ?? 'manquant',
                      // Autres champs de l'acteur...
                    ),
                    dateAjout: item['dateAjout'] ?? 'manquante',
                    localiteMagasin: item['localiteMagasin'] ?? 'manquante',
                    statutMagasin: item['statutMagasin'] ??
                        false, // ou une valeur par défaut
                  ))
              .toList();
      isLoading.value = false;
      update();
    } else {
       print("reponse else: ${response.statusCode}");
      Get.snackbar(
        'Erreur lors de la recuperation des magasins par region!',
        'Server responded: ${response.statusCode}:${response.reasonPhrase.toString()}',
      );
      debugPrint(
          'Error Loading data! , Server responded: ${response.statusCode}:${response.reasonPhrase.toString()}');
    }
  } catch (e) {
    Get.snackbar('Catch', 'Erreur catch lors de la recuperation des magasins par region!: $e');
    debugPrint('Error: $e');
  }
}

 
   Future<void> fetchMagasinByRegionAndActeur( String idActeur, String idNiveau1Pays) async {
    // try {
      final response = await http.get(Uri.parse(
          // 'https://koumi.ml/api-koumi/Magasin/getAllMagasinByActeurAndNiveau1Pays/${idActeur}/${idNiveau1Pays}'));
          'http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByActeurAndNiveau1Pays/$idActeur/$idNiveau1Pays'));
      
   if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
      final String jsonString = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(jsonString);
          magasinListe1 = data
          // .where((magasin) => magasin['statutMagasin'] == true)
                           .map((item) => Magasin(
                    nomMagasin: item['nomMagasin'] ?? 'Nom du magasin manquant',
                    idMagasin: item['idMagasin'] ?? 'ID du magasin manquant',
                    contactMagasin:
                        item['contactMagasin'] ?? 'Contact manquant',
                    photo: item['photo'] ?? '',
                    // ou utilisez une URL par défaut
                    acteur: Acteur(
                      idActeur: item['acteur']['idActeur'] ?? 'manquant',
                      nomActeur: item['acteur']['nomActeur'] ?? ' manquant',
                      // Autres champs de l'acteur...
                    ),
                    niveau1Pays: Niveau1Pays(
                      idNiveau1Pays: item['niveau1Pays']['idNiveau1Pays'] ?? 'manquant',
                      nomN1: item['niveau1Pays']['nomN1'] ?? 'manquant',
                      // Autres champs de l'acteur...
                    ),
                    dateAjout: item['dateAjout'] ?? 'manquante',
                    localiteMagasin: item['localiteMagasin'] ?? 'manquante',
                    statutMagasin: item['statutMagasin'] ??
                        false, // ou une valeur par défaut
                  ))
              .toList();
      isLoading1.value = false;
      // update();
    } else {
      // Get.snackbar('Erreur lors de la recuperation des magasins de l\'acteur!',
          // 'Sever responded: ${response.statusCode}:${response.reasonPhrase.toString()}');
      debugPrint('Error Loading data! , Sever responded: ${response.statusCode}:${response.reasonPhrase.toString()}');
    }
  }


  //  @override
  // void onInit() {
  //   super.onInit();
  // // fetchMagasinByRegionAndActeur(idActeur!, idNiveau1Pays!);
  //   // fetchMagasin();
  //   // fetchMagasinByRegion(id);
  //   // fetchMagasinByRegionAndActeur(idActeur, idNiveau1Pays);
  // }

 }