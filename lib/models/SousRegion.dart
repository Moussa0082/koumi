import 'dart:convert';

import 'package:koumi_app/models/Continent.dart';

class SousRegion {
  final String? idSousRegion;
  final String codeSousRegion;
  final String nomSousRegion;
  final bool statutSousRegion;
  final String? dateAjout;
  final String? dateModif;
  final Continent continent;
  SousRegion({
    this.idSousRegion,
    required this.codeSousRegion,
    required this.nomSousRegion,
    required this.statutSousRegion,
    this.dateAjout,
    this.dateModif,
    required this.continent,
  });

  SousRegion copyWith({
    String? idSousRegion,
    String? codeSousRegion,
    String? nomSousRegion,
    bool? statutSousRegion,
    String? dateAjout,
    String? dateModif,
    Continent? continent,
  }) {
    return SousRegion(
      idSousRegion: idSousRegion ?? this.idSousRegion,
      codeSousRegion: codeSousRegion ?? this.codeSousRegion,
      nomSousRegion: nomSousRegion ?? this.nomSousRegion,
      statutSousRegion: statutSousRegion ?? this.statutSousRegion,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      continent: continent ?? this.continent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idSousRegion': idSousRegion,
      'codeSousRegion': codeSousRegion,
      'nomSousRegion': nomSousRegion,
      'statutSousRegion': statutSousRegion,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'continent': continent.toMap(),
    };
  }

  factory SousRegion.fromMap(Map<String, dynamic> map) {
    return SousRegion(
      idSousRegion: map['idSousRegion'] != null ? map['idSousRegion'] as String : null,
      codeSousRegion: map['codeSousRegion'] as String,
      nomSousRegion: map['nomSousRegion'] as String,
      statutSousRegion: map['statutSousRegion'] as bool,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      continent: Continent.fromMap(map['continent'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SousRegion.fromJson(String source) => SousRegion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SousRegion(idSousRegion: $idSousRegion, codeSousRegion: $codeSousRegion, nomSousRegion: $nomSousRegion, statutSousRegion: $statutSousRegion, dateAjout: $dateAjout, dateModif: $dateModif, continent: $continent)';
  }

  @override
  bool operator ==(covariant SousRegion other) {
    if (identical(this, other)) return true;
  
    return 
      other.idSousRegion == idSousRegion &&
      other.codeSousRegion == codeSousRegion &&
      other.nomSousRegion == nomSousRegion &&
      other.statutSousRegion == statutSousRegion &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.continent == continent;
  }

  @override
  int get hashCode {
    return idSousRegion.hashCode ^
      codeSousRegion.hashCode ^
      nomSousRegion.hashCode ^
      statutSousRegion.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      continent.hashCode;
  }
}
