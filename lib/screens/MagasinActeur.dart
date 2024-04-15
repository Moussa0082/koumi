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
  late Future<List<Magasin>> magasinList;
    String searchText = "";


  Future<List<Magasin>> getListe(String idActeur, String idNiveau1Pays) async {
    final response = await  fetchMagasinssByRegionAndActeur(idActeur, idNiveau1Pays);

    return response;
  }


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


  Future<List<Magasin>> fetchMagasinssByRegionAndActeur(
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
    return magasin;
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
    magasinList = fetchMagasinssByRegionAndActeur(acteur.idActeur!, selectedRegionId);
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

     List<Magasin> magasinss = magasin;

    if (magasinss.isEmpty) {
      // Si les données ne sont pas encore chargées, affichez l'effet Shimmer
      return   
        SingleChildScrollView(
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
      List<Magasin> filteredMagasins = magasinss.where((magasin) {
        String nomMagasin = magasin.nomMagasin!.toString().toLowerCase();
        nomMagasin = magasin.contactMagasin!.toString().toLowerCase();
        searchText = _searchController.text.toLowerCase();
        return nomMagasin.contains(searchText);
      }).toList();

      // Si aucun magasin n'est trouvé après le filtrage
      if (filteredMagasins.isEmpty) {
        // Vous pouvez afficher une image ou un texte ici
        return 
        SingleChildScrollView(
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
return Consumer<MagasinService>(
      builder: (context, magasinController, _) {
  return FutureBuilder(
                    future: magasinList,
                    builder: (context, snapshot) {      
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
                                         
                                            !isExist ? SizedBox() :  Container(
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
                );
    }
      );
    }
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
