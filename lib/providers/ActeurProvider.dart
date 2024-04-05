
import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';

import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActeurProvider with ChangeNotifier {
  Acteur? _acteur;
  Acteur? get acteur => _acteur;

   
  
 // Méthode pour initialiser les données de l'utilisateur à partir de SharedPreferences
  Future<void> initializeActeurFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idActeur = prefs.getString('idActeur');
    String? emailActeur = prefs.getString('emailActeur');
    String? password = prefs.getString('password');
    List<String>? userTypeList = prefs.getStringList('userType');
    String? nomActeur = prefs.getString('nomActeur'); 
    String? adresseActeur = prefs.getString('adresseActeur'); 
    String? telephoneActeur = prefs.getString('telephoneActeur');
    String? whatsAppActeur = prefs.getString('whatsAppActeur');
    String? niveau3PaysActeur = prefs.getString('niveau3PaysActeur');
    String? localiteActeur = prefs.getString('localiteActeur');

    if (emailActeur != null && password != null && userTypeList != null &&
        idActeur != null && nomActeur != null && adresseActeur!= null &&
        telephoneActeur != null && whatsAppActeur != null && niveau3PaysActeur != null &&
        localiteActeur != null) {

      // Créer l'objet Acteur à partir des données de SharedPreferences
      _acteur = Acteur.fromSharedPreferencesData(
        emailActeur, password, userTypeList, idActeur, nomActeur,
        telephoneActeur, adresseActeur, whatsAppActeur,
        niveau3PaysActeur, localiteActeur
      );

      // Mettre à jour le Provider avec les données de l'utilisateur
      notifyListeners();
    }
  }

  void setActeur(Acteur newActeur) {
    _acteur = newActeur;
    notifyListeners();
  }

  Future<void> logout() async {
    // Supprimer les données utilisateur
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailActeur = prefs.getString('emailActeur');
    String? codeActeur = prefs.getString('codeActeur');
   String savedCodeActeur = codeActeur!;
    _acteur = null;

 if (emailActeur == null || emailActeur.isEmpty) {
  // Nettoyer toutes les données de SharedPreferences
  // await prefs.clear();
  debugPrint("Email shared : $emailActeur");
  }else{
  debugPrint("Email shared isExist : $emailActeur");

  }

// Vérifier si le codeActeur est présent dans SharedPreferences
if (codeActeur.isEmpty) {
  // Gérer le cas où le codeActeur est manquant
  // Sauvegarder le codeActeur avant de nettoyer les SharedPreferences
  // String savedCodeActeur = "VF212";

  // Nettoyer toutes les données de SharedPreferences
  await prefs.clear();

  // Réenregistrer le codeActeur dans SharedPreferences
  prefs.setString('codeActeur', savedCodeActeur);
} else {
  // // Sauvegarder le codeActeur avant de nettoyer les SharedPreferences
  // String savedCodeActeur = "VF212";
  //   String savedCodeActeur = codeActeur;

  // // Nettoyer toutes les données de SharedPreferences
  // await prefs.clear();

  // // Réenregistrer le codeActeur dans SharedPreferences
  // prefs.setString('codeActeur', savedCodeActeur);

  // // // Nettoyer toutes les données de SharedPreferences
  // await prefs.clear();

  // // // Réenregistrer le codeActeur dans SharedPreferences
  // prefs.setString('codeActeur', savedCodeActeur);
}

    notifyListeners();
    // Rediriger vers la page de connexion

  
}

  }
