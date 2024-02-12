// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Commande.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/Unite.dart';
import 'package:koumi_app/models/ZoneProduction.dart';

class Stock {
  final String? idStock;
  final String codeStock;
  final String nomProduit;
  final String formeProduit;
  final String dateProduction;
  final int quantiteStock;
  final String typeProduit;
  final String descriptionStock;
  final String photo;
  final ZoneProduction zoneProduction;
  final String dateAjout;
  final String dateModif;
  final String personneModif;
  final bool statutSotck;
  final Speculation speculation;
  final Unite unite;
  final Magasin magasin;
  final Acteur acteur;
  final Commande commande;
  Stock({
    this.idStock,
    required this.codeStock,
    required this.nomProduit,
    required this.formeProduit,
    required this.dateProduction,
    required this.quantiteStock,
    required this.typeProduit,
    required this.descriptionStock,
    required this.photo,
    required this.zoneProduction,
    required this.dateAjout,
    required this.dateModif,
    required this.personneModif,
    required this.statutSotck,
    required this.speculation,
    required this.unite,
    required this.magasin,
    required this.acteur,
    required this.commande,
  });

  Stock copyWith({
    String? idStock,
    String? codeStock,
    String? nomProduit,
    String? formeProduit,
    String? dateProduction,
    int? quantiteStock,
    String? typeProduit,
    String? descriptionStock,
    String? photo,
    ZoneProduction? zoneProduction,
    String? dateAjout,
    String? dateModif,
    String? personneModif,
    bool? statutSotck,
    Speculation? speculation,
    Unite? unite,
    Magasin? magasin,
    Acteur? acteur,
    Commande? commande,
  }) {
    return Stock(
      idStock: idStock ?? this.idStock,
      codeStock: codeStock ?? this.codeStock,
      nomProduit: nomProduit ?? this.nomProduit,
      formeProduit: formeProduit ?? this.formeProduit,
      dateProduction: dateProduction ?? this.dateProduction,
      quantiteStock: quantiteStock ?? this.quantiteStock,
      typeProduit: typeProduit ?? this.typeProduit,
      descriptionStock: descriptionStock ?? this.descriptionStock,
      photo: photo ?? this.photo,
      zoneProduction: zoneProduction ?? this.zoneProduction,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      personneModif: personneModif ?? this.personneModif,
      statutSotck: statutSotck ?? this.statutSotck,
      speculation: speculation ?? this.speculation,
      unite: unite ?? this.unite,
      magasin: magasin ?? this.magasin,
      acteur: acteur ?? this.acteur,
      commande: commande ?? this.commande,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idStock': idStock,
      'codeStock': codeStock,
      'nomProduit': nomProduit,
      'formeProduit': formeProduit,
      'dateProduction': dateProduction,
      'quantiteStock': quantiteStock,
      'typeProduit': typeProduit,
      'descriptionStock': descriptionStock,
      'photo': photo,
      'zoneProduction': zoneProduction.toMap(),
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'personneModif': personneModif,
      'statutSotck': statutSotck,
      'speculation': speculation.toMap(),
      'unite': unite.toMap(),
      'magasin': magasin.toMap(),
      'acteur': acteur.toMap(),
      'commande': commande.toMap(),
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      idStock: map['idStock'] != null ? map['idStock'] as String : null,
      codeStock: map['codeStock'] as String,
      nomProduit: map['nomProduit'] as String,
      formeProduit: map['formeProduit'] as String,
      dateProduction: map['dateProduction'] as String,
      quantiteStock: map['quantiteStock'] as int,
      typeProduit: map['typeProduit'] as String,
      descriptionStock: map['descriptionStock'] as String,
      photo: map['photo'] as String,
      zoneProduction: ZoneProduction.fromMap(map['zoneProduction'] as Map<String,dynamic>),
      dateAjout: map['dateAjout'] as String,
      dateModif: map['dateModif'] as String,
      personneModif: map['personneModif'] as String,
      statutSotck: map['statutSotck'] as bool,
      speculation: Speculation.fromMap(map['speculation'] as Map<String,dynamic>),
      unite: Unite.fromMap(map['unite'] as Map<String,dynamic>),
      magasin: Magasin.fromMap(map['magasin'] as Map<String,dynamic>),
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
      commande: Commande.fromMap(map['commande'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Stock.fromJson(String source) => Stock.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Stock(idStock: $idStock, codeStock: $codeStock, nomProduit: $nomProduit, formeProduit: $formeProduit, dateProduction: $dateProduction, quantiteStock: $quantiteStock, typeProduit: $typeProduit, descriptionStock: $descriptionStock, photo: $photo, zoneProduction: $zoneProduction, dateAjout: $dateAjout, dateModif: $dateModif, personneModif: $personneModif, statutSotck: $statutSotck, speculation: $speculation, unite: $unite, magasin: $magasin, acteur: $acteur, commande: $commande)';
  }

  @override
  bool operator ==(covariant Stock other) {
    if (identical(this, other)) return true;
  
    return 
      other.idStock == idStock &&
      other.codeStock == codeStock &&
      other.nomProduit == nomProduit &&
      other.formeProduit == formeProduit &&
      other.dateProduction == dateProduction &&
      other.quantiteStock == quantiteStock &&
      other.typeProduit == typeProduit &&
      other.descriptionStock == descriptionStock &&
      other.photo == photo &&
      other.zoneProduction == zoneProduction &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.personneModif == personneModif &&
      other.statutSotck == statutSotck &&
      other.speculation == speculation &&
      other.unite == unite &&
      other.magasin == magasin &&
      other.acteur == acteur &&
      other.commande == commande;
  }

  @override
  int get hashCode {
    return idStock.hashCode ^
      codeStock.hashCode ^
      nomProduit.hashCode ^
      formeProduit.hashCode ^
      dateProduction.hashCode ^
      quantiteStock.hashCode ^
      typeProduit.hashCode ^
      descriptionStock.hashCode ^
      photo.hashCode ^
      zoneProduction.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      personneModif.hashCode ^
      statutSotck.hashCode ^
      speculation.hashCode ^
      unite.hashCode ^
      magasin.hashCode ^
      acteur.hashCode ^
      commande.hashCode;
  }
}
