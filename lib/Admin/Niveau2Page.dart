import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/Admin/CodePays.dart';
import 'package:koumi_app/Admin/UpdatesNiveau2.dart';
import 'package:koumi_app/Admin/niveau3Liste.dart';
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/models/Niveau2Pays.dart';
import 'package:koumi_app/models/Niveau3Pays.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/service/Niveau1Service.dart';
import 'package:koumi_app/service/Niveau2Service.dart';
import 'package:koumi_app/service/Niveau3Service.dart';
import 'package:provider/provider.dart';

class Niveau2Page extends StatefulWidget {
  // final Niveau1Pays niveau1pays;
  const Niveau2Page({super.key});

  @override
  State<Niveau2Page> createState() => _Niveau2PageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _Niveau2PageState extends State<Niveau2Page> {
  // late ParametreGeneraux para;
  late Acteur acteur;
  List<Niveau2Pays> niveauList = [];
  List<Niveau3Pays> niveau3List = [];
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late Future<List<Niveau2Pays>> _liste;
  List<ParametreGeneraux> paraList = [];
  late Niveau1Pays niveau1;
  late Pays pays;
  String? paysValue;
  late Future _paysList;
  String? n1Value;
  late Future _niveauList;
  late TextEditingController _searchController;

  Future<List<Niveau2Pays>> getNiveauListe(String id) async {
    final response = await Niveau2Service().fetchNiveau2ByNiveau1(id);
    return response;
  }

  bool isLoadingLibelle = true;
  String? libelleNiveau2Pays;

  Future<String> getLibelleNiveau2PaysByActor(String id) async {
    final response = await http
        .get(Uri.parse('$apiOnlineUrl/acteur/libelleNiveau2Pays/$id'));

    if (response.statusCode == 200) {
      print("libelle : ${response.body}");
      return response
          .body; // Return the body directly since it's a plain string
    } else {
      throw Exception('Failed to load libelle niveau2Pays');
    }
  }

  Future<void> fetchPaysDataByActor() async {
    try {
      String libelle2 = await getLibelleNiveau2PaysByActor(acteur.idActeur!);

      setState(() {
        libelleNiveau2Pays = libelle2;
        isLoadingLibelle = false;
      });
    } catch (e) {
      setState(() {
        isLoadingLibelle = false;
      });
      print('Error: $e');
    }
  }

  String? libelleNiveau1Pays;
  bool isLoadingLibelle1 = true;
  Future<String> getlibelleNiveau1PaysByActor(String id) async {
    final response = await http
        .get(Uri.parse('$apiOnlineUrl/acteur/libelleNiveau1Pays/$id'));

    if (response.statusCode == 200) {
      print("libelle : ${response.body}");
      return response
          .body; // Return the body directly since it's a plain string
    } else {
      throw Exception('Failed to load libelle niveau2Pays');
    }
  }

  Future<void> fetchPaysData1ByActor() async {
    try {
      String libelle2 = await getlibelleNiveau1PaysByActor(acteur.idActeur!);

      setState(() {
        libelleNiveau1Pays = libelle2;
        isLoadingLibelle1 = false;
      });
    } catch (e) {
      setState(() {
        isLoadingLibelle1 = false;
      });
      print('Error: $e');
    }
  }
String? libelleNiveau3Pays;
    bool isLoadingLibelle3 = true;
    
   Future<String> getlibelleNiveau3PaysByActor(String id) async {
    final response = await http
        .get(Uri.parse('$apiOnlineUrl/acteur/libelleNiveau3Pays/$id'));

    if (response.statusCode == 200) {
      print("libelle : ${response.body}");
      return response
          .body; // Return the body directly since it's a plain string
    } else {
      throw Exception('Failed to load libelle niveau2Pays');
    }
  }

  Future<void> fetchPaysData3ByActor() async {
    try {
      String libelle2 = await getlibelleNiveau3PaysByActor(acteur.idActeur!);

      setState(() {
        libelleNiveau3Pays = libelle2;
        isLoadingLibelle3 = false;
      });
    } catch (e) {
      setState(() {
        isLoadingLibelle3 = false;
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
    //     .parametreList!;
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    // para = paraList[0];
    //         acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    _paysList = http.get(Uri.parse('$apiOnlineUrl/pays/read'));
    _niveauList = http.get(Uri.parse('$apiOnlineUrl/niveau1Pays/read'));
    fetchPaysDataByActor();
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
          "Niveau 2",
          style:
              const TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold,fontSize: 18),
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
                  title: Text(
                    "Ajouter un niveau 2",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
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
          Consumer<Niveau2Service>(builder: (context, niveau2Service, child) {
            return FutureBuilder(
                future: niveau2Service.fetchNiveau2Pays(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                          child: Text("Aucun niveau 2 trouvé")),
                    );
                  } else {
                    niveauList = snapshot.data!;
                    String searchText = "";
                    List<Niveau2Pays> filtereSearch =
                        niveauList.where((search) {
                      String libelle = search.nomN2.toLowerCase();
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
                                                  Niveau3Liste(
                                                      niveau2pays: e)));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
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
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: CodePays().getFlag(
                                                e.niveau1Pays.pays!.nomPays!),
                                            title: Text(e.nomN2.toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                            subtitle: Text(
                                                e.descriptionN2.trim(),
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.italic,
                                                )),
                                          ),
                                          Consumer<Niveau1Service>(builder:
                                              (context, niveauSer, child) {
                                            return FutureBuilder(
                                                future: Niveau3Service()
                                                    .fetchNiveau3ByNiveau2(
                                                        e.idNiveau2Pays!),
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
                                                              "Nombres ${libelleNiveau3Pays} :",
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
                                                    niveau3List =
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
                                                              "Nombres ${libelleNiveau3Pays} :",
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
                                                              niveau3List.length
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
                                                });
                                          }),
                                          Container(
                                            alignment: Alignment.bottomRight,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _buildEtat(e.statutN2),
                                                PopupMenuButton<String>(
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder: (context) =>
                                                      <PopupMenuEntry<String>>[
                                                    PopupMenuItem<String>(
                                                      child: ListTile(
                                                        leading: e.statutN2 ==
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
                                                        title: Text(
                                                          e.statutN2 == false
                                                              ? "Activer"
                                                              : "Desactiver",
                                                          style: TextStyle(
                                                            color: e.statutN2 ==
                                                                    false
                                                                ? Colors.green
                                                                : Colors.orange[
                                                                    400],
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          e.statutN2 == false
                                                              ? await Niveau2Service()
                                                                  .activerNiveau2(e
                                                                      .idNiveau2Pays!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<Niveau2Service>(context, listen: false).applyChange(),
                                                                            // setState(
                                                                            //     () {
                                                                            //   _liste = Niveau2Service().fetchNiveau2ByNiveau1(widget
                                                                            //       .niveau1pays
                                                                            //       .idNiveau1Pays!);
                                                                            // }),
                                                                            Navigator.of(context).pop(),
                                                                            ScaffoldMessenger.of(context).showSnackBar(
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
                                                                          })
                                                              : await Niveau2Service()
                                                                  .desactiverNiveau2Pays(e
                                                                      .idNiveau2Pays!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<Niveau2Service>(context, listen: false).applyChange(),
                                                                            // setState(
                                                                            //     () {
                                                                            //   _liste = Niveau2Service().fetchNiveau2ByNiveau1(widget
                                                                            //       .niveau1pays
                                                                            //       .idNiveau1Pays!);
                                                                            // }),
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

                                                          ScaffoldMessenger.of(
                                                                  context)
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
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                                          BorderRadius.circular(
                                                                              16),
                                                                    ),
                                                                    content: UpdatesNiveau2(
                                                                        niveau2pays:
                                                                            e)),
                                                          );

                                                          // Si les détails sont modifiés, appliquer les changements
                                                          if (updatedSousRegion !=
                                                              null) {
                                                            Provider.of<Niveau2Service>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .applyChange();
                                                            setState(() {
                                                              _liste =
                                                                  updatedSousRegion;
                                                            });
                                                            // Mettre à jour la liste des sous-régions
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
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          await Niveau2Service()
                                                              .deleteNiveau2Pays(e
                                                                  .idNiveau2Pays!)
                                                              .then((value) => {
                                                                    Provider.of<Niveau2Service>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .applyChange(),
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                  })
                                                              .catchError(
                                                                  (onError) => {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          const SnackBar(
                                                                            content:
                                                                                Row(
                                                                              children: [
                                                                                Text("Impossible de supprimer"),
                                                                              ],
                                                                            ),
                                                                            duration:
                                                                                Duration(seconds: 2),
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
      ),
    );
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
                    "Ajouter un niveau 2",
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
                          labelText: "Nom du niveau 2",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Consumer<Niveau1Service>(
                        builder: (context, niveauService, child) {
                          return FutureBuilder(
                            future: _niveauList,
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

                              if (snapshot.hasData) {
                                dynamic jsonString =
                                    utf8.decode(snapshot.data.bodyBytes);
                                dynamic reponse = json.decode(jsonString);

                                // final reponse = json.decode(snapshot.data.body);
                                if (reponse is List) {
                                  final niveauList = reponse
                                      .map((e) => Niveau1Pays.fromMap(e))
                                      .where((con) => con.statutN1 == true)
                                      .toList();

                                  if (niveauList.isEmpty) {
                                    return DropdownButtonFormField(
                                      items: [],
                                      onChanged: null,
                                      decoration: InputDecoration(
                                        labelText:
                                            'Aucun ${libelleNiveau1Pays} trouvé',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    );
                                  }

                                  return DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    items: niveauList
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.idNiveau1Pays,
                                            child: Text(e.nomN1 ?? ''),
                                          ),
                                        )
                                        .toList(),
                                    value: n1Value,
                                    onChanged: (newValue) {
                                      setState(() {
                                        n1Value = newValue;
                                        if (newValue != null) {
                                          niveau1 = niveauList.firstWhere(
                                              (element) =>
                                                  element.idNiveau1Pays ==
                                                  newValue);
                                          debugPrint(
                                              "niveau select :${niveau1.toString()}");
                                          // typeSelected = true;
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText:
                                          'Sélectionner un ${libelleNiveau1Pays}',
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
                                  labelText:
                                      'Aucun ${libelleNiveau1Pays} trouvé',
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
                              await Niveau2Service()
                                  .addNiveau2Pays(
                                    nomN2: libelle,
                                    descriptionN2: description,
                                    niveau1Pays: niveau1,
                                  )
                                  .then((value) => {
                                        Provider.of<Niveau2Service>(context,
                                                listen: false)
                                            .applyChange(),
                                        Navigator.of(context).pop(),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                Text(
                                                    "niveau 2 ajouté avec success"),
                                              ],
                                            ),
                                            duration: Duration(seconds: 5),
                                          ),
                                        ),
                                        libelleController.clear(),
                                        descriptionController.clear(),
                                        setState(() {
                                          niveau1 == null;
                                        }),
                                      });
                            } catch (e) {
                              final String errorMessage = e.toString();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Text("niveau 2 existe déjà"),
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
