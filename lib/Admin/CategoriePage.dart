import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/Admin/SpeculationPage.dart';
import 'package:koumi_app/Admin/UpdatesCategorie.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Filiere.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/CategorieService.dart';
import 'package:koumi_app/service/FiliereService.dart';
import 'package:koumi_app/service/SpeculationService.dart';
import 'package:provider/provider.dart';
 
class CategoriPage extends StatefulWidget {
  const CategoriPage({super.key});

  @override
  State<CategoriPage> createState() => _CategoriPageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _CategoriPageState extends State<CategoriPage> {
  Future<List<CategorieProduit>> getCatListe(String id) async {
    return await CategorieService().fetchCategorieByFiliere(id);
  }

  List<CategorieProduit> categorieList = [];
  List<Speculation> speculationList = [];
  late Future<List<CategorieProduit>> _liste;
  late Acteur acteur;
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? filiereValue;
  late Future _filiereList;
  late Filiere filiere;
  String? catValue;
  late Future _categorieList;
  late CategorieProduit categorieProduit;
  late TextEditingController _searchController;

  Future<List<CategorieProduit>> getCat() async {
    return await CategorieService().fetchCategorie();
  }

  @override
  void initState() {
    super.initState();

    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    _filiereList = http
        .get(Uri.parse('https://koumi.ml/api-koumi/Filiere/getAllFiliere/'));
        // .get( Uri.parse('http://10.0.2.2:9000/api-koumi/Filiere/getAllFiliere/'));
        
    // _categorieList = http.get( Uri.parse('http://10.0.2.2:9000/api-koumi/Categorie/allCategorie'));
    _categorieList = http.get(Uri.parse('https://koumi.ml/api-koumi/Categorie/allCategorie'));
    _liste = getCat();
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
        title: const Text(
          "Catégorie produit",
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
                    "Ajouter une spéculation",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    _showDialogSpeculation();
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
            Consumer<CategorieService>(
              builder: (context, categorieService, child) {
                return FutureBuilder(
                    future: categorieService.fetchCategorie(),
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
                                Text('Aucune catégorie trouvé ',
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
                        categorieList = snapshot.data!;
                        String searchText = "";
                        List<CategorieProduit> filteredCatSearch =
                            categorieList.where((cate) {
                          String nomCat = cate.libelleCategorie!.toLowerCase();
                          searchText = _searchController.text.toLowerCase();
                          return nomCat.contains(searchText);
                        }).toList();
                        return Column(
                            children: filteredCatSearch.isEmpty
                                ? [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Image.asset(
                                                'assets/images/notif.jpg'),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text('Aucune catégorie trouvé ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))
                                          ],
                                        ),
                                      ),
                                    )
                                  ]
                                : filteredCatSearch
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  offset: const Offset(0, 2),
                                                  blurRadius: 5,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SpeculationPage(
                                                                    categorieProduit:
                                                                        e)));
                                                  },
                                                  child: ListTile(
                                                      leading:
                                                          _getIconForFiliere(e
                                                              .filiere!
                                                              .libelleFiliere),
                                                      title: Text(
                                                          e.libelleCategorie!
                                                              .toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                      subtitle: Text(
                                                          e.descriptionCategorie!
                                                              .trim(),
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ))),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          "Filière appartenant:",
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          )),
                                                      Text(
                                                          e.filiere!
                                                              .libelleFiliere,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                FutureBuilder(
                                                    future: SpeculationService()
                                                        .fetchSpeculationByCategorie(e
                                                            .idCategorieProduit!),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                        );
                                                      }

