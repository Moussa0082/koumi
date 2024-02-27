import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActeurProvider with ChangeNotifier {
  Acteur? _acteur;
  Acteur? get acteur => _acteur;

   
  
  // Méthode pour initialiser les données de l'utilisateur à partir de SharedPreferences
  Future<void> initializeActeurFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailActeur = prefs.getString('emailActeur');
    String? password = prefs.getString('password');
    List<String>? userTypeList = prefs.getStringList('userType');

    if (emailActeur != null && password != null && userTypeList != null) {
      // Créer l'objet Acteur à partir des données de SharedPreferences
      // Assurez-vous d'avoir les méthodes nécessaires dans la classe Acteur pour créer un objet à partir des données
      // par exemple, si Acteur a un constructeur nommé `fromSharedPreferencesData`, utilisez-le ici
      // sinon, vous devrez ajouter les méthodes nécessaires dans la classe Acteur
      _acteur = Acteur.fromSharedPreferencesData(emailActeur, password, userTypeList);

      // Informer les auditeurs (les widgets qui écoutent les changements dans ce fournisseur) que les données ont été mises à jour
      notifyListeners();
    }
  }

  void setActeur(Acteur newActeur) {
    _acteur = newActeur;
    // debugPrint(" provider ${newActeur.toString()}");
    notifyListeners();
  }


  Future<void> logout() async {
    // Supprimer les données utilisateur
    _acteur = null;
    notifyListeners();
    // Rediriger vers la page de connexion
   }

}
