import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/screens/DetailProduits.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FruitAndLegumes extends StatefulWidget {
  const FruitAndLegumes({super.key});

  @override
  State<FruitAndLegumes> createState() => _FruitAndLegumesState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _FruitAndLegumesState extends State<FruitAndLegumes> {
  late TextEditingController _searchController;
  List<Stock> stockListe = [];
  late Future<List<Stock>> stockListeFuture;

  ScrollController scrollableController = ScrollController();

  String libelle = "Végétale";
  String? monnaie;
  int page = 0;
  bool isLoading = false;
  int size = 6;
  bool hasMore = true;
  void _scrollListener() {
    if (scrollableController.position.pixels >=
            scrollableController.position.maxScrollExtent - 200 &&
        hasMore &&
        !isLoading) {
      // if (selectedCat != null) {
      // Incrementez la page et récupérez les stocks par catégorie
      debugPrint("yes - fetch by category");
      setState(() {
        // Rafraîchir les données ici
        page++;
      });

      fetchStock().then((value) {
        setState(() {
          // Rafraîchir les données ici
          debugPrint("page inc all ${page}");
        });
      });
    }
    debugPrint("no");
  }

  Future<List<Stock>> fetchStock({bool refresh = false}) async {
    if (isLoading == true) return [];

    setState(() {
      isLoading = true;
    });

    if (refresh) {
      setState(() {
        stockListe.clear();
        page = 0;
        hasMore = true;
      });
    }

    try {
      final response = await http.get(Uri.parse(
          '$apiOnlineUrl/Stock/listeStockByLibelleCategorie?libelle=$libelle&page=$page&size=$size'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          setState(() {
            List<Stock> newStocks = body.map((e) => Stock.fromMap(e)).toList();
            stockListe.addAll(newStocks);
          });
        }

        debugPrint(
            "response body all stock by categorie with pagination ${page} par défilement soit ${stockListe.length}");
      } else {
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print(
          'Une erreur s\'est produite lors de la récupération des intrants: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return stockListe;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollableController.addListener(_scrollListener);
    });
    stockListeFuture = fetchStock();
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Disposez le TextEditingController lorsque vous n'en avez plus besoin
    scrollableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          toolbarHeight: 100,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text(
            "Fruits & légumes",
            style: TextStyle(
              color: d_colorGreen,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverToBoxAdapter(
                        child: Column(children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color:
                                Colors.blueGrey[50], // Couleur d'arrière-plan
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search,
                                  color: Colors
                                      .blueGrey[400]), // Couleur de l'icône
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
                    ])),
                  ];
                },
                body: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        page = 0;
                        // Rafraîchir les données ici
                      });
                      debugPrint("refresh page ${page}");
                    },
                    child: SingleChildScrollView(
                      controller: scrollableController,
                      child: Consumer<StockService>(
                          builder: (context, intrantService, child) {
                        return FutureBuilder(
                            future: stockListeFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return _buildShimmerEffect();
                              }

                              if (!snapshot.hasData) {
                                return const Padding(
                                  padding: EdgeInsets.all(10),
                                  child:
                                      Center(child: Text("Aucun donné trouvé")),
                                );
                              } else {
                                stockListe = snapshot.data!;
                                String searchText = "";
                                List<Stock> filteredSearch =
                                    stockListe.where((cate) {
                                  String nomCat =
                                      cate.nomProduit!.toLowerCase();
                                  searchText =
                                      _searchController.text.toLowerCase();
                                  return nomCat.contains(searchText);
                                }).toList();
                                return filteredSearch
                                            // .where((element) => element.statutIntrant == true)
                                            .isEmpty &&
                                        isLoading == false
                                    ? SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/images/notif.jpg'),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Aucun produit trouvé',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          childAspectRatio: 0.8,
                                        ),
                                        itemCount: filteredSearch.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index < filteredSearch.length) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailProduits(
                                                      stock:
                                                          filteredSearch[index],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Card(
                                                margin: EdgeInsets.all(8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: SizedBox(
                                                        height: 85,
                                                        child: filteredSearch[
                                                                            index]
                                                                        .photo ==
                                                                    null ||
                                                                filteredSearch[
                                                                        index]
                                                                    .photo!
                                                                    .isEmpty
                                                            ? Image.asset(
                                                                "assets/images/default_image.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : CachedNetworkImage(
                                                                imageUrl:
                                                                    "https://koumi.ml/api-koumi/Stock/${filteredSearch[index].idStock}/image",
                                                                fit: BoxFit
                                                                    .cover,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const Center(
                                                                        child:
                                                                            CircularProgressIndicator()),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                  'assets/images/default_image.png',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                    // SizedBox(height: 8),
                                                    ListTile(
                                                      title: Text(
                                                        filteredSearch[index]
                                                            .nomProduit!,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black87,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      subtitle: Text(
                                                        "${filteredSearch[index].quantiteStock.toString()} ${filteredSearch[index].unite!.sigleUnite}",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Text(
                                                        monnaie != null
                                                            ? "${filteredSearch[index].prix.toString()} ${monnaie}"
                                                            : "${filteredSearch[index].prix.toString()} FCFA ",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return isLoading == true
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 32),
                                                    child: Center(
                                                        child: const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.orange,
                                                      ),
                                                    )),
                                                  )
                                                : Container();
                                          }
                                        },
                                      );
                              }
                            });
                      }),
                    )))));
  }

  Widget _buildShimmerEffect() {
    return Center(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: 6, // Number of shimmer items to display
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 85,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ListTile(
                  title: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 16,
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 15,
                      color: Colors.grey,
                      margin: EdgeInsets.only(top: 4),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 15,
                      color: Colors.grey,
                      margin: EdgeInsets.only(top: 4),
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

  Widget _buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                // overflow: TextOverflow.ellipsis,
                fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis,
                fontSize: 16),
          )
        ],
      ),
    );
  }
}
