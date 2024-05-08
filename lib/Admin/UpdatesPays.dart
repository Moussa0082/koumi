import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/models/SousRegion.dart';
import 'package:koumi_app/service/PaysService.dart';
import 'package:provider/provider.dart';

class UpdatesPays extends StatefulWidget {
  final Pays pays;
  const UpdatesPays({super.key, required this.pays});

  @override
  State<UpdatesPays> createState() => _UpdatesPaysState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _UpdatesPaysState extends State<UpdatesPays> {
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late SousRegion sousRegion;
  String? sousValue;
  late Future _sousRegionList;
  late Pays payss;

  @override
  void initState() {
    super.initState();
    _sousRegionList =
        http.get(Uri.parse('https://koumi.ml/api-koumi/sousRegion/read'));
        // http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/sousRegion/read'));
    payss = widget.pays;
    sousValue = payss.sousRegion.idSousRegion;
    libelleController.text = payss.nomPays;
    descriptionController.text = payss.descriptionPays;
    sousRegion = payss.sousRegion;
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
                      labelText: "Nom du pays",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  FutureBuilder(
                    future: _sousRegionList,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return DropdownButtonFormField(
                                  items: [],
                                  onChanged: null,
                                  decoration: InputDecoration(
                                    labelText: 'Chargement ...',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                      }
                      if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      if (snapshot.hasData) {
                        final reponse = json.decode((snapshot.data.body)) as List;
                        final sousList = reponse
                            .map((e) => SousRegion.fromMap(e))
                            .where((con) => con.statutSousRegion == true)
                            .toList();
        
                        if (sousList.isEmpty) {
                          return Text(
                            'Aucun sous region disponible',
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          );
                        }
        
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          items: sousList
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.idSousRegion,
                                  child: Text(e.nomSousRegion),
                                ),
                              )
                              .toList(),
                          value: sousValue,
                          onChanged: (newValue) {
                            setState(() {
                              sousValue = newValue;
                              if (newValue != null) {
                                sousRegion = sousList.firstWhere((element) =>
                                    element.idSousRegion == newValue);
                                debugPrint(
                                    "con select ${sousRegion.idSousRegion.toString()}");
                                // typeSelected = true;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Sélectionner un sous région',
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
                          await PaysService()
                              .updatePays(
                                  idPays: payss.idPays!,
                                  nomPays: libelle,
                                  descriptionPays: description,
                                  sousRegion: sousRegion)
                              .then((value) => {
                                    Provider.of<PaysService>(context,
                                            listen: false)
                                        .applyChange(),
                                    Provider.of<PaysService>(context,
                                            listen: false)
                                        .applyChange(),
                                    libelleController.clear(),
                                    descriptionController.clear(),
                                    setState(() {
                                      sousRegion == null;
                                    }),
                                    Navigator.of(context).pop()
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
                      "Modufuer",
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
