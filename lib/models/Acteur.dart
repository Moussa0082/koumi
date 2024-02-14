import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:koumi_app/models/TypeActeur.dart';

class Acteur {
  String? idActeur;
  String? resetToken;
  String? tokenCreationDate;
  final String? codeActeur;
  final String nomActeur;
  final String adresseActeur;
  final String telephoneActeur;
  String? whatsAppActeur;
  String? latitude;
  String? longitude;
  String? photoSiegeActeur;
  String? logoActeur;
  final String niveau3PaysActeur;
  final String password;
  String? dateAjout;
  String? dateModif;
  String? personneModif;
  final String localiteActeur;
  final String emailActeur;
  final String filiereActeur;
  final bool statutActeur;
  final List<TypeActeur> typeActeur;
  final String maillonActeur;
  
  Acteur({
    this.idActeur,
    required this.resetToken,
    required this.tokenCreationDate,
    required this.codeActeur,
    required this.nomActeur,
    required this.adresseActeur,
    required this.telephoneActeur,
    required this.whatsAppActeur,
    required this.latitude,
    required this.longitude,
    required this.photoSiegeActeur,
    required this.logoActeur,
    required this.niveau3PaysActeur,
    required this.password,
    this.dateAjout,
    this.dateModif,
    this.personneModif,
    required this.localiteActeur,
    required this.emailActeur,
    required this.filiereActeur,
    required this.statutActeur,
    required this.typeActeur,
    required this.maillonActeur,
  });

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
    String? filiereActeur,
    bool? statutActeur,
    List<TypeActeur>? typeActeur,
    String? maillonActeur,
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
      filiereActeur: filiereActeur ?? this.filiereActeur,
      statutActeur: statutActeur ?? this.statutActeur,
      typeActeur: typeActeur ?? this.typeActeur,
      maillonActeur: maillonActeur ?? this.maillonActeur,
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
      'filiereActeur': filiereActeur,
      'statutActeur': statutActeur,
      'typeActeur': typeActeur.map((x) => x.toMap()).toList(),
      'maillonActeur': maillonActeur,
    };
  }

  factory Acteur.fromMap(Map<String, dynamic> map) {
    return Acteur(
      idActeur: map['idActeur'] as String?,
      resetToken: map['resetToken'] as String?,
      tokenCreationDate: map['tokenCreationDate'] as String?,
      codeActeur: map['codeActeur'] as String?,
      nomActeur: map['nomActeur'] as String,
      adresseActeur: map['adresseActeur'] as String,
      telephoneActeur: map['telephoneActeur'] as String,
      whatsAppActeur: map['whatsAppActeur'] as String?,
      latitude: map['latitude'] as String?,
      longitude: map['longitude'] as String?,
      photoSiegeActeur: map['photoSiegeActeur'] as String?,
      logoActeur: map['logoActeur'] as String?,
      niveau3PaysActeur: map['niveau3PaysActeur'] as String,
      password: map['password'] as String,
      dateAjout: map['dateAjout'] as String?,
      dateModif: map['dateModif'] as String?,
      personneModif: map['personneModif'] as String?,
      localiteActeur: map['localiteActeur'] as String,
      emailActeur: map['emailActeur'] as String,
      filiereActeur: map['filiereActeur'] as String,
      statutActeur: map['statutActeur'] as bool,
      typeActeur: List<TypeActeur>.from((map['typeActeur'] as List<dynamic>).map((x) => TypeActeur.fromMap(x))),
      maillonActeur: map['maillonActeur'] as String,
    );
  }


  String toJson() => json.encode(toMap());

  factory Acteur.fromJson(String source) => Acteur.fromMap(json.decode(source) as Map<String, dynamic>);

}

