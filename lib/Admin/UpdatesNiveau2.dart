import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/models/Niveau2Pays.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/service/Niveau2Service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UpdatesNiveau2 extends StatefulWidget {
  final Niveau2Pays niveau2pays;
  const UpdatesNiveau2({super.key, required this.niveau2pays});

  @override
  State<UpdatesNiveau2> createState() => _UpdatesNiveau2State();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _UpdatesNiveau2State extends State<UpdatesNiveau2> {
  late ParametreGeneraux para;
  List<Niveau2Pays> niveauList = [];
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late Future<List<Niveau2Pays>> _liste;
  List<ParametreGeneraux> paraList = [];
  late Niveau2Pays niveau;
  late Acteur acteur;
  late Niveau1Pays niveau1;
  late Pays pays;
  String? paysValue;
  late Future _paysList;
  String? n1Value;
  late Future _niveauList;

  @override
  void initState() {
    super.initState();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;
    para = paraList[0];
    _paysList = http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/pays/read'));
    _niveauList =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read'));
    niveau = widget.niveau2pays;
    libelleController.text = niveau.nomN2;
    descriptionController.text = niveau.descriptionN2;
    niveau1 = niveau.niveau1Pays;
    n1Value = niveau.niveau1Pays.idNiveau1Pays;
    paysValue = niveau.niveau1Pays.pays!.idPays;
    pays = niveau.niveau1Pays.pays!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(
                "Ajouter un(e) ${para.libelleNiveau2Pays}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 24,
                ),
              ),
            ),
            SizedBox(height: 16),
            Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez remplir ce champ";
                      }
                      return null;
                    },
                    controller: libelleController,
                    decoration: InputDecoration(
                      labelText: "Nom du ${para.libelleNiveau2Pays}",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  FutureBuilder(
                    future: _paysList,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      if (snapshot.hasData) {
                        final reponse = json.decode((snapshot.data.body)) as List;
                        final paysList = reponse
                            .map((e) => Pays.fromMap(e))
                            .where((con) => con.statutPays == true)
                            .toList();
        
                        if (paysList.isEmpty) {
                          return Text(
                            'Aucun donné disponible',
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          );
                        }
        
                        return DropdownButtonFormField<String>(
                          items: paysList
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.idPays,
                                  child: Text(e.nomPays),
                                ),
                              )
                              .toList(),
                          value: paysValue,
                          onChanged: (newValue) {
                            setState(() {
                              paysValue = newValue;
                              if (newValue != null) {
                                pays = paysList.firstWhere(
                                    (element) => element.idPays == newValue);
        
                                // typeSelected = true;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Sélectionner un pays',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }
                      return Text(
                        'Aucune donnée disponible',
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  FutureBuilder(
                    future: _niveauList,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      if (snapshot.hasData) {
                        final reponse = json.decode((snapshot.data.body)) as List;
                        final niveauList = reponse
                            .map((e) => Niveau1Pays.fromMap(e))
                            .where((con) => con.statutN1 == true)
                            .toList();
        
                        if (niveauList.isEmpty) {
                          return Text(
                            'Aucun donné disponible',
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          );
                        }
        
                        return DropdownButtonFormField<String>(
                          items: niveauList
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.idNiveau1Pays,
                                  child: Text(e.nomN1!),
                                ),
                              )
                              .toList(),
                          value: n1Value,
                          onChanged: (newValue) {
                            setState(() {
                              paysValue = newValue;
                              if (newValue != null) {
                                niveau1 = niveauList.firstWhere((element) =>
                                    element.idNiveau1Pays == newValue);
                                debugPrint(
                                    "niveau select :${niveau1.toString()}");
                                // typeSelected = true;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            labelText:
                                'Sélectionner un ${para.libelleNiveau2Pays}',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }
                      return Text(
                        'Aucune donnée disponible',
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez remplir ce champ";
                      }
                      return null;
                    },
                    controller: descriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final String libelle = libelleController.text;
                      final String description = descriptionController.text;
                      if (formkey.currentState!.validate()) {
                        try {
                          await Niveau2Service()
                              .updateNiveau2Pays(
                                  idNiveau2Pays: niveau.idNiveau2Pays!,
                                  nomN2: libelle,
                                  descriptionN2: description,
                                  personeModif: acteur.nomActeur!,
                                  niveau1Pays: niveau1)
                              .then((value) => {
                                    Provider.of<Niveau2Service>(context,
                                            listen: false)
                                        .applyChange(),
                                    libelleController.clear(),
                                    descriptionController.clear(),
                                    Navigator.of(context).pop(),
                                    setState(() {
                                      pays == null;
                                      niveau1 == null;
                                    }),
                                  });
                        } catch (e) {
                          final String errorMessage = e.toString();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Row(
                                children: [
                                  Text("Une erreur s'est produit"),
                                ],
                              ),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Orange color code
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(290, 45),
                    ),
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Modifier",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