                                                      if (!snapshot.hasData) {
                                                        return Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Nombres de spéculation:",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  )),
                                                              Text("0",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                  ))
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        speculationList =
                                                            snapshot.data!;
                                                        return Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Nombres de spéculation",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  )),
                                                              Text(
                                                                  speculationList
                                                                      .length
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontSize:
                                                                        18,
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
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      _buildEtat(
                                                          e.statutCategorie!),
                                                      PopupMenuButton<String>(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        itemBuilder:
                                                            (context) =>
                                                                <PopupMenuEntry<
                                                                    String>>[
                                                          PopupMenuItem<String>(
                                                            child: ListTile(
                                                              leading:
                                                                  const Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              title: const Text(
                                                                "Activer",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              onTap: () async {
                                                                await CategorieService()
                                                                    .activerCategorie(e
                                                                        .idCategorieProduit!)
                                                                    .then(
                                                                        (value) =>
                                                                            {
                                                                              Provider.of<CategorieService>(context, listen: false).applyChange(),
                                                                              // setState(
                                                                              //     () {
                                                                              //   _liste =
                                                                              //       CategorieService().fetchCategorieByFiliere(filiere.idFiliere!);
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
                                                                        .orange[
                                                                    400],
                                                              ),
                                                              title: Text(
                                                                "Désactiver",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .orange[
                                                                      400],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              onTap: () async {
                                                                await CategorieService()
                                                                    .desactiverCategorie(e
                                                                        .idCategorieProduit!)
                                                                    .then(
                                                                        (value) =>
                                                                            {
                                                                              Provider.of<CategorieService>(context, listen: false).applyChange(),
                                                                              // setState(
                                                                              //     () {
                                                                              //   _liste =
                                                                              //       CategorieService().fetchCategorieByFiliere(filiere.idFiliere!);
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
                                                                    content:
                                                                        Row(
                                                                      children: [
                                                                        Text(
                                                                            "Désactiver avec succèss "),
                                                                      ],
                                                                    ),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            2),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          PopupMenuItem<String>(
                                                            child: ListTile(
                                                              leading:
                                                                  const Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              title: const Text(
                                                                "Modifier",
                                                                style:
                                                                    TextStyle(
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
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      AlertDialog(
                                                                          backgroundColor: Colors
                                                                              .white,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                          ),
                                                                          content:
                                                                              UpdatesCategorie(categorieProduit: e)),
                                                                );

                                                                // setState(() {
                                                                //   _liste = CategorieService()
                                                                //       .fetchCategorieByFiliere(
                                                                //           filiere
                                                                //               .idFiliere!);
                                                                // });
                                                                if (updatedSousRegion !=
                                                                    null) {
                                                                  Provider.of<CategorieService>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .applyChange();
                                                                  // setState(() {
                                                                  //   _liste = CategorieService()
                                                                  //       .fetchCategorieByFiliere(
                                                                  //           filiere
                                                                  //               .idFiliere!);
                                                                  // });
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          PopupMenuItem<String>(
                                                            child: ListTile(
                                                              leading:
                                                                  const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              title: const Text(
                                                                "Supprimer",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              onTap: () async {
                                                                await CategorieService()
                                                                    .deleteCategorie(e
                                                                        .idCategorieProduit!)
                                                                    .then(
                                                                        (value) =>
                                                                            {
                                                                              Provider.of<CategorieService>(context, listen: false).applyChange(),
                                                                              setState(() {
                                                                                // _categorieList = http.
                                                                                // get(Uri.parse('http://10.0.2.2:9000/api-koumi/Categorie/allCategorie'));

                                                                                _categorieList = http.
                                                                                get(Uri.parse('https://koumi.ml/api-koumi/Categorie/allCategorie'));
                                                                                
                                                                            
                                                                              }),
                                                                              Navigator.of(context).pop(),
                                                                            })
                                                                    .catchError(
                                                                        (onError) =>
                                                                            {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
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
          ],
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return DropdownButtonFormField(
                                  items: [],
                                  onChanged: null,
                                  decoration: InputDecoration(
                                    labelText: 'Chargement...',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                            }
                            
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
                                      )
                                  .then((value) => {
                                        Provider.of<CategorieService>(context,
                                                listen: false)
                                            .applyChange(),
                                        setState(() {
                                           _categorieList = http.
                                          //  get(Uri.parse('http://10.0.2.2:9000/api-koumi/Categorie/allCategorie'));
                                          get(Uri.parse('https://koumi.ml/api-koumi/Categorie/allCategorie'));
                                          filiereValue = null;
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

  void _showDialogSpeculation() {
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
                    "Ajouter une spéculation",
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
                          labelText: "Nom de la speculation",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Consumer<CategorieService>(
                          builder: (context, catService, child) {
                        return FutureBuilder(
                          future: _categorieList,
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            if (snapshot.hasData) {
                              dynamic responseData =
                                  json.decode(snapshot.data.body);
                              if (responseData is List) {
                                final reponse = responseData;
                                final filiereList = reponse
                                    .map((e) => CategorieProduit.fromMap(e))
                                    .where((con) => con.statutCategorie == true)
                                    .toList();

                                if (filiereList.isEmpty) {
                                  return DropdownButtonFormField(
                                    items: [],
                                    onChanged: null,
                                    decoration: InputDecoration(
                                      labelText: 'Aucune catégorie trouvé',
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
                                          value: e.idCategorieProduit,
                                          child: Text(e.libelleCategorie!),
                                        ),
                                      )
                                      .toList(),
                                  value: catValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      catValue = newValue;
                                      if (newValue != null) {
                                        categorieProduit =
                                            filiereList.firstWhere(
                                          (element) =>
                                              element.idCategorieProduit ==
                                              newValue,
                                        );
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Sélectionner une catégorie',
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
                                    labelText: 'Aucune catégorie trouvé',
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
                                labelText: 'Aucune catégorie trouvé',
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
                              await SpeculationService()
                                  .addSpeculation(
                                      nomSpeculation: libelle,
                                      descriptionSpeculation: description,
                                      categorieProduit: categorieProduit,
                                      )
                                  .then((value) => {
                                        Provider.of<SpeculationService>(context,
                                                listen: false)
                                            .applyChange(),
                                        libelleController.clear(),
                                        descriptionController.clear(),
                                        Navigator.of(context).pop(),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Row(
                                              children: [
                                                Text(
                                                    "Spéculation ajouter avec success"),
                                              ],
                                            ),
                                            duration: Duration(seconds: 5),
                                          ),
                                        )
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
