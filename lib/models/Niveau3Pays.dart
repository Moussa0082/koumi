// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:koumi_app/models/Niveau2Pays.dart';

class Niveau3Pays {
  final String? idNiveau3Pays;
  final String codeN3;
  final String nomN3;
  final String descriptionN3;
  final bool statutN3;
  final String? dateAjout;
  final String? dateModif;
  final String? personneModif;
  final Niveau2Pays niveau2Pays;
  
  Niveau3Pays({
    this.idNiveau3Pays,
    required this.codeN3,
    required this.nomN3,
    required this.descriptionN3,
    required this.statutN3,
    this.dateAjout,
    this.dateModif,
    this.personneModif,
    required this.niveau2Pays,
  });
  
 

  Niveau3Pays copyWith({
    String? idNiveau3Pays,
    String? codeN3,
    String? nomN3,
    String? descriptionN3,
    bool? statutN3,
    String? dateAjout,
    String? dateModif,
    String? personneModif,
    Niveau2Pays? niveau2Pays,
  }) {
    return Niveau3Pays(
      idNiveau3Pays: idNiveau3Pays ?? this.idNiveau3Pays,
      codeN3: codeN3 ?? this.codeN3,
      nomN3: nomN3 ?? this.nomN3,
      descriptionN3: descriptionN3 ?? this.descriptionN3,
      statutN3: statutN3 ?? this.statutN3,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      personneModif: personneModif ?? this.personneModif,
      niveau2Pays: niveau2Pays ?? this.niveau2Pays,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idNiveau3Pays': idNiveau3Pays,
      'codeN3': codeN3,
      'nomN3': nomN3,
      'descriptionN3': descriptionN3,
      'statutN3': statutN3,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'personneModif': personneModif,
      'niveau2Pays': niveau2Pays.toMap(),
    };
  }

  factory Niveau3Pays.fromMap(Map<String, dynamic> map) {
    return Niveau3Pays(
      idNiveau3Pays: map['idNiveau3Pays'] != null ? map['idNiveau3Pays'] as String : null,
      codeN3: map['codeN3'] as String,
      nomN3: map['nomN3'] as String,
      descriptionN3: map['descriptionN3'] as String,
      statutN3: map['statutN3'] as bool,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      personneModif: map['personneModif'] != null ? map['personneModif'] as String : null,
      niveau2Pays: Niveau2Pays.fromMap(map['niveau2Pays'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Niveau3Pays.fromJson(String source) => Niveau3Pays.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Niveau3Pays(idNiveau3Pays: $idNiveau3Pays, codeN3: $codeN3, nomN3: $nomN3, descriptionN3: $descriptionN3, statutN3: $statutN3, dateAjout: $dateAjout, dateModif: $dateModif, personneModif: $personneModif, niveau2Pays: $niveau2Pays)';
  }

  @override
  bool operator ==(covariant Niveau3Pays other) {
    if (identical(this, other)) return true;
  
    return 
      other.idNiveau3Pays == idNiveau3Pays &&
      other.codeN3 == codeN3 &&
      other.nomN3 == nomN3 &&
      other.descriptionN3 == descriptionN3 &&
      other.statutN3 == statutN3 &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.personneModif == personneModif &&
      other.niveau2Pays == niveau2Pays;
  }

  @override
  int get hashCode {
    return idNiveau3Pays.hashCode ^
      codeN3.hashCode ^
      nomN3.hashCode ^
      descriptionN3.hashCode ^
      statutN3.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      personneModif.hashCode ^
      niveau2Pays.hashCode;
  }
}
