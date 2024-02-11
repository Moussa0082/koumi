

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:provider/provider.dart';


// class ActeurService extends ChangeNotifier {


//   static const String apiUrl = 'http://10.0.2.2:9000/acteur/create'; // Mettez à jour l'URL correcte
//   static const String apiUrl2 = 'http://10.0.2.2:9000/acteur/update'; // Mettez à jour l'URL correcte


//     static Future<Acteur> ajouterUtilisateur({
//   required String nom,
//   required String prenom,
//   required String email,
//   required String password,
//   File? image,
// }) async {
//   try {
//     var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

//     if (image != null) {
//       request.files.add(http.MultipartFile('image', image.readAsBytes().asStream(), image.lengthSync(), filename: basename(image.path)));
//     }

//     request.fields['acteur'] = jsonEncode({
//       'nom': nom,
//       'prenom': prenom,
//       'email': email,
//       'password': password,
//       'image': "",
//     });

//     var response = await request.send();
//     var responsed = await http.Response.fromStream(response);

//     // Log des informations sur la réponse
//     debugPrint('Response Status Code: ${response.statusCode}');
//     debugPrint('Response Body: ${responsed.body}');

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final responseData = json.decode(responsed.body);
//       return Acteur.fromJson(responseData);
//     } else {
//       throw Exception('Impossible d\'ajouter l\'utilisateur. Statut de réponse : ${response.statusCode}');
//     }
//   } catch (e) {
//     // Log des informations sur l'exception
//     debugPrint('Exception lors de l\'ajout de l\'utilisateur : $e');
//     throw Exception('Une erreur s\'est produite lors de l\'ajout de l\'utilisateur : $e');
//   }
// }




//    void applyChange(){
//     notifyListeners();
//   }
  


// }
