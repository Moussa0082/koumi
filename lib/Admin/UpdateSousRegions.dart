import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Continent.dart';
import 'package:koumi_app/models/SousRegion.dart';
import 'package:koumi_app/service/SousRegionService.dart';
import 'package:provider/provider.dart';

class updateSousRegions extends StatefulWidget {
  final SousRegion sousRegion;
  const updateSousRegions({super.key, required this.sousRegion});

  @override
  State<updateSousRegions> createState() => _updateSousRegionsState();
}

class _updateSousRegionsState extends State<updateSousRegions> {
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  late Continent continents;
  String? continentValue;
  late Future _continentList;
  @override
  void initState() {
    libelleController.text = widget.sousRegion.nomSousRegion;
    continents = widget.sousRegion.continent;
    continentValue = widget.sousRegion.continent.idContinent;
    _continentList =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/continent/read'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Color.fromARGB(255, 250, 250, 250),
      //   borderRadius: BorderRadius.circular(15),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.4),
      //       offset: Offset(0, 4),
      //       blurRadius: 10,
      //       spreadRadius: 2,
      //     ),
      //   ],
      // ),
      padding: const EdgeInsets.all(16),
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
                    labelText: "Nom de la sous-région",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                FutureBuilder(
                  future: _continentList,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    if (snapshot.hasData) {
                      final reponse = json.decode((snapshot.data.body)) as List;
                      final continentList = reponse
                          .map((e) => Continent.fromMap(e))
                          .where((con) => con.statutContinent == true)
                          .toList();

                      if (continentList.isEmpty) {
                        return Text('Aucun continent disponible');
                      }

                      return DropdownButtonFormField<String>(
                        items: continentList
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.idContinent,
                                child: Text(e.nomContinent),
                              ),
                            )
                            .toList(),
                        value: continentValue,
                        onChanged: (newValue) {
                          setState(() {
                            continentValue = newValue;
                            if (newValue != null) {
                              continents = continentList.firstWhere(
                                  (element) => element.idContinent == newValue);
                              debugPrint(
                                  "con select ${continents.idContinent.toString()}");
                              // typeSelected = true;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Sélectionner un continent',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }
                    return Text('Aucune donnée disponible');
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    final String libelle = libelleController.text;
                    if (formkey.currentState!.validate()) {
                      try {
                        await SousRegionService()
                            .updateSousRegion(
                                idSousRegion: widget.sousRegion.idSousRegion!,
                                nomSousRegion: libelle,
                                continent: continents)
                            .then((value) => {
                                  Provider.of<SousRegionService>(context,
                                          listen: false)
                                      .applyChange(),
                                  libelleController.clear(),
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
    );
  }
}
