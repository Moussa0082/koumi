// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Commande.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/Unite.dart';
import 'package:koumi_app/models/ZoneProduction.dart';

class Stock {
  String? idStock;
  final String? codeStock;
  final String? nomProduit;
   String? formeProduit;
  final String? dateProduction;
  final double? quantiteStock;
  final int? prix;
  final String? typeProduit;
  final String? descriptionStock;
   String? photo;
  final ZoneProduction? zoneProduction;
  final String? dateAjout;
  final String? dateModif;
   String? personneModif;
  final bool? statutSotck;
  final Speculation? speculation;
  final Unite? unite;
  final Magasin? magasin;
  final Acteur? acteur;
  final List<Commande>? commande;

  Stock({
    this.idStock,
    this.codeStock,
     this.nomProduit,
     this.formeProduit,
    this.dateProduction,
     this.quantiteStock,
     this.prix,
     this.typeProduit,
     this.descriptionStock,
    this.photo,
     this.zoneProduction,
    this.dateAjout,
    this.dateModif,
    this.personneModif,
     this.statutSotck,
     this.speculation,
     this.unite,
     this.magasin,
     this.acteur,
    this.commande,
  });

  

 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idStock': idStock,
      'codeStock': codeStock,
      'nomProduit': nomProduit,
      'formeProduit': formeProduit,
      'dateProduction': dateProduction,
      'quantiteStock': quantiteStock,
      'prix': prix,
      'typeProduit': typeProduit,
      'descriptionStock': descriptionStock,
      'photo': photo,
      'zoneProduction': zoneProduction?.toMap(),
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'personneModif': personneModif,
      'statutSotck': statutSotck,
      'speculation': speculation?.toMap(),
      'unite': unite?.toMap(),
      'magasin': magasin?.toMap(),
      'acteur': acteur?.toMap(),
      'commande': commande!.map((x) => x?.toMap()).toList(),
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      idStock: map['idStock'] as String?,
      codeStock: map['codeStock'] as String?,
      nomProduit: map['nomProduit'] as String,
      formeProduit: map['formeProduit'] as String? ?? '',
      dateProduction: map['dateProduction'] as String?,
      quantiteStock: (map['quantiteStock'] as num?)?.toDouble() ?? 0.0,
      prix: (map['prix'] as num?)?.toInt() ?? 0,
      typeProduit: map['typeProduit'] as String,
      descriptionStock: map['descriptionStock'] as String,
      photo: map['photo'] as String?,
      zoneProduction:
          ZoneProduction.fromMap(map['zoneProduction'] as Map<String, dynamic>),
      dateAjout: map['dateAjout'] as String?,
      dateModif: map['dateModif'] as String?,
      personneModif: map['personneModif'] as String?,
      statutSotck: map['statutSotck'] as bool? ?? false,
      speculation:
          Speculation.fromMap(map['speculation'] as Map<String, dynamic>),
      unite: Unite.fromMap(map['unite'] as Map<String, dynamic>),
      magasin: Magasin.fromMap(map['magasin'] as Map<String, dynamic>),
      acteur: Acteur.fromMap(map['acteur'] as Map<String, dynamic>),
      commande: (map['commande'] as List<dynamic>?)
          ?.map((e) => Commande.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }


  String toJson() => json.encode(toMap());

  factory Stock.fromJson(String source) => Stock.fromMap(json.decode(source) as Map<String, dynamic>);

  
}
