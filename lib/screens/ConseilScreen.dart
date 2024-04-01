import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Conseil.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddConseil.dart';
import 'package:koumi_app/screens/DetailConseil.dart';
import 'package:koumi_app/service/ConseilService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          actions: [
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
                                builder: (context) => AddConseil()));
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
                                                  DetailConseil(conseil: e)));
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
                                      child: Column(children: [
                                        ListTile(
                                            leading: Image.asset(
                                              "assets/images/conseille.png",
                                              width: 80,
                                              height: 80,
                                            ),
                                            title: Text(
                                                e.titreConseil.toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                            subtitle: Text(e.dateAjout!,
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.italic,
                                                ))),
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
}
