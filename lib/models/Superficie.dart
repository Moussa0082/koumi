// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Campagne.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/models/Speculation.dart';

class Superficie {
  final String? idSuperficie;
  final String codeSuperficie;
  final String localite;
  final String personneModif;
  final String superficieHa;
  final bool statutSuperficie;
  final String? dateSemi;
  final String? dateAjout;
  final String? dateModif;
  final Acteur acteur;
  final List<Intrant> intrants;
  final Speculation speculation;
  final Campagne campagne;
  Superficie({
    this.idSuperficie,
    required this.codeSuperficie,
    required this.localite,
    required this.personneModif,
    required this.superficieHa,
    required this.statutSuperficie,
    this.dateSemi,
    this.dateAjout,
    this.dateModif,
    required this.acteur,
    required this.intrants,
    required this.speculation,
    required this.campagne,
  });

  Superficie copyWith({
    String? idSuperficie,
    String? codeSuperficie,
    String? localite,
    String? personneModif,
    String? superficieHa,
    bool? statutSuperficie,
    String? dateSemi,
    String? dateAjout,
    String? dateModif,
    Acteur? acteur,
    List<Intrant>? intrants,
    Speculation? speculation,
    Campagne? campagne,
  }) {
    return Superficie(
      idSuperficie: idSuperficie ?? this.idSuperficie,
      codeSuperficie: codeSuperficie ?? this.codeSuperficie,
      localite: localite ?? this.localite,
      personneModif: personneModif ?? this.personneModif,
      superficieHa: superficieHa ?? this.superficieHa,
      statutSuperficie: statutSuperficie ?? this.statutSuperficie,
      dateSemi: dateSemi ?? this.dateSemi,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      acteur: acteur ?? this.acteur,
      intrants: intrants ?? this.intrants,
      speculation: speculation ?? this.speculation,
      campagne: campagne ?? this.campagne,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idSuperficie': idSuperficie,
      'codeSuperficie': codeSuperficie,
      'localite': localite,
      'personneModif': personneModif,
      'superficieHa': superficieHa,
      'statutSuperficie': statutSuperficie,
      'dateSemi': dateSemi,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'acteur': acteur.toMap(),
      'intrants': intrants.map((x) => x.toMap()).toList(),
      'speculation': speculation.toMap(),
      'campagne': campagne.toMap(),
    };
  }

  factory Superficie.fromMap(Map<String, dynamic> map) {
    return Superficie(
      idSuperficie: map['idSuperficie'] != null ? map['idSuperficie'] as String : null,
      codeSuperficie: map['codeSuperficie'] as String,
      localite: map['localite'] as String,
      personneModif: map['personneModif'] as String,
      superficieHa: map['superficieHa'] as String,
      statutSuperficie: map['statutSuperficie'] as bool,
      dateSemi: map['dateSemi'] != null ? map['dateSemi'] as String : null,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
      intrants: List<Intrant>.from((map['intrants'] as List<int>).map<Intrant>((x) => Intrant.fromMap(x as Map<String,dynamic>),),),
      speculation: Speculation.fromMap(map['speculation'] as Map<String,dynamic>),
      campagne: Campagne.fromMap(map['campagne'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Superficie.fromJson(String source) => Superficie.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Superficie(idSuperficie: $idSuperficie, codeSuperficie: $codeSuperficie, localite: $localite, personneModif: $personneModif, superficieHa: $superficieHa, statutSuperficie: $statutSuperficie, dateSemi: $dateSemi, dateAjout: $dateAjout, dateModif: $dateModif, acteur: $acteur, intrants: $intrants, speculation: $speculation, campagne: $campagne)';
  }

  @override
  bool operator ==(covariant Superficie other) {
    if (identical(this, other)) return true;
  
    return 
      other.idSuperficie == idSuperficie &&
      other.codeSuperficie == codeSuperficie &&
      other.localite == localite &&
      other.personneModif == personneModif &&
      other.superficieHa == superficieHa &&
      other.statutSuperficie == statutSuperficie &&
      other.dateSemi == dateSemi &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.acteur == acteur &&
      listEquals(other.intrants, intrants) &&
      other.speculation == speculation &&
      other.campagne == campagne;
  }

  @override
  int get hashCode {
    return idSuperficie.hashCode ^
      codeSuperficie.hashCode ^
      localite.hashCode ^
      personneModif.hashCode ^
      superficieHa.hashCode ^
      statutSuperficie.hashCode ^
      dateSemi.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      acteur.hashCode ^
      intrants.hashCode ^
      speculation.hashCode ^
      campagne.hashCode;
  }
}
