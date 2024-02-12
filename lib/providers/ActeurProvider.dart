import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';

class ActeurProvider with ChangeNotifier {
  Acteur? _acteur;
  Acteur? get acteur => _acteur;

  void setActeur(Acteur newActeur) {
    notifyListeners();
  }
}
