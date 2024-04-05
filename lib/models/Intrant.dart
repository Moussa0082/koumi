// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/Superficie.dart';

class Intrant {
  final String? idIntrant;
  final String nomIntrant;
  final double quantiteIntrant;
  final int prixIntrant;
  final String? codeIntrant;
  final String descriptionIntrant;
  final String? photoIntrant;
  final bool? statutIntrant;
  final String? dateExpiration;
  final String? dateAjout;
  final String? dateModif;
  final String? personneModif;
  final Acteur acteur;
  final Speculation? speculation;
  Intrant({
    this.idIntrant,
    required this.nomIntrant,
    required this.quantiteIntrant,
    required this.prixIntrant,
    this.codeIntrant,
    required this.descriptionIntrant,
    this.photoIntrant,
    this.statutIntrant,
    this.dateExpiration,
    this.dateAjout,
    this.dateModif,
    this.personneModif,
    required this.acteur,
    this.speculation,
  });

 

  Intrant copyWith({
    String? idIntrant,
    String? nomIntrant,
    double? quantiteIntrant,
    int? prixIntrant,
    String? codeIntrant,
    String? descriptionIntrant,
    String? photoIntrant,
    bool? statutIntrant,
    String? dateExpiration,
    String? dateAjout,
    String? dateModif,
    String? personneModif,
    Acteur? acteur,
    Speculation? speculation,
  }) {
    return Intrant(
      idIntrant: idIntrant ?? this.idIntrant,
      nomIntrant: nomIntrant ?? this.nomIntrant,
      quantiteIntrant: quantiteIntrant ?? this.quantiteIntrant,
      prixIntrant: prixIntrant ?? this.prixIntrant,
      codeIntrant: codeIntrant ?? this.codeIntrant,
      descriptionIntrant: descriptionIntrant ?? this.descriptionIntrant,
      photoIntrant: photoIntrant ?? this.photoIntrant,
      statutIntrant: statutIntrant ?? this.statutIntrant,
      dateExpiration: dateExpiration ?? this.dateExpiration,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      personneModif: personneModif ?? this.personneModif,
      acteur: acteur ?? this.acteur,
      speculation: speculation ?? this.speculation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idIntrant': idIntrant,
      'nomIntrant': nomIntrant,
      'quantiteIntrant': quantiteIntrant,
      'prixIntrant': prixIntrant,
      'codeIntrant': codeIntrant,
      'descriptionIntrant': descriptionIntrant,
      'photoIntrant': photoIntrant,
      'statutIntrant': statutIntrant,
      'dateExpiration': dateExpiration,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'personneModif': personneModif,
      'acteur': acteur.toMap(),
      'speculation': speculation?.toMap(),
    };
  }

  factory Intrant.fromMap(Map<String, dynamic> map) {
    return Intrant(
      idIntrant: map['idIntrant'] != null ? map['idIntrant'] as String : null,
      nomIntrant: map['nomIntrant'] as String,
      quantiteIntrant: map['quantiteIntrant'] as double,
      prixIntrant: map['prixIntrant'] as int,
      codeIntrant: map['codeIntrant'] != null ? map['codeIntrant'] as String : null,
      descriptionIntrant: map['descriptionIntrant'] as String,
      photoIntrant: map['photoIntrant'] != null ? map['photoIntrant'] as String : null,
      statutIntrant: map['statutIntrant'] != null ? map['statutIntrant'] as bool : null,
      dateExpiration: map['dateExpiration'] != null ? map['dateExpiration'] as String : null,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      personneModif: map['personneModif'] != null ? map['personneModif'] as String : null,
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
      speculation: map['speculation'] != null ? Speculation.fromMap(map['speculation'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Intrant.fromJson(String source) => Intrant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Intrant(idIntrant: $idIntrant, nomIntrant: $nomIntrant, quantiteIntrant: $quantiteIntrant, prixIntrant: $prixIntrant, codeIntrant: $codeIntrant, descriptionIntrant: $descriptionIntrant, photoIntrant: $photoIntrant, statutIntrant: $statutIntrant, dateExpiration: $dateExpiration, dateAjout: $dateAjout, dateModif: $dateModif, personneModif: $personneModif, acteur: $acteur, speculation: $speculation)';
  }

  @override
  bool operator ==(covariant Intrant other) {
    if (identical(this, other)) return true;
  
    return 
      other.idIntrant == idIntrant &&
      other.nomIntrant == nomIntrant &&
      other.quantiteIntrant == quantiteIntrant &&
      other.prixIntrant == prixIntrant &&
      other.codeIntrant == codeIntrant &&
      other.descriptionIntrant == descriptionIntrant &&
      other.photoIntrant == photoIntrant &&
      other.statutIntrant == statutIntrant &&
      other.dateExpiration == dateExpiration &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.personneModif == personneModif &&
      other.acteur == acteur &&
      other.speculation == speculation;
  }

  @override
  int get hashCode {
    return idIntrant.hashCode ^
      nomIntrant.hashCode ^
      quantiteIntrant.hashCode ^
      prixIntrant.hashCode ^
      codeIntrant.hashCode ^
      descriptionIntrant.hashCode ^
      photoIntrant.hashCode ^
      statutIntrant.hashCode ^
      dateExpiration.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      personneModif.hashCode ^
      acteur.hashCode ^
      speculation.hashCode;
  }
}
