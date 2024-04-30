import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/models/Stock.dart';

class Commande {
  String? idCommande;
  String? codeCommande;
  String? dateCommande;
  final List<Stock>? stock;
  final List<Intrant>? intrant;
  final List<dynamic>? materielList;
  String? photoSignature;
  String? idClient;
  String? idCommercant;
  String? personneAjout;
  String? dateAjout;
  String? personneModif;
   Acteur? acteur;
  String? dateModif;

  Commande({
    this.idCommande,
     this.codeCommande,
     this.dateCommande,
     this.stock,
     this.intrant,
     this.materielList,
     this.photoSignature,
     this.idClient,
     this.idCommercant,
     this.personneAjout,
     this.dateAjout,
     this.personneModif,
     this.acteur,
     this.dateModif,
  });

  factory Commande.fromMap(Map<String, dynamic> map) {
    return Commande(
      idCommande: map['idCommande'] as String?,
      codeCommande: map['codeCommande'] as String,
      dateCommande: map['dateCommande'] as String,
      stock: List<Stock>.from(map['stock'].map((x) => x)),
      intrant: List<Intrant>.from(map['intrant'].map((x) => x)),
      materielList: List<dynamic>.from(
          map['materielList'].map((x) => x)),
      photoSignature: map['photoSignature'] as String?,
      idClient: map['idClient'] as String?,
      idCommercant: map['idCommercant'] as String?,
      personneAjout: map['personneAjout'] as String?,
      dateAjout: map['dateAjout'] as String?,
      personneModif: map['personneModif'] as String?,
      // acteur: map['acteur'] as String?,
      acteur: map['acteur'] != null ? Acteur.fromMap(map['acteur'] as Map<String,dynamic>) : null,
      dateModif: map['dateModif'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idCommande': idCommande,
      'codeCommande': codeCommande,
      'dateCommande': dateCommande,
      'stock': stock,
      'intrant': intrant,
      'materielList': materielList,
      'photoSignature': photoSignature,
      'idClient': idClient,
      'idCommercant': idCommercant,
      'personneAjout': personneAjout,
      'dateAjout': dateAjout,
      'personneModif': personneModif,
       'acteur': acteur?.toJson(),
      'dateModif': dateModif,
    };
  }

  String toJson() => json.encode(toMap());
  //  Map<String, dynamic> toJson() => {
  //       "idCommande": idCommande,
  //       "codeCommande": codeCommande,
  //       "dateCommande": dateCommande,
  //       "stocks": List<dynamic>.from(stock!.map((x) => x)),
  //       "intrants": List<dynamic>.from(intrant!.map((x) => x)),
  //       "dateModif": dateModif,
  //       "acteur": acteur?.toJson(),
  //   };

  factory Commande.fromJson(String source) =>
      Commande.fromMap(json.decode(source));
}
