import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/Admin/CodePays.dart';
import 'package:koumi_app/Admin/UpdatesNiveau2.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/models/Niveau2Pays.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/service/Niveau2Service.dart';
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
  late ParametreGeneraux para;
  List<Niveau2Pays> niveauList = [];
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

  Future<List<Niveau2Pays>> getNiveauListe(String id) async {
    final response = await Niveau2Service().fetchNiveau2ByNiveau1(id);
    return response;
  }

  @override
  void initState() {
    super.initState();
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;
    para = paraList[0];
    _paysList = http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/pays/read'));
    _niveauList =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read'));
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
          "Niveau 2 : ${para.libelleNiveau2Pays}",
          style:
              const TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
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
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(child: Text("Aucun donné trouvé")),
                    );
                  } else {
                    niveauList = snapshot.data!;
                    return Column(
                        children: niveauList
                            .map((e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
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
                                              e.niveau1Pays!.pays.nomPays),
                                          title: Text(e.nomN2.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                          subtitle: Text(e.descriptionN2,
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                              )),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              _buildEtat(e.statutN2),
                                              PopupMenuButton<String>(
                                                padding: EdgeInsets.zero,
                                                itemBuilder: (context) =>
                                                    <PopupMenuEntry<String>>[
                                                  PopupMenuItem<String>(
                                                    child: ListTile(
                                                      leading: const Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                      ),
                                                      title: const Text(
                                                        "Activer",
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        await Niveau2Service()
                                                            .activerNiveau2(e
                                                                .idNiveau2Pays!)
                                                            .then((value) => {
                                                                  Provider.of<Niveau2Service>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .applyChange(),
                                                                  // setState(
                                                                  //     () {
                                                                  //   _liste = Niveau2Service().fetchNiveau2ByNiveau1(widget
                                                                  //       .niveau1pays
                                                                  //       .idNiveau1Pays!);
                                                                  // }),
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      content:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                              "Activer avec succèss "),
                                                                        ],
                                                                      ),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              2),
                                                                    ),
                                                                  )
                                                                })
                                                            .catchError(
                                                                (onError) => {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        const SnackBar(
                                                                          content:
                                                                              Row(
                                                                            children: [
                                                                              Text("Une erreur s'est produit"),
                                                                            ],
                                                                          ),
                                                                          duration:
                                                                              Duration(seconds: 5),
                                                                        ),
                                                                      ),
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                    });
                                                      },
                                                    ),
                                                  ),
                                                  PopupMenuItem<String>(
                                                    child: ListTile(
                                                      leading: Icon(
                                                        Icons.disabled_visible,
                                                        color:
                                                            Colors.orange[400],
                                                      ),
                                                      title: Text(
                                                        "Désactiver",
                                                        style: TextStyle(
                                                          color: Colors
                                                              .orange[400],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        await Niveau2Service()
                                                            .desactiverNiveau2Pays(e
                                                                .idNiveau2Pays!)
                                                            .then((value) => {
                                                                  Provider.of<Niveau2Service>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .applyChange(),
                                                                  // setState(
                                                                  //     () {
                                                                  //   _liste = Niveau2Service().fetchNiveau2ByNiveau1(widget
                                                                  //       .niveau1pays
                                                                  //       .idNiveau1Pays!);
                                                                  // }),
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                                })
                                                            .catchError(
                                                                (onError) => {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        const SnackBar(
                                                                          content:
                                                                              Row(
                                                                            children: [
                                                                              Text("Une erreur s'est produit"),
                                                                            ],
                                                                          ),
                                                                          duration:
                                                                              Duration(seconds: 5),
                                                                        ),
                                                                      ),
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
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
                                                            duration: Duration(
                                                                seconds: 2),
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
                                                                  listen: false)
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
                                                                      ScaffoldMessenger.of(
                                                                              context)
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          if (snapshot.hasData) {
                            final reponse =
                                json.decode((snapshot.data.body)) as List;
                            final paysList = reponse
                                .map((e) => Pays.fromMap(e))
                                .where((con) => con.statutPays == true)
                                .toList();

                            if (paysList.isEmpty) {
                              return Text(
                                'Aucun donné disponible',
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis),
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
                                    pays = paysList.firstWhere((element) =>
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          if (snapshot.hasData) {
                            final reponse =
                                json.decode((snapshot.data.body)) as List;
                            final niveauList = reponse
                                .map((e) => Niveau1Pays.fromMap(e))
                                .where((con) => con.statutN1 == true)
                                .toList();

                            if (niveauList.isEmpty) {
                              return Text(
                                'Aucun donné disponible',
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis),
                              );
                            }

                            return DropdownButtonFormField<String>(
                              items: niveauList
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.idNiveau1Pays,
                                      child: Text(e.nomN1),
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
                                  .addNiveau2Pays(
                                    nomN2: libelle,
                                    descriptionN2: description,
                                    niveau1Pays: niveau1,
                                  )
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
