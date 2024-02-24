import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/Admin/UpdateSousRegions.dart';
import 'package:koumi_app/models/Continent.dart';
import 'package:koumi_app/models/SousRegion.dart';
import 'package:koumi_app/service/SousRegionService.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SousRegionPage extends StatefulWidget {
  // final Continent continent;
  const SousRegionPage({super.key});

  @override
  State<SousRegionPage> createState() => _SousRegionPageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _SousRegionPageState extends State<SousRegionPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  late Continent continents;
  String? continentValue;
  List<SousRegion> regionList = [];
  late Future<List<SousRegion>> _liste;
  late Future _continentList;
  // Future<List<SousRegion>> getSousRegionListe() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   return await SousRegionService()
  //       .fetchSousRegionByContinent(continents.idContinent!);
  // }

  @override
  void initState() {
    // continents = widget.continent;
    // _liste = getSousRegionListe();
    _continentList =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/continent/read'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 100,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
          title: const Text(
            "Sous regions",
            style: TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _showDialog();
              },
              icon: const Icon(
                Icons.add,
                color: d_colorGreen,
                size: 30,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Consumer<SousRegionService>(
              builder: (context, sousService, child) {
                return FutureBuilder(
                    future: sousService.fetchSousRegion(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(10),
                          child:
                              Center(child: Text("Aucun sous region trouvé")),
                        );
                      } else {
                        regionList = snapshot.data!;
                        return Column(
                            children: regionList
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      child: Container(
                                        height: 150,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              offset: const Offset(0, 2),
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            ListTile(
                                                leading: Image.asset(
                                                  "assets/images/sous.png",
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                title: Text(
                                                    e.nomSousRegion
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                                subtitle: Text(
                                                    e.continent.nomContinent,
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ))),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Nombres pays :",
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      )),
                                                  Text("10",
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  _buildEtat(
                                                      e.statutSousRegion),
                                                  PopupMenuButton<String>(
                                                    padding: EdgeInsets.zero,
                                                    itemBuilder: (context) =>
                                                        <PopupMenuEntry<
                                                            String>>[
                                                      PopupMenuItem<String>(
                                                        child: ListTile(
                                                          leading: const Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                          title: const Text(
                                                            "Activer",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            await SousRegionService()
                                                                .activerSousRegion(e
                                                                    .idSousRegion!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<SousRegionService>(context, listen: false)
                                                                              .applyChange(),
                                                                          // setState(() {
                                                                          //   _liste = SousRegionService().fetchSousRegionByContinent(continents.idContinent!);
                                                                          // }),
                                                                          Navigator.of(context)
                                                                              .pop(),
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                              content: Row(
                                                                                children: [
                                                                                  Text("Activer avec succèss "),
                                                                                ],
                                                                              ),
                                                                              duration: Duration(seconds: 2),
                                                                            ),
                                                                          )
                                                                        })
                                                                .catchError(
                                                                    (onError) =>
                                                                        {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                              content: Row(
                                                                                children: [
                                                                                  Text("Une erreur s'est produit"),
                                                                                ],
                                                                              ),
                                                                              duration: Duration(seconds: 5),
                                                                            ),
                                                                          ),
                                                                          Navigator.of(context)
                                                                              .pop(),
                                                                        });
                                                          },
                                                        ),
                                                      ),
                                                      PopupMenuItem<String>(
                                                        child: ListTile(
                                                          leading: Icon(
                                                            Icons
                                                                .disabled_visible,
                                                            color: Colors
                                                                .orange[400],
                                                          ),
                                                          title: Text(
                                                            "Désactiver",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .orange[400],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            await SousRegionService()
                                                                .desactiverSousRegion(e
                                                                    .idSousRegion!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<SousRegionService>(context, listen: false)
                                                                              .applyChange(),
                                                                          Navigator.of(context)
                                                                              .pop(),
                                                                        })
                                                                .catchError(
                                                                    (onError) =>
                                                                        {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                              content: Row(
                                                                                children: [
                                                                                  Text("Une erreur s'est produit"),
                                                                                ],
                                                                              ),
                                                                              duration: Duration(seconds: 5),
                                                                            ),
                                                                          ),
                                                                          Navigator.of(context)
                                                                              .pop(),
                                                                        });

                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Row(
                                                                  children: [
                                                                    Text(
                                                                        "Désactiver avec succèss "),
                                                                  ],
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      PopupMenuItem<String>(
                                                        child: ListTile(
                                                          leading: const Icon(
                                                            Icons.edit,
                                                            color: Colors.green,
                                                          ),
                                                          title: const Text(
                                                            "Modifier",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            // Ouvrir la boîte de dialogue de modification
                                                            var updatedSousRegion =
                                                                await showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  AlertDialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                ),
                                                                content:
                                                                    updateSousRegions(
                                                                        sousRegion:
                                                                            e),
                                                              ),
                                                            );

                                                            // Si les détails sont modifiés, appliquer les changements
                                                            if (updatedSousRegion !=
                                                                null) {
                                                              Provider.of<SousRegionService>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .applyChange();
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      PopupMenuItem<String>(
                                                        child: ListTile(
                                                          leading: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                          title: const Text(
                                                            "Supprimer",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            await SousRegionService()
                                                                .deleteSousRegion(e
                                                                    .idSousRegion!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<SousRegionService>(context, listen: false)
                                                                              .applyChange(),
                                                                          Navigator.of(context)
                                                                              .pop(),
                                                                        })
                                                                .catchError(
                                                                    (onError) =>
                                                                        {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                              content: Row(
                                                                                children: [
                                                                                  Text("Impossible de supprimer"),
                                                                                ],
                                                                              ),
                                                                              duration: Duration(seconds: 2),
                                                                            ),
                                                                          )
                                                                        });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList());
                      }
                    });
              },
            ),
          ]),
        ));
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 250, 250, 250),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0, 2),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: Text(
                    "Ajouter une sous region",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20,
                      ))),
              const SizedBox(height: 10),
              Form(
                key: formkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez remplir les champs";
                          }
                          return null;
                        },
                        controller: libelleController,
                        decoration: InputDecoration(
                          hintText: "Nom de sous région",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: const Offset(0, 2),
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FutureBuilder(
                          future: _continentList,
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: DropdownButton(
                                    dropdownColor: Colors.orange,
                                    items: [],
                                    onChanged: (value) {}),
                              );
                            }
                            if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            if (snapshot.hasData) {
                              final reponse =
                                  json.decode((snapshot.data.body)) as List;
                              final continentList = reponse
                                  .map((e) => Continent.fromMap(e))
                                  .where((con) =>
                                      con.statutContinent ==
                                      true) // Filtrer les types d'acteurs actifs et différents de l'administrateur
                                  .toList();

                              List<DropdownMenuItem<String>> dropdownItems = [];

                              if (continentList.isNotEmpty) {
                                dropdownItems = continentList
                                    .map((e) => DropdownMenuItem(
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: Text(
                                            e.nomContinent,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: e.idContinent,
                                        ))
                                    .toList();
                              } else {
                                dropdownItems.add(DropdownMenuItem(
                                  child: Text('Aucun continent disponible'),
                                  value: null,
                                ));
                              }
                              // bool typeSelected = false;
                              return DropdownButton(
                                alignment: AlignmentDirectional.center,
                                items: dropdownItems,
                                value: continentValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    continentValue = newValue;
                                    if (newValue != null) {
                                      continents = continentList.firstWhere(
                                          (element) =>
                                              element.idContinent == newValue);
                                      debugPrint(
                                          continents.idContinent.toString());
                                      // typeSelected = true;
                                    } else {
                                      // typeSelected = false;
                                      // Gérer le cas où aucun type n'est sélectionné
                                      // if (!typeSelected) {
                                      //   Text(
                                      //     "Veuillez choisir un type d'acteur",
                                      //     style: TextStyle(color: Colors.red),
                                      //   );
                                      // }
                                    }
                                  });
                                },
                              );
                            }
                            return Text('Aucune donnée disponible');
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final String libelle = libelleController.text;
                        if (formkey.currentState!.validate()) {
                          try {
                            await SousRegionService()
                                .addSousRegion(
                                    nomSousRegion: libelle,
                                    continent: continents)
                                .then((value) => {
                                      Provider.of<SousRegionService>(context,
                                              listen: false)
                                          .applyChange(),
                                      setState(() {
                                        _liste = SousRegionService()
                                            .fetchSousRegionByContinent(
                                                continents.idContinent!);
                                      }),
                                      libelleController.clear(),
                                      setState(() {
                                        continents == null;
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
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Ajouter",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEtat(bool isState) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isState ? Colors.green : Colors.red,
      ),
    );
  }
}
