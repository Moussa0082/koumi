import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:shimmer/shimmer.dart';

class ProduitScreen extends StatefulWidget {
  final String? id; // ID du magasin (optionnel)
  final String? nom;
  ProduitScreen({super.key, this.id, this.nom});

  @override
  State<ProduitScreen> createState() => _ProduitScreenState();
}

class _ProduitScreenState extends State<ProduitScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late TextEditingController _searchController;

  List<Stock> stock = [];
  List<CategorieProduit> categorieProduit = [];
  String selectedCategorieProduit = "";
  String selectedCategorieProduitNom = "";

  Set<String> loadedRegions = {};

  void fetchProduitByCategorie(String idCategorie, String idMagasin) async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:9000/api-koumi/Stock/categorieAndMagasin/$idCategorie/$idMagasin'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          stock = data
              .where((stock) => stock['statutSotck'] == true)
              .map((item) => Stock(
                    idStock: item['idStock'] as String,
                    nomProduit: item['nomProduit'] as String,
                    photo: item['photo'] ?? '',
                    quantiteStock: item['quantiteStock'] ?? 0,
                    prix: item['prix'] ?? 0,
                  ))
              .toList();
        });
        debugPrint("Produit : ${stock.map((e) => e.nomProduit)}");
      } else {
        throw Exception('Failed to load stock');
      }
    } catch (e) {
      print('Error fetching stock: $e');
    }
  }

  void fetchCategorie() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:9000/api-koumi/Categorie/allCategorie'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          categorieProduit = data
              .map((item) => CategorieProduit(
                    idCategorieProduit: item['idCategorieProduit'] as String,
                    libelleCategorie: item['libelleCategorie'] as String,
                  ))
              .toList();
          _tabController =
              TabController(length: categorieProduit.length, vsync: this);
          _tabController!.addListener(_handleTabChange);
          selectedCategorieProduit = categorieProduit.isNotEmpty
              ? categorieProduit.first.idCategorieProduit!
              : '';
          selectedCategorieProduitNom = categorieProduit.isNotEmpty
              ? categorieProduit[_tabController!.index].libelleCategorie
              : '';
          fetchProduitByCategorie(selectedCategorieProduit, widget.id!);
        });
        debugPrint(
            "Id Cat : ${categorieProduit.map((e) => e.idCategorieProduit)}");
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void _handleTabChange() {
    if (_tabController != null &&
        _tabController!.index >= 0 &&
        _tabController!.index < categorieProduit.length) {
      selectedCategorieProduit =
          categorieProduit[_tabController!.index].idCategorieProduit!;
      selectedCategorieProduitNom =
          categorieProduit[_tabController!.index].libelleCategorie;
      fetchProduitByCategorie(selectedCategorieProduit, widget.id!);
      debugPrint("Cat id : " + selectedCategorieProduit);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    if (categorieProduit.isEmpty) {
      fetchCategorie();
      // fetchProduitByCategorie(selectedCategorieProduit);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
           const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
    return Container(
      child: DefaultTabController(
        length: categorieProduit.length,
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
            title: Text('Categories'),
            bottom: TabBar(
              isScrollable: true,
              labelColor: Colors.black,
              controller: _tabController,
              tabs: categorieProduit
                  .map((categorie) => Tab(text: categorie.libelleCategorie))
                  .toList(),
            ),
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
                Flexible(
                  child: GestureDetector(
                    child: TabBarView(
                      controller: _tabController,
                      children: categorieProduit.map((categorie) {
                        return buildGridView(
                            categorie.idCategorieProduit!, widget.id!);
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

  Widget buildGridView(String idCategorie, String idMagasin) {
    List<Stock> filteredStocks = stock;
    String searchText = "";
    if (filteredStocks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            textAlign: TextAlign.justify,
            'Aucun produit trouvé dans le magasin ' +
                widget.nom!.toUpperCase() +
                " dans la categorie " +
                selectedCategorieProduitNom.toUpperCase(),
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    } else {
      List<Stock> filteredStocksSearch = filteredStocks.where((stock) {
        String nomProduit = stock.nomProduit!.toLowerCase();
        searchText = _searchController.text.toLowerCase();
        return nomProduit.contains(searchText);
      }).toList();

      if (filteredStocksSearch.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              textAlign: TextAlign.justify,
              'Aucun produit trouvé avec le nom ' +
                  searchText.toUpperCase() +
                  " dans la categorie " +
                  selectedCategorieProduitNom.toUpperCase(),
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }

     
 return Container(
  color: Colors.white,
   child: GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
    ),
    itemCount: filteredStocks.length,
    itemBuilder: (context, index) {
      return Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),

        color: const Color.fromARGB(255, 247, 235, 218),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 240, 238, 238).withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        margin: EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () {
            // Action à effectuer lorsqu'un produit est cliqué
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 120, // Taille de la photo
                child: Image.network(
                  filteredStocks[index].photo ?? 'assets/images/produit.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/produit.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      filteredStocks[index].nomProduit ?? 'Pas de nom défini',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: Text(
                        filteredStocks[index].quantiteStock.toString(),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredStocks[index].prix!.toInt()} €', // Convertir en entier
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    RatingBar.builder(
                      initialRating: 3, // Rating initial du produit
                      minRating: 0,
                      maxRating: 5,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 20, // Taille du rating augmentée
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        // Fonction appelée lorsque l'utilisateur met à jour le rating
                        // Vous pouvez implémenter ici la logique pour mettre à jour le rating dans la base de données
                      },
                    ),
                  ],
                ),
              ),
            ],
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
        itemCount: 6,
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
