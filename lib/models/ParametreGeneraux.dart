import 'dart:convert';

class ParametreGeneraux {
  final String? idParametreGeneraux;
  final String sigleStructure;
  final String nomStructure;
  final String sigleSysteme;
  final String nomSysteme;
  final String descriptionSysteme;
  final String sloganSysteme;
  final String? logoSysteme;
  final String adresseStructure;
  final String emailStructure;
  final String telephoneStructure;
  final String whattsAppStructure;
  final String libelleNiveau1Pays;
  final String libelleNiveau2Pays;
  final String libelleNiveau3Pays;
  final String codeNiveauStructure;
  final String localiteStructure;
  final String? dateAjout;
  final String? dateModif;
  
  ParametreGeneraux({
    this.idParametreGeneraux,
    required this.sigleStructure,
    required this.nomStructure,
    required this.sigleSysteme,
    required this.nomSysteme,
    required this.descriptionSysteme,
    required this.sloganSysteme,
    this.logoSysteme,
    required this.adresseStructure,
    required this.emailStructure,
    required this.telephoneStructure,
    required this.whattsAppStructure,
    required this.libelleNiveau1Pays,
    required this.libelleNiveau2Pays,
    required this.libelleNiveau3Pays,
    required this.codeNiveauStructure,
    required this.localiteStructure,
    this.dateAjout,
    this.dateModif,
  });

  ParametreGeneraux copyWith({
    String? idParametreGeneraux,
    String? sigleStructure,
    String? nomStructure,
    String? sigleSysteme,
    String? nomSysteme,
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
      sigleStructure: map['sigleStructure'] as String,
      nomStructure: map['nomStructure'] as String,
      sigleSysteme: map['sigleSysteme'] as String,
      nomSysteme: map['nomSysteme'] as String,
      descriptionSysteme: map['descriptionSysteme'] as String,
      sloganSysteme: map['sloganSysteme'] as String,
      logoSysteme: map['logoSysteme'] != null ? map['logoSysteme'] as String : null,
      adresseStructure: map['adresseStructure'] as String,
      emailStructure: map['emailStructure'] as String,
      telephoneStructure: map['telephoneStructure'] as String,
      whattsAppStructure: map['whattsAppStructure'] as String,
      libelleNiveau1Pays: map['libelleNiveau1Pays'] as String,
      libelleNiveau2Pays: map['libelleNiveau2Pays'] as String,
      libelleNiveau3Pays: map['libelleNiveau3Pays'] as String,
      codeNiveauStructure: map['codeNiveauStructure'] as String,
      localiteStructure: map['localiteStructure'] as String,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParametreGeneraux.fromJson(String source) => ParametreGeneraux.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ParametreGeneraux(idParametreGeneraux: $idParametreGeneraux, sigleStructure: $sigleStructure, nomStructure: $nomStructure, sigleSysteme: $sigleSysteme, nomSysteme: $nomSysteme, descriptionSysteme: $descriptionSysteme, sloganSysteme: $sloganSysteme, logoSysteme: $logoSysteme, adresseStructure: $adresseStructure, emailStructure: $emailStructure, telephoneStructure: $telephoneStructure, whattsAppStructure: $whattsAppStructure, libelleNiveau1Pays: $libelleNiveau1Pays, libelleNiveau2Pays: $libelleNiveau2Pays, libelleNiveau3Pays: $libelleNiveau3Pays, codeNiveauStructure: $codeNiveauStructure, localiteStructure: $localiteStructure, dateAjout: $dateAjout, dateModif: $dateModif)';
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
