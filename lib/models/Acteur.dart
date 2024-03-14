import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/TypeActeur.dart';

class Acteur {

     final String? idActeur;
    final String? resetToken;
    final String? tokenCreationDate;
    final String? codeActeur;
    final String? nomActeur;
    final String? adresseActeur;
    final String? telephoneActeur;
    final String? whatsAppActeur;
    final String? latitude;
    final String? longitude;
    final String? photoSiegeActeur;
    final String? logoActeur;
    final String? niveau3PaysActeur;
    final String? password;
    final String? dateAjout;
    final String? dateModif;
    final String? personneModif;
    final String? localiteActeur;
    final String? emailActeur;
    final bool? statutActeur;
    final List<Speculation>? speculations;
    final List<TypeActeur>? typeActeur;

  Acteur({
    this.idActeur,
    this.resetToken,
    this.tokenCreationDate,

    this.codeActeur,
    this.nomActeur,
    this.adresseActeur,
    this.telephoneActeur,
    this.whatsAppActeur,
    this.latitude,
    this.longitude,
    this.photoSiegeActeur,
    this.logoActeur,
    this.niveau3PaysActeur,
    this.password,
    this.dateAjout,
    this.dateModif,
    this.personneModif,
    this.localiteActeur,
    this.emailActeur,
    this.statutActeur,
    this.speculations,
    this.typeActeur,
  });





    static Acteur? fromSharedPreferencesData(String emailActeur, String password, List<String> userTypeList, String idActeur, String nomActeur, String telephoneActeur, String adresseActeur, String whatsAppActeur, String niveau3paysActeur, String localiteActeur) {}


