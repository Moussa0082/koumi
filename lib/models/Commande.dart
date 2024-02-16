import 'dart:convert';

class Commande {
  String? idCommande;
  String? codeCommande;
  String? dateCommande;
  final List<dynamic> stock;
  final List<dynamic> materielList;
  String? photoSignature;
  String? idClient;
  String? idCommercant;
  String? personneAjout;
  String? dateAjout;
  String? personneModif;
  String? dateModif;

  Commande({
    this.idCommande,
    required this.codeCommande,
    required this.dateCommande,
    required this.stock,
    required this.materielList,
    required this.photoSignature,
    required this.idClient,
    required this.idCommercant,
    required this.personneAjout,
    required this.dateAjout,
    required this.personneModif,
    required this.dateModif,
  });

  factory Commande.fromMap(Map<String, dynamic> map) {
    return Commande(
      idCommande: map['idCommande'] as String?,
      codeCommande: map['codeCommande'] as String,
      dateCommande: map['dateCommande'] as String,
      stock: List<dynamic>.from(map['stock'].map((x) => x)),
      materielList: List<dynamic>.from(
          map['materielList'].map((x) => x)),
      photoSignature: map['photoSignature'] as String?,
      idClient: map['idClient'] as String?,
      idCommercant: map['idCommercant'] as String?,
      personneAjout: map['personneAjout'] as String?,
      dateAjout: map['dateAjout'] as String?,
      personneModif: map['personneModif'] as String?,
      dateModif: map['dateModif'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idCommande': idCommande,
      'codeCommande': codeCommande,
      'dateCommande': dateCommande,
      'stock': stock,
      'materielList': materielList,
      'photoSignature': photoSignature,
      'idClient': idClient,
      'idCommercant': idCommercant,
      'personneAjout': personneAjout,
      'dateAjout': dateAjout,
      'personneModif': personneModif,
      'dateModif': dateModif,
    };
  }

  String toJson() => json.encode(toMap());

  factory Commande.fromJson(String source) =>
      Commande.fromMap(json.decode(source));
}
