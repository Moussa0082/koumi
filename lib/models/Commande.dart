// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Materiel.dart';
import 'package:koumi_app/models/Stock.dart';

class Commande {
  final String? idCommande;
  final String codeCommande;
  final String descriptionCommande;
  final bool statutCommande;
  final bool statutCommandeLivrer;
  final bool statutConfirmation;
  final String? dateCommande;
  final String codeProduit;
  final int? quantiteDemande;
  final int? quantiteLivree;
  final int? quantiteNonLivree;
  final String nomProduit;
  final String codeAcheteur;
  final String? dateAjout;
  final String? dateModif;
  final Acteur acteur;
  final List<Stock> stock;
  final List<Materiel> materielList;
  
  Commande({
    this.idCommande,
    required this.codeCommande,
    required this.descriptionCommande,
    required this.statutCommande,
    required this.statutCommandeLivrer,
    required this.statutConfirmation,
    this.dateCommande,
    required this.codeProduit,
    this.quantiteDemande,
    this.quantiteLivree,
    this.quantiteNonLivree,
    required this.nomProduit,
    required this.codeAcheteur,
    this.dateAjout,
    this.dateModif,
    required this.acteur,
    required this.stock,
    required this.materielList,
  });

  Commande copyWith({
    String? idCommande,
    String? codeCommande,
    String? descriptionCommande,
    bool? statutCommande,
    bool? statutCommandeLivrer,
    bool? statutConfirmation,
    String? dateCommande,
    String? codeProduit,
    int? quantiteDemande,
    int? quantiteLivree,
    int? quantiteNonLivree,
    String? nomProduit,
    String? codeAcheteur,
    String? dateAjout,
    String? dateModif,
    Acteur? acteur,
    List<Stock>? stock,
    List<Materiel>? materielList,
  }) {
    return Commande(
      idCommande: idCommande ?? this.idCommande,
      codeCommande: codeCommande ?? this.codeCommande,
      descriptionCommande: descriptionCommande ?? this.descriptionCommande,
      statutCommande: statutCommande ?? this.statutCommande,
      statutCommandeLivrer: statutCommandeLivrer ?? this.statutCommandeLivrer,
      statutConfirmation: statutConfirmation ?? this.statutConfirmation,
      dateCommande: dateCommande ?? this.dateCommande,
      codeProduit: codeProduit ?? this.codeProduit,
      quantiteDemande: quantiteDemande ?? this.quantiteDemande,
      quantiteLivree: quantiteLivree ?? this.quantiteLivree,
      quantiteNonLivree: quantiteNonLivree ?? this.quantiteNonLivree,
      nomProduit: nomProduit ?? this.nomProduit,
      codeAcheteur: codeAcheteur ?? this.codeAcheteur,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      acteur: acteur ?? this.acteur,
      stock: stock ?? this.stock,
      materielList: materielList ?? this.materielList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idCommande': idCommande,
      'codeCommande': codeCommande,
      'descriptionCommande': descriptionCommande,
      'statutCommande': statutCommande,
      'statutCommandeLivrer': statutCommandeLivrer,
      'statutConfirmation': statutConfirmation,
      'dateCommande': dateCommande,
      'codeProduit': codeProduit,
      'quantiteDemande': quantiteDemande,
      'quantiteLivree': quantiteLivree,
      'quantiteNonLivree': quantiteNonLivree,
      'nomProduit': nomProduit,
      'codeAcheteur': codeAcheteur,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'acteur': acteur.toMap(),
      'stock': stock.map((x) => x.toMap()).toList(),
      'materielList': materielList.map((x) => x.toMap()).toList(),
    };
  }

  factory Commande.fromMap(Map<String, dynamic> map) {
    return Commande(
      idCommande: map['idCommande'] != null ? map['idCommande'] as String : null,
      codeCommande: map['codeCommande'] as String,
      descriptionCommande: map['descriptionCommande'] as String,
      statutCommande: map['statutCommande'] as bool,
      statutCommandeLivrer: map['statutCommandeLivrer'] as bool,
      statutConfirmation: map['statutConfirmation'] as bool,
      dateCommande: map['dateCommande'] != null ? map['dateCommande'] as String : null,
      codeProduit: map['codeProduit'] as String,
      quantiteDemande: map['quantiteDemande'] != null ? map['quantiteDemande'] as int : null,
      quantiteLivree: map['quantiteLivree'] != null ? map['quantiteLivree'] as int : null,
      quantiteNonLivree: map['quantiteNonLivree'] != null ? map['quantiteNonLivree'] as int : null,
      nomProduit: map['nomProduit'] as String,
      codeAcheteur: map['codeAcheteur'] as String,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
      stock: List<Stock>.from((map['stock'] as List<int>).map<Stock>((x) => Stock.fromMap(x as Map<String,dynamic>),),),
      materielList: List<Materiel>.from((map['materielList'] as List<int>).map<Materiel>((x) => Materiel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Commande.fromJson(String source) => Commande.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Commande(idCommande: $idCommande, codeCommande: $codeCommande, descriptionCommande: $descriptionCommande, statutCommande: $statutCommande, statutCommandeLivrer: $statutCommandeLivrer, statutConfirmation: $statutConfirmation, dateCommande: $dateCommande, codeProduit: $codeProduit, quantiteDemande: $quantiteDemande, quantiteLivree: $quantiteLivree, quantiteNonLivree: $quantiteNonLivree, nomProduit: $nomProduit, codeAcheteur: $codeAcheteur, dateAjout: $dateAjout, dateModif: $dateModif, acteur: $acteur, stock: $stock, materielList: $materielList)';
  }

  @override
  bool operator ==(covariant Commande other) {
    if (identical(this, other)) return true;
  
    return 
      other.idCommande == idCommande &&
      other.codeCommande == codeCommande &&
      other.descriptionCommande == descriptionCommande &&
      other.statutCommande == statutCommande &&
      other.statutCommandeLivrer == statutCommandeLivrer &&
      other.statutConfirmation == statutConfirmation &&
      other.dateCommande == dateCommande &&
      other.codeProduit == codeProduit &&
      other.quantiteDemande == quantiteDemande &&
      other.quantiteLivree == quantiteLivree &&
      other.quantiteNonLivree == quantiteNonLivree &&
      other.nomProduit == nomProduit &&
      other.codeAcheteur == codeAcheteur &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.acteur == acteur &&
      listEquals(other.stock, stock) &&
      listEquals(other.materielList, materielList);
  }

  @override
  int get hashCode {
    return idCommande.hashCode ^
      codeCommande.hashCode ^
      descriptionCommande.hashCode ^
      statutCommande.hashCode ^
      statutCommandeLivrer.hashCode ^
      statutConfirmation.hashCode ^
      dateCommande.hashCode ^
      codeProduit.hashCode ^
      quantiteDemande.hashCode ^
      quantiteLivree.hashCode ^
      quantiteNonLivree.hashCode ^
      nomProduit.hashCode ^
      codeAcheteur.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      acteur.hashCode ^
      stock.hashCode ^
      materielList.hashCode;
  }
}
