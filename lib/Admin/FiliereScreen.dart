import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/Admin/AddCategorie.dart';
import 'package:koumi_app/Admin/UpdatesFiliere.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Filiere.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/service/CategorieService.dart';
import 'package:koumi_app/service/FiliereService.dart';
import 'package:provider/provider.dart';

class FiliereScreen extends StatefulWidget {
  const FiliereScreen({super.key});

  @override
  State<FiliereScreen> createState() => _FiliereScreenState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _FiliereScreenState extends State<FiliereScreen> {
  List<Filiere> filiereList = [];
  late ParametreGeneraux para;
  List<ParametreGeneraux> paraList = [];
  late Acteur acteur;
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? filiereValue;
  late Future _filiereList;
  late Future<List<Filiere>> _liste;
  late Filiere filiere;
  late TextEditingController _searchController;

  Future<List<Filiere>> getFil() async {
    return await FiliereService().fetchFiliere();
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;
    para = paraList[0];
    _filiereList = http
        // .get(Uri.parse('https://koumi.ml/api-koumi/Filiere/getAllFiliere/'));
        .get(Uri.parse('http://10.0.2.2:9000/api-koumi/Filiere/getAllFiliere/'));
    _liste = getFil();
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
        title: const Text(
          "Filière agricole",
          style: TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
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
                  title: const Text(
                    "Ajouter filières",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    _showDialog();
                  },
                ),
              ),
              PopupMenuItem<String>(
                child: ListTile(
                  leading: Icon(
                    Icons.add,
                    color: Colors.orange[400],
                  ),
                  title: Text(
                    "Ajouter catégorie",
                    style: TextStyle(
                      color: Colors.orange[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    _addCategorie();
                  },
                ),
              ),
            ],
          )
          // IconButton(
          //   onPressed: () {
          //     _addCategorie();
          //   },
          //   icon: const Icon(
          //     Icons.add_circle_outline,
          //     color: d_colorGreen,
          //     size: 25,
          //   ),
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            Consumer<FiliereService>(
              builder: (context, filiereService, child) {
                return FutureBuilder(
                    future:
                        filiereService.fetchFiliereByActeur(acteur.idActeur!),
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
                            child: Column(
                              children: [
                                Image.asset('assets/images/notif.jpg'),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Aucune filière trouvé ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      overflow: TextOverflow.ellipsis,
                                    ))
                              ],
                            ),
                          ),
                        );
                      } else {
                        filiereList = snapshot.data!;
                        String searchText = "";
                        List<Filiere> filteredFiliereSearch =
                            filiereList.where((fil) {
                          String nomfiliere = fil.libelleFiliere.toLowerCase();
                          searchText = _searchController.text.toLowerCase();
                          return nomfiliere.contains(searchText);
                        }).toList();
                        return Column(
                            children: filteredFiliereSearch
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
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
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddCategorie(
                                                          filiere: e,
                                                        )));
                                          },
                                          child: Column(
                                            children: [
                                              ListTile(
                                                  leading: _getIconForFiliere(
                                                      e.libelleFiliere),
                                                  title: Text(
                                                      e.libelleFiliere
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                  subtitle: Text(
                                                      e.descriptionFiliere
                                                          .trim(),
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ))),
                                              // const Padding(
                                              //   padding: EdgeInsets.symmetric(
                                              //       horizontal: 15),
                                              //   child: Row(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment
                                              //             .spaceBetween,
                                              //     children: [
                                              //       Text("Nombres pays :",
                                              //           style: TextStyle(
                                              //             color: Colors.black87,
                                              //             fontSize: 17,
                                              //             fontWeight:
                                              //                 FontWeight.w500,
                                              //             fontStyle:
                                              //                 FontStyle.italic,
                                              //           )),
                                              //       Text("10",
                                              //           style: TextStyle(
                                              //             color: Colors.black87,
                                              //             fontSize: 18,
                                              //             fontWeight:
                                              //                 FontWeight.w800,
                                              //           ))
                                              //     ],
                                              //   ),
                                              // ),
                                              Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    _buildEtat(e.statutFiliere),
                                                    PopupMenuButton<String>(
                                                      padding: EdgeInsets.zero,
                                                      itemBuilder: (context) =>
                                                          <PopupMenuEntry<
                                                              String>>[
                                                        PopupMenuItem<String>(
                                                          child: ListTile(
                                                            leading: const Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            title: const Text(
                                                              "Activer",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              await FiliereService()
                                                                  .activerFiliere(e
                                                                      .idFiliere!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<FiliereService>(context, listen: false).applyChange(),
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
                                                                        .orange[
                                                                    400],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              await FiliereService()
                                                                  .desactiverFiliere(e
                                                                      .idFiliere!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<FiliereService>(context, listen: false).applyChange(),
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
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            title: const Text(
                                                              "Modifier",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              // Ouvrir la boîte de dialogue de modification
                                                              var updatedSousRegion =
                                                                  await showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext context) => AlertDialog(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    content: UpdatesFilieres(
                                                                        filiere:
                                                                            e)),
                                                              );

                                                              // Si les détails sont modifiés, appliquer les changements
                                                              if (updatedSousRegion !=
                                                                  null) {
                                                                Provider.of<FiliereService>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .applyChange();

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
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              await FiliereService()
                                                                  .deleteFiliere(e
                                                                      .idFiliere!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<FiliereService>(context, listen: false).applyChange(),
                                                                            Navigator.of(context).pop(),
                                                                            setState(() {
                                                                              _filiereList = http
                                                                                  // .get(Uri.parse('https://koumi.ml/api-koumi/Filiere/getAllFiliere/'));
                                                                                  .get(Uri.parse('http://10.0.2.2:9000/api-koumi/Filiere/getAllFiliere/'));
                                                                            })
                                                                          })
                                                                  .catchError(
                                                                      (onError) =>
                                                                          {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(
                                                                                content: Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      "Impossible de supprimer car cette filière est déjà associé a une categorie",
                                                                                      style: TextStyle(overflow: TextOverflow.ellipsis),
                                                                                    ),
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
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIconForFiliere(String libelle) {
    switch (libelle.toLowerCase()) {
      case 'céréale':
      case 'céréales':
      case 'cereale':
      case 'cereales':
        return Image.asset(
          "assets/images/cereale.png",
          width: 80,
          height: 80,
        );
      case 'fruits':
      case 'fruit':
        return Image.asset(
          "assets/images/fruits.png",
          width: 80,
          height: 80,
        );
      case 'bétails':
      case 'bétail':
      case 'betails':
      case 'betail':
      case 'animal':
        return Image.asset(
          "assets/images/betail.png",
          width: 80,
          height: 80,
        );
      case 'légumes':
      case 'légume':
      case 'legumes':
      case 'legume':
        return Image.asset(
          "assets/images/legumes.png",
          width: 80,
          height: 80,
        );
      default:
        return Image.asset(
          "assets/images/default.png",
          width: 80,
          height: 80,
        );
    }
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
              children: [
                ListTile(
                  title: Text(
                    "Ajouter une filière",
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
                const SizedBox(height: 5),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez remplir les champs";
                          }
                          return null;
                        },
                        controller: libelleController,
                        decoration: InputDecoration(
                          hintText: "Nom de la filiere",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez remplir les champs";
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
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final String libelle = libelleController.text;
                          final String description = descriptionController.text;
                          if (formkey.currentState!.validate()) {
                            try {
                              await FiliereService()
                                  .addFileres(
                                      libelleFiliere: libelle,
                                      descriptionFiliere: description,
                                      acteur: acteur)
                                  .then((value) => {
                                        Provider.of<FiliereService>(context,
                                                listen: false)
                                            .applyChange(),
                                        setState(() {
                                          _filiereList = http
                                              // .get(Uri.parse('https://koumi.ml/api-koumi/Filiere/getAllFiliere/'));
                                              .get(Uri.parse('http://10.0.2.2:9000/api-koumi/Filiere/getAllFiliere/'));
                                        }),
                                        libelleController.clear(),
                                        descriptionController.clear(),
                                        Navigator.of(context).pop()
                                      });
                            } catch (e) {
                              final String errorMessage = e.toString();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    children: [
                                      Text("Une erreur s'est produite"),
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
      ),
    );
  }

  void _addCategorie() {
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
                    "Ajouter une catégorie",
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
                          labelText: "Nom de la catégorie",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Consumer<FiliereService>(
                          builder: (context, filiereService, child) {
                        return FutureBuilder(
                          future: _filiereList,
                          builder: (_, snapshot) {
                            // if (snapshot.connectionState ==
                            //     ConnectionState.waiting) {
                            //   return CircularProgressIndicator();
                            // }
                            // if (snapshot.hasError) {
                            //   return Text("${snapshot.error}");
                            // }
                            if (snapshot.hasData) {
                              dynamic responseData =
                                  json.decode(snapshot.data.body);
                              if (responseData is List) {
                                final reponse = responseData;
                                final filiereList = reponse
                                    .map((e) => Filiere.fromMap(e))
                                    .where((con) => con.statutFiliere == true)
                                    .toList();

                                if (filiereList.isEmpty) {
                                  return DropdownButtonFormField(
                                    items: [],
                                    onChanged: null,
                                    decoration: InputDecoration(
                                      labelText: 'Aucun filière trouvé',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                }

                                return DropdownButtonFormField<String>(
                                  items: filiereList
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.idFiliere,
                                          child: Text(e.libelleFiliere),
                                        ),
                                      )
                                      .toList(),
                                  value: filiereValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      filiereValue = newValue;
                                      if (newValue != null) {
                                        filiere = filiereList.firstWhere(
                                          (element) =>
                                              element.idFiliere == newValue,
                                        );
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Sélectionner un filiere',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              } else {
                                return DropdownButtonFormField(
                                  items: [],
                                  onChanged: null,
                                  decoration: InputDecoration(
                                    labelText: 'Aucun filière trouvé',
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
                                labelText: 'Aucun filière trouvé',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        );
                      }),
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
                              await CategorieService()
                                  .addCategorie(
                                      libelleCategorie: libelle,
                                      descriptionCategorie: description,
                                      filiere: filiere,
                                      acteur: acteur)
                                  .then((value) => {
                                        Provider.of<CategorieService>(context,
                                                listen: false)
                                            .applyChange(),
                                        setState(() {
                                          filiere == null;
                                        }),
                                        libelleController.clear(),
                                        descriptionController.clear(),
                                        Navigator.of(context).pop(),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Row(
                                              children: [
                                                Text(
                                                    "Catégorie ajouter avec success"),
                                              ],
                                            ),
                                            duration: Duration(seconds: 3),
                                          ),
                                        )
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
}
