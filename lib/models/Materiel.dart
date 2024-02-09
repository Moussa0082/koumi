import 'dart:convert';

import 'package:meta/meta.dart';

import 'package:koumi_app/models/Acteur.dart';

class Materiel {
  final String? idMateriel;
  final String codeMateriel;
  final int prix;
  final String nom;
  final String description;
  final String? photoMateriel;
  final String localisation;
  final String personneModif;
  final bool statut;
  final bool statutCommande;
  final String? dateAjout;
  final String? dateModif;
  final Acteur acteur;
  final String etatMateriel;
  Materiel({
    this.idMateriel,
    required this.codeMateriel,
    required this.prix,
    required this.nom,
    required this.description,
    this.photoMateriel,
    required this.localisation,
    required this.personneModif,
    required this.statut,
    required this.statutCommande,
    this.dateAjout,
    this.dateModif,
    required this.acteur,
    required this.etatMateriel,
  });

  Materiel copyWith({
    String? idMateriel,
    String? codeMateriel,
    int? prix,
    String? nom,
    String? description,
    String? photoMateriel,
    String? localisation,
    String? personneModif,
    bool? statut,
    bool? statutCommande,
    String? dateAjout,
    String? dateModif,
    Acteur? acteur,
    String? etatMateriel,
  }) {
    return Materiel(
      idMateriel: idMateriel ?? this.idMateriel,
      codeMateriel: codeMateriel ?? this.codeMateriel,
      prix: prix ?? this.prix,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      photoMateriel: photoMateriel ?? this.photoMateriel,
      localisation: localisation ?? this.localisation,
      personneModif: personneModif ?? this.personneModif,
      statut: statut ?? this.statut,
      statutCommande: statutCommande ?? this.statutCommande,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      acteur: acteur ?? this.acteur,
      etatMateriel: etatMateriel ?? this.etatMateriel,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idMateriel': idMateriel,
      'codeMateriel': codeMateriel,
      'prix': prix,
      'nom': nom,
      'description': description,
      'photoMateriel': photoMateriel,
      'localisation': localisation,
      'personneModif': personneModif,
      'statut': statut,
      'statutCommande': statutCommande,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'acteur': acteur.toMap(),
      'etatMateriel': etatMateriel,
    };
  }

  factory Materiel.fromMap(Map<String, dynamic> map) {
    return Materiel(
      idMateriel: map['idMateriel'] != null ? map['idMateriel'] as String : null,
      codeMateriel: map['codeMateriel'] as String,
      prix: map['prix'] as int,
      nom: map['nom'] as String,
      description: map['description'] as String,
      photoMateriel: map['photoMateriel'] != null ? map['photoMateriel'] as String : null,
      localisation: map['localisation'] as String,
      personneModif: map['personneModif'] as String,
      statut: map['statut'] as bool,
      statutCommande: map['statutCommande'] as bool,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
      etatMateriel: map['etatMateriel'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Materiel.fromJson(String source) => Materiel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Materiel(idMateriel: $idMateriel, codeMateriel: $codeMateriel, prix: $prix, nom: $nom, description: $description, photoMateriel: $photoMateriel, localisation: $localisation, personneModif: $personneModif, statut: $statut, statutCommande: $statutCommande, dateAjout: $dateAjout, dateModif: $dateModif, acteur: $acteur, etatMateriel: $etatMateriel)';
  }

  @override
  bool operator ==(covariant Materiel other) {
    if (identical(this, other)) return true;
  
    return 
      other.idMateriel == idMateriel &&
      other.codeMateriel == codeMateriel &&
      other.prix == prix &&
      other.nom == nom &&
      other.description == description &&
      other.photoMateriel == photoMateriel &&
      other.localisation == localisation &&
      other.personneModif == personneModif &&
      other.statut == statut &&
      other.statutCommande == statutCommande &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.acteur == acteur &&
      other.etatMateriel == etatMateriel;
  }

  @override
  int get hashCode {
    return idMateriel.hashCode ^
      codeMateriel.hashCode ^
      prix.hashCode ^
      nom.hashCode ^
      description.hashCode ^
      photoMateriel.hashCode ^
      localisation.hashCode ^
      personneModif.hashCode ^
      statut.hashCode ^
      statutCommande.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      acteur.hashCode ^
      etatMateriel.hashCode;
  }
}
