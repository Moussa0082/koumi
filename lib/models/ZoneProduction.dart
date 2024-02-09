// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:koumi_app/models/Acteur.dart';

class ZoneProduction {
  final String? idZoneProduction;
  final String codeZone;
  final String nomZoneProduction;
  final bool statutZoneProduction;
  final String? latitude;
  final String? longitude;
  final String? photoZone;
  final String? dateAjout;
  final String? dateModif;
  final String personneAjout;
  final bool statutZone;
  final Acteur acteur;
  
  ZoneProduction({
    this.idZoneProduction,
    required this.codeZone,
    required this.nomZoneProduction,
    required this.statutZoneProduction,
    this.latitude,
    this.longitude,
    this.photoZone,
    this.dateAjout,
    this.dateModif,
    required this.personneAjout,
    required this.statutZone,
    required this.acteur,
  });

  ZoneProduction copyWith({
    String? idZoneProduction,
    String? codeZone,
    String? nomZoneProduction,
    bool? statutZoneProduction,
    String? latitude,
    String? longitude,
    String? photoZone,
    String? dateAjout,
    String? dateModif,
    String? personneAjout,
    bool? statutZone,
    Acteur? acteur,
  }) {
    return ZoneProduction(
      idZoneProduction: idZoneProduction ?? this.idZoneProduction,
      codeZone: codeZone ?? this.codeZone,
      nomZoneProduction: nomZoneProduction ?? this.nomZoneProduction,
      statutZoneProduction: statutZoneProduction ?? this.statutZoneProduction,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoZone: photoZone ?? this.photoZone,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      personneAjout: personneAjout ?? this.personneAjout,
      statutZone: statutZone ?? this.statutZone,
      acteur: acteur ?? this.acteur,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idZoneProduction': idZoneProduction,
      'codeZone': codeZone,
      'nomZoneProduction': nomZoneProduction,
      'statutZoneProduction': statutZoneProduction,
      'latitude': latitude,
      'longitude': longitude,
      'photoZone': photoZone,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'personneAjout': personneAjout,
      'statutZone': statutZone,
      'acteur': acteur.toMap(),
    };
  }

  factory ZoneProduction.fromMap(Map<String, dynamic> map) {
    return ZoneProduction(
      idZoneProduction: map['idZoneProduction'] != null ? map['idZoneProduction'] as String : null,
      codeZone: map['codeZone'] as String,
      nomZoneProduction: map['nomZoneProduction'] as String,
      statutZoneProduction: map['statutZoneProduction'] as bool,
      latitude: map['latitude'] != null ? map['latitude'] as String : null,
      longitude: map['longitude'] != null ? map['longitude'] as String : null,
      photoZone: map['photoZone'] != null ? map['photoZone'] as String : null,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      personneAjout: map['personneAjout'] as String,
      statutZone: map['statutZone'] as bool,
      acteur: Acteur.fromMap(map['acteur'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ZoneProduction.fromJson(String source) => ZoneProduction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ZoneProduction(idZoneProduction: $idZoneProduction, codeZone: $codeZone, nomZoneProduction: $nomZoneProduction, statutZoneProduction: $statutZoneProduction, latitude: $latitude, longitude: $longitude, photoZone: $photoZone, dateAjout: $dateAjout, dateModif: $dateModif, personneAjout: $personneAjout, statutZone: $statutZone, acteur: $acteur)';
  }

  @override
  bool operator ==(covariant ZoneProduction other) {
    if (identical(this, other)) return true;
  
    return 
      other.idZoneProduction == idZoneProduction &&
      other.codeZone == codeZone &&
      other.nomZoneProduction == nomZoneProduction &&
      other.statutZoneProduction == statutZoneProduction &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.photoZone == photoZone &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.personneAjout == personneAjout &&
      other.statutZone == statutZone &&
      other.acteur == acteur;
  }

  @override
  int get hashCode {
    return idZoneProduction.hashCode ^
      codeZone.hashCode ^
      nomZoneProduction.hashCode ^
      statutZoneProduction.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      photoZone.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      personneAjout.hashCode ^
      statutZone.hashCode ^
      acteur.hashCode;
  }
}
