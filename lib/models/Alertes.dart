import 'dart:convert';

class Alertes {
  final String? idAlerte;
  final String? codeAlerte;
  final String titreAlerte;
  final String? videoAlerte;
  final String? photoAlerte;
  final String? dateAjout;
  final String? dateModif;
  final String? personneModif;
  final String descriptionAlerte;
  final String? audioAlerte;
  final bool statutAlerte;

  Alertes({
    this.idAlerte,
    this.codeAlerte,
    required this.titreAlerte,
    this.videoAlerte,
    this.photoAlerte,
    this.dateAjout,
    this.dateModif,
    this.personneModif,
    required this.descriptionAlerte,
    this.audioAlerte,
    required this.statutAlerte,
  });

  Alertes copyWith({
    String? idAlerte,
    String? codeAlerte,
    String? titreAlerte,
    String? videoAlerte,
    String? photoAlerte,
    String? dateAjout,
    String? dateModif,
    String? personneModif,
    String? descriptionAlerte,
    String? audioAlerte,
    bool? statutAlerte,
  }) {
    return Alertes(
      idAlerte: idAlerte ?? this.idAlerte,
      codeAlerte: codeAlerte ?? this.codeAlerte,
      titreAlerte: titreAlerte ?? this.titreAlerte,
      videoAlerte: videoAlerte ?? this.videoAlerte,
      photoAlerte: photoAlerte ?? this.photoAlerte,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      personneModif: personneModif ?? this.personneModif,
      descriptionAlerte: descriptionAlerte ?? this.descriptionAlerte,
      audioAlerte: audioAlerte ?? this.audioAlerte,
      statutAlerte: statutAlerte ?? this.statutAlerte,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idAlerte': idAlerte,
      'codeAlerte': codeAlerte,
      'titreAlerte': titreAlerte,
      'videoAlerte': videoAlerte,
      'photoAlerte': photoAlerte,
      'dateAjout': dateAjout,
      'dateModif': dateModif,
      'personneModif': personneModif,
      'descriptionAlerte': descriptionAlerte,
      'audioAlerte': audioAlerte,
      'statutAlerte': statutAlerte,
    };
  }

  factory Alertes.fromMap(Map<String, dynamic> map) {
    return Alertes(
      idAlerte: map['idAlerte'] != null ? map['idAlerte'] as String : null,
      codeAlerte: map['codeAlerte'] != null ? map['codeAlerte'] as String : null,
      titreAlerte: map['titreAlerte'] as String,
      videoAlerte: map['videoAlerte'] != null ? map['videoAlerte'] as String : null,
      photoAlerte: map['photoAlerte'] != null ? map['photoAlerte'] as String : null,
      dateAjout: map['dateAjout'] != null ? map['dateAjout'] as String : null,
      dateModif: map['dateModif'] != null ? map['dateModif'] as String : null,
      personneModif: map['personneModif'] != null ? map['personneModif'] as String : null,
      descriptionAlerte: map['descriptionAlerte'] as String,
      audioAlerte: map['audioAlerte'] != null ? map['audioAlerte'] as String : null,
      statutAlerte: map['statutAlerte'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Alertes.fromJson(String source) => Alertes.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Alertes(idAlerte: $idAlerte, codeAlerte: $codeAlerte, titreAlerte: $titreAlerte, videoAlerte: $videoAlerte, photoAlerte: $photoAlerte, dateAjout: $dateAjout, dateModif: $dateModif, personneModif: $personneModif, descriptionAlerte: $descriptionAlerte, audioAlerte: $audioAlerte, statutAlerte: $statutAlerte)';
  }

  @override
  bool operator ==(covariant Alertes other) {
    if (identical(this, other)) return true;
  
    return 
      other.idAlerte == idAlerte &&
      other.codeAlerte == codeAlerte &&
      other.titreAlerte == titreAlerte &&
      other.videoAlerte == videoAlerte &&
      other.photoAlerte == photoAlerte &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.personneModif == personneModif &&
      other.descriptionAlerte == descriptionAlerte &&
      other.audioAlerte == audioAlerte &&
      other.statutAlerte == statutAlerte;
  }

  @override
  int get hashCode {
    return idAlerte.hashCode ^
      codeAlerte.hashCode ^
      titreAlerte.hashCode ^
      videoAlerte.hashCode ^
      photoAlerte.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      personneModif.hashCode ^
      descriptionAlerte.hashCode ^
      audioAlerte.hashCode ^
      statutAlerte.hashCode;
  }
}