import 'dart:convert';

import 'package:meta/meta.dart';

import 'package:koumi_app/models/Acteur.dart';

class TypeActeur {
  final String? idVehicule;
  final String nomVehicule;
  final String capaciteVehicule;
  final bool statutVehicule;
  final String? photoVehicule;
  final String? dateAjout;
  final String? dateModif;
  final String? personneModif;
  final Acteur acteur;

  TypeActeur({
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

  TypeActeur copyWith({
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
    return TypeActeur(
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

  factory TypeActeur.fromMap(Map<String, dynamic> map) {
    return TypeActeur(
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

  factory TypeActeur.fromJson(String source) => TypeActeur.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TypeActeur(idVehicule: $idVehicule, nomVehicule: $nomVehicule, capaciteVehicule: $capaciteVehicule, statutVehicule: $statutVehicule, photoVehicule: $photoVehicule, dateAjout: $dateAjout, dateModif: $dateModif, personneModif: $personneModif, acteur: $acteur)';
  }

  @override
  bool operator ==(covariant TypeActeur other) {
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
