import 'dart:convert';

import 'package:koumi_app/models/ParametreFiche.dart';

class RegroupementParametre {
  final String idRegroupement;
  final String parametreRegroupe;
  final String libelle;
  final DateTime dateAjout;
  final DateTime dateModif;
  final bool statutRegroupement;
  final ParametreFiche parametreFiche;
  RegroupementParametre({
    required this.idRegroupement,
    required this.parametreRegroupe,
    required this.libelle,
    required this.dateAjout,
    required this.dateModif,
    required this.statutRegroupement,
    required this.parametreFiche,
  });

  RegroupementParametre copyWith({
    String? idRegroupement,
    String? parametreRegroupe,
    String? libelle,
    DateTime? dateAjout,
    DateTime? dateModif,
    bool? statutRegroupement,
    ParametreFiche? parametreFiche,
  }) {
    return RegroupementParametre(
      idRegroupement: idRegroupement ?? this.idRegroupement,
      parametreRegroupe: parametreRegroupe ?? this.parametreRegroupe,
      libelle: libelle ?? this.libelle,
      dateAjout: dateAjout ?? this.dateAjout,
      dateModif: dateModif ?? this.dateModif,
      statutRegroupement: statutRegroupement ?? this.statutRegroupement,
      parametreFiche: parametreFiche ?? this.parametreFiche,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idRegroupement': idRegroupement,
      'parametreRegroupe': parametreRegroupe,
      'libelle': libelle,
      'dateAjout': dateAjout.millisecondsSinceEpoch,
      'dateModif': dateModif.millisecondsSinceEpoch,
      'statutRegroupement': statutRegroupement,
      'parametreFiche': parametreFiche.toJson(),
    };
  }

  factory RegroupementParametre.fromMap(Map<String, dynamic> map) {
    return RegroupementParametre(
      idRegroupement: map['idRegroupement'] as String,
      parametreRegroupe: map['parametreRegroupe'] as String,
      libelle: map['libelle'] as String,
      dateAjout: DateTime.fromMillisecondsSinceEpoch(map['dateAjout'] as int),
      dateModif: DateTime.fromMillisecondsSinceEpoch(map['dateModif'] as int),
      statutRegroupement: map['statutRegroupement'] as bool,
      parametreFiche: ParametreFiche.fromJson(map['parametreFiche'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory RegroupementParametre.fromJson(String source) => RegroupementParametre.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RegroupementParametre(idRegroupement: $idRegroupement, parametreRegroupe: $parametreRegroupe, libelle: $libelle, dateAjout: $dateAjout, dateModif: $dateModif, statutRegroupement: $statutRegroupement, parametreFiche: $parametreFiche)';
  }

  @override
  bool operator ==(covariant RegroupementParametre other) {
    if (identical(this, other)) return true;
  
    return 
      other.idRegroupement == idRegroupement &&
      other.parametreRegroupe == parametreRegroupe &&
      other.libelle == libelle &&
      other.dateAjout == dateAjout &&
      other.dateModif == dateModif &&
      other.statutRegroupement == statutRegroupement &&
      other.parametreFiche == parametreFiche;
  }

  @override
  int get hashCode {
    return idRegroupement.hashCode ^
      parametreRegroupe.hashCode ^
      libelle.hashCode ^
      dateAjout.hashCode ^
      dateModif.hashCode ^
      statutRegroupement.hashCode ^
      parametreFiche.hashCode;
  }
}
