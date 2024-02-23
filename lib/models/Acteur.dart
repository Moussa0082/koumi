import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:koumi_app/models/TypeActeur.dart';

class Acteur {
 String? idActeur;
    String? resetToken;
    String? tokenCreationDate;
    String? codeActeur;
    String nomActeur;
    String adresseActeur;
    String telephoneActeur;
    String whatsAppActeur;
    String? latitude;
    String? longitude;
    String? photoSiegeActeur;
    String? logoActeur;
    String niveau3PaysActeur;
    String password;
    String? dateAjout;
    String? dateModif;
    String? personneModif;
    String localiteActeur;
    String emailActeur;
    String filiereActeur;
    bool? statutActeur;
    List<TypeActeur> typeActeur;
    String maillonActeur;
  
  Acteur({
    this.idActeur,
    this.resetToken,
    this.tokenCreationDate,
     this.codeActeur,
    required this.nomActeur,
    required this.adresseActeur,
    required this.telephoneActeur,
    required this.whatsAppActeur,
     this.latitude,
     this.longitude,
     this.photoSiegeActeur,
     this.logoActeur,
    required this.niveau3PaysActeur,
    required this.password,
    this.dateAjout,
    this.dateModif,
    this.personneModif,
    required this.localiteActeur,
    required this.emailActeur,
    required this.filiereActeur,
     this.statutActeur,
    required this.typeActeur,
    required this.maillonActeur,
  });

  
 Acteur acteurFromJson(String str) => Acteur.fromJson(json.decode(str));

 String acteurToJson(Acteur data) => json.encode(data.toJson());
  
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

    Map<String, dynamic> toJson() => {
        "idActeur": idActeur,
        "resetToken": resetToken,
        "tokenCreationDate": tokenCreationDate,
        "codeActeur": codeActeur,
        "nomActeur": nomActeur,
        "adresseActeur": adresseActeur,
        "telephoneActeur": telephoneActeur,
        "whatsAppActeur": whatsAppActeur,
        "latitude": latitude,
        "longitude": longitude,
        "photoSiegeActeur": photoSiegeActeur,
        "logoActeur": logoActeur,
        "niveau3PaysActeur": niveau3PaysActeur,
        "password": password,
        "dateAjout": dateAjout,
        "dateModif": dateModif,
        "personneModif": personneModif,
        "localiteActeur": localiteActeur,
        "emailActeur": emailActeur,
        "filiereActeur": filiereActeur,
        "statutActeur": statutActeur,
        // 'typeActeur': typeActeur.map((type) => type.toJson()).toList(),

        "typeActeur": List<dynamic>.from(typeActeur.map((x) => x.toJson())),
        "maillonActeur": maillonActeur,
    };

 
    factory Acteur.fromJson(Map<String, dynamic> json) => Acteur(
        idActeur: json["idActeur"],
        resetToken: json["resetToken"],
        tokenCreationDate: json["tokenCreationDate"],
        codeActeur: json["codeActeur"],
        nomActeur: json["nomActeur"],
        adresseActeur: json["adresseActeur"],
        telephoneActeur: json["telephoneActeur"],
        whatsAppActeur: json["whatsAppActeur"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        photoSiegeActeur: json["photoSiegeActeur"],
        logoActeur: json["logoActeur"],
        niveau3PaysActeur: json["niveau3PaysActeur"],
        password: json["password"],
        dateAjout: json["dateAjout"],
        dateModif: json["dateModif"],
        personneModif: json["personneModif"],
        localiteActeur: json["localiteActeur"],
        emailActeur: json["emailActeur"],
        filiereActeur: json["filiereActeur"],
        statutActeur: json["statutActeur"],
       typeActeur: (json['typeActeur'] as List)
          .map((type) => TypeActeur.fromJson(type))
          .toList(), 
          // typeActeur: List<TypeActeur>.from(json["typeActeur"].map((x) => TypeActeur.fromJson(x))),
        maillonActeur: json["maillonActeur"],
    );

   
  factory Acteur.fromMap(Map<String, dynamic> map) {
    return Acteur(
      idActeur: map['idActeur'] as String?,
      resetToken: map['resetToken'] as String?,
      tokenCreationDate: map['tokenCreationDate'] as String?,
      codeActeur: map['codeActeur'] as String?,
      nomActeur: map['nomActeur'] as String,
      adresseActeur: map['adresseActeur'] as String,
      telephoneActeur: map['telephoneActeur'] as String,
      whatsAppActeur: map['whatsAppActeur'] as String,
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
      statutActeur: map['statutActeur'] as bool?,
      typeActeur: List<TypeActeur>.from((map['typeActeur'] as List<dynamic>).map((x) => TypeActeur.fromMap(x))),
      maillonActeur: map['maillonActeur'] as String,
    );
  }


  // factory Acteur.fromJson(String source) => Acteur.fromMap(json.decode(source) as Map<String, dynamic>);

}

