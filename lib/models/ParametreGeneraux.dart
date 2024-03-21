// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ParametreGeneraux {
   String? idParametreGeneraux;
   String? sigleStructure;
   String? nomStructure;
   String? sigleSysteme;
   String? nomSysteme;
   String? monnaie;
   String? tauxDollar;
   String? tauxYuan;
   String? descriptionSysteme;
   String? sloganSysteme;
   String? logoSysteme;
   String? adresseStructure;
   String? emailStructure;
   String? telephoneStructure;
   String? whattsAppStructure;
   String? libelleNiveau1Pays;
   String? libelleNiveau2Pays;
   String? libelleNiveau3Pays;
   String? codeNiveauStructure;
   String? localiteStructure;
   String? dateAjout;
   String? dateModif;
  ParametreGeneraux({
    this.idParametreGeneraux,
    this.sigleStructure,
    this.nomStructure,
    this.sigleSysteme,
    this.nomSysteme,
    this.monnaie,
    this.tauxDollar,
    this.tauxYuan,
    this.descriptionSysteme,
    this.sloganSysteme,
    this.logoSysteme,
    this.adresseStructure,
    this.emailStructure,
    this.telephoneStructure,
    this.whattsAppStructure,
    this.libelleNiveau1Pays,
    this.libelleNiveau2Pays,
    this.libelleNiveau3Pays,
    this.codeNiveauStructure,
    this.localiteStructure,
    this.dateAjout,
    this.dateModif,
  });
 

  ParametreGeneraux copyWith({
    String? idParametreGeneraux,
    String? sigleStructure,
    String? nomStructure,
    String? sigleSysteme,
    String? nomSysteme,
    String? monnaie,
    String? tauxDollar,
    String? tauxYuan,
    String? descriptionSysteme,
    String? sloganSysteme,
    String? logoSysteme,
    String? adresseStructure,
    String? emailStructure,
    String? telephoneStructure,
    String? whattsAppStructure,
    String? libelleNiveau1Pays,
    String? libelleNiveau2Pays,
    String? libelleNiveau3Pays,
    String? codeNiveauStructure,
    String? localiteStructure,
    String? dateAjout,
    String? dateModif,
  }) {
    return ParametreGeneraux(
      idParametreGeneraux: idParametreGeneraux ?? this.idParametreGeneraux,
      sigleStructure: sigleStructure ?? this.sigleStructure,
      nomStructure: nomStructure ?? this.nomStructure,
      sigleSysteme: sigleSysteme ?? this.sigleSysteme,
      nomSysteme: nomSysteme ?? this.nomSysteme,
      monnaie: monnaie ?? this.monnaie,
      tauxDollar: tauxDollar ?? this.tauxDollar,
      tauxYuan: tauxYuan ?? this.tauxYuan,
      descriptionSysteme: descriptionSysteme ?? this.descriptionSysteme,
      sloganSysteme: sloganSysteme ?? this.sloganSysteme,
      logoSysteme: logoSysteme ?? this.logoSysteme,
      adresseStructure: adresseStructure ?? this.adresseStructure,
      emailStructure: emailStructure ?? this.emailStructure,
      telephoneStructure: telephoneStructure ?? this.telephoneStructure,
      whattsAppStructure: whattsAppStructure ?? this.whattsAppStructure,
      libelleNiveau1Pays: libelleNiveau1Pays ?? this.libelleNiveau1Pays,
      libelleNiveau2Pays: libelleNiveau2Pays ?? this.libelleNiveau2Pays,
      libelleNiveau3Pays: libelleNiveau3Pays ?? this.libelleNiveau3Pays,
      codeNiveauStructure: codeNiveauStructure ?? this.codeNiveauStructure,
      localiteStructure: localiteStructure ?? this.localiteStructure,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idParametreGeneraux': idParametreGeneraux,
      'sigleStructure': sigleStructure,
      'nomStructure': nomStructure,
      'sigleSysteme': sigleSysteme,
      'nomSysteme': nomSysteme,
      'monnaie': monnaie,
      'tauxDollar': tauxDollar,
      'tauxYuan': tauxYuan,
      'descriptionSysteme': descriptionSysteme,
      'sloganSysteme': sloganSysteme,
      'logoSysteme': logoSysteme,
      'adresseStructure': adresseStructure,
      'emailStructure': emailStructure,
      'telephoneStructure': telephoneStructure,
      'whattsAppStructure': whattsAppStructure,
      'libelleNiveau1Pays': libelleNiveau1Pays,
      'libelleNiveau2Pays': libelleNiveau2Pays,
      'libelleNiveau3Pays': libelleNiveau3Pays,
      'codeNiveauStructure': codeNiveauStructure,
      'localiteStructure': localiteStructure,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
    };
  }

  factory ParametreGeneraux.fromMap(Map<String, dynamic> map) {
    return ParametreGeneraux(
      idParametreGeneraux: map['idParametreGeneraux'] != null ? map['idParametreGeneraux'] as String : null,
      sigleStructure: map['sigleStructure'] != null ? map['sigleStructure'] as String : null,
      nomStructure: map['nomStructure'] != null ? map['nomStructure'] as String : null,
      sigleSysteme: map['sigleSysteme'] != null ? map['sigleSysteme'] as String : null,
      nomSysteme: map['nomSysteme'] != null ? map['nomSysteme'] as String : null,
      monnaie: map['monnaie'] != null ? map['monnaie'] as String : null,
      tauxDollar: map['tauxDollar'] != null ? map['tauxDollar'] as String : null,
      tauxYuan: map['tauxYuan'] != null ? map['tauxYuan'] as String : null,
      descriptionSysteme: map['descriptionSysteme'] != null ? map['descriptionSysteme'] as String : null,
      sloganSysteme: map['sloganSysteme'] != null ? map['sloganSysteme'] as String : null,
      logoSysteme: map['logoSysteme'] != null ? map['logoSysteme'] as String : null,
      adresseStructure: map['adresseStructure'] != null ? map['adresseStructure'] as String : null,
      emailStructure: map['emailStructure'] != null ? map['emailStructure'] as String : null,
      telephoneStructure: map['telephoneStructure'] != null ? map['telephoneStructure'] as String : null,
      whattsAppStructure: map['whattsAppStructure'] != null ? map['whattsAppStructure'] as String : null,
      libelleNiveau1Pays: map['libelleNiveau1Pays'] != null ? map['libelleNiveau1Pays'] as String : null,
      libelleNiveau2Pays: map['libelleNiveau2Pays'] != null ? map['libelleNiveau2Pays'] as String : null,
      libelleNiveau3Pays: map['libelleNiveau3Pays'] != null ? map['libelleNiveau3Pays'] as String : null,
      codeNiveauStructure: map['codeNiveauStructure'] != null ? map['codeNiveauStructure'] as String : null,
      localiteStructure: map['localiteStructure'] != null ? map['localiteStructure'] as String : null,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParametreGeneraux.fromJson(String source) => ParametreGeneraux.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ParametreGeneraux(idParametreGeneraux: $idParametreGeneraux, sigleStructure: $sigleStructure, nomStructure: $nomStructure, sigleSysteme: $sigleSysteme, nomSysteme: $nomSysteme, monnaie: $monnaie, tauxDollar: $tauxDollar, tauxYuan: $tauxYuan, descriptionSysteme: $descriptionSysteme, sloganSysteme: $sloganSysteme, logoSysteme: $logoSysteme, adresseStructure: $adresseStructure, emailStructure: $emailStructure, telephoneStructure: $telephoneStructure, whattsAppStructure: $whattsAppStructure, libelleNiveau1Pays: $libelleNiveau1Pays, libelleNiveau2Pays: $libelleNiveau2Pays, libelleNiveau3Pays: $libelleNiveau3Pays, codeNiveauStructure: $codeNiveauStructure, localiteStructure: $localiteStructure, dateAjout: $dateAjout, dateModif: $dateModif)';
  }

  @override
  bool operator ==(covariant ParametreGeneraux other) {
    if (identical(this, other)) return true;
  
    return 
      other.idParametreGeneraux == idParametreGeneraux &&
      other.sigleStructure == sigleStructure &&
      other.nomStructure == nomStructure &&
      other.sigleSysteme == sigleSysteme &&
      other.nomSysteme == nomSysteme &&
      other.monnaie == monnaie &&
      other.tauxDollar == tauxDollar &&
      other.tauxYuan == tauxYuan &&
      other.descriptionSysteme == descriptionSysteme &&
      other.sloganSysteme == sloganSysteme &&
      other.logoSysteme == logoSysteme &&
      other.adresseStructure == adresseStructure &&
      other.emailStructure == emailStructure &&
      other.telephoneStructure == telephoneStructure &&
      other.whattsAppStructure == whattsAppStructure &&
      other.libelleNiveau1Pays == libelleNiveau1Pays &&
      other.libelleNiveau2Pays == libelleNiveau2Pays &&
      other.libelleNiveau3Pays == libelleNiveau3Pays &&
      other.codeNiveauStructure == codeNiveauStructure &&
      other.localiteStructure == localiteStructure &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif;
  }

  @override
  int get hashCode {
    return idParametreGeneraux.hashCode ^
      sigleStructure.hashCode ^
      nomStructure.hashCode ^
      sigleSysteme.hashCode ^
      nomSysteme.hashCode ^
      monnaie.hashCode ^
      tauxDollar.hashCode ^
      tauxYuan.hashCode ^
      descriptionSysteme.hashCode ^
      sloganSysteme.hashCode ^
      logoSysteme.hashCode ^
      adresseStructure.hashCode ^
      emailStructure.hashCode ^
      telephoneStructure.hashCode ^
      whattsAppStructure.hashCode ^
      libelleNiveau1Pays.hashCode ^
      libelleNiveau2Pays.hashCode ^
      libelleNiveau3Pays.hashCode ^
      codeNiveauStructure.hashCode ^
      localiteStructure.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode;
  }
}
