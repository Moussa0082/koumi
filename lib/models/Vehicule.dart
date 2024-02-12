// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';

class Vehicule {
  final String? idVehicule;
  final String nomVehicule;
  final String capaciteVehicule;
  final bool statutVehicule;
  final String? photoVehicule;
  final String? dateAjout;
  final String? dateModif;
  final String? personneModif;
  final Acteur acteur;
  
  Vehicule({
    this.idVehicule,
    required this.nomVehicule,
    required this.capaciteVehicule,
    required this.statutVehicule,
    this.photoVehicule,
    this.dateAjout,
    this.dateModif,
    this.personneModif,
    required this.acteur,
  });

  Vehicule copyWith({
    String? idVehicule,
    String? nomVehicule,
    String? capaciteVehicule,
    bool? statutVehicule,
    String? photoVehicule,
    String? dateAjout,
    String? dateModif,
    String? personneModif,
    Acteur? acteur,
  }) {
    return Vehicule(
      idVehicule: idVehicule ?? this.idVehicule,
      nomVehicule: nomVehicule ?? this.nomVehicule,
      capaciteVehicule: capaciteVehicule ?? this.capaciteVehicule,
      statutVehicule: statutVehicule ?? this.statutVehicule,
      photoVehicule: photoVehicule ?? this.photoVehicule,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      personneModif: personneModif ?? this.personneModif,
      acteur: acteur ?? this.acteur,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idVehicule': idVehicule,
      'nomVehicule': nomVehicule,
      'capaciteVehicule': capaciteVehicule,
      'statutVehicule': statutVehicule,
      'photoVehicule': photoVehicule,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'personneModif': personneModif,
      'acteur': acteur.toMap(),
    };
  }

  factory Vehicule.fromMap(Map<String, dynamic> map) {
    return Vehicule(
      idVehicule: map['idVehicule'] != null ? map['idVehicule'] as String : null,
      nomVehicule: map['nomVehicule'] as String,
      capaciteVehicule: map['capaciteVehicule'] as String,
      statutVehicule: map['statutVehicule'] as bool,
      photoVehicule: map['photoVehicule'] != null ? map['photoVehicule'] as String : null,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      personneModif: map['personneModif'] != null ? map['personneModif'] as String : null,
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Vehicule.fromJson(String source) => Vehicule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Vehicule(idVehicule: $idVehicule, nomVehicule: $nomVehicule, capaciteVehicule: $capaciteVehicule, statutVehicule: $statutVehicule, photoVehicule: $photoVehicule, dateAjout: $dateAjout, dateModif: $dateModif, personneModif: $personneModif, acteur: $acteur)';
  }

  @override
  bool operator ==(covariant Vehicule other) {
    if (identical(this, other)) return true;
  
    return 
      other.idVehicule == idVehicule &&
      other.nomVehicule == nomVehicule &&
      other.capaciteVehicule == capaciteVehicule &&
      other.statutVehicule == statutVehicule &&
      other.photoVehicule == photoVehicule &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.personneModif == personneModif &&
      other.acteur == acteur;
  }

  @override
  int get hashCode {
    return idVehicule.hashCode ^
      nomVehicule.hashCode ^
      capaciteVehicule.hashCode ^
      statutVehicule.hashCode ^
      photoVehicule.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      personneModif.hashCode ^
      acteur.hashCode;
  }
}
