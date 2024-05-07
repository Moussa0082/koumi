// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Commande.dart';
import 'package:koumi_app/models/Forme.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/Unite.dart';
import 'package:koumi_app/models/ZoneProduction.dart';

class Stock {
  String? idStock;
   String? codeStock;
   String? nomProduit;
   String? formeProduit;
   String? origineProduit;
   String? dateProduction;
   double? quantiteStock;
   int? prix;
   String? typeProduit;
   String? descriptionStock;
   String? photo;
   ZoneProduction? zoneProduction;
   String? dateAjout;
  String? dateModif;
   String? personneModif;
   bool? statutSotck;
   Speculation? speculation;
   Unite? unite;
   Magasin? magasin;
   Acteur? acteur;

  Stock({
    this.idStock,
    this.codeStock,
     this.nomProduit,
     this.formeProduit,
     this.origineProduit,
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
  });

  

 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idStock': idStock,
      'codeStock': codeStock,
      'nomProduit': nomProduit,
      'formeProduit': formeProduit,
      'origineProduit': origineProduit,
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

  factory Stock.fromMap(Map<String, dynamic> map) {
  return Stock(
    idStock: map['idStock'] ,
    codeStock: map['codeStock'] ,
    nomProduit: map['nomProduit'] ,
    formeProduit: map['formeProduit'] ,
    origineProduit: map['origineProduit'] ,
    dateProduction: map['dateProduction'] ,
    quantiteStock: (map['quantiteStock'] as num).toDouble(),
    prix: (map['prix'] as num).toInt(),
    typeProduit: map['typeProduit'] ,
    descriptionStock: map['descriptionStock'] ,
    photo: map['photo'] ,
    zoneProduction: map['zoneProduction'] != null
        ? ZoneProduction.fromMap(map['zoneProduction'] as Map<String, dynamic>)
        : ZoneProduction(), // Create an empty ZoneProduction if null
    dateAjout: map['dateAjout'] ,
    dateModif: map['dateModif'] ,
    personneModif: map['personneModif'] ,
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
        : Acteur(),
  
  );
}



  // String toJson() => json.encode(toMap());
   Map<String, dynamic> toJson() {
    return {
         'idStock': idStock,
      'codeStock': codeStock,
      'nomProduit': nomProduit,
      'formeProduit': formeProduit,
      'origineProduit': origineProduit,
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
    origineProduit: json['origineProduit'],
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
  );
}


  
}