import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/service/Niveau1Service.dart';
import 'package:provider/provider.dart';

class UpdatesNiveau1 extends StatefulWidget {
  final Niveau1Pays niveau1pays;
  const UpdatesNiveau1({super.key, required this.niveau1pays});

  @override
  State<UpdatesNiveau1> createState() => _UpdatesNiveau1State();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _UpdatesNiveau1State extends State<UpdatesNiveau1> {
  late ParametreGeneraux para;
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late Future<List<Niveau1Pays>> _liste;
  List<ParametreGeneraux> paraList = [];
  late Niveau1Pays niveau;
  String? paysValue;
  late Future _paysList;
  late Pays pays;

  @override
  void initState() {
    super.initState();
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;
    para = paraList[0];
    // _paysList = http.get(Uri.parse('https://koumi.ml/api-koumi/pays/read'));
    _paysList = http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/pays/read'));

    niveau = widget.niveau1pays;
    libelleController.text = niveau.nomN1!;
    descriptionController.text = niveau.descriptionN1!;
    paysValue = niveau.pays!.idPays;
    pays = niveau.pays!;
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
                "Modification",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
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
                      labelText: "Nom du ${para.libelleNiveau1Pays}",
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
                          await Niveau1Service()
                              .updateNiveau1Pays(
                                  idNiveau1Pays: niveau.idNiveau1Pays!,
                                  nomN1: libelle,
                                  descriptionN1: description,
                                  pays: pays)
                              .then((value) => {
                                    Provider.of<Niveau1Service>(context,
                                            listen: false)
                                        .applyChange(),
                                    Provider.of<Niveau1Service>(context,
                                        listen: false),
                                    libelleController.clear(),
                                    descriptionController.clear(),
                                    setState(() {
                                      pays == null;
                                    }),
                                    Navigator.of(context).pop()
                                  })
                              .catchError(
                                  (onError) => {print(onError.toString())});
                        } catch (e) {
                          final String errorMessage = e.toString();
                          print(errorMessage);
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
