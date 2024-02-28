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
                SizedBox(
                  height: 40,
                  child: Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 245, 212, 169),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'Rechercher',
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                      ),
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

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: filteredStocksSearch.length, // Utiliser la liste filtrée
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
                          filteredStocksSearch[index].photo ??
                              'assets/images/magasin.png', // Utiliser la photo du stock
                          width: double.infinity,
                          height: null,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
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
                    overflow: TextOverflow.ellipsis,
                    filteredStocksSearch[index].nomProduit ??
                        'Pas de nom défini',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
