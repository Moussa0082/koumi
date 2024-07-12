// import 'dart:convert';

// import 'package:koumi_app/models/Acteur.dart';
// import 'package:koumi_app/models/Monnaie.dart';
// import 'package:koumi_app/models/Speculation.dart';
// import 'package:koumi_app/models/TypeMateriel.dart';

// class Materiels {
//     String? idMateriel;
//     String? codeMateriel;
//     int? prixParHeure;
//     String? nom;
//     String? description;
//     String? photoMateriel;
//     String? etatMateriel;
//     String? localisation;
//     String? personneModif;
//     bool? statut;
//     bool? statutCommande;
//     String? pays;
//     String? dateAjout;
//     String? dateModif;
//     Acteur? acteur;
//     TypeMateriel? typeMateriel;
//     Monnaie? monnaie;
//     Speculation? speculation;

//   Materiels({
//     this.idMateriel,
//     this.codeMateriel,
//     this.prixParHeure,
//     this.nom,
//     this.description,
//     this.photoMateriel,
//     this.etatMateriel,
//     this.localisation,
//     this.personneModif,
//     this.statut,
//     this.statutCommande,
//     this.pays,
//     this.dateAjout,
//     this.dateModif,
//     this.acteur,
//     this.typeMateriel,
//     this.monnaie,
//     this.speculation,
//   });

//   Materiels copyWith({
//     String? idMateriel,
//     String? codeMateriel,
//     int? prixParHeure,
//     String? nom,
//     String? description,
//     String? photoMateriel,
//     String? etatMateriel,
//     String? localisation,
//     String? personneModif,
//     bool? statut,
//     bool? statutCommande,
//     String? pays,
//     String? dateAjout,
//     String? dateModif,
//     Acteur? acteur,
//     TypeMateriel? typeMateriel,
//     Monnaie? monnaie,
//     Speculation? speculation,
//   }) {
//     return Materiels(
//       idMateriel: idMateriel ?? this.idMateriel,
//       codeMateriel: codeMateriel ?? this.codeMateriel,
//       prixParHeure: prixParHeure ?? this.prixParHeure,
//       nom: nom ?? this.nom,
//       description: description ?? this.description,
//       photoMateriel: photoMateriel ?? this.photoMateriel,
//       etatMateriel: etatMateriel ?? this.etatMateriel,
//       localisation: localisation ?? this.localisation,
//       personneModif: personneModif ?? this.personneModif,
//       statut: statut ?? this.statut,
//       statutCommande: statutCommande ?? this.statutCommande,
//       pays: pays ?? this.pays,
//       dateAjout: dateAjout ?? this.dateAjout,
//       dateModif: dateModif ?? this.dateModif,
//       acteur: acteur ?? this.acteur,
//       typeMateriel: typeMateriel ?? this.typeMateriel,
//       monnaie: monnaie ?? this.monnaie,
//       speculation: speculation ?? this.speculation,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'idMateriel': idMateriel,
//       'codeMateriel': codeMateriel,
//       'prixParHeure': prixParHeure,
//       'nom': nom,
//       'description': description,
//       'photoMateriel': photoMateriel,
//       'etatMateriel': etatMateriel,
//       'localisation': localisation,
//       'personneModif': personneModif,
//       'statut': statut,
//       'statutCommande': statutCommande,
//       'pays': pays,
//       'dateAjout': dateAjout,
//       'dateModif': dateModif,
//       'acteur': acteur?.toMap(),
//       'typeMateriel': typeMateriel?.toMap(),
//       'monnaie': monnaie?.toMap(),
//       'speculation': speculation?.toMap(),
//     };
//   }

