// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:koumi_app/models/Commande.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/models/Stock.dart';


class DetailCommande {

 String? idDetailCommande;
    String? codeProduit;
    int? quantiteDemande;
    int? quantiteLivree;
    int? quantiteNonLivree;
    String? nomProduit;
    String? dateAjout;
    bool? isStock;
    Commande? commande;
    Stock? stock;
    Intrant? intrant;
  DetailCommande({
    this.idDetailCommande,
    this.codeProduit,
    this.quantiteDemande,
    this.quantiteLivree,
    this.quantiteNonLivree,
    this.nomProduit,
    this.dateAjout,
    this.isStock,
    this.commande,
    this.stock,
    this.intrant,
  });

  DetailCommande copyWith({
    String? idDetailCommande,
    String? codeProduit,
    int? quantiteDemande,
    int? quantiteLivree,
    int? quantiteNonLivree,
    String? nomProduit,
    String? dateAjout,
    Commande? commande,
    Stock? stock,
    Intrant? intrant,
  }) {
    return DetailCommande(
      idDetailCommande: idDetailCommande ?? this.idDetailCommande,
      codeProduit: codeProduit ?? this.codeProduit,
      quantiteDemande: quantiteDemande ?? this.quantiteDemande,
      quantiteLivree: quantiteLivree ?? this.quantiteLivree,
      quantiteNonLivree: quantiteNonLivree ?? this.quantiteNonLivree,
      nomProduit: nomProduit ?? this.nomProduit,
      dateAjout: dateAjout ?? this.dateAjout,
      commande: commande ?? this.commande,
      stock: stock ?? this.stock,
      intrant: intrant ?? this.intrant,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idDetailCommande': idDetailCommande,
      'codeProduit': codeProduit,
      'quantiteDemande': quantiteDemande,
      'quantiteLivree': quantiteLivree,
      'quantiteNonLivree': quantiteNonLivree,
      'nomProduit': nomProduit,
      'dateAjout': dateAjout,
      'isStock': isStock,
      'commande': commande?.toMap(),
      'stock': stock?.toMap(),
      'intrant': intrant?.toMap(),
    };
  }

  factory DetailCommande.fromMap(Map<String, dynamic> map) {
    return DetailCommande(
      idDetailCommande: map['idDetailCommande'] != null ? map['idDetailCommande'] as String : null,
      codeProduit: map['codeProduit'] != null ? map['codeProduit'] as String : null,
      quantiteDemande: map['quantiteDemande'] != null ? map['quantiteDemande'] as int : null,
      quantiteLivree: map['quantiteLivree'] != null ? map['quantiteLivree'] as int : null,
      quantiteNonLivree: map['quantiteNonLivree'] != null ? map['quantiteNonLivree'] as int : null,
      nomProduit: map['nomProduit'] != null ? map['nomProduit'] as String : null,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      isStock: map['isStock'] != null ? map['isStock'] as bool : false,
      commande: map['commande'] != null ? Commande.fromMap(map['commande'] as Map<String,dynamic>) : null,
      stock: map['stock'] != null ? Stock.fromMap(map['stock'] as Map<String,dynamic>) : null,
      intrant: map['intrant'] != null ? Intrant.fromMap(map['intrant'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailCommande.fromJson(String source) => DetailCommande.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DetailCommande(idDetailCommande: $idDetailCommande, codeProduit: $codeProduit, quantiteDemande: $quantiteDemande, quantiteLivree: $quantiteLivree, quantiteNonLivree: $quantiteNonLivree, nomProduit: $nomProduit, dateAjout: $dateAjout, isStock : $isStock, commande: $commande, stock: $stock, intrant: $intrant)';
  }

  @override
  bool operator ==(covariant DetailCommande other) {
    if (identical(this, other)) return true;
  
    return 
      other.idDetailCommande == idDetailCommande &&
      other.codeProduit == codeProduit &&
      other.quantiteDemande == quantiteDemande &&
      other.quantiteLivree == quantiteLivree &&
      other.quantiteNonLivree == quantiteNonLivree &&
      other.nomProduit == nomProduit &&
      other.dateAjout == dateAjout &&
      other.isStock == isStock &&
      other.commande == commande &&
      other.stock == stock &&
      other.intrant == intrant;
  }

  @override
  int get hashCode {
    return idDetailCommande.hashCode ^
      codeProduit.hashCode ^
      quantiteDemande.hashCode ^
      quantiteLivree.hashCode ^
      quantiteNonLivree.hashCode ^
      nomProduit.hashCode ^
      dateAjout.hashCode ^
      isStock.hashCode ^
      commande.hashCode ^
      stock.hashCode ^
      intrant.hashCode;
  }

  
}
