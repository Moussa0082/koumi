import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/Admin/CodePays.dart';
import 'package:koumi_app/Admin/Niveau2List.dart';
import 'package:koumi_app/Admin/UpdateNiveau1.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/models/Niveau2Pays.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/service/Niveau1Service.dart';
import 'package:koumi_app/service/Niveau2Service.dart';
import 'package:koumi_app/service/PaysService.dart';
import 'package:provider/provider.dart';

class Niveau1Page extends StatefulWidget {
  const Niveau1Page({super.key});

  @override
  State<Niveau1Page> createState() => _Niveau1PageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _Niveau1PageState extends State<Niveau1Page> {
  late ParametreGeneraux para;
  List<Niveau1Pays> niveauList = [];
  List<Niveau2Pays> niveau2List = [];
  List<ParametreGeneraux> paraList = [];
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late Pays pays;
  String? paysValue;
  late Future _paysList;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;
    para = paraList[0];
    _paysList = http.get(Uri.parse('https://koumi.ml/api-koumi/pays/read'));
    // _paysList = http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/pays/read'));
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Disposez le TextEditingController lorsque vous n'en avez plus besoin
    super.dispose();
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
          title: Text(
            "Niveau 1 : ${para.libelleNiveau1Pays}",
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
          actions: [
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  child: ListTile(
                    leading: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    title:  Text(
                      "Ajouter un ${para.libelleNiveau1Pays}  ",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                    onTap: () async {
                      _showDialog();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50], // Couleur d'arrière-plan
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search,
                        color: Colors.blueGrey[400]), // Couleur de l'icône
                    SizedBox(
                        width:
                            10), // Espacement entre l'icône et le champ de recherche
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Rechercher',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: Colors
                                  .blueGrey[400]), // Couleur du texte d'aide
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Consumer<Niveau1Service>(builder: (context, niveau1Service, child) {
              return FutureBuilder(
                  future: niveau1Service.fetchNiveau1Pays(),
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
                        child: Center(child: Text("Aucun donné trouvé")),
                      );
                    } else {
                      niveauList = snapshot.data!;
                      String searchText = "";
                      List<Niveau1Pays> filtereSearch =
                          niveauList.where((search) {
                        String libelle = search.nomN1!.toLowerCase();
                        searchText = _searchController.text.toLowerCase();
                        return libelle.contains(searchText);
                      }).toList();
                      return Column(
                          children: filtereSearch
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Niveau2List(
                                                        niveau1pays: e)));
                                      },
                                      child: Container(
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
                                              leading: CodePays()
                                                  .getFlag(e.pays!.nomPays),
                                              title:
                                                  Text(e.nomN1!.toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                              subtitle: Text(
                                                  e.descriptionN1!.trim(),
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.italic,
                                                  )),
                                            ),
                                            FutureBuilder(
                                                future: Niveau2Service()
                                                    .fetchNiveau2ByNiveau1(
                                                        e.idNiveau1Pays!),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.orange,
                                                      ),
                                                    );
                                                  }

                                                  if (!snapshot.hasData) {
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Nombres ${para.libelleNiveau2Pays} :",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              )),
                                                          Text("0",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ))
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    niveau2List =
                                                        snapshot.data!;
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Nombres ${para.libelleNiveau2Pays} :",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              )),
                                                          Text(
                                                              niveau2List.length
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ))
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                }),
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  _buildEtat(e.statutN1!),
                                                  PopupMenuButton<String>(
                                                    padding: EdgeInsets.zero,
                                                    itemBuilder: (context) =>
                                                        <PopupMenuEntry<
                                                            String>>[
                                                      PopupMenuItem<String>(
                                                        child: ListTile(
                                                          leading: e.statutN1 ==
                                                                  false
                                                              ? Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .green,
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .disabled_visible,
                                                                  color: Colors
                                                                          .orange[
                                                                      400]),
                                                          title:  Text(
                                                            e.statutN1 == false ? "Activer" : "Desactiver",
                                                                 style: TextStyle(
                                                                   color: e.statutN1 == false ? Colors.green : Colors.orange[
                                                                      400],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                             e.statutN1 == false ? 
                                                            await Niveau1Service()
                                                                .activerNiveau1(e
                                                                    .idNiveau1Pays!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<Niveau1Service>(context, listen: false)
                                                                              .applyChange(),
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
                                                                        }) :  await Niveau1Service()
                                                                    .desactiverNiveau1Pays(e
                                                                        .idNiveau1Pays!)
                                                                    .then(
                                                                        (value) =>
                                                                            {
                                                                              Provider.of<Niveau1Service>(context, listen: false).applyChange(),
                                                                              Navigator.of(context).pop(),
                                                                            })
                                                                    .catchError(
                                                                        (onError) =>
                                                                            {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                const SnackBar(
                                                                                  content: Row(
                                                                                    children: [
                                                                                      Text("Une erreur s'est produit"),
                                                                                    ],
                                                                                  ),
                                                                                  duration: Duration(seconds: 5),
                                                                                ),
                                                                              ),
                                                                              Navigator.of(context).pop(),
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
                                                                            BorderRadius.circular(16),
                                                                      ),
                                                                      content:
                                                                          UpdatesNiveau1(
                                                                        niveau1pays:
                                                                            e,
                                                                      )),
                                                            );

                                                            // Si les détails sont modifiés, appliquer les changements
                                                            if (updatedSousRegion !=
                                                                null) {
                                                              Provider.of<Niveau1Service>(
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
                                                            await Niveau1Service()
                                                                .deleteNiveau1Pays(e
                                                                    .idNiveau1Pays!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<Niveau1Service>(context, listen: false)
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
                                    ),
                                  ))
                              .toList());
                    }
                  });
            })
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
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(
                    "Ajouter un(e) ${para.libelleNiveau1Pays}",
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
                          labelText: "Nom du ${para.libelleNiveau1Pays}",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Consumer<PaysService>(
                        builder: (context, paysService, child) {
                          return FutureBuilder(
                            future: _paysList,
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return DropdownButtonFormField(
                                  items: [],
                                  onChanged: null,
                                  decoration: InputDecoration(
                                    labelText: 'Chargement...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              }
                              // if (snapshot.hasError) {
                              //   return Text("${snapshot.error}");
                              // }
                              if (snapshot.hasData) {
                                dynamic jsonString =
                                    utf8.decode(snapshot.data.bodyBytes);
                                dynamic responseData = json.decode(jsonString);

                                // final reponse = json.decode(snapshot.data.body);
                                if (responseData is List) {
                                  final paysList = responseData
                                      .map((e) => Pays.fromMap(e))
                                      .where((con) => con.statutPays == true)
                                      .toList();
                                  if (paysList.isEmpty) {
                                    return DropdownButtonFormField(
                                      items: [],
                                      onChanged: null,
                                      decoration: InputDecoration(
                                        labelText: 'Aucun pays trouvé',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    );
                                  }

                                  return DropdownButtonFormField<String>(
                                    isExpanded: true,
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
                                              (element) =>
                                                  element.idPays == newValue);
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
                              }
                              return DropdownButtonFormField(
                                items: [],
                                onChanged: null,
                                decoration: InputDecoration(
                                  labelText: 'Aucun pays trouvé',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            },
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
                                  .addNiveau1Pays(
                                      nomN1: libelle,
                                      descriptionN1: description,
                                      pays: pays)
                                  .then((value) => {
                                    Navigator.of(context).pop(),
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
                                         ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                  content: Row(
                                    children: [
                                      Text("${para.libelleNiveau1Pays} ajouté avec success"),
                                    ],
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              )
                                        // Navigator.of(context).pop()
                                      });
                            } catch (e) {
                              final String errorMessage = e.toString();
                              ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                  content: Row(
                                    children: [
                                      Text("${para.libelleNiveau1Pays} existe déjà"),
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
                ),
              ],
            ),
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
