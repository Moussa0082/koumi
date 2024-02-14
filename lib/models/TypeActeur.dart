// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TypeActeur {
  final String? idTypeActeur;
  final String libelle;
  final String codeTypeActeur;
  final bool    statutTypeActeur;
  final String descriptionTypeActeur;
  final String? dateAjout;
  final String? dateModif;
  final String? personneModif;
  TypeActeur({
    this.idTypeActeur,
    required this.libelle,
    required this.codeTypeActeur,
    required this.statutTypeActeur,
    required this.descriptionTypeActeur,
    this.dateAjout,
    this.dateModif,
    this.personneModif,
  });
  

  TypeActeur copyWith({
    String? idTypeActeur,
    String? libelle,
    String? codeTypeActeur,
    bool? statutTypeActeur,
    String? descriptionTypeActeur,
    String? dateAjout,
    String? dateModif,
    String? personneModif,
  }) {
    return TypeActeur(
      idTypeActeur: idTypeActeur ?? this.idTypeActeur,
      libelle: libelle ?? this.libelle,
      codeTypeActeur: codeTypeActeur ?? this.codeTypeActeur,
      statutTypeActeur: statutTypeActeur ?? this.statutTypeActeur,
      descriptionTypeActeur: descriptionTypeActeur ?? this.descriptionTypeActeur,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      personneModif: personneModif ?? this.personneModif,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idTypeActeur': idTypeActeur,
      'libelle': libelle,
      'codeTypeActeur': codeTypeActeur,
      'statutTypeActeur': statutTypeActeur,
      'descriptionTypeActeur': descriptionTypeActeur,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'personneModif': personneModif,
    };
  }

  factory TypeActeur.fromMap(Map<String, dynamic> map) {
    return TypeActeur(
      idTypeActeur: map['idTypeActeur'] != null ? map['idTypeActeur'] as String : null,
      libelle: map['libelle'] as String,
      codeTypeActeur: map['codeTypeActeur'] as String,
      statutTypeActeur: map['statutTypeActeur'] as bool,
      descriptionTypeActeur: map['descriptionTypeActeur'] as String,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      personneModif: map['personneModif'] != null ? map['personneModif'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeActeur.fromJson(String source) => TypeActeur.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TypeActeur(idTypeActeur: $idTypeActeur, libelle: $libelle, codeTypeActeur: $codeTypeActeur, statutTypeActeur: $statutTypeActeur, descriptionTypeActeur: $descriptionTypeActeur, dateAjout: $dateAjout, dateModif: $dateModif, personneModif: $personneModif)';
  }

  @override
  bool operator ==(covariant TypeActeur other) {
    if (identical(this, other)) return true;
  
    return 
      other.idTypeActeur == idTypeActeur &&
      other.libelle == libelle &&
      other.codeTypeActeur == codeTypeActeur &&
      other.statutTypeActeur == statutTypeActeur &&
      other.descriptionTypeActeur == descriptionTypeActeur &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.personneModif == personneModif;
  }

  @override
  int get hashCode {
    return idTypeActeur.hashCode ^
      libelle.hashCode ^
      codeTypeActeur.hashCode ^
      statutTypeActeur.hashCode ^
      descriptionTypeActeur.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      personneModif.hashCode;
  }
}
