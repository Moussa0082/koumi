import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Superficie.dart';

class Intrant {
  final String? idIntrant;
  final String nomIntrant;
  final int quantiteIntrant;
  final String condeIntrant;
  final String descriptionIntrant;
  final String? photoIntrant;
  final bool statutIntrant;
  final String? dateAjout;
  final String? dateModif;
  final String? personneModif;
  final Acteur acteur;
  final Superficie superficie;
  Intrant({
    this.idIntrant,
    required this.nomIntrant,
    required this.quantiteIntrant,
    required this.condeIntrant,
    required this.descriptionIntrant,
    this.photoIntrant,
    required this.statutIntrant,
    this.dateAjout,
    this.dateModif,
    this.personneModif,
    required this.acteur,
    required this.superficie,
  });

  Intrant copyWith({
    String? idIntrant,
    String? nomIntrant,
    int? quantiteIntrant,
    String? condeIntrant,
    String? descriptionIntrant,
    String? photoIntrant,
    bool? statutIntrant,
    String? dateAjout,
    String? dateModif,
    String? personneModif,
    Acteur? acteur,
    Superficie? superficie,
  }) {
    return Intrant(
      idIntrant: idIntrant ?? this.idIntrant,
      nomIntrant: nomIntrant ?? this.nomIntrant,
      quantiteIntrant: quantiteIntrant ?? this.quantiteIntrant,
      condeIntrant: condeIntrant ?? this.condeIntrant,
      descriptionIntrant: descriptionIntrant ?? this.descriptionIntrant,
      photoIntrant: photoIntrant ?? this.photoIntrant,
      statutIntrant: statutIntrant ?? this.statutIntrant,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      personneModif: personneModif ?? this.personneModif,
      acteur: acteur ?? this.acteur,
      superficie: superficie ?? this.superficie,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idIntrant': idIntrant,
      'nomIntrant': nomIntrant,
      'quantiteIntrant': quantiteIntrant,
      'condeIntrant': condeIntrant,
      'descriptionIntrant': descriptionIntrant,
      'photoIntrant': photoIntrant,
      'statutIntrant': statutIntrant,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'personneModif': personneModif,
      'acteur': acteur.toMap(),
      'superficie': superficie.toMap(),
    };
  }

  factory Intrant.fromMap(Map<String, dynamic> map) {
    return Intrant(
      idIntrant: map['idIntrant'] != null ? map['idIntrant'] as String : null,
      nomIntrant: map['nomIntrant'] as String,
      quantiteIntrant: map['quantiteIntrant'] as int,
      condeIntrant: map['condeIntrant'] as String,
      descriptionIntrant: map['descriptionIntrant'] as String,
      photoIntrant: map['photoIntrant'] != null ? map['photoIntrant'] as String : null,
      statutIntrant: map['statutIntrant'] as bool,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      personneModif: map['personneModif'] != null ? map['personneModif'] as String : null,
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
      superficie: Superficie.fromMap(map['superficie'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Intrant.fromJson(String source) => Intrant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Intrant(idIntrant: $idIntrant, nomIntrant: $nomIntrant, quantiteIntrant: $quantiteIntrant, condeIntrant: $condeIntrant, descriptionIntrant: $descriptionIntrant, photoIntrant: $photoIntrant, statutIntrant: $statutIntrant, dateAjout: $dateAjout, dateModif: $dateModif, personneModif: $personneModif, acteur: $acteur, superficie: $superficie)';
  }

  @override
  bool operator ==(covariant Intrant other) {
    if (identical(this, other)) return true;
  
    return 
      other.idIntrant == idIntrant &&
      other.nomIntrant == nomIntrant &&
      other.quantiteIntrant == quantiteIntrant &&
      other.condeIntrant == condeIntrant &&
      other.descriptionIntrant == descriptionIntrant &&
      other.photoIntrant == photoIntrant &&
      other.statutIntrant == statutIntrant &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.personneModif == personneModif &&
      other.acteur == acteur &&
      other.superficie == superficie;
  }

  @override
  int get hashCode {
    return idIntrant.hashCode ^
      nomIntrant.hashCode ^
      quantiteIntrant.hashCode ^
      condeIntrant.hashCode ^
      descriptionIntrant.hashCode ^
      photoIntrant.hashCode ^
      statutIntrant.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      personneModif.hashCode ^
      acteur.hashCode ^
      superficie.hashCode;
  }
}