  Acteur copyWith({
    String? idActeur,
    String? resetToken,
    String? tokenCreationDate,
    String? codeActeur,
    String? nomActeur,
    String? adresseActeur,
    String? telephoneActeur,
    String? whatsAppActeur,
    String? latitude,
    String? longitude,
    String? photoSiegeActeur,
    String? logoActeur,
    String? niveau3PaysActeur,
    String? password,
    String? dateAjout,
    String? dateModif,
    String? personneModif,
    String? localiteActeur,
    String? emailActeur,
    bool? statutActeur,
    List<Speculation>? speculations,
    List<TypeActeur>? typeActeur,
  }) {
    return Acteur(

      idActeur: idActeur ?? this.idActeur,
      resetToken: resetToken ?? this.resetToken,
      tokenCreationDate: tokenCreationDate ?? this.tokenCreationDate,
      codeActeur: codeActeur ?? this.codeActeur,
      nomActeur: nomActeur ?? this.nomActeur,
      adresseActeur: adresseActeur ?? this.adresseActeur,
      telephoneActeur: telephoneActeur ?? this.telephoneActeur,
      whatsAppActeur: whatsAppActeur ?? this.whatsAppActeur,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoSiegeActeur: photoSiegeActeur ?? this.photoSiegeActeur,
      logoActeur: logoActeur ?? this.logoActeur,
      niveau3PaysActeur: niveau3PaysActeur ?? this.niveau3PaysActeur,
      password: password ?? this.password,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      personneModif: personneModif ?? this.personneModif,
      localiteActeur: localiteActeur ?? this.localiteActeur,
      emailActeur: emailActeur ?? this.emailActeur,
      statutActeur: statutActeur ?? this.statutActeur,
      speculations: speculations ?? this.speculations,
      typeActeur: typeActeur ?? this.typeActeur,
    );
  }

 Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idActeur': idActeur,
      'resetToken': resetToken,
      'tokenCreationDate': tokenCreationDate,
      'codeActeur': codeActeur,
      'nomActeur': nomActeur,
      'adresseActeur': adresseActeur,
      'telephoneActeur': telephoneActeur,
      'whatsAppActeur': whatsAppActeur,
      'latitude': latitude,
      'longitude': longitude,
      'photoSiegeActeur': photoSiegeActeur,
      'logoActeur': logoActeur,
      'niveau3PaysActeur': niveau3PaysActeur,
      'password': password,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'personneModif': personneModif,
      'localiteActeur': localiteActeur,
      'emailActeur': emailActeur,
      'statutActeur': statutActeur,
      'speculations': speculations?.map((x) => x?.toMap())?.toList(),
      'typeActeur': typeActeur?.map((x) => x?.toMap())?.toList(),
    };
  }



   factory Acteur.fromMap(Map<String, dynamic> map) {
    return Acteur(
      idActeur: map['idActeur'],
      resetToken: map['resetToken'],
      tokenCreationDate: map['tokenCreationDate'],
      codeActeur: map['codeActeur'],
      nomActeur: map['nomActeur'],
      adresseActeur: map['adresseActeur'],
      telephoneActeur: map['telephoneActeur'],
      whatsAppActeur: map['whatsAppActeur'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      photoSiegeActeur: map['photoSiegeActeur'],
      logoActeur: map['logoActeur'],
      niveau3PaysActeur: map['niveau3PaysActeur'],
      password: map['password'],
      dateAjout: map['dateAjout'],
      dateModif: map['dateModif'],
      personneModif: map['personneModif'],
      localiteActeur: map['localiteActeur'],
      emailActeur: map['emailActeur'],
      statutActeur: map['statutActeur'],
      speculations: map['speculations'] != null
          ? List<Speculation>.from((map['speculations'] as List<dynamic>)
              .map<Speculation>((x) => Speculation.fromMap(x)))
          : null,
      typeActeur: map['typeActeur'] != null
          ? List<TypeActeur>.from((map['typeActeur'] as List<dynamic>)
              .map<TypeActeur>((x) => TypeActeur.fromMap(x)))
          : null,
    );
  }

  //  factory Acteur.fromJson(Map<String, dynamic> json) => Acteur(
  //       idActeur: json["idActeur"],
  //       resetToken: json["resetToken"],
  //       tokenCreationDate: json["tokenCreationDate"],
  //       codeActeur: json["codeActeur"],
  //       nomActeur: json["nomActeur"],
  //       adresseActeur: json["adresseActeur"],
  //       telephoneActeur: json["telephoneActeur"],
  //       whatsAppActeur: json["whatsAppActeur"],
  //       latitude: json["latitude"],
  //       longitude: json["longitude"],
  //       photoSiegeActeur: json["photoSiegeActeur"],
  //       logoActeur: json["logoActeur"],
  //       niveau3PaysActeur: json["niveau3PaysActeur"],
  //       password: json["password"],
  //       dateAjout: json["dateAjout"],
  //       dateModif: json["dateModif"],
  //       personneModif: json["personneModif"],
  //       localiteActeur: json["localiteActeur"],
  //       emailActeur: json["emailActeur"],
  //       filiereActeur: json["filiereActeur"],
  //       statutActeur: json["statutActeur"],
  //      typeActeur: (json['typeActeur'] as List)
  //         .map((type) => TypeActeur.fromJson(type))
  //         .toList(), 
  //         // typeActeur: List<TypeActeur>.from(json["typeActeur"].map((x) => TypeActeur.fromJson(x))),
  //       maillonActeur: json["maillonActeur"],
  //   );

  String toJson() => json.encode(toMap());

  factory Acteur.fromJson(String source) => Acteur.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Acteur(idActeur: $idActeur, resetToken: $resetToken, tokenCreationDate: $tokenCreationDate, codeActeur: $codeActeur, nomActeur: $nomActeur, adresseActeur: $adresseActeur, telephoneActeur: $telephoneActeur, whatsAppActeur: $whatsAppActeur, latitude: $latitude, longitude: $longitude, photoSiegeActeur: $photoSiegeActeur, logoActeur: $logoActeur, niveau3PaysActeur: $niveau3PaysActeur, password: $password, dateAjout: $dateAjout, dateModif: $dateModif, personneModif: $personneModif, localiteActeur: $localiteActeur, emailActeur: $emailActeur, statutActeur: $statutActeur, speculations: $speculations, typeActeur: $typeActeur)';
  }

  @override
  bool operator ==(covariant Acteur other) {
    if (identical(this, other)) return true;
  
    return 
      other.idActeur == idActeur &&
      other.resetToken == resetToken &&
      other.tokenCreationDate == tokenCreationDate &&
      other.codeActeur == codeActeur &&
      other.nomActeur == nomActeur &&
      other.adresseActeur == adresseActeur &&
      other.telephoneActeur == telephoneActeur &&
      other.whatsAppActeur == whatsAppActeur &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.photoSiegeActeur == photoSiegeActeur &&
      other.logoActeur == logoActeur &&
      other.niveau3PaysActeur == niveau3PaysActeur &&
      other.password == password &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.personneModif == personneModif &&
      other.localiteActeur == localiteActeur &&
      other.emailActeur == emailActeur &&
      other.statutActeur == statutActeur &&
      listEquals(other.speculations, speculations) &&
      listEquals(other.typeActeur, typeActeur);
  }

  @override
  int get hashCode {
    return idActeur.hashCode ^
      resetToken.hashCode ^
      tokenCreationDate.hashCode ^
      codeActeur.hashCode ^
      nomActeur.hashCode ^
      adresseActeur.hashCode ^
      telephoneActeur.hashCode ^
      whatsAppActeur.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      photoSiegeActeur.hashCode ^
      logoActeur.hashCode ^
      niveau3PaysActeur.hashCode ^
      password.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      personneModif.hashCode ^
      localiteActeur.hashCode ^
      emailActeur.hashCode ^
      statutActeur.hashCode ^
      speculations.hashCode ^
      typeActeur.hashCode;
  }
}

