// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeVoiture.dart';

class Vehicule {
  String? idVehicule;
  String nomVehicule;
  String capaciteVehicule;
  String? codeVehicule;
  Map<String, int> prixParDestination;
  bool statutVehicule;
  String? photoVehicule;
  String localisation;
  String? dateAjout;
  String? dateModif;
  String etatVehicule;
  String? personneModif;
  Acteur acteur;
  TypeVoiture typeVoiture;

  Vehicule({
    this.idVehicule,
    required this.nomVehicule,
    required this.capaciteVehicule,
    this.codeVehicule,
    required this.prixParDestination,
    required this.statutVehicule,
    this.photoVehicule,
    required this.localisation,
    this.dateAjout,
    this.dateModif,
    required this.etatVehicule,
    this.personneModif,
    required this.acteur,
    required this.typeVoiture,
  });
  

  Vehicule copyWith({
    String? idVehicule,
    String? nomVehicule,
    String? capaciteVehicule,
    String? codeVehicule,
    Map<String, int>? prixParDestination,
    bool? statutVehicule,
    String? photoVehicule,
    String? localisation,
    String? dateAjout,
    String? dateModif,
    String? etatVehicule,
    String? personneModif,
    Acteur? acteur,
    TypeVoiture? typeVoiture,
  }) {
    return Vehicule(
      idVehicule: idVehicule ?? this.idVehicule,
      nomVehicule: nomVehicule ?? this.nomVehicule,
      capaciteVehicule: capaciteVehicule ?? this.capaciteVehicule,
      codeVehicule: codeVehicule ?? this.codeVehicule,
      prixParDestination: prixParDestination ?? this.prixParDestination,
      statutVehicule: statutVehicule ?? this.statutVehicule,
      photoVehicule: photoVehicule ?? this.photoVehicule,
      localisation: localisation ?? this.localisation,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      etatVehicule: etatVehicule ?? this.etatVehicule,
      personneModif: personneModif ?? this.personneModif,
      acteur: acteur ?? this.acteur,
      typeVoiture: typeVoiture ?? this.typeVoiture,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idVehicule': idVehicule,
      'nomVehicule': nomVehicule,
      'capaciteVehicule': capaciteVehicule,
      'codeVehicule': codeVehicule,
      'prixParDestination': prixParDestination,
      'statutVehicule': statutVehicule,
      'photoVehicule': photoVehicule,
      'localisation': localisation,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'etatVehicule': etatVehicule,
      'personneModif': personneModif,
      'acteur': acteur.toMap(),
      'typeVoiture': typeVoiture.toMap(),
    };
  }

  factory Vehicule.fromMap(Map<String, dynamic> map) {
    return Vehicule(
      idVehicule:
          map['idVehicule'] != null ? map['idVehicule'] as String : null,
      nomVehicule: map['nomVehicule'] as String,
      capaciteVehicule: map['capaciteVehicule'] as String,
      codeVehicule:
          map['codeVehicule'] != null ? map['codeVehicule'] as String : null,
      prixParDestination: Map<String, int>.from(
          map['prixParDestination'] as Map<String, dynamic>),
      statutVehicule: map['statutVehicule'] as bool,
      photoVehicule:
          map['photoVehicule'] != null ? map['photoVehicule'] as String : null,
      localisation: map['localisation'] as String,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      etatVehicule: map['etatVehicule'] as String,
      personneModif:
          map['personneModif'] != null ? map['personneModif'] as String : null,
      acteur: Acteur.fromMap(map['acteur'] as Map<String, dynamic>),
      typeVoiture:
          TypeVoiture.fromMap(map['typeVoiture'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Vehicule.fromJson(String source) => Vehicule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Vehicule(idVehicule: $idVehicule, nomVehicule: $nomVehicule, capaciteVehicule: $capaciteVehicule, codeVehicule: $codeVehicule, prixParDestination: $prixParDestination, statutVehicule: $statutVehicule, photoVehicule: $photoVehicule, localisation: $localisation, dateAjout: $dateAjout, dateModif: $dateModif, etatVehicule: $etatVehicule, personneModif: $personneModif, acteur: $acteur, typeVoiture: $typeVoiture)';
  }

  @override
  bool operator ==(covariant Vehicule other) {
    if (identical(this, other)) return true;
  
    return
      other.idVehicule == idVehicule &&
      other.nomVehicule == nomVehicule &&
      other.capaciteVehicule == capaciteVehicule &&
      other.codeVehicule == codeVehicule &&
      mapEquals(other.prixParDestination, prixParDestination) &&
      other.statutVehicule == statutVehicule &&
      other.photoVehicule == photoVehicule &&
      other.localisation == localisation &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.etatVehicule == etatVehicule &&
      other.personneModif == personneModif &&
      other.acteur == acteur &&
      other.typeVoiture == typeVoiture;
  }

  @override
  int get hashCode {
    return idVehicule.hashCode ^
      nomVehicule.hashCode ^
      capaciteVehicule.hashCode ^
      codeVehicule.hashCode ^
      prixParDestination.hashCode ^
      statutVehicule.hashCode ^
      photoVehicule.hashCode ^
      localisation.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      etatVehicule.hashCode ^
      personneModif.hashCode ^
      acteur.hashCode ^
      typeVoiture.hashCode;
  }
}