//   factory Materiels.fromMap(Map<String, dynamic> map) {
//     return Materiels(
//       idMateriel: map['idMateriel'] != null ? map['idMateriel'] as String : null,
//       codeMateriel: map['codeMateriel'] != null ? map['codeMateriel'] as String : null,
//       prixParHeure: map['prixParHeure'] != null ? map['prixParHeure'] as int : null,
//       nom: map['nom'] != null ? map['nom'] as String : null,
//       description: map['description'] != null ? map['description'] as String : null,
//       photoMateriel: map['photoMateriel'] != null ? map['photoMateriel'] as String : null,
//       etatMateriel: map['etatMateriel'] != null ? map['etatMateriel'] as String : null,
//       localisation: map['localisation'] != null ? map['localisation'] as String : null,
//       personneModif: map['personneModif'] != null ? map['personneModif'] as String : null,
//       statut: map['statut'] != null ? map['statut'] as bool : null,
//       statutCommande: map['statutCommande'] != null ? map['statutCommande'] as bool : null,
//       pays: map['pays'] != null ? map['pays'] as String : null,
//       dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
//       dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
//       acteur: map['acteur'] != null
//           ? Acteur.fromMap(map['acteur'] as Map<String, dynamic>)
//           : Acteur(),
//       typeMateriel: map['typeMateriel'] != null
//       ? TypeMateriel.fromMap(map['typeMateriel'] as Map<String,dynamic>) : TypeMateriel(),
//         monnaie: map['monnaie'] != null
//           ? Monnaie.fromMap(map['monnaie'] as Map<String, dynamic>)
//           : Monnaie(),
//       speculation: map['speculation'] != null
//           ? Speculation.fromMap(map['speculation'] as Map<String, dynamic>)
//           : Speculation(),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Materiels.fromJson(String source) => Materiels.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'Materiels(idMateriel: $idMateriel, codeMateriel: $codeMateriel, prixParHeure: $prixParHeure, nom: $nom, description: $description, photoMateriel: $photoMateriel, etatMateriel: $etatMateriel, localisation: $localisation, personneModif: $personneModif, statut: $statut, statutCommande: $statutCommande, pays: $pays, dateAjout: $dateAjout, dateModif: $dateModif, acteur: $acteur, typeMateriel: $typeMateriel, monnaie: $monnaie, speculation: $speculation)';
//   }

//   @override
//   bool operator ==(covariant Materiels other) {
//     if (identical(this, other)) return true;

//     return
//       other.idMateriel == idMateriel &&
//       other.codeMateriel == codeMateriel &&
//       other.prixParHeure == prixParHeure &&
//       other.nom == nom &&
//       other.description == description &&
//       other.photoMateriel == photoMateriel &&
//       other.etatMateriel == etatMateriel &&
//       other.localisation == localisation &&
//       other.personneModif == personneModif &&
//       other.statut == statut &&
//       other.statutCommande == statutCommande &&
//       other.pays == pays &&
//       other.dateAjout == dateAjout &&
//       other.dateModif == dateModif &&
//       other.acteur == acteur &&
//       other.typeMateriel == typeMateriel &&
//       other.monnaie == monnaie &&
//       other.speculation == speculation;
//   }

//   @override
//   int get hashCode {
//     return idMateriel.hashCode ^
//       codeMateriel.hashCode ^
//       prixParHeure.hashCode ^
//       nom.hashCode ^
//       description.hashCode ^
//       photoMateriel.hashCode ^
//       etatMateriel.hashCode ^
//       localisation.hashCode ^
//       personneModif.hashCode ^
//       statut.hashCode ^
//       statutCommande.hashCode ^
//       pays.hashCode ^
//       dateAjout.hashCode ^
//       dateModif.hashCode ^
//       acteur.hashCode ^
//       typeMateriel.hashCode ^
//       monnaie.hashCode ^
//       speculation.hashCode;
//   }
// }

import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Monnaie.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/TypeMateriel.dart';

class Materiels {
  String? idMateriel;
  String? codeMateriel;
  int? prixParHeure;
  String? nom;
  String? description;
  String? photoMateriel;
  String? etatMateriel;
  String? localisation;
  String? personneModif;
  bool? statut;
  bool? statutCommande;
  String? pays;
  String? dateAjout;
  String? dateModif;
  Acteur? acteur;
  TypeMateriel? typeMateriel;
  Monnaie? monnaie;
  Speculation? speculation;

  Materiels({
    this.idMateriel,
    this.codeMateriel,
    this.prixParHeure,
    this.nom,
    this.description,
    this.photoMateriel,
    this.etatMateriel,
    this.localisation,
    this.personneModif,
    this.statut,
    this.statutCommande,
    this.pays,
    this.dateAjout,
    this.dateModif,
    this.acteur,
    this.typeMateriel,
    this.monnaie,
    this.speculation,
  });

