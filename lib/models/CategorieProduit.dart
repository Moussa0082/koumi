import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Filiere.dart';

class CategorieProduit {
  final String? idCategorieProduit;
  String? codeCategorie;
  final String libelleCategorie;
  final String? descriptionCategorie;
  final bool? statutCategorie;
  final String? dateAjout;
  final String? personneModif;
  final String? dateModif;
  final Filiere? filiere;
  final Acteur? acteur;

  CategorieProduit({
    this.idCategorieProduit,
     this.codeCategorie,
    required this.libelleCategorie,
     this.descriptionCategorie,
     this.statutCategorie,
    this.dateAjout,
    this.personneModif,
    this.dateModif,
     this.filiere,
     this.acteur,
  });

  CategorieProduit copyWith({
    String? idCategorieProduit,
    String? codeCategorie,
    String? libelleCategorie,
    String? descriptionCategorie,
    bool? statutCategorie,
    String? dateAjout,
    String? personneModif,
    String? dateModif,
    Filiere? filiere,
    Acteur? acteur,
  }) {
    return CategorieProduit(
      idCategorieProduit: idCategorieProduit ?? this.idCategorieProduit,
      codeCategorie: codeCategorie ?? this.codeCategorie,
      libelleCategorie: libelleCategorie ?? this.libelleCategorie,
      descriptionCategorie: descriptionCategorie ?? this.descriptionCategorie,
      statutCategorie: statutCategorie ?? this.statutCategorie,
      dateAjout: dateAjout ?? this.dateAjout,
      personneModif: personneModif ?? this.personneModif,
      dateModif: dateModif ?? this.dateModif,
      filiere: filiere ?? this.filiere,
      acteur: acteur ?? this.acteur,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idCategorieProduit': idCategorieProduit,
      'codeCategorie': codeCategorie,
      'libelleCategorie': libelleCategorie,
      'descriptionCategorie': descriptionCategorie,
      'statutCategorie': statutCategorie,
      'dateAjout': dateAjout,
      'personneModif': personneModif,
      'dateModif': dateModif,
      'filiere': filiere?.toMap(),
      'acteur': acteur?.toMap(),
    };
  }

  factory CategorieProduit.fromMap(Map<String, dynamic> map) {
    return CategorieProduit(
      idCategorieProduit: map['idCategorieProduit'] != null ? map['idCategorieProduit'] as String : null,
      codeCategorie: map['codeCategorie'] as String,
      libelleCategorie: map['libelleCategorie'] as String,
      descriptionCategorie: map['descriptionCategorie'] as String,
      statutCategorie: map['statutCategorie'] as bool,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      personneModif: map['personneModif'] != null ? map['personneModif'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      filiere: Filiere.fromMap(map['filiere'] as Map<String,dynamic>),
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategorieProduit.fromJson(String source) => CategorieProduit.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategorieProduit(idCategorieProduit: $idCategorieProduit, codeCategorie: $codeCategorie, libelleCategorie: $libelleCategorie, descriptionCategorie: $descriptionCategorie, statutCategorie: $statutCategorie, dateAjout: $dateAjout, personneModif: $personneModif, dateModif: $dateModif, filiere: $filiere, acteur: $acteur)';
  }

  @override
  bool operator ==(covariant CategorieProduit other) {
    if (identical(this, other)) return true;
  
    return 
      other.idCategorieProduit == idCategorieProduit &&
      other.codeCategorie == codeCategorie &&
      other.libelleCategorie == libelleCategorie &&
      other.descriptionCategorie == descriptionCategorie &&
      other.statutCategorie == statutCategorie &&
      other.dateAjout == dateAjout &&
      other.personneModif == personneModif &&
      other.dateModif == dateModif &&
      other.filiere == filiere &&
      other.acteur == acteur;
  }

  @override
  int get hashCode {
    return idCategorieProduit.hashCode ^
      codeCategorie.hashCode ^
      libelleCategorie.hashCode ^
      descriptionCategorie.hashCode ^
      statutCategorie.hashCode ^
      dateAjout.hashCode ^
      personneModif.hashCode ^
      dateModif.hashCode ^
      filiere.hashCode ^
      acteur.hashCode;
  }
}
