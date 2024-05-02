import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/models/Stock.dart';

class Commande {
  String? idCommande;
  String? codeCommande;
  String? dateCommande;
  final bool? statutCommande;
  final bool? statutCommandeLivrer;
  final bool? statutConfirmation;
  List<Stock>? stock;
  List<Intrant>? intrant;
  List<dynamic>? materielList;
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
     this.statutCommande,
     this.statutCommandeLivrer,
     this.statutConfirmation,
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
      statutCommande: map['statutCommande'] as bool,
      statutCommandeLivrer: map['statutCommandeLivrer'] as bool,
      statutConfirmation: map['statutConfirmation'] as bool,
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
      'statutCommande': statutCommande,
      'statutCommandeLivrer': statutCommandeLivrer,
      'statutConfirmation': statutConfirmation,
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


  factory Commande.fromJson(String source) =>
      Commande.fromMap(json.decode(source));
}
