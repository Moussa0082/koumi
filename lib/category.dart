import 'package:flutter/material.dart';
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class category {
  static const  String phyto = '';
  static const String fruitLegume = '';
  static const String complement = '';
  static const String engrais = '';
  static const String elevage = '';
  static const String transforme = '';

  static const String baseUrl = '$apiOnlineUrl/Categorie';
  
  List<CategorieProduit> categorieList = [];
  late Future<List<CategorieProduit>> _liste;


}


