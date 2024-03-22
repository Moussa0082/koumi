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
  final String? formeProduit;
  final String? dateProduction;
   double? quantiteStock;
  final int? prix;
  final String? typeProduit;
  final String? descriptionStock;
   String? photo;
  final ZoneProduction? zoneProduction;
  final String? dateAjout;
  final String? dateModif;
  final String? personneModif;
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
    formeProduit: map['formeProduit'] as String?,
    dateProduction: map['dateProduction'] as String?,
    quantiteStock: (map['quantiteStock'] as num?)?.toDouble() ?? 0.0,
    prix: (map['prix'] as num?)?.toInt() ?? 0,
    typeProduit: map['typeProduit'] as String?,
    descriptionStock: map['descriptionStock'] as String?,
    photo: map['photo'] as String?,
    zoneProduction: map['zoneProduction'] != null
        ? ZoneProduction.fromMap(map['zoneProduction'] as Map<String, dynamic>)
        : ZoneProduction(), // Create an empty ZoneProduction if null
    dateAjout: map['dateAjout'] as String?,
    dateModif: map['dateModif'] as String?,
    personneModif: map['personneModif'] as String?,
    statutSotck: map['statutSotck'] as bool? ?? false,
    speculation: map['speculation'] != null
        ? Speculation.fromMap(map['speculation'] as Map<String, dynamic>)
        : Speculation(), // Create an empty Speculation if null
    unite: map['unite'] != null
        ? Unite.fromMap(map['unite'] as Map<String, dynamic>)
        : Unite(), // Create an empty Unite if null
    magasin: map['magasin'] != null
        ? Magasin.fromMap(map['magasin'] as Map<String, dynamic>)
        : Magasin(), // Create an empty Magasin if null
    acteur: map['acteur'] != null
        ? Acteur.fromMap(map['acteur'] as Map<String, dynamic>)
        : Acteur(), // Create an empty Acteur if null
    commande: (map['commande'] as List<dynamic>?)
        ?.map((e) => Commande.fromMap(e as Map<String, dynamic>))
        .toList(),
  );
}



  // String toJson() => json.encode(toMap());
   Map<String, dynamic> toJson() {
    return {
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
    };
  }

  // factory Stock.fromJson(String source) => Stock.fromMap(json.decode(source) as Map<String, dynamic>);

 factory Stock.fromJson(Map<String, dynamic> json) {
  return Stock(
    idStock: json['idStock'],
    codeStock: json['codeStock'],
    nomProduit: json['nomProduit'],
    formeProduit: json['formeProduit'],
    dateProduction: json['dateProduction'],
    quantiteStock: json['quantiteStock']?.toDouble(),
    prix: json['prix'],
    typeProduit: json['typeProduit'],
    descriptionStock: json['descriptionStock'],
    photo: json['photo'],
    zoneProduction: json['zoneProduction'] != null ? ZoneProduction.fromJson(json['zoneProduction']) : null,
    dateAjout: json['dateAjout'],
    dateModif: json['dateModif'],
    personneModif: json['personneModif'],
    statutSotck: json['statutSotck'],
    speculation: json['speculation'] != null ? Speculation.fromJson(json['speculation']) : null,
    unite: json['unite'] != null ? Unite.fromJson(json['unite']) : null,
    magasin: json['magasin'] != null ? Magasin.fromJson(json['magasin']) : null,
    acteur: json['acteur'] != null ? Acteur.fromJson(json['acteur']) : null,
    commande: (json['commande'] as List<dynamic>?)?.map((e) => Commande.fromJson(e)).toList(),
  );
}


  
}
