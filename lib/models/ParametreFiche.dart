import 'package:meta/meta.dart';
import 'dart:convert';

class ParametreFiche {
  final String idParametreFiche;
  final String classeParametre;
  final String champParametre;
  final String codeParametre;
  final String libelleParametre;
  final String typeDonneeParametre;
  final List<String> listeDonneeParametre;
  final int valeurMax;
  final int valeurMin;
  final int valeurObligatoire;
  final DateTime dateAjout;
  final DateTime dateModif;
  final String critereChampParametre;
  final bool statutParametre;

  ParametreFiche({
    required this.idParametreFiche,
    required this.classeParametre,
    required this.champParametre,
    required this.codeParametre,
    required this.libelleParametre,
    required this.typeDonneeParametre,
    required this.listeDonneeParametre,
    required this.valeurMax,
    required this.valeurMin,
    required this.valeurObligatoire,
    required this.dateAjout,
    required this.dateModif,
    required this.critereChampParametre,
    required this.statutParametre,
  });

  ParametreFiche copyWith({
    String? idParametreFiche,
    String? classeParametre,
    String? champParametre,
    String? codeParametre,
    String? libelleParametre,
    String? typeDonneeParametre,
    List<String>? listeDonneeParametre,
    int? valeurMax,
    int? valeurMin,
    int? valeurObligatoire,
    DateTime? dateAjout,
    DateTime? dateModif,
    String? critereChampParametre,
    bool? statutParametre,
  }) =>
      ParametreFiche(
        idParametreFiche: idParametreFiche ?? this.idParametreFiche,
        classeParametre: classeParametre ?? this.classeParametre,
        champParametre: champParametre ?? this.champParametre,
        codeParametre: codeParametre ?? this.codeParametre,
        libelleParametre: libelleParametre ?? this.libelleParametre,
        typeDonneeParametre: typeDonneeParametre ?? this.typeDonneeParametre,
        listeDonneeParametre: listeDonneeParametre ?? this.listeDonneeParametre,
        valeurMax: valeurMax ?? this.valeurMax,
        valeurMin: valeurMin ?? this.valeurMin,
        valeurObligatoire: valeurObligatoire ?? this.valeurObligatoire,
        dateAjout: dateAjout ?? this.dateAjout,
        dateModif: dateModif ?? this.dateModif,
        critereChampParametre:
            critereChampParametre ?? this.critereChampParametre,
        statutParametre: statutParametre ?? this.statutParametre,
      );

  factory ParametreFiche.fromRawJson(String str) =>
      ParametreFiche.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ParametreFiche.fromJson(Map<String, dynamic> json) => ParametreFiche(
        idParametreFiche: json["idParametreFiche"],
        classeParametre: json["classeParametre"],
        champParametre: json["champParametre"],
        codeParametre: json["codeParametre"],
        libelleParametre: json["libelleParametre"],
        typeDonneeParametre: json["typeDonneeParametre"],
        listeDonneeParametre:
            List<String>.from(json["listeDonneeParametre"].map((x) => x)),
        valeurMax: json["valeurMax"],
        valeurMin: json["valeurMin"],
        valeurObligatoire: json["valeurObligatoire"],
        dateAjout: DateTime.parse(json["dateAjout"]),
        dateModif: DateTime.parse(json["dateModif"]),
        critereChampParametre: json["critereChampParametre"],
        statutParametre: json["statutParametre"],
      );

  Map<String, dynamic> toJson() => {
        "idParametreFiche": idParametreFiche,
        "classeParametre": classeParametre,
        "champParametre": champParametre,
        "codeParametre": codeParametre,
        "libelleParametre": libelleParametre,
        "typeDonneeParametre": typeDonneeParametre,
        "listeDonneeParametre":
            List<dynamic>.from(listeDonneeParametre.map((x) => x)),
        "valeurMax": valeurMax,
        "valeurMin": valeurMin,
        "valeurObligatoire": valeurObligatoire,
        "dateAjout": dateAjout.toIso8601String(),
        "dateModif": dateModif.toIso8601String(),
        "critereChampParametre": critereChampParametre,
        "statutParametre": statutParametre,
      };
}
