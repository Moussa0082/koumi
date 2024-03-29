import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/Admin/AcceuilAdmin.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddMagasinScreen.dart';
import 'package:koumi_app/screens/Produit.dart';
import 'package:koumi_app/service/MagasinService.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class MagasinScreen extends StatefulWidget {
  const MagasinScreen({super.key});

  @override
  State<MagasinScreen> createState() => _MagasinScreenState();
}

class _MagasinScreenState extends State<MagasinScreen>
    with TickerProviderStateMixin {
  // Déclarez une variable pour suivre si le chargement est terminé
  

  TabController? _tabController;
  late TextEditingController _searchController;

  List<Magasin> magasin = [];
  late Acteur acteur = Acteur();
  late List<TypeActeur> typeActeurData = [];
  late String type;
  List<Niveau1Pays> niveau1Pays = [];
  String selectedRegionId =
      ''; // Ajoutez une variable pour stocker l'ID de la région sélectionnée

  double scaleFactor = 1;
  bool isVisible = true;

  String localiteMagasin = "";
  String contactMagasin = "";
  File? photo;
  String searchText = "";

  Set<String> loadedRegions =
      {}; // Ensemble pour garder une trace des régions pour lesquelles les magasins ont déjà été chargés

  void fetchRegions() async {
    try {
      final response = await http
          // .get(Uri.parse('https://koumi.ml/api-koumi/niveau1Pays/read'));
          .get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

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
        fetchMagasinsByRegion(
            niveau1Pays.isNotEmpty ? niveau1Pays.first.idNiveau1Pays! : '');
      } else {
        throw Exception('Failed to load regions');
      }
    } catch (e) {
      print('Error fetching regions: $e');
    }
  }


  void fetchMagasinsByRegion(String id) async {
    try {
      final response = await http.get(Uri.parse(
          // 'https://koumi.ml/api-koumi/Magasin/getAllMagasinByPays/${id}'));
          'http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByPays/${id}'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
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
      } else {
        throw Exception('Failed to load magasins for region $id');
      }
    } catch (e) {
      print('Error fetching magasins for region $id: $e');
    }
  }
  Future<void> fetchMagasinByRegion(String id) async {
    try {
      final response = await http.get(Uri.parse(
          // 'https://koumi.ml/api-koumi/Magasin/getAllMagasinByPays/${id}'));
          'http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByPays/${id}'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
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
      } else {
        throw Exception('Failed to load magasins for region $id');
      }
    } catch (e) {
      print('Error fetching magasins for region $id: $e');
    }
  }

  void _handleTabChange() {
    if (_tabController != null &&
        _tabController!.index >= 0 &&
        _tabController!.index < niveau1Pays.length) {
      selectedRegionId = niveau1Pays[_tabController!.index].idNiveau1Pays!;
      fetchMagasinsByRegion(selectedRegionId);
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
      if (niveau1Pays.isNotEmpty) {
      selectedRegionId = niveau1Pays[_tabController!.index].idNiveau1Pays!;
      // fetchMagasinsByRegion(selectedRegionId);
    }
    fetchRegions();
  }


  @override
  void initState() {
    super.initState();
    verify();
    _searchController = TextEditingController();
  
  }

  @override
  Widget build(BuildContext context) {
    const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
    return Container(
      child: DefaultTabController(
        length: niveau1Pays.length,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 100,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
            title: Text('Tous les boutiques'),
            bottom: TabBar(
              isScrollable: niveau1Pays.length > 4,
              labelColor: Colors.black,
              controller: _tabController, // Ajoutez le contrôleur TabBar
              tabs: niveau1Pays
                  .map((region) => Tab(text: region.nomN1!))
                  .toList(),
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
                        "Ajouter Magasin",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMagasinScreen(isEditable: false,)));

                      },
                    ),
                  ),
                ],
              )
            ],
          ),
          body: Padding(
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
                        return buildGridView(region.idNiveau1Pays!);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridView(String id) {
    List<Magasin> magasinss = magasin;
    // Accéder à la liste des types d'acteurs de cet acteur

    if (magasinss.isEmpty) {
      // Si les données ne sont pas encore chargées, affichez l'effet Shimmer
      return _buildShimmerEffect();
    } else {
      // Filtrer les magasins en fonction du texte de recherche
      List<Magasin> filteredMagasins = magasinss.where((magasin) {
        String nomMagasin = magasin.nomMagasin!.toString().toLowerCase();
        localiteMagasin = magasin.localiteMagasin!.toString().toLowerCase();
        contactMagasin = magasin.contactMagasin!.toString().toLowerCase();
        searchText = _searchController.text.toLowerCase();
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
            Magasin magasin = filteredMagasins[index];
            Magasin currentMagasin = magasin;
            String typeActeurList = '';
              
            // Vérifiez d'abord si l'acteur est disponible dans le magasin
            if (currentMagasin.acteur != null &&
                currentMagasin.acteur!.typeActeur != null) {
              // Parcourez la liste des types d'acteurs et extrayez les libellés
              typeActeurList = currentMagasin.acteur!.typeActeur!
                  .map((type) => type
                      .libelle) // Utilisez la propriété libelle pour récupérer le libellé
                  .join(', '); // Joignez tous les libellés avec une virgule
            }
            // ici on a recuperer les details du  magasin
            // String magasin = filteredMagasins[index].photo!;
            return GestureDetector(
                     onTap: () {
                    String id = magasin.idMagasin!;
                    String nom = magasin.nomMagasin!;
                
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ProduitScreen(
                          id: id,
                          nom: nom,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin =
                              Offset(0.0, 1.0); // Commencer en bas de l'écran
                          var end = Offset.zero; // Finir en haut de l'écran
                          var curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(
                            milliseconds: 1900), // Durée de la transition
                      ),
                    );
                  },
              child: Column(
                children: [
                         Container(
                          // height: MediaQuery.sizeOf(context).height,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.2),
                                        offset: const Offset(0, 1),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: SizedBox(
                                              height: 80,
                                              child: magasin.photo == null
                                                  ? Image.asset(
                                                      "assets/images/magasin.png",
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      "http://10.0.2.2/${magasin.photo}",
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (BuildContext
                                                                  context,
                                                              Object
                                                                  exception,
                                                              StackTrace?
                                                                  stackTrace) {
                                                        return Image.asset(
                                                          'assets/images/magasin.png',
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    ),
                                            ),
                                          ),
                                        ),
                                        // _buildItem(
                                        //     "Nom :", magasin.nomMagasin!.toUpperCase()),
                                        // _buildItem(
                                        //     "Type Acteur :", type),
                                     Column(
                                                  children: [
                                                       Padding(
                                           padding: const EdgeInsets.all(4.0),
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Flexible(
                                                 child: Text(
                                                   "Nom",
                                                   style: const TextStyle(
                                                   
                                                       color: Colors.black87,
                                                       fontWeight: FontWeight.w800,
                                                       fontStyle: FontStyle.italic,
                                                       overflow: TextOverflow.ellipsis,
                                                       fontSize: 16),
                                                 ),
                                               ),
                                               Flexible(
                                                 child: Text(
                                                   magasin.nomMagasin!.toUpperCase(),
                                                   style: const TextStyle(
                                                       color: Colors.black,
                                                       fontWeight: FontWeight.w800,
                                                       overflow: TextOverflow.ellipsis,
                                                       fontSize: 16),
                                                 ),
                                               )
                                             ],
                                           ),
                                         ),
                                        // Padding(
                                        //    padding: const EdgeInsets.all(4.0),
                                        //    child: Row(
                                        //      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //      children: [
                                        //        Flexible(
                                        //          child: Text(
                                        //            "title",
                                        //            style: const TextStyle(
                                                   
                                        //                color: Colors.black87,
                                        //                fontWeight: FontWeight.w800,
                                        //                fontStyle: FontStyle.italic,
                                        //                overflow: TextOverflow.ellipsis,
                                        //                fontSize: 16),
                                        //          ),
                                        //        ),
                                        //        Flexible(
                                        //          child: Text(
                                        //            "value",
                                        //            style: const TextStyle(
                                        //                color: Colors.black,
                                        //                fontWeight: FontWeight.w800,
                                        //                overflow: TextOverflow.ellipsis,
                                        //                fontSize: 16),
                                        //          ),
                                        //        )
                                        //      ],
                                        //    ),
                                        //  ),
                                     
                                          Container(
                                            child: 
                                             Container(
                                              alignment:
                                                        Alignment.bottomRight,
                                           child: Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                                                                                        child: Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               children: [
                                                 _buildEtat(magasin.statutMagasin!),
                                                 SizedBox(width: 120,),
                                                 Expanded(
                                                   child: PopupMenuButton<String>(
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
                                                               fontWeight: FontWeight.bold,
                                                             ),
                                                           ),
                                                           onTap: () async {
                                                             await MagasinService()
                                                                 .activerMagasin(magasin.idMagasin!)
                                                                 .then((value) => {
                                                                       Navigator.of(context).pop(),
                                                                     })
                                                                 .catchError((onError) => {
                                                                       ScaffoldMessenger.of(context)
                                                                           .showSnackBar(
                                                                         const SnackBar(
                                                                           content: Row(
                                                                             children: [
                                                                               Text(
                                                                                   "Une erreur s'est produit"),
                                                                             ],
                                                                           ),
                                                                           duration:
                                                                               Duration(seconds: 5),
                                                                         ),
                                                                       ),
                                                                       Navigator.of(context).pop(),
                                                                     });
                                                   
                                                             ScaffoldMessenger.of(context)
                                                                 .showSnackBar(
                                                               const SnackBar(
                                                                 content: Row(
                                                                   children: [
                                                                     Text("Activer avec succèss "),
                                                                   ],
                                                                 ),
                                                                 duration: Duration(seconds: 2),
                                                               ),
                                                             );
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
                                                               color: Colors.orange[400],
                                                               fontWeight: FontWeight.bold,
                                                             ),
                                                           ),
                                                           onTap: () async {
                                                             await MagasinService()
                                                                 .desactiverMagasin(magasin.idMagasin!)
                                                                 .then((value) => {
                                                                       Navigator.of(context).pop(),
                                                                     })
                                                                 .catchError((onError) => {
                                                                       ScaffoldMessenger.of(context)
                                                                           .showSnackBar(
                                                                         const SnackBar(
                                                                           content: Row(
                                                                             children: [
                                                                               Text(
                                                                                   "Une erreur s'est produit"),
                                                                             ],
                                                                           ),
                                                                           duration:
                                                                               Duration(seconds: 5),
                                                                         ),
                                                                       ),
                                                                       Navigator.of(context).pop(),
                                                                     });
                                                   
                                                             ScaffoldMessenger.of(context)
                                                                 .showSnackBar(
                                                               const SnackBar(
                                                                 content: Row(
                                                                   children: [
                                                                     Text("Désactiver avec succèss "),
                                                                   ],
                                                                 ),
                                                                 duration: Duration(seconds: 2),
                                                               ),
                                                             );
                                                           },
                                                         ),
                                                       ),
                                                       PopupMenuItem<String>(
                                                         child: ListTile(
                                                           leading: Icon(
                                                             Icons.disabled_visible,
                                                             color: Colors.green[400],
                                                           ),
                                                           title: Text(
                                                             "Modifier",
                                                             style: TextStyle(
                                                               color: Colors.green[400],
                                                               fontWeight: FontWeight.bold,
                                                             ),
                                                           ),
                                                           onTap: () async {
                                                             Navigator.push(
                                                               context,
                                                               PageRouteBuilder(
                                                                 pageBuilder: (context, animation,
                                                                     secondaryAnimation) {
                                                                   return FadeTransition(
                                                                     opacity: animation,
                                                                     child: ScaleTransition(
                                                                       scale: animation,
                                                                       child: AddMagasinScreen(
                                                                         idMagasin: magasin.idMagasin,
                                                                         isEditable: true,
                                                                         nomMagasin:
                                                                             magasin.nomMagasin,
                                                                         contactMagasin:
                                                                             magasin.contactMagasin,
                                                                         localiteMagasin:
                                                                             magasin.localiteMagasin,
                                                                         niveau1Pays:
                                                                             magasin.niveau1Pays!,
                                                                         // photo: filteredMagasins[index]['photo']!,
                                                                       ),
                                                                     ),
                                                                   );
                                                                 },
                                                                 transitionsBuilder: (context,
                                                                     animation,
                                                                     secondaryAnimation,
                                                                     child) {
                                                                   return child;
                                                                 },
                                                                 transitionDuration: const Duration(
                                                                     milliseconds:
                                                                         1500), // Durée de la transition
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
                                                               fontWeight: FontWeight.bold,
                                                             ),
                                                           ),
                                                           onTap: () async {
                                                             await MagasinService()
                                                                 .deleteMagasin(filteredMagasins[index]
                                                                     .idMagasin!)
                                                                 .then((value) => {
                                                                       Provider.of<MagasinService>(
                                                                               context,
                                                                               listen: false)
                                                                           .applyChange(),
                                                                       setState(() {
                                                                         filteredMagasins = magasinss;
                                                                       }),
                                                                       Navigator.of(context).pop(),
                                                                       ScaffoldMessenger.of(context)
                                                                           .showSnackBar(
                                                                         const SnackBar(
                                                                           content: Row(
                                                                             children: [
                                                                               Text(
                                                                                   "Magasin supprimer avec succès"),
                                                                             ],
                                                                           ),
                                                                           duration:
                                                                               Duration(seconds: 2),
                                                                         ),
                                                                       )
                                                                     })
                                                                 .catchError((onError) => {
                                                                       ScaffoldMessenger.of(context)
                                                                           .showSnackBar(
                                                                         const SnackBar(
                                                                           content: Row(
                                                                             children: [
                                                                               Text(
                                                                                   "Impossible de supprimer"),
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
                                                 ),
                                               ],
                                                                                        ),
                                                                                      ),
                                             ),
                                          ),
                                                       ],
                                     ),
                                        
                                      ],
                                    ),
                                  ),
                                ),
              
                                
                 
                ],
              ),
            );
          },
        ),
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

 Widget _buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
              
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

}