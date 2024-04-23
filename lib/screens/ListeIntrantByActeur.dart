import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/screens/DetailIntrant.dart';
import 'package:koumi_app/service/IntrantService.dart';
import 'package:provider/provider.dart';

class ListeIntrantByActeur extends StatefulWidget {
  const ListeIntrantByActeur({super.key});

  @override
  State<ListeIntrantByActeur> createState() => _ListeIntrantByActeurState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _ListeIntrantByActeurState extends State<ListeIntrantByActeur> {
  late Acteur acteur;
  late TextEditingController _searchController;
  List<Intrant> intrantListe = [];
  late Future futureList;

  List<ParametreGeneraux> paraList = [];
  late ParametreGeneraux para = ParametreGeneraux();

  Future<List<Intrant>> getListe(String id) async {
    final response = await IntrantService().fetchIntrantByActeur(id);
    return response;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    futureList = getListe(acteur.idActeur!);
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;

    if (paraList.isNotEmpty) {
      para = paraList[0];
    }
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
          "Mes intrants ",
          style: TextStyle(
            color: d_colorGreen,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
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
                      color: Colors.blueGrey[400],
                      size: 28), // Utiliser une icône de recherche plus grande
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'Rechercher',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.blueGrey[400]),
                      ),
                    ),
                  ),
                  // Ajouter un bouton de réinitialisation pour effacer le texte de recherche
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Consumer<IntrantService>(builder: (context, intrantService, child) {
            return FutureBuilder(
                future: futureList,
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
                    String searchText = "";
                    List<Intrant> filtereSearch = intrantListe.where((search) {
                      String libelle = search.nomIntrant.toLowerCase();
                      searchText = _searchController.text.toLowerCase();
                      return libelle.contains(searchText);
                    }).toList();
                    return intrantListe.isEmpty
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
                                          height: 90,
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
                                      // SizedBox(height: 8),
                                      ListTile(
                                        title: Text(
                                          e.nomIntrant,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          // maxLines: 1,
                                          // overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                          "${e.prixIntrant.toString()} ${para.monnaie}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildEtat(e.statutIntrant!),
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
                                                      await IntrantService()
                                                          .activerIntrant(
                                                              e.idIntrant!)
                                                          .then((value) => {
                                                                Provider.of<IntrantService>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .applyChange(),
                                                                setState(() {
                                                                  futureList =
                                                                      getListe(
                                                                          acteur
                                                                              .idActeur!);
                                                                }),
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
                                                      color: Colors.orange[400],
                                                    ),
                                                    title: Text(
                                                      "Désactiver",
                                                      style: TextStyle(
                                                        color:
                                                            Colors.orange[400],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      await IntrantService()
                                                          .desactiverIntrant(
                                                              e.idIntrant!)
                                                          .then((value) => {
                                                                Provider.of<IntrantService>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .applyChange(),
                                                                setState(() {
                                                                  futureList =
                                                                      getListe(
                                                                          acteur
                                                                              .idActeur!);
                                                                }),
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
                                                      await IntrantService()
                                                          .deleteIntrant(
                                                              e.idIntrant!)
                                                          .then((value) => {
                                                                Provider.of<IntrantService>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .applyChange(),
                                                                setState(() {
                                                                  futureList =
                                                                      getListe(
                                                                          acteur
                                                                              .idActeur!);
                                                                }),
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
                              );
                            },
                          );
                  }
                });
          })
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
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                overflow: TextOverflow.ellipsis,
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
