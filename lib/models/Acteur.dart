
import 'package:koumi_app/models/Pays.dart';

import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/TypeActeur.dart';

class Acteur {
   String? idActeur;
    String? resetToken;
    String? tokenCreationDate;
    String? codeActeur;
    String? nomActeur;
    String? adresseActeur;
    String? telephoneActeur;
    String? whatsAppActeur;
    String? latitude;
    String? longitude;
    String? photoSiegeActeur;
    String? logoActeur;
    String? niveau3PaysActeur;
    String? password;
    String? dateAjout;
    String? dateModif;
    String? personneModif;
    String? localiteActeur;
    String? emailActeur;
    bool? statutActeur;
    bool? isConnected;
    List<Speculation>? speculations;
    Pays? pays;
    List<TypeActeur>? typeActeur;

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
         this.isConnected,
         this.speculations,
         this.pays,
         this.typeActeur,
    });

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
        statutActeur: json["statutActeur"],
        isConnected: json["isConnected"],
        pays: Pays.fromJson(json["pays"]),
        speculations: List<Speculation>.from(json["speculations"].map((x) => Speculation.fromJson(x))),
        typeActeur: List<TypeActeur>.from(json["typeActeur"].map((x) => TypeActeur.fromJson(x))),
    );

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
        "statutActeur": statutActeur,
        "isConnected": isConnected,
        "speculations": List<dynamic>.from(speculations!.map((x) => x.toJson())),
        "pays": pays?.toJson(),
        "typeActeur": List<dynamic>.from(typeActeur!.map((x) => x.toJson())),
    };

  // Méthode pour créer une instance d'Acteur à partir des données de SharedPreferences
  factory Acteur.fromSharedPreferencesData(
      String emailActeur,
      String password,
      List<String> userTypeList,
      String idActeur,
      String nomActeur,
      String telephoneActeur,
      String adressActeur,
      String whatsAppActeur,
      String niveau3PaysActeur,
      String localiteActeur) {
    // Créez une liste de TypeActeur à partir de la liste de chaînes userTypeList
    List<TypeActeur> typeActeurList =
        userTypeList.map((libelle) => TypeActeur(libelle: libelle)).toList();

    // Retournez une nouvelle instance d'Acteur avec les données fournies
    return Acteur(
        // Initialiser les autres propriétés de l'acteur selon vos besoins
        emailActeur: emailActeur,
        password: password,
        typeActeur: typeActeurList,
        idActeur: idActeur,
        nomActeur: nomActeur,
        adresseActeur: adressActeur,
        telephoneActeur: telephoneActeur,
        whatsAppActeur: whatsAppActeur,
        niveau3PaysActeur: niveau3PaysActeur,
        localiteActeur: localiteActeur);
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
      'pays':pays?.toMap(),
      'speculations': speculations?.map((x) => x.toMap()).toList(),
      'typeActeur': typeActeur?.map((x) => x.toMap()).toList(),
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


  // factory Acteur.fromJson(String source) => Acteur.fromMap(json.decode(source) as Map<String, dynamic>);

  

 }
