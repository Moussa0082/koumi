import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:shimmer/shimmer.dart';


class ProduitScreen extends StatefulWidget {
    final String? id; // ID du magasin (optionnel)
   ProduitScreen({super.key, this.id});

  @override
  State<ProduitScreen> createState() => _ProduitScreenState();
}
class _ProduitScreenState extends State<ProduitScreen> with TickerProviderStateMixin {
    // Déclarez une variable pour suivre si le chargement est terminé

  TabController? _tabController;
    late TextEditingController _searchController;

  List<Stock> stock = [];
  List<CategorieProduit> categorieProduit = [];
   String selectedCategorieProduit = "" ;
   

  Set<String> loadedRegions = {}; // Ensemble pour garder une trace des régions pour lesquelles les magasins ont déjà été chargés

  void fetchProduitByCategorie(String id) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9000/Stock/getAllStocksByIdMagasin/${id}'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
      stock= data.map((item) => Stock(
        idStock: item['idStock'] as String,
        nomProduit: item['nomProduit']as String,
      )).toList();

        
      } else {
        throw Exception('Failed to load stock');
      }
    } catch (e) {
      print('Error fetching stock: $e');
    }
  }

  void fetchCategorie() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9000/Categorie/allCategorie'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
      setState(() {
        categorieProduit = data.map((item) => CategorieProduit(
          idCategorieProduit: item['idCategorieProduit'],
          libelleCategorie: item['libelleCategorie'],
        )).toList();
        // Mise à jour du TabController une fois les catégories récupérées
        _tabController = TabController(length: categorieProduit.length, vsync: this);
        _tabController!.addListener(_handleTabChange);
      });
      // Si des catégories de produits ont été récupérées, récupérez les stocks pour la première catégorie (si elle existe)
      if (categorieProduit.isNotEmpty) {
        fetchProduitByCategorie(categorieProduit[0].idCategorieProduit!);
      }
    } else {
      throw Exception('Failed to load categoris');
    }
    } catch (e) {
      print('Error fetching categoris for magasins : $e');
    }
  }

 void _handleTabChange() {
  if (_tabController != null && _tabController!.index >= 0 && _tabController!.index <categorieProduit.length) {
    fetchCategorie();
  }
}

  @override
  void initState() {
    super.initState();
    // debugPrint("Id : ${widget.id!}");
     _searchController = TextEditingController();

  _tabController = TabController(length: categorieProduit.length, vsync: this); // Initialiser le TabController avec une longueur de 0

    fetchCategorie();
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
    if(categorieProduit.length<0){
   return Text("Vide");
    }
    return Container(
      child: DefaultTabController(
        length: categorieProduit.length,
        child: Scaffold(
          appBar: AppBar(
          centerTitle: true,
          title: Text('Categories'),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            controller: _tabController, // Ajoutez le contrôleur TabBar
            tabs: categorieProduit.map((categorie) => Tab(text: categorie.libelleCategorie)).toList(),
          ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // const SizedBox(height:10),
                //  SizedBox(
                //      height:40,
                //    child: Container(
                //      padding: EdgeInsets.only(left: 5),
                //      decoration: BoxDecoration(
                //        color: Color.fromARGB(255, 245, 212, 169),
                //        borderRadius: BorderRadius.circular(30),
                                    
                //      ),
                //      child: TextField(
                //       controller: _searchController,
                //        onChanged: (value) {
                //               setState(() {
                //                 // Le changement de texte déclenche la reconstruction du widget
                //               });
                //             },
                //        decoration: InputDecoration(
                //          hintText: 'Rechercher',
                //          contentPadding: EdgeInsets.all(10),
                //          border: InputBorder.none,
                //        ),
                //      ),
                //    ),
                //  ),
                // const SizedBox(height:10),
                // // const SizedBox(height:10),
                // // Flexible(
                // //   child: GestureDetector(
                // //     child:  TabBarView(
                // //   controller: _tabController,
                // //   children: categorieProduit.map((categorie) {
                // //     return buildGridView(widget.id!, categorie.idCategorieProduit!);
                // //   }).toList(),
                // // ),
                // //   ),
                // // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridView(String id, String idCategorie) {
  // Filtrer les stocks en fonction de la catégorie sélectionnée
  List<Stock> filteredStocks = stock.where((stock) => stock.magasin!.idMagasin == id).toList();

  // Filtrer les stocks en fonction de la catégorie sélectionnée
  // List<Stock> filteredStocksByCategory = filteredStocks.where((stock) => stock.magasin!.CategorieProduit!.idCategorieProduit == idCategorie).toList();


    if (filteredStocks == null) {
      // Si les données ne sont pas encore chargées, affichez l'effet Shimmer
      return _buildShimmerEffect();
    } else {
     // Filtrer les stocks en fonction du texte de recherche
  List<Stock> filteredStocksSearch = filteredStocks.where((stock) {
    String nomProduit = stock.nomProduit!.toLowerCase();
    String searchText = _searchController.text.toLowerCase();
    return nomProduit.contains(searchText);
  }).toList();

      // Si aucun magasin n'est trouvé après le filtrage
      if (filteredStocks.isEmpty) {
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
        itemCount: filteredStocks.length,
        itemBuilder: (context, index) {
          return Container(
            child: Card(
              shadowColor: Colors.white,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Image.asset('assets/images/rc.png'),
                      ),
                      Container(
                        child: Image.network(
                          filteredStocksSearch[index].nomProduit ?? 'assets/images/magasin.png',
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
                    filteredStocksSearch[index].nomProduit ?? 'Pas de nom défini',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                 TextButton(
  style: ButtonStyle(
    fixedSize: MaterialStateProperty.all(Size(20, 10)),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
    )),
  ),
  onPressed: null,
  child: Text('Voir', style: TextStyle(fontWeight: FontWeight.bold),),
),
                ],
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



