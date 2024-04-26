import 'package:flutter/material.dart';
import 'package:koumi_app/Admin/AddAlerte.dart';
import 'package:koumi_app/Admin/AlerteDisable.dart';
import 'package:koumi_app/Admin/DetailAlerte.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Alertes.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/AlerteService.dart';
import 'package:provider/provider.dart';

class AlerteScreen extends StatefulWidget {
  const AlerteScreen({super.key});

  @override
  State<AlerteScreen> createState() => _AlerteScreenState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AlerteScreenState extends State<AlerteScreen> {
  late Acteur acteur = Acteur();
  String? email = "";
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late TextEditingController _searchController;
  List<Alertes> alerteList = [];

  // void verify() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   email = prefs.getString('emailActeur');
  //   if (email != null) {
  //     // Si l'email de l'acteur est présent, exécute checkLoggedIn
  //     acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
  //     typeActeurData = acteur.typeActeur!;
  //     type = typeActeurData.map((data) => data.libelle).join(', ');
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
            "Alerte ",
            style: TextStyle(
              color: d_colorGreen,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: type.toLowerCase() != 'admin'
              ? null
              : [
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
                              "Ajouter Alerte ",
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
                                      builder: (context) => AddAlerte()));
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
                              "Alerte Désactiver ",
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
                                      builder: (context) => AlerteDisable()));
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
            Consumer<AlertesService>(builder: (context, alerteService, child) {
              return FutureBuilder(
                  future: alerteService.fetchAlertes(),
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
                      alerteList = snapshot.data!;
                      String searchText = "";
                      List<Alertes> filtereSearch = alerteList.where((search) {
                        String libelle = search.titreAlerte!.toLowerCase();
                        searchText = _searchController.text.toLowerCase();
                        return libelle.contains(searchText);
                      }).toList();
                      return filtereSearch
                              .where((element) => element.statutAlerte == true)
                              .isEmpty
                          ? Padding(
                              padding: EdgeInsets.all(10),
                              child: Center(child: Text("Aucun alerte trouvé")),
                            )
                          : Column(
                              children: filtereSearch
                                  .where(
                                      (element) => element.statutAlerte == true)
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailAlerte(
                                                            alertes: e)));
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
                                                    "assets/images/alt.png",
                                                    width: 80,
                                                    height: 80,
                                                  ),
                                                  title: Text(
                                                      e.titreAlerte!
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                  subtitle: Text(
                                                      "Date d'ajout : ${e.dateAjout!}",
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ))),
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
                                                              e.statutAlerte!),
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
                                                                  leading: e.statutAlerte ==
                                                                          false
                                                                      ? Icon(
                                                                          Icons
                                                                              .check,
                                                                          color:
                                                                              Colors.green,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .disabled_visible,
                                                                          color:
                                                                              Colors.orange[400]),
                                                                  title: Text(
                                                                    e.statutAlerte ==
                                                                            false
                                                                        ? "Activer"
                                                                        : "Desactiver",
                                                                    style:
                                                                        TextStyle(
                                                                      color: e.statutAlerte ==
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
                                                                    e.statutAlerte ==
                                                                            false
                                                                        ? await AlertesService()
                                                                            .activerAlertes(e
                                                                                .idAlerte!)
                                                                            .then((value) =>
                                                                                {
                                                                                  Provider.of<AlertesService>(context, listen: false).applyChange(),
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
                                                                        : await AlertesService()
                                                                            .desactiverAlertes(e
                                                                                .idAlerte!)
                                                                            .then((value) =>
                                                                                {
                                                                                  Provider.of<AlertesService>(context, listen: false).applyChange(),
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
                                                                    await AlertesService()
                                                                        .deleteAlertes(e
                                                                            .idAlerte!)
                                                                        .then((value) =>
                                                                            {
                                                                              Provider.of<AlertesService>(context, listen: false).applyChange(),
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
