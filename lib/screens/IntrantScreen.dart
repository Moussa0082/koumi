import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/screens/AddIntrant.dart';
import 'package:koumi_app/screens/DetailIntrant.dart';
import 'package:koumi_app/screens/ListeIntrantByActeur.dart';
import 'package:koumi_app/service/IntrantService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntrantScreen extends StatefulWidget {
  const IntrantScreen({super.key});

  @override
  State<IntrantScreen> createState() => _IntrantScreenState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _IntrantScreenState extends State<IntrantScreen> {
  bool isExist = false;
  late Acteur acteur = Acteur();
  String? email = "";
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late TextEditingController _searchController;
  List<Intrant> intrantListe = [];
  List<ParametreGeneraux> paraList = [];
  late ParametreGeneraux para = ParametreGeneraux();
  String? catValue;
  late Future _typeList;
  CategorieProduit? selectedType;

  void verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('emailActeur');
    if (email != null) {
      // Si l'email de l'acteur est présent, exécute checkLoggedIn
      acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
      typeActeurData = acteur.typeActeur!;
      type = typeActeurData.map((data) => data.libelle).join(', ');
      setState(() {
        isExist = true;
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    verify();
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;

    if (paraList.isNotEmpty) {
      para = paraList[0];
    }
    _searchController = TextEditingController();
    _typeList = http
        .get(Uri.parse('https://koumi.ml/api-koumi/Categorie/allCategorie'));
    // http.get(
    //     Uri.parse('http://10.0.2.2:9000/api-koumi/Categorie/allCategorie'));
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
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          toolbarHeight: 100,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text(
            "Intrant agricole ",
            style: TextStyle(
              color: d_colorGreen,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: !isExist
              ? null
              : (type.toLowerCase() == 'admin' ||
                          type.toLowerCase() == 'fournisseur' ||
                          type.toLowerCase() == 'fournisseurs') ||
                      type.toLowerCase() == 'commerçant' ||
                      type.toLowerCase() == 'commercant'
                  ? [
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context) {
                          return <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.add,
                                  color: d_colorGreen,
                                ),
                                title: const Text(
                                  "Ajouter intrant ",
                                  style: TextStyle(
                                    color: d_colorGreen,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddIntrant()));
                                },
                              ),
                            ),
                            PopupMenuItem<String>(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.remove_red_eye,
                                  color: d_colorGreen,
                                ),
                                title: const Text(
                                  "Mes intrants ",
                                  style: TextStyle(
                                    color: d_colorGreen,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListeIntrantByActeur()));
                                },
                              ),
                            )
                          ];
                        },
                      )
                    ]
                  : null),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: FutureBuilder(
              future: _typeList,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                  dynamic jsonString = utf8.decode(snapshot.data.bodyBytes);
                  dynamic responseData = json.decode(jsonString);

                  // dynamic responseData = json.decode(snapshot.data.body);
                  if (responseData is List) {
                    final reponse = responseData;
                    final typeList = reponse
                        .map((e) => CategorieProduit.fromMap(e))
                        .where((con) => con.statutCategorie == true)
                        .toList();

                    if (typeList.isEmpty) {
                      return DropdownButtonFormField(
                        items: [],
                        onChanged: null,
                        decoration: InputDecoration(
                          labelText: '-- Aucun categorie trouvé --',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }

                    return DropdownButtonFormField<String>(
                      items: typeList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.idCategorieProduit,
                              child: Text(e.libelleCategorie!),
                            ),
                          )
                          .toList(),
                      hint: Text("-- Filtre par categorie --"),
                      value: catValue,
                      onChanged: (newValue) {
                        setState(() {
                          catValue = newValue;
                          if (newValue != null) {
                            selectedType = typeList.firstWhere(
                              (element) =>
                                  element.idCategorieProduit == newValue,
                            );
                          }
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
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
                        labelText: '-- Aucun categorie trouvé --',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
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
                    labelText: '-- Aucun categorie trouvé --',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Consumer<IntrantService>(builder: (context, intrantService, child) {
            return FutureBuilder(
                future: selectedType != null
                    ? intrantService.fetchIntrantByCategorie(
                        selectedType!.idCategorieProduit!)
                    : intrantService.fetchIntrant(),
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
                    intrantListe = snapshot.data!;
                    // String searchText = "";
                    // List<Intrant> filtereSearch = intrantListe.where((search) {
                    //   String libelle = search.nomIntrant.toLowerCase();
                    //   searchText = _searchController.text.toLowerCase();
                    //   return libelle.contains(searchText);
                    // }).toList();
                    return intrantListe
                            .where((element) => element.statutIntrant == true)
                            .isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(child: Text("Aucun donné trouvé")),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: intrantListe
                                .where(
                                    (element) => element.statutIntrant == true)
                                .length,
                            itemBuilder: (context, index) {
                              var e = intrantListe
                                  .where((element) =>
                                      element.statutIntrant == true)
                                  .elementAt(index);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailIntrant(
                                        intrant: e,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(250, 250, 250, 250),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        offset: Offset(0, 2),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: SizedBox(
                                          height: 100,
                                          child: e.photoIntrant == null
                                              ? Image.asset(
                                                  "assets/images/default_image.png",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  "https://koumi.ml/api-koumi/intrant/${e.idIntrant}/image",
                                                  // "http://10.0.2.2/${e.photoIntrant}",
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/default_image.png',
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      ListTile(
                                          title: Text(
                                            e.nomIntrant!,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                            // maxLines: 1,
                                            // overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                            para.monnaie != null
                                                ? "${e.prixIntrant.toString()} ${para.monnaie}"
                                                : "${e.prixIntrant.toString()} FCFA",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          trailing: Container(
                                            width:
                                                30, // Largeur du conteneur réduite
                                            height:
                                                30, // Hauteur du conteneur réduite
                                            decoration: BoxDecoration(
                                              color:
                                                  d_colorGreen, // Couleur de fond du bouton
                                              borderRadius: BorderRadius.circular(
                                                  15), // Coins arrondis du bouton
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                //                                        if (e.acteur.idActeur! == acteur.idActeur!){
                                                // Snack.error(titre: "Alerte", message: "Désolé!, Vous ne pouvez pas commander un intrant qui vous appartient");
                                                // }else{
                                                //   Provider.of<CartProvider>(context, listen: false)
                                                // .addToCartInt(e, 1, "");
                                                // }
                                              },
                                              icon: Icon(
                                                  Icons.add), // Icône du panier
                                              color: Colors
                                                  .white, // Couleur de l'icône
                                              iconSize:
                                                  20, // Taille de l'icône réduite
                                              padding: EdgeInsets
                                                  .zero, // Aucune marge intérieure
                                              splashRadius:
                                                  15, // Rayon de l'effet de pression réduit
                                              tooltip:
                                                  'Ajouter au panier', // Info-bulle au survol de l'icône
                                            ),
                                          )),

                                      // Align(
                                      //   alignment: Alignment.bottomRight,
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     child: Container(
                                      //       width:
                                      //           30, // Largeur du conteneur réduite
                                      //       height:
                                      //           30, // Hauteur du conteneur réduite
                                      //       decoration: BoxDecoration(
                                      //         color:
                                      //             d_colorGreen, // Couleur de fond du bouton
                                      //         borderRadius: BorderRadius.circular(
                                      //             15), // Coins arrondis du bouton
                                      //       ),
                                      //       child: IconButton(
                                      //         onPressed: () {
                                      //           //                                        if (e.acteur.idActeur! == acteur.idActeur!){
                                      //           // Snack.error(titre: "Alerte", message: "Désolé!, Vous ne pouvez pas commander un intrant qui vous appartient");
                                      //           // }else{
                                      //           //   Provider.of<CartProvider>(context, listen: false)
                                      //           // .addToCartInt(e, 1, "");
                                      //           // }
                                      //         },
                                      //         icon: Icon(
                                      //             Icons.add), // Icône du panier
                                      //         color: Colors
                                      //             .white, // Couleur de l'icône
                                      //         iconSize:
                                      //             20, // Taille de l'icône réduite
                                      //         padding: EdgeInsets
                                      //             .zero, // Aucune marge intérieure
                                      //         splashRadius:
                                      //             15, // Rayon de l'effet de pression réduit
                                      //         tooltip:
                                      //             'Ajouter au panier', // Info-bulle au survol de l'icône
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                  }
                });
          }),
        ]),
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

  Widget _buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                // overflow: TextOverflow.ellipsis,
                fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis,
                fontSize: 16),
          )
        ],
      ),
    );
  }
}
