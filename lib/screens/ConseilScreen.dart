import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Conseil.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddConseil.dart';
import 'package:koumi_app/screens/ConseilDisable.dart';
import 'package:koumi_app/screens/DetailConseil.dart';
import 'package:koumi_app/screens/UpdateConseil.dart';
import 'package:koumi_app/service/ConseilService.dart';
import 'package:provider/provider.dart';

class ConseilScreen extends StatefulWidget {
  const ConseilScreen({super.key});

  @override
  State<ConseilScreen> createState() => _ConseilScreenState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _ConseilScreenState extends State<ConseilScreen> {
  bool isExist = false;
  late Acteur acteur = Acteur();
  String? email = "";
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late TextEditingController _searchController;
  List<Conseil> conseilList = [];

  // void verify() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   email = prefs.getString('emailActeur');
  //   if (email != null) {
  //     // Si l'email de l'acteur est présent, exécute checkLoggedIn
  //     acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
  //     typeActeurData = acteur.typeActeur!;
  //     type = typeActeurData.map((data) => data.libelle).join(', ');
  //     setState(() {
  //       isExist = true;
  //     });
  //   } else {
  //     setState(() {
  //       isExist = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    typeActeurData = acteur.typeActeur!;
    type = typeActeurData.map((data) => data.libelle).join(', ');
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
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text(
            "Conseil ",
            style: TextStyle(
              color: d_colorGreen,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: type.toLowerCase() == 'fournisseur' ||
                  type.toLowerCase() == 'commerçant' ||
                  type.toLowerCase() == 'transporteur' ||
                  type.toLowerCase() == 'transformeur' ||
                  type.toLowerCase() == 'producteur' ||
                  type.toLowerCase() == 'commerçant' ||
                  type.toLowerCase() == 'commercant'
              ? null
              : [
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context) {
                      return type.toLowerCase() != 'admin'
                          ? <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.add,
                                    color: d_colorGreen,
                                  ),
                                  title: const Text(
                                    "Ajouter conseil ",
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
                                                AddConseil()));
                                  },
                                ),
                              ),
                            ]
                          : <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.add,
                                    color: d_colorGreen,
                                  ),
                                  title: const Text(
                                    "Ajouter conseil ",
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
                                                AddConseil()));
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
                                    "Voir conseil désactiver ",
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
                                                ConseilDisable()));
                                  },
                                ),
                              ),
                            ];
                    },
                  )
                ]),
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
            Consumer<ConseilService>(builder: (context, conseilService, child) {
              return FutureBuilder(
                  future: conseilService.fetchConseil(),
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
                        child: Center(child: Text("Aucun conseil trouvé")),
                      );
                    } else {
                      conseilList = snapshot.data!;
                      String searchText = "";
                      List<Conseil> filtereSearch = conseilList.where((search) {
                        String libelle = search.titreConseil.toLowerCase();
                        searchText = _searchController.text.toLowerCase();
                        return libelle.contains(searchText);
                      }).toList();
                      return filtereSearch.isEmpty
                          ? Padding(
                              padding: EdgeInsets.all(10),
                              child:
                                  Center(child: Text("Aucun conseil trouvé")),
                            )
                          : Column(
                              children: filtereSearch
                                  .where((element) =>
                                      element.statutConseil == true)
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailConseil(
                                                            conseil: e)));
                                          },
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
                                            child: Column(children: [
                                              ListTile(
                                                  leading: Image.asset(
                                                    "assets/images/conseille.png",
                                                    width: 80,
                                                    height: 80,
                                                  ),
                                                  title: Text(
                                                      e.titreConseil
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                  subtitle: Text(
                                                      e.descriptionConseil,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 17,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ))),
                                              Text(
                                                  "Date d'ajout : ${e.dateAjout!}",
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.italic,
                                                  )),
                                              SizedBox(height: 10),
                                              type.toLowerCase() != 'admin'
                                                  ? Container()
                                                  : Container(
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
                                                              e.statutConseil),
                                                          PopupMenuButton<
                                                              String>(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            itemBuilder: (context) =>
                                                                <PopupMenuEntry<
                                                                    String>>[
                                                              PopupMenuItem<
                                                                  String>(
                                                                child: ListTile(
                                                                  leading:
                                                                      e.statutConseil ==
                                                                              false
                                                                          ? Icon(
                                                                              Icons.check,
                                                                              color: Colors.green,
                                                                            )
                                                                          : Icon(
                                                                              Icons.disabled_visible,
                                                                              color: Colors.orange[400],
                                                                            ),
                                                                  title: Text(
                                                                    e.statutConseil ==
                                                                            false
                                                                        ? "Activer"
                                                                        : "Desactiver",
                                                                    style:
                                                                        TextStyle(
                                                                      color: e.statutConseil ==
                                                                              false
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .orange[400],
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  onTap:
                                                                      () async {
                                                                    e.statutConseil ==
                                                                            false
                                                                        ? await ConseilService()
                                                                            .activerConseil(e
                                                                                .idConseil!)
                                                                            .then((value) =>
                                                                                {
                                                                                  Provider.of<ConseilService>(context, listen: false).applyChange(),
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
                                                                            .catchError((onError) =>
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
                                                                        : await ConseilService()
                                                                            .desactiverConseil(e
                                                                                .idConseil!)
                                                                            .then((value) =>
                                                                                {
                                                                                  Provider.of<ConseilService>(context, listen: false).applyChange(),
                                                                                  Navigator.of(context).pop(),
                                                                                })
                                                                            .catchError((onError) =>
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
                                                                            Text("Désactiver avec succèss "),
                                                                          ],
                                                                        ),
                                                                        duration:
                                                                            Duration(seconds: 2),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              PopupMenuItem<
                                                                  String>(
                                                                child: ListTile(
                                                                  leading:
                                                                      const Icon(
                                                                    Icons.edit,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  title:
                                                                      const Text(
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
                                                                  onTap:
                                                                      () async {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                UpdateConseil(conseils: e)));
                                                                  },
                                                                ),
                                                              ),
                                                              PopupMenuItem<
                                                                  String>(
                                                                child: ListTile(
                                                                  leading:
                                                                      const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  title:
                                                                      const Text(
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
                                                                  onTap:
                                                                      () async {
                                                                    await ConseilService()
                                                                        .deleteConseil(e
                                                                            .idConseil!)
                                                                        .then((value) =>
                                                                            {
                                                                              Provider.of<ConseilService>(context, listen: false).applyChange(),
                                                                              Navigator.of(context).pop(),
                                                                            })
                                                                        .catchError((onError) =>
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
                                            ]),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            );
                    }
                  });
            })
          ],
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
