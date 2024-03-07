import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/screens/AddMagasinScreen.dart';
import 'package:koumi_app/screens/Produit.dart';
import 'package:koumi_app/service/MagasinService.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MagasinScreen extends StatefulWidget {
  const MagasinScreen({super.key});

  @override
  State<MagasinScreen> createState() => _MagasinScreenState();
}

class _MagasinScreenState extends State<MagasinScreen>
    with TickerProviderStateMixin {
  // Déclarez une variable pour suivre si le chargement est terminé
  bool _loadingFinished = false;
  bool isEditable = true;
  bool isEditableAdd = false;

  TabController? _tabController;
  late TextEditingController _searchController;

  List<String> regions = [];
  List<String> idNiveau1Pays = [];
  String selectedRegionId =
      ''; // Ajoutez une variable pour stocker l'ID de la région sélectionnée

  Map<String, List<Map<String, dynamic>>> magasinsParRegion = {};

  double scaleFactor = 1;
  bool isVisible = true;

  List<Map<String, dynamic>> regionsData = [];
  List<String> magasins = [];

        String localiteMagasin = "";
        String contactMagasin = "";
        File? photo;
        String searchText = "";

  Set<String> loadedRegions =
      {}; // Ensemble pour garder une trace des régions pour lesquelles les magasins ont déjà été chargés

  void fetchRegions() async {
    try {
      final response = await http
          .get(Uri.parse('https://koumi.ml/api-koumi/niveau1Pays/read'));
          // .get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Filtrer les éléments avec statutN1 == true
        List<dynamic> filteredData =
            data.where((item) => item['statutN1'] == true).toList();

        setState(() {
          regionsData = filteredData.cast<Map<String, dynamic>>();
          regions = regionsData.map((item) => item['nomN1'] as String).toList();
          idNiveau1Pays = regionsData
              .map((item) => item['idNiveau1Pays'] as String)
              .toList();
        });

        _tabController = TabController(length: regions.length, vsync: this);
        _tabController!.addListener(_handleTabChange);

        // Fetch les magasins pour la première région
        fetchMagasinsByRegion(idNiveau1Pays.isNotEmpty
            ? idNiveau1Pays[_tabController!.index]
            : '');
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
          'https://koumi.ml/api-koumi/Magasin/getAllMagasinByPays/${id}'));
          // 'http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByPays/${id}'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> magasins = data
            .where((magasin) =>
                magasin['statutMagasin'] == true) // Filtrer les magasins actifs
            .map<Map<String, dynamic>>((item) => {
                  'nomMagasin': item['nomMagasin'],
                  'idMagasin': item['idMagasin'],
                  'contactMagasin': item['contactMagasin'],
                  'photo': item['photo'],
                  'acteur':item['acteur'],
                  'dateAjout':item['dateAjout'],
                  'localiteMagasin':item['localiteMagasin'],
                  'statutMagasin': item['statutMagasin'],
                  'niveau1Pays': item['niveau1Pays'],
                })
            .toList();
        setState(() {
          magasinsParRegion[id] = magasins;
        });
        if (!loadedRegions.contains(id)) {
          loadedRegions.add(id);
        }
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
        _tabController!.index < idNiveau1Pays.length) {
      String selectedRegionId = idNiveau1Pays[_tabController!.index];
      fetchMagasinsByRegion(selectedRegionId);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (idNiveau1Pays.isNotEmpty) {
      selectedRegionId = idNiveau1Pays[_tabController!.index];
    }
    fetchRegions();
  }

  @override
  Widget build(BuildContext context) {
    const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
    return Container(
      child: DefaultTabController(
        length: regions.length,
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
              isScrollable: regions.length > 4,
              labelColor: Colors.black,
              controller: _tabController, // Ajoutez le contrôleur TabBar
              tabs: regions.map((region) => Tab(text: region)).toList(),
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
                                builder: (context) => AddMagasinScreen(isEditable: isEditableAdd,)));
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
                      children: idNiveau1Pays.map((region) {
                        return buildGridView(region);
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
    List<Map<String, dynamic>>? magasins = magasinsParRegion[id];
        // Accéder à la liste des types d'acteurs de cet acteur

    if (magasins == null) {
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
                                  Text('Aucun magasin trouvé ',
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
      List<Map<String, dynamic>> filteredMagasins = magasins.where((magasin) {
        String nomMagasin = magasin['nomMagasin']!.toString().toLowerCase();
         localiteMagasin= magasin['localiteMagasin']!.toString().toLowerCase();
         contactMagasin= magasin['contactMagasin']!.toString().toLowerCase();
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
                                  Text('Aucun magasin trouvé ',
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
            Map<String, dynamic> magasin = filteredMagasins[index];
            return Container(
               height:100,
              // width: 150,
              child: GestureDetector(
                onTap: () {
                  String id = magasin['idMagasin'];
                  String nom = magasin['nomMagasin'];
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => ProduitScreen(
                  //             id: id,
                  //             nom: nom,
                  //           )),
                  // );
                  Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ProduitScreen(
      id: id,
      nom: nom,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0); // Commencer en bas de l'écran
      var end = Offset.zero; // Finir en haut de l'écran
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 1500 ), // Durée de la transition
  ),
);

//                   Navigator.push(
// context,
// PageRouteBuilder(
// pageBuilder: (context, animation, secondaryAnimation) => ProduitScreen(
//                               id: id,
//                               nom: nom,
//                             ),
// transitionsBuilder: (context, animation, secondaryAnimation, child) {
// var begin = Offset(1.0, 0.0);
// var end = Offset.zero;
// var curve = Curves.ease;

// var tween = Tween(begin: begin, end: end)
// .chain(CurveTween(curve: curve));

// return SlideTransition(
// position: animation.drive(tween),
// child: child,
// );
// },
// ),
// );
                },
        //         child: Card(
        //           shadowColor: Colors.white,
        //           child: Column(
        //          crossAxisAlignment: CrossAxisAlignment.stretch,
        //             children: [
        
        //               Container(
        //                 child: ClipRRect(
        //     borderRadius: BorderRadius.circular(8.0),
        //                   child: Image.network(
        //                     "http://10.0.2.2/${filteredMagasins[index]['photo']}" ??
        //                         "assets/images/magasin.png",
        //                     width: double.infinity,
        //                      height: 120,
        //                     fit: BoxFit.cover,
        //                     errorBuilder: (BuildContext context,
        //                         Object exception, StackTrace? stackTrace) {
        //                       return Image.asset(
        //                         'assets/images/magasin.png',
        //                         width: double.infinity,
        //                         height: 150,
        //                         fit: BoxFit.cover,
        //                       );
        //                     },
        //                   ),
        //                 ),
        //               ),
        //            const SizedBox(height: 10),
        //               Text(
        //                 // overflow: TextOverflow.ellipsis,
        //                 filteredMagasins[index]['nomMagasin']
        //                         .toUpperCase() ??
        //                     'Pas de nom défini',
        //                 textAlign: TextAlign.center,
        //                 style:
        //                     TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        //               ),

        //               GestureDetector(
        //                 onTap:(){
                           
        // showMenu(
        //   context: context,
        //   position: RelativeRect.fromLTRB(0, 0, 0, 0), // Vous pouvez ajuster la position selon vos besoins
        //   items: <PopupMenuEntry<String>>[
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
   
                      
        //             ],
        //           ),
        //         ),
        child:
        Container(
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
                                      child: Column(
                                        children: [
                                          ListTile(
                                              leading: 
                                                      filteredMagasins[index]['photo']
                                .toUpperCase().isEmpty
                                                  ? ProfilePhoto(
                                                      totalWidth: 50,
                                                      cornerRadius: 50,
                                                      color: Colors.black,
                                                      image: const AssetImage(
                                                          'assets/images/magasin.png'),
                                                    )
                                                  : ProfilePhoto(
                                                      totalWidth: 50,
                                                      cornerRadius: 50,
                                                      color: Colors.black,
                                                      image: NetworkImage(
                                                          "http://10.0.2.2/${filteredMagasins[index]['photo']}"),
                                                    ),
                                              title: Text(
filteredMagasins[index]['acteur'] != null ? filteredMagasins[index]['acteur']['nomActeur'].toUpperCase() : 'N/A' ,
                                                 style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                              subtitle: Text(
                                              'Ac',
                                                  // filteredMagasins[index]['acteur']['typeActeur']
                                                  //     .map((data) =>
                                                  //         data.libelle)
                                                  //     .join(', '),
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.italic,
                                                  ))),
                                          // Padding(
                                          //   padding: EdgeInsets.symmetric(
                                          //       horizontal: 15),
                                          //   child: Row(
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment
                                          //             .spaceBetween,
                                          //     children: [
                                          //       Text("Date d'adhésion :",
                                          //           style: TextStyle(
                                          //             color: Colors.black87,
                                          //             fontSize: 15,
                                          //             fontWeight:
                                          //                 FontWeight.w500,
                                          //             fontStyle:
                                          //                 FontStyle.italic,
                                          //           )),
                                          //       Text(filteredMagasins[index]['dateAjout'],
                                          //           style: TextStyle(
                                          //             color: Colors.black87,
                                          //             fontSize: 16,
                                          //             fontWeight:
                                          //                 FontWeight.w800,
                                          //           ))
                                          //     ],
                                          //   ),
                                          // ),
                                          Container(
                                            alignment: Alignment.bottomRight,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _buildEtat(filteredMagasins[index]['statutMagasin']),
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
                                                           await MagasinService()
                                                                                      .activerMagasin(
                                                                                        filteredMagasins[index]['idMagasin']
                                                                                          )
                                                                                      .then(
                                                                                          (value) =>
                                                                                              {
                                                                                            
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
                                                                                              "Activer avec succèss "),
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
                                                                .orange[400],
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                           await MagasinService()
                                                                                      .desactiverMagasin(
                                                                                        filteredMagasins[index]['idMagasin']
                                                                                          )
                                                                                      .then(
                                                                                          (value) =>
                                                                                              {
                                                                                            
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
                                                        leading: Icon(
                                                          Icons
                                                              .disabled_visible,
                                                          color: Colors
                                                              .green[400],
                                                        ),
                                                        title: Text(
                                                          "Modifier",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .green[400],
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          
                                                            Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: AddMagasinScreen(
            idMagasin: id,
            isEditable: isEditable,
            nomMagasin:filteredMagasins[index]['nomMagasin'] ,
            contactMagasin: filteredMagasins[index]['contactMagasin'],
            localiteMagasin:filteredMagasins[index]['localiteMagasin'],
            // niveau1Pays:filteredMagasins[index]['niveau1Pays'] ,
            // photo: filteredMagasins[index]['photo']!,
          ),
        ),
      );
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
    transitionDuration: const Duration(milliseconds: 1500), // Durée de la transition
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
                                                          await MagasinService()
                                                                                      .deleteMagasin(
                                                                              filteredMagasins[index]['idMagasin'])
                                                                                      .then(
                                                                                          (value) =>
                                                                                              {
                                                                                                Provider.of<MagasinService>(context, listen: false).applyChange(),
                                                                                                setState(() {
                                                                                                  filteredMagasins = magasins;
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
}