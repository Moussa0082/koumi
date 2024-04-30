// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:koumi_app/models/Commande.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/models/Stock.dart';

class CommandeAvecStocks {
  Commande? commande;
  List<Stock>? stocks;
  List<Intrant>? intrants;
  List<double>? quantitesDemandees;
  List<double>? quantitesIntrants;


  CommandeAvecStocks({
     this.commande,
     this.stocks,
     this.intrants,
     this.quantitesDemandees,
     this.quantitesIntrants,
  });


  // CommandeAvecStocks copyWith({
  //   Commande? commande,
  //   List<Stock>? stocks,
  //   List<double>? quantitesDemandees,
  // }) {
  //   return CommandeAvecStocks(
  //     commande: commande ?? this.commande,
  //     stocks: stocks ?? this.stocks,
  //     quantitesDemandees: quantitesDemandees ?? this.quantitesDemandees,
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'commande': commande?.toJson(),
      'stocks': stocks?.map((stock) => stock.toMap()).toList(),
      'intrants': intrants?.map((intrant) => intrant.toMap()).toList(),
      'quantitesDemandees': quantitesDemandees,
      'quantitesIntrants': quantitesIntrants,
    };
  }

  factory CommandeAvecStocks.fromMap(Map<String, dynamic> map) {
    return CommandeAvecStocks(
      commande: Commande.fromMap(map['commande'] as Map<String,dynamic>),
      stocks: List<Stock>.from((map['stocks'] as List<int>).map<Stock>((x) => Stock.fromMap(x as Map<String,dynamic>),),),
      intrants: List<Intrant>.from((map['intrants'] as List<int>).map<Intrant>((x) => Intrant.fromMap(x as Map<String,dynamic>),),),
      quantitesDemandees: List<double>.from((map['quantitesDemandees'] as List<double>),),
      quantitesIntrants: List<double>.from((map['quantitesIntrants'] as List<double>),)
    );
  }


  // factory CommandeAvecStocks.fromJson(String source) => CommandeAvecStocks.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CommandeAvecStocks(commande: $commande, stocks: $stocks,intrants: $intrants ,quantitesDemandees: $quantitesDemandees, quantitesIntrants: $quantitesIntrants)';

  @override
  bool operator ==(covariant CommandeAvecStocks other) {
    if (identical(this, other)) return true;
  
    return 
      other.commande == commande &&
      listEquals(other.stocks, stocks) &&
      listEquals(other.intrants, intrants) &&
      listEquals(other.quantitesDemandees, quantitesDemandees)&&
      listEquals(other.quantitesIntrants, quantitesIntrants);
  }

  @override
  int get hashCode => commande.hashCode ^ stocks.hashCode ^ intrants.hashCode ^ quantitesDemandees.hashCode ^ quantitesIntrants.hashCode;
 }
