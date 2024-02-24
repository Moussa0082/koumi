import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/screens/Produit.dart';
import 'package:shimmer/shimmer.dart';


class MagasinScreen extends StatefulWidget {
  const MagasinScreen({super.key});

  @override
  State<MagasinScreen> createState() => _MagasinScreenState();
}
class _MagasinScreenState extends State<MagasinScreen> with TickerProviderStateMixin {
    // Déclarez une variable pour suivre si le chargement est terminé
  bool _loadingFinished = false;

  TabController? _tabController;
    late TextEditingController _searchController;

  List<String> regions = [];
  List<String> idNiveau1Pays = [];
   String selectedRegionId = ''; // Ajoutez une variable pour stocker l'ID de la région sélectionnée
  
  Map<String, List<Map<String, dynamic>>> magasinsParRegion = {};

  List<Map<String, dynamic>> regionsData = [];
  List<String> magasins = [];
  int currentIndex = 0;

  Set<String> loadedRegions = {}; // Ensemble pour garder une trace des régions pour lesquelles les magasins ont déjà été chargés

  void fetchRegions() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9000/niveau1Pays/read'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          regionsData = data.cast<Map<String, dynamic>>();
          regions = regionsData.map((item) => item['nomN1'] as String).toList();
          idNiveau1Pays = regionsData.map((item) => item['idNiveau1Pays'] as String).toList();
        });
        _tabController = TabController(length: regions.length, vsync: this);
        _tabController!.addListener(_handleTabChange);
        // Fetch les magasins pour la première région
        fetchMagasinsByRegion(idNiveau1Pays.isNotEmpty ? idNiveau1Pays[_tabController!.index] : '');
      } else {
        throw Exception('Failed to load regions');
      }
    } catch (e) {
      print('Error fetching regions: $e');
    }
  }

  void fetchMagasinsByRegion(String id) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9000/Magasin/getAllMagasinByPays/${id}'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          magasinsParRegion[id] = data.map((item) => {
            'nomMagasin': item['nomMagasin'],
            'idMagasin': item['idMagasin'],
            'photo': item['photo'],
          }).toList();
        });
        // Si les magasins pour cette région n'ont pas déjà été chargés, ajoutez l'ID de la région à loadedRegions
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
  if (_tabController != null && _tabController!.index >= 0 && _tabController!.index < idNiveau1Pays.length) {
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
    _buildShimmerEffect();
   
  }

     @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose(); // Disposez le TextEditingController lorsque vous n'en avez plus besoin
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: regions.length,
        child: Scaffold(
          appBar: AppBar(
            centerTitle:true,
            title: Text('Tous les boutiques'),
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
                 SizedBox(
                     height:40,
                   child: Container(
                     padding: EdgeInsets.only(left: 5),
                     decoration: BoxDecoration(
                       color: Color.fromARGB(255, 245, 212, 169),
                       borderRadius: BorderRadius.circular(30),
                                    
                     ),
                     child: TextField(
                      controller: _searchController,
                       onChanged: (value) {
                              setState(() {
                                // Le changement de texte déclenche la reconstruction du widget
                              });
                            },
                       decoration: InputDecoration(
                         hintText: 'Rechercher',
                         contentPadding: EdgeInsets.all(10),
                         border: InputBorder.none,
                       ),
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
      return GridView.builder(
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
            child: GestureDetector(
              onTap:(){
                 String id = magasin['idMagasin'];
                Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProduitScreen(id:id)),
          );
              },
              child: Card(
                shadowColor: Colors.white,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Image.asset('assets/images/rectangle.png', width:double.infinity),
                        ),
                        Container(
                          child: Image.network(
                            filteredMagasins[index]['photo'] ?? 'assets/images/magasin.png',
                            width: double.infinity,
                            height: null,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Image.asset(
                                'assets/images/magasin.png',
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Text(
                      overflow:TextOverflow.ellipsis,
                      filteredMagasins[index]['nomMagasin'].toString().toUpperCase() ?? 'Pas de nom défini',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
              //      TextButton(
              //   style: ButtonStyle(
              //     fixedSize: MaterialStateProperty.all(Size(20, 10)),
              //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(50.0),
              //     )),
              //   ),
              //   onPressed: null,
              //   child: Text('Voir', style: TextStyle(fontWeight: FontWeight.bold),),
              // ),
                  ],
                ),
              ),
            ),
          );
        },
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
}



