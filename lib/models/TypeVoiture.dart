import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';

class TypeVoiture {
  final String idTypeVoiture;
  final String codeTypeVoiture;
  final String nom;
  final int? nombreSieges;
  final String? description;
  final String? dateAjout;
  final String? dateModif;
  final bool statutType;
  final Acteur acteur;
  
  TypeVoiture({
    required this.idTypeVoiture,
    required this.codeTypeVoiture,
    required this.nom,
    this.nombreSieges,
    this.description,
    this.dateAjout,
    this.dateModif,
    required this.statutType,
    required this.acteur,
  });


  TypeVoiture copyWith({
    String? idTypeVoiture,
    String? codeTypeVoiture,
    String? nom,
    int? nombreSieges,
    String? description,
    String? dateAjout,
    String? dateModif,
    bool? statutType,
    Acteur? acteur,
  }) {
    return TypeVoiture(
      idTypeVoiture: idTypeVoiture ?? this.idTypeVoiture,
      codeTypeVoiture: codeTypeVoiture ?? this.codeTypeVoiture,
      nom: nom ?? this.nom,
      nombreSieges: nombreSieges ?? this.nombreSieges,
      description: description ?? this.description,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      statutType: statutType ?? this.statutType,
      acteur: acteur ?? this.acteur,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idTypeVoiture': idTypeVoiture,
      'codeTypeVoiture': codeTypeVoiture,
      'nom': nom,
      'nombreSieges': nombreSieges,
      'description': description,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'statutType': statutType,
      'acteur': acteur.toMap(),
    };
  }

  factory TypeVoiture.fromMap(Map<String, dynamic> map) {
    return TypeVoiture(
      idTypeVoiture: map['idTypeVoiture'] as String,
      codeTypeVoiture: map['codeTypeVoiture'] as String,
      nom: map['nom'] as String,
      nombreSieges: map['nombreSieges'] != null ? map['nombreSieges'] as int : null,
      description: map['description'] != null ? map['description'] as String : null,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      statutType: map['statutType'] as bool,
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeVoiture.fromJson(String source) => TypeVoiture.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TypeVoiture(idTypeVoiture: $idTypeVoiture, codeTypeVoiture: $codeTypeVoiture, nom: $nom, nombreSieges: $nombreSieges, description: $description, dateAjout: $dateAjout, dateModif: $dateModif, statutType: $statutType, acteur: $acteur)';
  }

  @override
  bool operator ==(covariant TypeVoiture other) {
    if (identical(this, other)) return true;
  
    return 
      other.idTypeVoiture == idTypeVoiture &&
      other.codeTypeVoiture == codeTypeVoiture &&
      other.nom == nom &&
      other.nombreSieges == nombreSieges &&
      other.description == description &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.statutType == statutType &&
      other.acteur == acteur;
  }

  @override
  int get hashCode {
    return idTypeVoiture.hashCode ^
      codeTypeVoiture.hashCode ^
      nom.hashCode ^
      nombreSieges.hashCode ^
      description.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      statutType.hashCode ^
      acteur.hashCode;
  }
}
