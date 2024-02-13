import 'dart:convert';

class TypeActeur {
  final String? idTypeActeur;
  final String libelle;
  final String codeTypeActeur;
  final bool    statutTypeActeur;
  final String descriptionTypeActeur;
  final String? dateAjout;
  final String? dateModif;
  TypeActeur({
    this.idTypeActeur,
    required this.libelle,
    required this.codeTypeActeur,
    required this.statutTypeActeur,
    required this.descriptionTypeActeur,
    this.dateAjout,
    this.dateModif,
  });

  TypeActeur copyWith({
    String? idTypeActeur,
    String? libelle,
    String? codeTypeActeur,
    bool? statutTypeActeur,
    String? descriptionTypeActeur,
    String? dateAjout,
    String? dateModif,
  }) {
    return TypeActeur(
      idTypeActeur: idTypeActeur ?? this.idTypeActeur,
      libelle: libelle ?? this.libelle,
      codeTypeActeur: codeTypeActeur ?? this.codeTypeActeur,
      statutTypeActeur: statutTypeActeur ?? this.statutTypeActeur,
      descriptionTypeActeur: descriptionTypeActeur ?? this.descriptionTypeActeur,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
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
    };
  }

  factory TypeActeur.fromMap(Map<String, dynamic> map) {
    return TypeActeur(
      idTypeActeur: map['idTypeActeur'],
      libelle: map['libelle'],
      codeTypeActeur: map['codeTypeActeur'],
      statutTypeActeur: map['statutTypeActeur'],
      descriptionTypeActeur: map['descriptionTypeActeur'],
      dateAjout: map['dateAjout'],
      dateModif:
          map['dateModif'] ,
    );
  }
  String toJson() => json.encode(toMap());

  factory TypeActeur.fromJson(String source) => TypeActeur.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TypeActeur(idTypeActeur: $idTypeActeur, libelle: $libelle, codeTypeActeur: $codeTypeActeur, statutTypeActeur: $statutTypeActeur, descriptionTypeActeur: $descriptionTypeActeur, dateAjout: $dateAjout, dateModif: $dateModif)';
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
      other.dateModif == dateModif;
  }

  @override
  int get hashCode {
    return idTypeActeur.hashCode ^
      libelle.hashCode ^
      codeTypeActeur.hashCode ^
      statutTypeActeur.hashCode ^
      descriptionTypeActeur.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode;
  }
}
