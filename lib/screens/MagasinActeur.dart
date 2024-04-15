import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddMagasinScreen.dart';
import 'package:koumi_app/screens/Produit.dart';
import 'package:koumi_app/service/MagasinService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class MagasinActeurScreen extends StatefulWidget {
  const MagasinActeurScreen({super.key});

  @override
  State<MagasinActeurScreen> createState() => _MagasinActeurScreenState();
}

class _MagasinActeurScreenState extends State<MagasinActeurScreen>
    with TickerProviderStateMixin {
  late Acteur acteur = Acteur();
  TabController? _tabController;
  late TextEditingController _searchController;

  List<Niveau1Pays> niveau1Pays = [];
  List<Magasin> magasin = [];

  String selectedRegionId =
      ''; // Ajoutez une variable pour stocker l'ID de la région sélectionnée

  bool isAdmin = false;

  Set<String> loadedRegions =
      {}; // Ensemble pour garder une trace des régions pour lesquelles les magasins ont déjà été chargés

  void fetchRegions() async {
    try {
      final response = await http
          // .get(Uri.parse('https://koumi.ml/api-koumi/niveau1Pays/read'));
          .get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read'));
      if (response.statusCode == 200) {
        final String jsonString = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(jsonString);
        setState(() {
          niveau1Pays = data
              .where((niveau1Pays) => niveau1Pays['statutN1'] == true)
              .map((item) => Niveau1Pays(
                  idNiveau1Pays: item['idNiveau1Pays'] as String,
                  nomN1: item['nomN1']))
              .toList();
        });

        _tabController = TabController(length: niveau1Pays.length, vsync: this);
        _tabController!.addListener(_handleTabChange);

        // Fetch les magasins pour la première région

        fetchMagasinsByRegionAndActeur(acteur.idActeur!,
            niveau1Pays.isNotEmpty ? niveau1Pays.first.idNiveau1Pays! : '');
      } else {
        throw Exception('Failed to load regions');
      }
    } catch (e) {
      print('Error fetching regions: $e');
    }
  }

  void fetchMagasinsByRegionAndActeur(
      String idActeur, String idNiveau1Pays) async {
    try {
      final response = await http.get(Uri.parse(
          // 'https://koumi.ml/api-koumi/Magasin/getAllMagasinByActeurAndNieau1Pay/${idActeur}/${idNiveau1Pays}'));
          'http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByActeurAndNiveau1Pays/${idActeur}/${idNiveau1Pays}'));
      if (response.statusCode == 200) {
        final String jsonString = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(jsonString);
        setState(() {
          magasin = data
              .where((magasin) => magasin['statutMagasin'] == true)
              .map((item) => Magasin(
                    nomMagasin: item['nomMagasin'] ?? 'Nom du magasin manquant',
                    idMagasin: item['idMagasin'] ?? 'ID du magasin manquant',
                    contactMagasin:
                        item['contactMagasin'] ?? 'Contact manquant',
                    photo: item['photo'] ?? '',
                    // ou utilisez une URL par défaut
                    acteur: Acteur(
                      idActeur: item['acteur']['idActeur'] ?? 'manquant',
                      nomActeur: item['acteur']['nomActeur'] ?? ' manquant',
                      // Autres champs de l'acteur...
                    ),
                    niveau1Pays: Niveau1Pays(
                      idNiveau1Pays: item['niveau1Pays']['idNiveau1Pays'] ?? 'manquant',
                      nomN1: item['niveau1Pays']['nomN1'] ?? 'manquant',
                      // Autres champs de l'acteur...
                    ),
                    dateAjout: item['dateAjout'] ?? 'manquante',
                    localiteMagasin: item['localiteMagasin'] ?? 'manquante',
                    statutMagasin: item['statutMagasin'] ??
                        false, // ou une valeur par défaut
                  ))
              .toList();
        });

        // if (!loadedRegions.contains(idNiveau1Pays)) {
        //   loadedRegions.add(idNiveau1Pays);
        // }
      } else {
        throw Exception('Failed to load magasins for acteur $idActeur et region $idNiveau1Pays');
      }
    } catch (e) {
      print('Error fetching magasins for acteur $idActeur: $e');
    }
  }

  void _handleTabChange() {
    if (_tabController != null &&
        _tabController!.index >= 0 &&
        _tabController!.index < niveau1Pays.length) {
      selectedRegionId = niveau1Pays[_tabController!.index].idNiveau1Pays!;
      fetchMagasinsByRegionAndActeur(acteur.idActeur!, selectedRegionId);
    }
  }

  bool isExist = false;

  String? email = "";

  void verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('emailActeur');
    if (email != null) {
      // Si l'email de l'acteur est présent, exécute checkLoggedIn
      acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;

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
    _searchController = TextEditingController();
    verify();
    if (niveau1Pays.isNotEmpty) {
      selectedRegionId = niveau1Pays[_tabController!.index].idNiveau1Pays!;
    }
    fetchRegions();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController
        .dispose(); // Disposez le TextEditingController lorsque vous n'en avez plus besoin
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
    return Container(
      child: DefaultTabController(
        length: niveau1Pays.length,
        child: Scaffold(
          // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          appBar: AppBar(
            actions: <PopupMenuEntry<String>>[
              //     PopupMenuItem<String>(
              //       value: 'modifier',
              //       child: Text('Modifier'),
              //     ),
              //     PopupMenuItem<String>(
              //       value: 'activer',
              //       child: Text('Activer'),
              //     ),
              //     PopupMenuItem<String>(
              //       value: 'desactiver',
              //       child: Text('Désactiver'),
              //     ),
              //     PopupMenuItem<String>(
              //       value: 'supprimer',
              //       child: Text('Supprimer'),
              //     ),
              //   ],
              //   elevation: 8.0, // Ajustez l'élévation selon vos préférences
              // ).then((String? value) {
              //   if (value != null) {
              //     // Mettez en œuvre ici la logique pour chaque option sélectionnée
              //     switch (value) {
              //       case 'modifier':
              //         // Mettez en œuvre la logique pour modifier le magasin
              //         break;
              //       case 'activer':
              //         // Mettez en œuvre la logique pour activer le magasin
              //         break;
              //       case 'desactiver':
              //         // Mettez en œuvre la logique pour désactiver le magasin
              //         break;
              //       case 'supprimer':
              //         // Mettez en œuvre la logique pour supprimer le magasin
              //         break;
              //     }
              //   }});
              //                 },
              //                 child: Align(
              //                   alignment: Alignment.bottomRight,
              //                   child: SizedBox(
              //                     height: 10,
              //                     child: IconButton(
              //                       icon: Icon(Icons.more_vert), // Icône de points de suspension
              //                       onPressed: () {

              //                       },
              //                     ),
              //                   ),
              //                 ),
              //               ),
            ],
            centerTitle: true,
            toolbarHeight: 100,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
            title: Text('Mes boutiques'),
            bottom: TabBar(
              isScrollable: niveau1Pays.length > 4,
              labelColor: Colors.black,
              controller: _tabController, // Ajoutez le contrôleur TabBar
              tabs: niveau1Pays
                  .map((region) => Tab(text: region.nomN1!))
                  .toList(),
            ),
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                              color:
                                  Colors.blueGrey[400]), // Couleur de l'icône
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
                                    color: Colors.blueGrey[
                                        400]), // Couleur du texte d'aide
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // const SizedBox(height:10),
                  Flexible(
                    child: GestureDetector(
                      child: TabBarView(
                        controller:
                            _tabController, // Ajoutez le contrôleur TabBarView
                        children: niveau1Pays.map((region) {
                          return buildGridView(
                              acteur.idActeur!, region.idNiveau1Pays!);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridView(String idActeur, String idNiveau1Pays) {
    try {
      List<Magasin> magasins = magasin;

      if (magasins.isEmpty) {
        // Si les données ne sont pas encore chargées, affichez l'effet Shimmer

             return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/notif.jpg'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Aucun magasin trouvé ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
      } else {
        // Filtrer les magasins en fonction du texte de recherche
        List<Magasin> filteredMagasins = magasins.where((magasin) {
          String nomMagasin = magasin.nomMagasin!.toString().toLowerCase();
          String searchText = _searchController.text.toLowerCase();
          return nomMagasin.contains(searchText);
        }).toList();

        // Si aucun magasin n'est trouvé après le filtrage
        if (filteredMagasins.isEmpty) {
          // Vous pouvez afficher une image ou un texte ici
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/notif.jpg'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Aucun magasin trouvé ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Sinon, afficher la GridView avec les magasins filtrés
        return Container(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: filteredMagasins.length,
            itemBuilder: (context, index) {
              // ici on a recuperer les details du  magasin
              Magasin magasin = filteredMagasins[index];
              return Expanded(
                child: Container(
                  height: 150,
                  width: 150,
                  child: GestureDetector(
                    onTap: () {
                      String id = magasin.idMagasin!;
                      String nom = magasin.nomMagasin!;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProduitScreen(
                                  id: id,
                                  nom: nom,
                                )),
                      );
                    },
                    child: Card(
                      shadowColor: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: magasin.photo!.isNotEmpty ? Image.network(
                                // "https://koumi.ml/api-koumi/${magasin.photo}" ?? "assets/images/magasin.png",
                                "http://10.0.2.2:9000/api-koumi/${magasin.photo}" ,
                                     
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/magasin.png',
                                    height: 120,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ) : Image.asset("assets/images/magasin.png",height: 120,
                                    fit: BoxFit.cover,),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              magasin.nomMagasin!.toUpperCase(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Nombre de produits:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  '10',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          // if (isAdmin) // Ajoute l'action des trois points si l'utilisateur est un administrateur
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    } catch (e) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/notif.jpg'),
              SizedBox(
                height: 10,
              ),
              Text('Aucun magasin trouvé ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    overflow: TextOverflow.ellipsis,
                  ))
            ],
          ),
        ),
      );
    }
    // Ajoutez un retour de widget vide à la fin pour s'assurer que la fonction renvoie toujours un widget
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: 6, // Nombre de cellules de la grille
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
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
