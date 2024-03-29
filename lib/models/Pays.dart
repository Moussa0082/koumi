import 'dart:convert';

import 'package:koumi_app/models/SousRegion.dart';

class Pays {
  final String? idPays;
  final String codePays;
  final String nomPays;
  final String descriptionPays;
  final String? personneModif;
  final bool statutPays;
  final String? dateAjout;
  final String? dateModif;
  final SousRegion sousRegion;
  Pays({
    this.idPays,
    required this.codePays,
    required this.nomPays,
    required this.descriptionPays,
    this.personneModif,
    required this.statutPays,
    this.dateAjout,
    this.dateModif,
    required this.sousRegion,
  });

  Pays copyWith({
    String? idPays,
    String? codePays,
    String? nomPays,
    String? descriptionPays,
    String? personneModif,
    bool? statutPays,
    String? dateAjout,
    String? dateModif,
    SousRegion? sousRegion,
  }) {
    return Pays(
      idPays: idPays ?? this.idPays,
      codePays: codePays ?? this.codePays,
      nomPays: nomPays ?? this.nomPays,
      descriptionPays: descriptionPays ?? this.descriptionPays,
      personneModif: personneModif ?? this.personneModif,
      statutPays: statutPays ?? this.statutPays,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      sousRegion: sousRegion ?? this.sousRegion,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idPays': idPays,
      'codePays': codePays,
      'nomPays': nomPays,
      'descriptionPays': descriptionPays,
      'personneModif': personneModif,
      'statutPays': statutPays,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'sousRegion': sousRegion.toMap(),
    };
  }

  factory Pays.fromMap(Map<String, dynamic> map) {
    return Pays(
      idPays: map['idPays'] != null ? map['idPays'] as String : null,
      codePays: map['codePays'] as String,
      nomPays: map['nomPays'] as String,
      descriptionPays: map['descriptionPays'] as String,
      personneModif: map['personneModif'] != null ? map['personneModif'] as String : null,
      statutPays: map['statutPays'] as bool,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      sousRegion: SousRegion.fromMap(map['sousRegion'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Pays.fromJson(String source) => Pays.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Pays(idPays: $idPays, codePays: $codePays, nomPays: $nomPays, descriptionPays: $descriptionPays, personneModif: $personneModif, statutPays: $statutPays, dateAjout: $dateAjout, dateModif: $dateModif, sousRegion: $sousRegion)';
  }

  @override
  bool operator ==(covariant Pays other) {
    if (identical(this, other)) return true;
  
    return 
      other.idPays == idPays &&
      other.codePays == codePays &&
      other.nomPays == nomPays &&
      other.descriptionPays == descriptionPays &&
      other.personneModif == personneModif &&
      other.statutPays == statutPays &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.sousRegion == sousRegion;
  }

  @override
  int get hashCode {
    return idPays.hashCode ^
      codePays.hashCode ^
      nomPays.hashCode ^
      descriptionPays.hashCode ^
      personneModif.hashCode ^
      statutPays.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      sousRegion.hashCode;
  }
}
