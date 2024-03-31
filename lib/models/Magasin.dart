import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';

class Magasin {
   String? idMagasin;
  final String? codeMagasin;
   String? nomMagasin;
  // final String? niveau3PaysMagasin;
   String? latitude;
   String? longitude;
  final String? localiteMagasin;
  final String? contactMagasin;
   String? personneModif;
  final bool? statutMagasin;
   String? dateAjout;
   String? dateModif;
   String? photo;
  final Acteur? acteur;
  final Niveau1Pays? niveau1Pays;

  Magasin( {
     this.idMagasin,
     this.codeMagasin,
     this.nomMagasin,
    //  this.niveau3PaysMagasin,
     this.latitude,
     this.longitude,
     this.localiteMagasin,
     this.contactMagasin,
    this.personneModif,
     this.statutMagasin,
    this.dateAjout,
    this.dateModif,
    this.photo,
     this.acteur,
     this.niveau1Pays
  });

  Magasin copyWith({
    String? idMagasin,
    String? codeMagasin,
    String? nomMagasin,
    String? niveau3PaysMagasin,
    String? latitude,
    String? longitude,
    String? localiteMagasin,
    String? contactMagasin,
    String? personneModif,
    bool? statutMagasin,
    String? dateAjout,
    String? dateModif,
    String? photo,
    Acteur? acteur,
    Niveau1Pays? niveau1Pays,
  }) {
    return Magasin(
      idMagasin: idMagasin ?? this.idMagasin,
      codeMagasin: codeMagasin ?? this.codeMagasin,
      nomMagasin: nomMagasin ?? this.nomMagasin,
      // niveau3PaysMagasin: niveau3PaysMagasin ?? this.niveau3PaysMagasin,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      localiteMagasin: localiteMagasin ?? this.localiteMagasin,
      contactMagasin: contactMagasin ?? this.contactMagasin,
      personneModif: personneModif ?? this.personneModif,
      statutMagasin: statutMagasin ?? this.statutMagasin,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      photo: photo ?? this.photo,
      acteur: acteur ?? this.acteur,
      niveau1Pays: niveau1Pays ?? this.niveau1Pays,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idMagasin': idMagasin,
      'codeMagasin': codeMagasin,
      'nomMagasin': nomMagasin,
      // 'niveau3PaysMagasin': niveau3PaysMagasin,
      'latitude': latitude,
      'longitude': longitude,
      'localiteMagasin': localiteMagasin,
      'contactMagasin': contactMagasin,
      'personneModif': personneModif,
      'statutMagasin': statutMagasin,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'photo': photo,
      'acteur': acteur?.toMap(),
      'niveau1Pays': niveau1Pays?.toMap(),
    };
  }

  factory Magasin.fromMap(Map<String, dynamic> map) {
    return Magasin(
      idMagasin: map['idMagasin'] as String,
      codeMagasin: map['codeMagasin'] as String,
      nomMagasin: map['nomMagasin'] as String,
      // niveau3PaysMagasin: map['niveau3PaysMagasin'] as String,
      latitude: map['latitude'] as String,
      longitude: map['longitude'] as String,
      localiteMagasin: map['localiteMagasin'] as String,
      contactMagasin: map['contactMagasin'] as String,
      personneModif: map['personneModif'] != null ? map['personneModif'] as String : null,
      statutMagasin: map['statutMagasin'] as bool,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
      niveau1Pays: Niveau1Pays.fromMap(map['niveau1Pays'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Magasin.fromJson(String source) => Magasin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Magasin(idMagasin: $idMagasin, codeMagasin: $codeMagasin, nomMagasin: $nomMagasin,latitude: $latitude, longitude: $longitude, localiteMagasin: $localiteMagasin, contactMagasin: $contactMagasin, personneModif: $personneModif, statutMagasin: $statutMagasin, dateAjout: $dateAjout, dateModif: $dateModif, photo: $photo, acteur: $acteur, niveau1Pays: $niveau1Pays';
  }

  @override
  bool operator ==(covariant Magasin other) {
    if (identical(this, other)) return true;
  
    return 
      other.idMagasin == idMagasin &&
      other.codeMagasin == codeMagasin &&
      other.nomMagasin == nomMagasin &&
      // other.niveau3PaysMagasin == niveau3PaysMagasin &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.localiteMagasin == localiteMagasin &&
      other.contactMagasin == contactMagasin &&
      other.personneModif == personneModif &&
      other.statutMagasin == statutMagasin &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.photo == photo &&
      other.acteur == acteur &&
      other.niveau1Pays == niveau1Pays;
  }

  @override
  int get hashCode {
    return idMagasin.hashCode ^
      codeMagasin.hashCode ^
      nomMagasin.hashCode ^
      // niveau3PaysMagasin.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      localiteMagasin.hashCode ^
      contactMagasin.hashCode ^
      personneModif.hashCode ^
      statutMagasin.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      photo.hashCode ^
      acteur.hashCode ^
      niveau1Pays.hashCode;
  }
}