  Materiels copyWith({
    String? idMateriel,
    String? codeMateriel,
    int? prixParHeure,
    String? nom,
    String? description,
    String? photoMateriel,
    String? etatMateriel,
    String? localisation,
    String? personneModif,
    bool? statut,
    bool? statutCommande,
    String? pays,
    String? dateAjout,
    String? dateModif,
    Acteur? acteur,
    TypeMateriel? typeMateriel,
    Monnaie? monnaie,
    Speculation? speculation,
  }) {
    return Materiels(
      idMateriel: idMateriel ?? this.idMateriel,
      codeMateriel: codeMateriel ?? this.codeMateriel,
      prixParHeure: prixParHeure ?? this.prixParHeure,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      photoMateriel: photoMateriel ?? this.photoMateriel,
      etatMateriel: etatMateriel ?? this.etatMateriel,
      localisation: localisation ?? this.localisation,
      personneModif: personneModif ?? this.personneModif,
      statut: statut ?? this.statut,
      statutCommande: statutCommande ?? this.statutCommande,
      pays: pays ?? this.pays,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      acteur: acteur ?? this.acteur,
      typeMateriel: typeMateriel ?? this.typeMateriel,
      monnaie: monnaie ?? this.monnaie,
      speculation: speculation ?? this.speculation,
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
      'etatMateriel': etatMateriel,
      'localisation': localisation,
      'personneModif': personneModif,
      'statut': statut,
      'statutCommande': statutCommande,
      'pays': pays,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'acteur': acteur?.toMap(),
      'typeMateriel': typeMateriel?.toMap(),
      'monnaie': monnaie?.toMap(),
      'speculation': speculation?.toMap(),
    };
  }

  factory Materiels.fromMap(Map<String, dynamic> map) {
    return Materiels(
      idMateriel:
          map['idMateriel'] != null ? map['idMateriel'] as String : null,
      codeMateriel:
          map['codeMateriel'] != null ? map['codeMateriel'] as String : null,
      prixParHeure:
          map['prixParHeure'] != null ? map['prixParHeure'] as int : null,
      nom: map['nom'] != null ? map['nom'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      photoMateriel:
          map['photoMateriel'] != null ? map['photoMateriel'] as String : null,
      etatMateriel:
          map['etatMateriel'] != null ? map['etatMateriel'] as String : null,
      localisation:
          map['localisation'] != null ? map['localisation'] as String : null,
      personneModif:
          map['personneModif'] != null ? map['personneModif'] as String : null,
      statut: map['statut'] != null ? map['statut'] as bool : null,
      statutCommande:
          map['statutCommande'] != null ? map['statutCommande'] as bool : null,
      pays: map['pays'] != null ? map['pays'] as String : null,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      acteur: map['acteur'] != null
          ? Acteur.fromMap(map['acteur'] as Map<String, dynamic>)
          : null,
      typeMateriel: map['typeMateriel'] != null
          ? TypeMateriel.fromMap(map['typeMateriel'] as Map<String, dynamic>)
          : null,
      monnaie: map['monnaie'] != null
          ? Monnaie.fromMap(map['monnaie'] as Map<String, dynamic>)
          : null,
      speculation: map['speculation'] != null
          ? Speculation.fromMap(map['speculation'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Materiels.fromJson(String source) =>
      Materiels.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Materiels(idMateriel: $idMateriel, codeMateriel: $codeMateriel, prixParHeure: $prixParHeure, nom: $nom, description: $description, photoMateriel: $photoMateriel, etatMateriel: $etatMateriel, localisation: $localisation, personneModif: $personneModif, statut: $statut, statutCommande: $statutCommande, pays: $pays, dateAjout: $dateAjout, dateModif: $dateModif, acteur: $acteur, typeMateriel: $typeMateriel, monnaie: $monnaie, speculation: $speculation)';
  }

  @override
  bool operator ==(covariant Materiels other) {
    if (identical(this, other)) return true;

    return other.idMateriel == idMateriel &&
        other.codeMateriel == codeMateriel &&
        other.prixParHeure == prixParHeure &&
        other.nom == nom &&
        other.description == description &&
        other.photoMateriel == photoMateriel &&
        other.etatMateriel == etatMateriel &&
        other.localisation == localisation &&
        other.personneModif == personneModif &&
        other.statut == statut &&
        other.statutCommande == statutCommande &&
        other.pays == pays &&
        other.dateAjout == dateAjout &&
        other.dateModif == dateModif &&
        other.acteur == acteur &&
        other.typeMateriel == typeMateriel &&
        other.monnaie == monnaie &&
        other.speculation == speculation;
  }

  @override
  int get hashCode {
    return idMateriel.hashCode ^
        codeMateriel.hashCode ^
        prixParHeure.hashCode ^
        nom.hashCode ^
        description.hashCode ^
        photoMateriel.hashCode ^
        etatMateriel.hashCode ^
        localisation.hashCode ^
        personneModif.hashCode ^
        statut.hashCode ^
        statutCommande.hashCode ^
        pays.hashCode ^
        dateAjout.hashCode ^
        dateModif.hashCode ^
        acteur.hashCode ^
        typeMateriel.hashCode ^
        monnaie.hashCode ^
        speculation.hashCode;
  }
}
