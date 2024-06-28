import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/constants.dart';
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

    static const String baseUrl = '$apiOnlineUrl/Magasin';
    // static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/Magasin';
    List<Magasin> magasin = [];
    int page = 0;
   bool isLoading = false;
   int size = 4;
   bool hasMore = true;
 
  Future<void> creerMagasin({
    required String nomMagasin,
    required String contactMagasin,
    required String localiteMagasin,
    required String pays,
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
     'pays': pays,
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

   
    Future<List<Magasin>> fetchMagasinByActeur(String idMagasin,{bool refresh = false}) async {
    // if (_stockService.isLoading == true) return [];

      isLoading = true;

    if (refresh) {
        magasin.clear();
       page = 0;
        hasMore = true;
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Magasin/getAllMagasinsByActeurWithPagination?idActeur=$idMagasin&page=${page}&size=${size}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
           hasMore = false;
        } else {
           List<Magasin> newMagasin = body.map((e) => Magasin.fromMap(e)).toList();
          magasin.addAll(newMagasin);
        }

        debugPrint("response body all magasin by acteur with pagination ${page} par défilement soit ${magasin.length}");
      } else {
        print('Échec de la requête  mag avec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des magasins: $e');
    } finally {
       isLoading = false;
    }
    return magasin;
  }
    Future<List<Magasin>> fetchMagasinByNiveau1PaysWithPagination(String niveau3PaysActeur,String idNiveau1Pays,{bool refresh = false}) async {
    // if (_stockService.isLoading == true) return [];

      isLoading = true;

    if (refresh) {
        magasin.clear();
       page = 0;
        hasMore = true;
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Magasin/getAllMagasinByNiveau1PaysWithPagination?niveau3PaysActeur=$niveau3PaysActeur&idNiveau1Pays=$idNiveau1Pays&page=${page}&size=${size}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
           hasMore = false;
        } else {
           List<Magasin> newMagasin = body.map((e) => Magasin.fromMap(e)).toList();
          magasin.addAll(newMagasin);
        }

        debugPrint("response body all magasin by niveau 1 pays with pagination ${page} par défilement soit ${magasin.length}");
      } else {
        print('Échec de la requête  mag niavec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des magasins: $e');
    } finally {
       isLoading = false;
    }
    return magasin;
  }

    Future<List<Magasin>> fetchAllMagasin(String niveau3PaysActeur, {bool refresh = false}) async {

      isLoading = true;

    if (refresh) {
        magasin.clear();
       page = 0;
        hasMore = true;
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Magasin/getAllMagasinWithPagination?niveau3PaysActeur=$niveau3PaysActeur&page=${page}&size=${size}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
           hasMore = false;
        } else {
           List<Magasin> newMagasin = body.map((e) => Magasin.fromMap(e)).toList();
          magasin.addAll(newMagasin);
        }

        debugPrint("response body all magasin  with pagination ${page} par défilement soit ${magasin.length}");
      } else {
        print('Échec de la requête mag pagavec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des magasins: $e');
    } finally {
       isLoading = false;
    }
    return magasin;
  }



   Future<List<Magasin>> fetchMagasinByRegion(String id) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/getAllMagasinByPays/${id}'));
      if (response.statusCode == 200) {
  // final String jsonString = utf8.decode(response.bodyBytes);
  //       List<dynamic> data = json.decode(jsonString);
               List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        magasin = body.where((magasin) => magasin['statutMagasin'] == true)
        .map((e) => Magasin.fromMap(e)).toList();
      // magasin = data.map((item) => Magasin.fromMap(item)).toList();
      return magasin;
      } else {
        print('Failed to load magasins for region $id');
        return magasin = [];
      }
    } catch (e) {
      print('Error fetching magasins for region $id: $e');
    }
        return magasin = [];
        
  }

  


   

   Future<List<Magasin>> fetchMagasinByRegionAndActeur(String idActeur, String idNiveau1Pays) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/getAllMagasinByActeurAndNiveau1Pays/${idActeur}/${idNiveau1Pays}'));
      if (response.statusCode == 200 || response.statusCode == 201 ||  response.statusCode == 202) {
  // final String jsonString = utf8.decode(response.bodyBytes);
  //       List<dynamic> data = json.decode(jsonString);
          print("Fetching data succès ${idActeur} / ${idNiveau1Pays}");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        magasin = body.map((e) => Magasin.fromMap(e)).toList();
                debugPrint("Succes : idActeur : $idActeur , idNiveau1Pays : $idNiveau1Pays , : liste ${magasin.toString()}");
       return magasin;
      } else {
        print('Failed to load magasins for region $idNiveau1Pays | and acteur $idActeur');
       return magasin = [];
      }
    } catch (e) {
      print('Error fetching magasins for acteur $idActeur et region $idNiveau1Pays: $e');
          // throw Exception(" erreur catch :  ${e.toString()}");
     return magasin = [];
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

//  class MagasinController extends GetxController {
//    List<Magasin> magasinListen = [];
//    List<Magasin> magasinListe1 = [];
//   var isLoadingn = true.obs;
//   var isLoading1 = true.obs;
//   var isEmpty = false.obs;
//   var isEmpty1 = false.obs;

//     final Rx<List<Magasin>> magasins = Rx([]);


//   void clearMagasinListen() {
//     magasinListen.clear();
//   }


//     Future<void> fetchMagasinByRegion(String id) async {


//       //  var url = 'https://koumi.ml/api-koumi/Magasin/getAllMagasinByPays/$id';
//   try {
    
//      final response = await http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByPays/$id'));
//     if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
//        print("reponse all magasin active all: ${response.statusCode}");
//       final String jsonString = utf8.decode(response.bodyBytes);
//         List<dynamic> data = json.decode(jsonString);
//              print("reponse fetch magasi acteur : ${data.toList()}");
   
//                  await Future.delayed(Duration(seconds: 2));
//           magasinListen = data
//           .where((magasin) => magasin['statutMagasin'] == true)
//                            .map((item) => Magasin(
//                     nomMagasin: item['nomMagasin'] ?? 'Nom du magasin manquant',
//                     idMagasin: item['idMagasin'] ?? 'ID du magasin manquant',
//                     contactMagasin:
//                         item['contactMagasin'] ?? 'Contact manquant',
//                     photo: item['photo'] ?? '',
//                     // ou utilisez une URL par défaut
//                     acteur: Acteur(
//                       idActeur: item['acteur']['idActeur'] ?? 'manquant',
//                       nomActeur: item['acteur']['nomActeur'] ?? ' manquant',
//                       // Autres champs de l'acteur...
//                     ),
//                     niveau1Pays: Niveau1Pays(
//                       idNiveau1Pays: item['niveau1Pays']['idNiveau1Pays'] ?? 'manquant',
//                       nomN1: item['niveau1Pays']['nomN1'] ?? 'manquant',
//                       // Autres champs de l'acteur...
//                     ),
//                     dateAjout: item['dateAjout'] ?? 'manquante',
//                     localiteMagasin: item['localiteMagasin'] ?? 'manquante',
//                     statutMagasin: item['statutMagasin'] as bool
//                          // ou une valeur par défaut
//                   ))
//               .toList();
   
//                print("reponse fetch magasin liste n acteur : ${magasinListen.toList()}");
//       isLoadingn.value = false;
//       update();
      
//     } else {
//        print("reponse else: ${response.statusCode}");
     
//       debugPrint(
//           'Aucun magasin trouvé! , Server responded: ${response.statusCode}:${response.reasonPhrase.toString()}');
//     }
 
//   } catch (e) {
//       debugPrint(
//           'Error Loading data! , Server responded: $e');
    
//   }
// }

  
//    void clearMagasinListe1() {
//     magasinListe1.clear();
//   }

//    Future<void> fetchMagasinByRegionAndActeur( String idActeur, String idNiveau1Pays) async {
//     try {
      
    
//       final response = await http.get(Uri.parse(
//           // 'https://koumi.ml/api-koumi/Magasin/getAllMagasinByActeurAndNiveau1Pays/${idActeur}/${idNiveau1Pays}'));
//           'http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByActeurAndNiveau1Pays/$idActeur/$idNiveau1Pays'));
      
//    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
//              print("reponse fetch magasi acteur : ${response.statusCode}");

//       final String jsonString = utf8.decode(response.bodyBytes);
//         List<dynamic> data = json.decode(jsonString);
//               await Future.delayed(Duration(seconds: 2));
//           magasinListe1 = data
//           // .where((magasin) => magasin['statutMagasin'] == true)
//                            .map((item) => Magasin(
//                     nomMagasin: item['nomMagasin'] ?? 'Nom du magasin manquant',
//                     idMagasin: item['idMagasin'] ?? 'ID du magasin manquant',
//                     contactMagasin:
//                         item['contactMagasin'] ?? 'Contact manquant',
//                     photo: item['photo'] ?? '',
//                     // ou utilisez une URL par défaut
//                     acteur: Acteur(
//                       idActeur: item['acteur']['idActeur'] ?? 'manquant',
//                       nomActeur: item['acteur']['nomActeur'] ?? ' manquant',
//                       // Autres champs de l'acteur...
//                     ),
//                     niveau1Pays: Niveau1Pays(
//                       idNiveau1Pays: item['niveau1Pays']['idNiveau1Pays'] ?? 'manquant',
//                       nomN1: item['niveau1Pays']['nomN1'] ?? 'manquant',
//                       // Autres champs de l'acteur...
//                     ),
//                     dateAjout: item['dateAjout'] ?? 'manquante',
//                     localiteMagasin: item['localiteMagasin'] ?? 'manquante',
//                     statutMagasin: item['statutMagasin'] 
//                         as bool, // ou une valeur par défaut
//                   ))
//               .toList();
    
//         isLoading1.value = false;
//       update();
      
//     } else {
//       // Get.snackbar('Erreur lors de la recuperation des magasins de l\'acteur!',
//           // 'Sever responded: ${response.statusCode}:${response.reasonPhrase.toString()}');
//       debugPrint('Aucun magasin trouvé! , Sever responded: ${response.statusCode}:${response.reasonPhrase.toString()}');
//     }

//     }catch (e) {
//             debugPrint('Error catch Loading data! , Sever responded: $e');
//     }
//   }


 

//  }