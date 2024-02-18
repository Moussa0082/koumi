import 'package:flutter/material.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';

class ParametreGProvider with ChangeNotifier {
  List<ParametreGeneraux> parametreList = [];
  final List<ParametreGeneraux> _parametreList = [];
  ParametreGeneraux? _parametre;

  List<ParametreGeneraux> get parametreListe => _parametreList;
  ParametreGeneraux? get param => _parametre;

  // void setParametreList(List<ParametreGeneraux> list) {
  //   _parametreList = list;
  //   notifyListeners();
  // }

  void setParametre(dynamic newParametre) {
    _parametre = newParametre;
    notifyListeners();
  }
}
