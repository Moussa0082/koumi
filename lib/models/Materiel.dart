// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Monnaie.dart';
import 'package:koumi_app/models/TypeMateriel.dart';

class Materiel {
  final String? idMateriel;
  final String? codeMateriel;
  final int prixParHeure;
  final String nom;
  final String description;
  final String? photoMateriel;
  final String localisation;
  final String? personneModif;
  final bool? statut;
  final bool? statutCommande;
  final String? dateAjout;
  final String? dateModif;
  final Acteur acteur;
  final String etatMateriel;
  TypeMateriel typeMateriel;
  Monnaie? monnaie;
  
  Materiel({
    this.idMateriel,
    this.codeMateriel,
    required this.prixParHeure,
    required this.nom,
    required this.description,
    this.photoMateriel,
    required this.localisation,
    this.personneModif,
    this.statut,
    this.statutCommande,
    this.dateAjout,
    this.dateModif,
    required this.acteur,
    required this.etatMateriel,
    required this.typeMateriel,
    required this.monnaie,
  });

 
 

  

  Materiel copyWith({
    String? idMateriel,
    String? codeMateriel,
    int? prixParHeure,
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
    TypeMateriel? typeMateriel,
    Monnaie? monnaie
  }) {
    return Materiel(
      idMateriel: idMateriel ?? this.idMateriel,
      codeMateriel: codeMateriel ?? this.codeMateriel,
      prixParHeure: prixParHeure ?? this.prixParHeure,
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
      typeMateriel: typeMateriel ?? this.typeMateriel,
      monnaie: monnaie ?? this.monnaie,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idMateriel': idMateriel,
      'codeMateriel': codeMateriel,
      'prixParHeure': prixParHeure,
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
      'typeMateriel': typeMateriel.toMap(),
      'monnaie' : monnaie!.toMap(),
    };
  }

  factory Materiel.fromMap(Map<String, dynamic> map) {
    return Materiel(
      idMateriel: map['idMateriel'] != null ? map['idMateriel'] as String : null,
      codeMateriel: map['codeMateriel'] != null ? map['codeMateriel'] as String : null,
      prixParHeure: map['prixParHeure'] as int,
      nom: map['nom'] as String,
      description: map['description'] as String,
      photoMateriel: map['photoMateriel'] != null ? map['photoMateriel'] as String : null,
      localisation: map['localisation'] as String,
      personneModif: map['personneModif'] != null ? map['personneModif'] as String : null,
      statut: map['statut'] != null ? map['statut'] as bool : null,
      statutCommande: map['statutCommande'] != null ? map['statutCommande'] as bool : null,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
      etatMateriel: map['etatMateriel'] as String,
      typeMateriel: TypeMateriel.fromMap(map['typeMateriel'] as Map<String,dynamic>),
       monnaie: map['monnaie'] != null
            ? Monnaie.fromMap(map['monnaie'] as Map<String, dynamic>)
            : Monnaie()
    );
  }

  // String toJson() => json.encode(toMap());

  // factory Materiel.fromJson(String source) => Materiel.fromMap(json.decode(source) as Map<String, dynamic>);

  // @override
  // String toString() {
  //   return 'Materiel(idMateriel: $idMateriel, codeMateriel: $codeMateriel, prixParHeure: $prixParHeure, nom: $nom, description: $description, photoMateriel: $photoMateriel, localisation: $localisation, personneModif: $personneModif, statut: $statut, statutCommande: $statutCommande, dateAjout: $dateAjout, dateModif: $dateModif, acteur: $acteur, etatMateriel: $etatMateriel, typeMateriel: $typeMateriel)';
  // }

  // @override
  // bool operator ==(covariant Materiel other) {
  //   if (identical(this, other)) return true;
  
  //   return 
  //     other.idMateriel == idMateriel &&
  //     other.codeMateriel == codeMateriel &&
  //     other.prixParHeure == prixParHeure &&
  //     other.nom == nom &&
  //     other.description == description &&
  //     other.photoMateriel == photoMateriel &&
  //     other.localisation == localisation &&
  //     other.personneModif == personneModif &&
  //     other.statut == statut &&
  //     other.statutCommande == statutCommande &&
  //     other.dateAjout == dateAjout &&
  //     other.dateModif == dateModif &&
  //     other.acteur == acteur &&
  //     other.etatMateriel == etatMateriel &&
  //     other.typeMateriel == typeMateriel;
  // }

  // @override
  // int get hashCode {
  //   return idMateriel.hashCode ^
  //     codeMateriel.hashCode ^
  //     prixParHeure.hashCode ^
  //     nom.hashCode ^
  //     description.hashCode ^
  //     photoMateriel.hashCode ^
  //     localisation.hashCode ^
  //     personneModif.hashCode ^
  //     statut.hashCode ^
  //     statutCommande.hashCode ^
  //     dateAjout.hashCode ^
  //     dateModif.hashCode ^
  //     acteur.hashCode ^
  //     etatMateriel.hashCode ^
  //     typeMateriel.hashCode;
  // }
}
