// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';

class Vehicule {
  final String idVehicule;
  final String nomVehicule;
  final String capaciteVehicule;
  final String codeVehicule;
  final int prix;
  final bool statutVehicule;
  final String? photoVehicule;
  final String localisation;
  final String description;
  final String? dateAjout;
  final String? dateModif;
  final String etatVehicule;
  final String? personneModif;
  final Acteur acteur;
  Vehicule({
    required this.idVehicule,
    required this.nomVehicule,
    required this.capaciteVehicule,
    required this.codeVehicule,
    required this.prix,
    required this.statutVehicule,
    this.photoVehicule,
    required this.localisation,
    required this.description,
    this.dateAjout,
    this.dateModif,
    required this.etatVehicule,
    this.personneModif,
    required this.acteur,
  });

  Vehicule copyWith({
    String? idVehicule,
    String? nomVehicule,
    String? capaciteVehicule,
    String? codeVehicule,
    int? prix,
    bool? statutVehicule,
    String? photoVehicule,
    String? localisation,
    String? description,
    String? dateAjout,
    String? dateModif,
    String? etatVehicule,
    String? personneModif,
    Acteur? acteur,
  }) {
    return Vehicule(
      idVehicule: idVehicule ?? this.idVehicule,
      nomVehicule: nomVehicule ?? this.nomVehicule,
      capaciteVehicule: capaciteVehicule ?? this.capaciteVehicule,
      codeVehicule: codeVehicule ?? this.codeVehicule,
      prix: prix ?? this.prix,
      statutVehicule: statutVehicule ?? this.statutVehicule,
      photoVehicule: photoVehicule ?? this.photoVehicule,
      localisation: localisation ?? this.localisation,
      description: description ?? this.description,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      etatVehicule: etatVehicule ?? this.etatVehicule,
      personneModif: personneModif ?? this.personneModif,
      acteur: acteur ?? this.acteur,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idVehicule': idVehicule,
      'nomVehicule': nomVehicule,
      'capaciteVehicule': capaciteVehicule,
      'codeVehicule': codeVehicule,
      'prix': prix,
      'statutVehicule': statutVehicule,
      'photoVehicule': photoVehicule,
      'localisation': localisation,
      'description': description,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'etatVehicule': etatVehicule,
      'personneModif': personneModif,
      'acteur': acteur.toMap(),
    };
  }

  factory Vehicule.fromMap(Map<String, dynamic> map) {
    return Vehicule(
      idVehicule: map['idVehicule'] as String,
      nomVehicule: map['nomVehicule'] as String,
      capaciteVehicule: map['capaciteVehicule'] as String,
      codeVehicule: map['codeVehicule'] as String,
      prix: map['prix'] as int,
      statutVehicule: map['statutVehicule'] as bool,
      photoVehicule: map['photoVehicule'] != null ? map['photoVehicule'] as String : null,
      localisation: map['localisation'] as String,
      description: map['description'] as String,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      etatVehicule: map['etatVehicule'] as String,
      personneModif: map['personneModif'] != null ? map['personneModif'] as String : null,
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Vehicule.fromJson(String source) => Vehicule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Vehicule(idVehicule: $idVehicule, nomVehicule: $nomVehicule, capaciteVehicule: $capaciteVehicule, codeVehicule: $codeVehicule, prix: $prix, statutVehicule: $statutVehicule, photoVehicule: $photoVehicule, localisation: $localisation, description: $description, dateAjout: $dateAjout, dateModif: $dateModif, etatVehicule: $etatVehicule, personneModif: $personneModif, acteur: $acteur)';
  }

  @override
  bool operator ==(covariant Vehicule other) {
    if (identical(this, other)) return true;
  
    return 
      other.idVehicule == idVehicule &&
      other.nomVehicule == nomVehicule &&
      other.capaciteVehicule == capaciteVehicule &&
      other.codeVehicule == codeVehicule &&
      other.prix == prix &&
      other.statutVehicule == statutVehicule &&
      other.photoVehicule == photoVehicule &&
      other.localisation == localisation &&
      other.description == description &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.etatVehicule == etatVehicule &&
      other.personneModif == personneModif &&
      other.acteur == acteur;
  }

  @override
  int get hashCode {
    return idVehicule.hashCode ^
      nomVehicule.hashCode ^
      capaciteVehicule.hashCode ^
      codeVehicule.hashCode ^
      prix.hashCode ^
      statutVehicule.hashCode ^
      photoVehicule.hashCode ^
      localisation.hashCode ^
      description.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      etatVehicule.hashCode ^
      personneModif.hashCode ^
      acteur.hashCode;
  }
}
