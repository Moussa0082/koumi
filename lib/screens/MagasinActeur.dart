import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddMagasinScreen.dart';
import 'package:koumi_app/screens/Produit.dart';
import 'package:koumi_app/service/MagasinService.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';


class MagasinActeurScreen extends StatefulWidget {
  const MagasinActeurScreen({super.key});

  @override
  State<MagasinActeurScreen> createState() => _MagasinActeurScreenState();
}

class _MagasinActeurScreenState extends State<MagasinActeurScreen>  with TickerProviderStateMixin{
  
   late Acteur acteur;
   TabController? _tabController;
    late TextEditingController _searchController;

  List<String> regions = [];
  List<String> idNiveau1Pays = [];
   String selectedRegionId = ''; // Ajoutez une variable pour stocker l'ID de la région sélectionnée
  
  Map<String, List<Map<String, dynamic>>> magasinsParRegion = {};

  List<Map<String, dynamic>> regionsData = [];
  List<String> magasins = [];
  int currentIndex = 0;
  bool isAdmin = false;

  Set<String> loadedRegions = {}; // Ensemble pour garder une trace des régions pour lesquelles les magasins ont déjà été chargés

  void fetchRegions() async {
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      
      // Filtrer les éléments avec statutN1 == true
      List<dynamic> filteredData = data.where((item) => item['statutN1'] == true).toList();
      
      setState(() {
        regionsData = filteredData.cast<Map<String, dynamic>>();
        regions = regionsData.map((item) => item['nomN1'] as String).toList();
        idNiveau1Pays = regionsData.map((item) => item['idNiveau1Pays'] as String).toList();
      });
      
      _tabController = TabController(length: regions.length, vsync: this);
      _tabController!.addListener(_handleTabChange);
      
      // Fetch les magasins pour la première région
      fetchMagasinsByRegionAndActeur(acteur.idActeur!,idNiveau1Pays.isNotEmpty ? idNiveau1Pays[_tabController!.index] : '');
    } else {
      throw Exception('Failed to load regions');
    }
  } catch (e) {
    print('Error fetching regions: $e');
  }
}


  void fetchMagasinsByRegionAndActeur(String idActeur,String idNiveau1Pays) async {
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByActeurAndNieau1Pays/${idActeur}/${idNiveau1Pays}'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> magasins = data
          .where((magasin) => magasin['statutMagasin'] == true) // Filtrer les magasins actifs
          .map<Map<String, dynamic>>((item) => {
            'nomMagasin': item['nomMagasin'],
            'idMagasin': item['idMagasin'],
            'photo': item['photo'],
          })
          .toList();
      setState(() {
        magasinsParRegion[idNiveau1Pays] = magasins;
      });
      if (!loadedRegions.contains(idNiveau1Pays)) {
        loadedRegions.add(idNiveau1Pays);
      }
    } else {
      throw Exception('Failed to load magasins for acteur $idActeur');
    }
  } catch (e) {
    print('Error fetching magasins for acteur $idActeur: $e');
  }
}

 void _handleTabChange() {
  if (_tabController != null && _tabController!.index >= 0 && _tabController!.index < idNiveau1Pays.length) {
    String selectedRegionId = idNiveau1Pays[_tabController!.index];
    fetchMagasinsByRegionAndActeur(acteur.idActeur!,selectedRegionId);
  }
}

   
   @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
   if (idNiveau1Pays.isNotEmpty) {
      selectedRegionId = idNiveau1Pays[_tabController!.index];
    }
    fetchRegions();
  }

       @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose(); // Disposez le TextEditingController lorsque vous n'en avez plus besoin
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
          const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
    return Container(
      child: DefaultTabController(
        length: regions.length,
        child: Scaffold(
  // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

       backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
            title: Text('Mes boutiques'),
            bottom: TabBar(
              isScrollable: regions.length > 4,
              labelColor: Colors.black,
              controller: _tabController, // Ajoutez le contrôleur TabBar
              tabs: regions.map((region) => Tab(text: region)).toList(),
            ),
            
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height:10),
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
                const SizedBox(height:10),
                // const SizedBox(height:10),
                Flexible(
                  child: GestureDetector(
                    child: TabBarView(
                      controller: _tabController, // Ajoutez le contrôleur TabBarView
                      children: idNiveau1Pays.map((region) {
                        return buildGridView(acteur.idActeur!,region);
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

  Widget buildGridView(String idActeur, String idNiveau1Pays) {
    List<Map<String, dynamic>>? magasins = magasinsParRegion[idNiveau1Pays];

    if (magasins == null) {
      // Si les données ne sont pas encore chargées, affichez l'effet Shimmer
      return _buildShimmerEffect();
    } else {
      // Filtrer les magasins en fonction du texte de recherche
      List<Map<String, dynamic>> filteredMagasins = magasins.where((magasin) {
        String nomMagasin = magasin['nomMagasin']!.toString().toLowerCase();
        String searchText = _searchController.text.toLowerCase();
        return nomMagasin.contains(searchText);
      }).toList();

      // Si aucun magasin n'est trouvé après le filtrage
      if (filteredMagasins.isEmpty) {
        // Vous pouvez afficher une image ou un texte ici
        return Center(
          child: Text(
            'Aucun magasin trouvé',
            style: TextStyle(fontSize: 16),
          ),
        );
      }

      // Sinon, afficher la GridView avec les magasins filtrés
      return Container(
        margin: EdgeInsets.all(5),
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
            return Expanded(
              child: Container(
                height:300,
                // width: 150,
                child: GestureDetector(
                  onTap:(){
                     String id = magasin['idMagasin'];
                     String nom = magasin['nomMagasin'];
                    Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProduitScreen(id:id, nom: nom,)),
              );
                  },
                  child:Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              "http://10.0.2.2/${filteredMagasins[index]['photo']}" ?? "assets/images/magasin.png",
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/magasin.png',
                                  height: 120,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            filteredMagasins[index]['nomMagasin'].toUpperCase() ?? 'Pas de nom défini',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                         Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Nombre de produits:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        '10',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                        // if (isAdmin) // Ajoute l'action des trois points si l'utilisateur est un administrateur
                                                    // Align(
                                                    //   alignment:
                                                    //  Alignment.centerRight,
                                                    //   child: Container(height: 30,
                                                        
                                                    //     padding: const EdgeInsets.only(
                                                    //    left: 140),
                                                    //                 child: Row(
                                                    //                   mainAxisAlignment:
                                                    //                       MainAxisAlignment
                                                    //                           .spaceBetween,
                                                    //                   children: [
                                                                    
                                                    //                     // _buildEtat(),
                                                    //                     PopupMenuButton<String>(
                                                    //                       padding: EdgeInsets.zero,
                                                    //                       itemBuilder: (context) =>
                                                    //                           <PopupMenuEntry<
                                                    //                               String>>[
                                                    //                         PopupMenuItem<String>(
                                                    //                           child: ListTile(
                                                    //                             leading: const Icon(
                                                    //                               Icons.check,
                                                    //                               color:
                                                    //                                   Colors.green,
                                                    //                             ),
                                                    //                             title: const Text(
                                                    //                               "Activer",
                                                    //                               style: TextStyle(
                                                    //                                 color: Colors
                                                    //                                     .green,
                                                    //                                 fontWeight:
                                                    //                                     FontWeight
                                                    //                                         .bold,
                                                    //                               ),
                                                    //                             ),
                                                    //                             onTap: () async {
                                                    //                               await MagasinService()
                                                    //                                   .activerMagasin(
                                                    //                                     filteredMagasins[index]['idMagasin']
                                                    //                                       )
                                                    //                                   .then(
                                                    //                                       (value) =>
                                                    //                                           {
                                                    //                                             Provider.of<MagasinService>(context, listen: false).applyChange(),
                                                    //                                            setState(() {
                                                    //                                               filteredMagasins = magasins;
                                                    //                                             }),
                                                    //                                             Navigator.of(context).pop(),
                                                    //                                             ScaffoldMessenger.of(context).showSnackBar(
                                                    //                                               const SnackBar(
                                                    //                                                 content: Row(
                                                    //                                                   children: [
                                                    //                                                     Text("Activer avec succèss "),
                                                    //                                                   ],
                                                    //                                                 ),
                                                    //                                                 duration: Duration(seconds: 2),
                                                    //                                               ),
                                                    //                                             )
                                                    //                                           })
                                                    //                                   .catchError(
                                                    //                                       (onError) =>
                                                    //                                           {
                                                    //                                             ScaffoldMessenger.of(context).showSnackBar(
                                                    //                                               const SnackBar(
                                                    //                                                 content: Row(
                                                    //                                                   children: [
                                                    //                                                     Text("Une erreur s'est produit"),
                                                    //                                                   ],
                                                    //                                                 ),
                                                    //                                                 duration: Duration(seconds: 5),
                                                    //                                               ),
                                                    //                                             ),
                                                    //                                             Navigator.of(context).pop(),
                                                    //                                           });
                                                    //                             },
                                                    //                           ),
                                                    //                         ),
                                                    //                         PopupMenuItem<String>(
                                                    //                           child: ListTile(
                                                    //                             leading: Icon(
                                                    //                               Icons
                                                    //                                   .disabled_visible,
                                                    //                               color: Colors
                                                    //                                   .orange[400],
                                                    //                             ),
                                                    //                             title: Text(
                                                    //                               "Désactiver",
                                                    //                               style: TextStyle(
                                                    //                                 color: Colors
                                                    //                                         .orange[
                                                    //                                     400],
                                                    //                                 fontWeight:
                                                    //                                     FontWeight
                                                    //                                         .bold,
                                                    //                               ),
                                                    //                             ),
                                                    //                             onTap: () async {
                                                    //                               await MagasinService()
                                                    //                                   .desactiverMagasin(
                                                    //                                     filteredMagasins[index]['idMagasin']
                                                    //                                       )
                                                    //                                   .then(
                                                    //                                       (value) =>
                                                    //                                           {
                                                                                            
                                                    //                                             Navigator.of(context).pop(),
                                                    //                                           })
                                                    //                                   .catchError(
                                                    //                                       (onError) =>
                                                    //                                           {
                                                    //                                             ScaffoldMessenger.of(context).showSnackBar(
                                                    //                                               const SnackBar(
                                                    //                                                 content: Row(
                                                    //                                                   children: [
                                                    //                                                     Text("Une erreur s'est produit"),
                                                    //                                                   ],
                                                    //                                                 ),
                                                    //                                                 duration: Duration(seconds: 5),
                                                    //                                               ),
                                                    //                                             ),
                                                    //                                             Navigator.of(context).pop(),
                                                    //                                           });
                                                                    
                                                    //                               ScaffoldMessenger
                                                    //                                       .of(context)
                                                    //                                   .showSnackBar(
                                                    //                                 const SnackBar(
                                                    //                                   content: Row(
                                                    //                                     children: [
                                                    //                                       Text(
                                                    //                                           "Désactiver avec succèss "),
                                                    //                                     ],
                                                    //                                   ),
                                                    //                                   duration:
                                                    //                                       Duration(
                                                    //                                           seconds:
                                                    //                                               2),
                                                    //                                 ),
                                                    //                               );
                                                    //                             },
                                                    //                           ),
                                                    //                         ),
                                                    //                         PopupMenuItem<String>(
                                                    //                           child: ListTile(
                                                    //                             leading: Icon(
                                                    //                               Icons
                                                    //                                   .disabled_visible,
                                                    //                               color: Colors
                                                    //                                   .orange[400],
                                                    //                             ),
                                                    //                             title: Text(
                                                    //                               "Modifier",
                                                    //                               style: TextStyle(
                                                    //                                 color: Colors
                                                    //                                         .orange[
                                                    //                                     400],
                                                    //                                 fontWeight:
                                                    //                                     FontWeight
                                                    //                                         .bold,
                                                    //                               ),
                                                    //                             ),
                                                    //                             onTap: () async {
                                                    //                               // await MagasinService()
                                                    //                               //     .desactiverMagasin(
                                                    //                               //       filteredMagasins[index]['idMagasin']
                                                    //                               //         )
                                                    //                               //     .then(
                                                    //                               //         (value) =>
                                                    //                               //             {
                                                                                            
                                                    //                               //               Navigator.of(context).pop(),
                                                    //                               //             })
                                                    //                               //     .catchError(
                                                    //                               //         (onError) =>
                                                    //                               //             {
                                                    //                               //               ScaffoldMessenger.of(context).showSnackBar(
                                                    //                               //                 const SnackBar(
                                                    //                               //                   content: Row(
                                                    //                               //                     children: [
                                                    //                               //                       Text("Une erreur s'est produit"),
                                                    //                               //                     ],
                                                    //                               //                   ),
                                                    //                               //                   duration: Duration(seconds: 5),
                                                    //                               //                 ),
                                                    //                               //               ),
                                                    //                               //               Navigator.of(context).pop(),
                                                    //                               //             });
                                                                    
                                                    //                               // ScaffoldMessenger
                                                    //                               //         .of(context)
                                                    //                               //     .showSnackBar(
                                                    //                               //   const SnackBar(
                                                    //                               //     content: Row(
                                                    //                               //       children: [
                                                    //                               //         Text(
                                                    //                               //             "Désactiver avec succèss "),
                                                    //                               //       ],
                                                    //                               //     ),
                                                    //                               //     duration:
                                                    //                               //         Duration(
                                                    //                               //             seconds:
                                                    //                               //                 2),
                                                    //                               //   ),
                                                    //                               // );
                                                    //                             },
                                                    //                           ),
                                                    //                         ),
                                                                           
                                                    //                         PopupMenuItem<String>(
                                                    //                           child: ListTile(
                                                    //                             leading: const Icon(
                                                    //                               Icons.delete,
                                                    //                               color: Colors.red,
                                                    //                             ),
                                                    //                             title: const Text(
                                                    //                               "Supprimer",
                                                    //                               style: TextStyle(
                                                    //                                 color:
                                                    //                                     Colors.red,
                                                    //                                 fontWeight:
                                                    //                                     FontWeight
                                                    //                                         .bold,
                                                    //                               ),
                                                    //                             ),
                                                    //                             onTap: () async {
                                                    //                               await MagasinService()
                                                    //                                   .deleteMagasin(
                                                    //                           filteredMagasins[index]['idMagasin'])
                                                    //                                   .then(
                                                    //                                       (value) =>
                                                    //                                           {
                                                    //                                             Provider.of<MagasinService>(context, listen: false).applyChange(),
                                                    //                                             setState(() {
                                                    //                                               filteredMagasins = magasins;
                                                    //                                             }),
                                                    //                                             Navigator.of(context).pop(),
                                                    //                                           })
                                                    //                                   .catchError(
                                                    //                                       (onError) =>
                                                    //                                           {
                                                    //                                             ScaffoldMessenger.of(context).showSnackBar(
                                                    //                                               const SnackBar(
                                                    //                                                 content: Row(
                                                    //                                                   children: [
                                                    //                                                     Text("Impossible de supprimer"),
                                                    //                                                   ],
                                                    //                                                 ),
                                                    //                                                 duration: Duration(seconds: 2),
                                                    //                                               ),
                                                    //                                             )
                                                    //                                           });
                                                    //                             },
                                                    //                           ),
                                                    //                         ),
                                                    //                       ],
                                                    //                     ),
                                                    //                   ],
                                                    //                 ),
                                                    //               ),
                                                    // ),
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
