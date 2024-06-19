import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Forme.dart';
import 'package:koumi_app/models/Monnaie.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/Superficie.dart';

class Intrant {
  final String? idIntrant;
   String? nomIntrant;
   double? quantiteIntrant;
   int? prixIntrant;
  final String? codeIntrant;
  final String? descriptionIntrant;
  final String? photoIntrant;
  final bool? statutIntrant;
  final String? dateExpiration;
  final String? dateAjout;
  final String? dateModif;
  final String? personneModif;
  final String? unite;
  final Forme? forme;
  final Acteur? acteur;
  final CategorieProduit? categorieProduit;
  final Monnaie? monnaie;
  
  Intrant({
    this.idIntrant,
    this.nomIntrant,
    this.quantiteIntrant,
    this.prixIntrant,
    this.codeIntrant,
    this.descriptionIntrant,
    this.photoIntrant,
    this.statutIntrant,
    this.dateExpiration,
    this.dateAjout,
    this.dateModif,
    this.personneModif,
    this.unite,
    this.forme,
    this.acteur,
    this.categorieProduit,
    this.monnaie,
  });
  
 

  Intrant copyWith({
    String? idIntrant,
    String? nomIntrant,
    double? quantiteIntrant,
    int? prixIntrant,
    String? codeIntrant,
    String? descriptionIntrant,
    String? photoIntrant,
    bool? statutIntrant,
    String? dateExpiration,
    String? dateAjout,
    String? dateModif,
    String? personneModif,
    String? unite,
    Forme? forme,
    Acteur? acteur,
    CategorieProduit? categorieProduit,
    Monnaie? monnaie,
  }) {
    return Intrant(
      idIntrant: idIntrant ?? this.idIntrant,
      nomIntrant: nomIntrant ?? this.nomIntrant,
      quantiteIntrant: quantiteIntrant ?? this.quantiteIntrant,
      prixIntrant: prixIntrant ?? this.prixIntrant,
      codeIntrant: codeIntrant ?? this.codeIntrant,
      descriptionIntrant: descriptionIntrant ?? this.descriptionIntrant,
      photoIntrant: photoIntrant ?? this.photoIntrant,
      statutIntrant: statutIntrant ?? this.statutIntrant,
      dateExpiration: dateExpiration ?? this.dateExpiration,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      personneModif: personneModif ?? this.personneModif,
      unite: unite ?? this.unite,
      forme: forme ?? this.forme,
      acteur: acteur ?? this.acteur,
      categorieProduit: categorieProduit ?? this.categorieProduit,
      monnaie: monnaie ?? this.monnaie,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idIntrant': idIntrant,
      'nomIntrant': nomIntrant,
      'quantiteIntrant': quantiteIntrant,
      'prixIntrant': prixIntrant,
      'codeIntrant': codeIntrant,
      'descriptionIntrant': descriptionIntrant,
      'photoIntrant': photoIntrant,
      'statutIntrant': statutIntrant,
      'dateExpiration': dateExpiration,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'personneModif': personneModif,
      'unite': unite,
      'forme': forme?.toMap(),
      'acteur': acteur?.toMap(),
      'categorieProduit': categorieProduit?.toMap(),
      'monnaie': monnaie?.toMap(),
    };
  }

  factory Intrant.fromMap(Map<String, dynamic> map) {
    return Intrant(
      idIntrant: map['idIntrant'] != null ? map['idIntrant'] as String : null,
      nomIntrant: map['nomIntrant'] != null ? map['nomIntrant'] as String : null,
      quantiteIntrant: map['quantiteIntrant'] != null ? map['quantiteIntrant'] as double : null,
      prixIntrant: map['prixIntrant'] != null ? map['prixIntrant'] as int : null,
      codeIntrant: map['codeIntrant'] != null ? map['codeIntrant'] as String : null,
      descriptionIntrant: map['descriptionIntrant'] != null ? map['descriptionIntrant'] as String : null,
      photoIntrant: map['photoIntrant'] != null ? map['photoIntrant'] as String : null,
      statutIntrant: map['statutIntrant'] != null ? map['statutIntrant'] as bool : null,
      dateExpiration: map['dateExpiration'] != null ? map['dateExpiration'] as String : null,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      personneModif: map['personneModif'] != null ? map['personneModif'] as String : null,
      unite: map['unite'] != null ? map['unite'] as String : null,
      forme: map['forme'] != null ? Forme.fromMap(map['forme'] as Map<String,dynamic>) : null,
      acteur: map['acteur'] != null ? Acteur.fromMap(map['acteur'] as Map<String,dynamic>) : null,
      categorieProduit: map['categorieProduit'] != null ? CategorieProduit.fromMap(map['categorieProduit'] as Map<String,dynamic>) : null,
       monnaie: map['monnaie'] != null
          ? Monnaie.fromMap(map['monnaie'] as Map<String, dynamic>)
          : Monnaie(),
    );
  }


}
