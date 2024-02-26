
import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/screens/LoginScreen.dart';

class ActeurProvider with ChangeNotifier {
  Acteur? _acteur;
  Acteur? get acteur => _acteur;

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
