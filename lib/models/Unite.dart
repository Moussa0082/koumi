import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';

class Unite {
  final String? idUnite;
  final String codeUnite;
  final String nomUnite;
  final String? dateAjout;
  final String? dateModif;
  final bool statutUnite;
  final String personneModif;
  final Acteur acteur;

  Unite({
    this.idUnite,
    required this.codeUnite,
    required this.nomUnite,
    this.dateAjout,
    this.dateModif,
    required this.statutUnite,
    required this.personneModif,
    required this.acteur,
  });

  Unite copyWith({
    String? idUnite,
    String? codeUnite,
    String? nomUnite,
    String? dateAjout,
    String? dateModif,
    bool? statutUnite,
    String? personneModif,
    Acteur? acteur,
  }) {
    return Unite(
      idUnite: idUnite ?? this.idUnite,
      codeUnite: codeUnite ?? this.codeUnite,
      nomUnite: nomUnite ?? this.nomUnite,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      statutUnite: statutUnite ?? this.statutUnite,
      personneModif: personneModif ?? this.personneModif,
      acteur: acteur ?? this.acteur,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idUnite': idUnite,
      'codeUnite': codeUnite,
      'nomUnite': nomUnite,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'statutUnite': statutUnite,
      'personneModif': personneModif,
      'acteur': acteur.toMap(),
    };
  }

  factory Unite.fromMap(Map<String, dynamic> map) {
    return Unite(
      idUnite: map['idUnite'] != null ? map['idUnite'] as String : null,
      codeUnite: map['codeUnite'] as String,
      nomUnite: map['nomUnite'] as String,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      statutUnite: map['statutUnite'] as bool,
      personneModif: map['personneModif'] as String,
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Unite.fromJson(String source) => Unite.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Unite(idUnite: $idUnite, codeUnite: $codeUnite, nomUnite: $nomUnite, dateAjout: $dateAjout, dateModif: $dateModif, statutUnite: $statutUnite, personneModif: $personneModif, acteur: $acteur)';
  }

  @override
  bool operator ==(covariant Unite other) {
    if (identical(this, other)) return true;
  
    return 
      other.idUnite == idUnite &&
      other.codeUnite == codeUnite &&
      other.nomUnite == nomUnite &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.statutUnite == statutUnite &&
      other.personneModif == personneModif &&
      other.acteur == acteur;
  }

  @override
  int get hashCode {
    return idUnite.hashCode ^
      codeUnite.hashCode ^
      nomUnite.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      statutUnite.hashCode ^
      personneModif.hashCode ^
      acteur.hashCode;
  }
}
