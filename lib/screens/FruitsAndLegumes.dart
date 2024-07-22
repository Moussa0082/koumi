import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddAndUpdateProductScreen.dart';
import 'package:koumi_app/screens/DetailProduits.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:koumi_app/widgets/AutoComptet.dart';
import 'package:koumi_app/widgets/DetectorPays.dart';
import 'package:provider/provider.dart';
import 'package:search_field_autocomplete/search_field_autocomplete.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class FruitAndLegumes extends StatefulWidget {
  
  FruitAndLegumes({super.key});

  @override
  State<FruitAndLegumes> createState() => _FruitAndLegumesState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _FruitAndLegumesState extends State<FruitAndLegumes> {
  late TextEditingController _searchController;
  List<Stock> stockListe = [];
  List<Stock> stockList = [];
  late Future<List<Stock>> stockListeFuture;
  late Future<List<Stock>> stockListeFuture1;
  CategorieProduit? selectedCat;
  String? typeValue;
  late Future _catList;
String? detectedCountry;
  ScrollController scrollableController = ScrollController();
  ScrollController scrollableController1 = ScrollController();

  String libelle = "Végétales";
  // List<String> libelles = ["Végétale", "Vegetale", "vegetale", "végétale","Végétales"];

  // String? monnaie;
  int page = 0;
  bool isLoading = false;
  int size = sized;
  bool hasMore = true;
  bool isExist = false;
  String? email = "";
  bool isSearchMode = true;
  late String type;
  late Acteur acteur = Acteur();
  late List<TypeActeur> typeActeurData = [];

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
        // stockListeFuture = fetchAllStock();
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

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

      fetchStock(
              detectedCountry != null ? detectedCountry! : "Mali")
          .then((value) {
        setState(() {
          // Rafraîchir les données ici
          debugPrint("page inc all ${page}");
        });
      });
    }
    debugPrint("no");
  }

 void _scrollListener1() {
    if (scrollableController1.position.pixels >=
            scrollableController1.position.maxScrollExtent - 200 &&
        hasMore &&
        !isLoading &&
        selectedCat != null) {
      // if (selectedCat != null) {
      // Incrementez la page et récupérez les stocks par catégorie
      debugPrint("yes - fetch by category and pays");
      if (mounted)
        setState(() {
          // Rafraîchir les données ici
          page++;
        });

      fetchStockByCategorie(
              detectedCountry != null ? detectedCountry! : "Mali")
          .then((value) {
        setState(() {
          // Rafraîchir les données ici
          debugPrint("page inc all ${page}");
        });
      });
    }
    debugPrint("no");
  }

   Future<List<Stock>> getAllStock() async {
    if (selectedCat != null) {
      stockListe = await StockService().fetchStockByCategorieAndFiliere(
          selectedCat!.idCategorieProduit!, libelle , detectedCountry!);
    }

    return stockListe;
  }

 Future<List<Stock>> fetchStockByCategorie(String niveau3PaysActeur,
      {bool refresh = false}) async {
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
          '$apiOnlineUrl/Stock/getAllStocksByCategorieAndFiliere?idCategorie=${selectedCat!.idCategorieProduit}&libelleFiliere=$libelle&niveau3PaysActeur=$niveau3PaysActeur&page=$page&size=$size'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          List<Stock> newStocks = body.map((e) => Stock.fromMap(e)).toList();
          setState(() {
            stockListe.addAll(newStocks.where((newStock) => !stockListe
                .any((existStock) => existStock.idStock == newStock.idStock)));
          });
        }

        debugPrint(
            "response body all stock by categorie and pays with pagination ${page} par défilement soit ${stockListe.length}");
      } else {
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print(
          'Une erreur s\'est produite lors de la récupération des stocks: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return stockListe;
  }


  Future<List<Stock>> fetchStock(String pays, {bool refresh = false}) async {
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
      // List<Stock> tempStockListe = [];
      // for (String libelle in libelles) {
      final response = await http.get(Uri.parse(
          '$apiOnlineUrl/Stock/listeStockByLibelleCategorie?libelle=$libelle&pays=$pays&page=$page&size=$size'));
      // '$apiOnlineUrl/Stock/listeStockByLibelleCategorie?pays=$pays&libelle=$libelle&page=$page&size=$size'));
      debugPrint(
          '$apiOnlineUrl/Stock/listeStockByLibelleCategorie?libelle=$libelle&pays=$pays&page=$page&size=$size');
      // debugPrint( '$apiOnlineUrl/Stock/listeStockByLibelleCategorie?libelle=$libelle&pays=$pays&page=$page&size=$size');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          List<Stock> newStocks = body.map((e) => Stock.fromMap(e)).toList();
          setState(() {
            stockListe.addAll(newStocks.where((newStock) => !stockListe
                .any((existStock) => existStock.idStock == newStock.idStock)));
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
    detectedCountry =
        Provider.of<DetectorPays>(context, listen: false).detectedCountry!;
    verify();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollableController.addListener(_scrollListener);
    });
      WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollableController1.addListener(_scrollListener1);
    });
      _catList = http.get(Uri.parse('$apiOnlineUrl/Categorie/allCategorieByLibelleFiliere/$libelle'));
    stockListeFuture1 = getAllStock();
    stockListeFuture = fetchStock(
        detectedCountry != null ? detectedCountry! : "Mali");
  }

  Future<void> _getResultFromNextScreen1(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddAndUpdateProductScreen(
                  isEditable: false,
                )));
    log(result.toString());
    if (result == true) {
      print("Rafraichissement en cours");
      setState(() {
        stockListeFuture = fetchStock(
            detectedCountry != null ? detectedCountry! : "Mali");
      });
    }
  }

  void _updateMode(int index) {
    if (mounted) {
      setState(() {
        isSearchMode = index == 0;
        if (!isSearchMode) {
          _searchController.clear();
          _searchController.dispose();
          _searchController = TextEditingController();
        }
      });
    }
  }

  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isSearchMode) {
      _searchController = TextEditingController();
    } else {
      _searchController.dispose();
    }
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Disposez le TextEditingController lorsque vous n'en avez plus besoin
    scrollableController.dispose();
    scrollableController1.dispose();
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: !isExist
              ? [
                  IconButton(
                      onPressed: () {
                        stockListeFuture = fetchStock(
                            detectedCountry != null
                                ? detectedCountry!
                                : "Mali");
                      },
                      icon: const Icon(Icons.refresh, color: d_colorGreen)),
                ]
              : [
                  IconButton(
                      onPressed: () {
                        stockListeFuture = fetchStock(
                            detectedCountry != null
                                ? detectedCountry!
                                : "Mali");
                      },
                      icon: const Icon(Icons.refresh, color: d_colorGreen)),
                  (typeActeurData
                              .map((e) => e.libelle!.toLowerCase())
                              .contains("commercant") ||
                          typeActeurData
                              .map((e) => e.libelle!.toLowerCase())
                              .contains("commerçant") ||
                          typeActeurData
                              .map((e) => e.libelle!.toLowerCase())
                              .contains("admin") ||
                          typeActeurData
                              .map((e) => e.libelle!.toLowerCase())
                              .contains("producteur"))
                      ? PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context) {
                            return <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  ),
                                  title: const Text(
                                    "Ajouter produit",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    _getResultFromNextScreen1(context);
                                  },
                                ),
                              ),
                            ];
                          },
                        )
                      : Container()
                ],
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
                        child: ToggleButtons(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('Rechercher'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('Filtrer'),
                            ),
                          ],
                          isSelected: [isSearchMode, !isSearchMode],
                          onPressed: _updateMode,
                        ),
                      ),
                      if (isSearchMode)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SearchFieldAutoComplete<String>(
                            controller: _searchController,
                            placeholder: 'Rechercher...',
                             itemHeight: 25,
                            placeholderStyle:
                                TextStyle(fontStyle: FontStyle.italic),
                            suggestions: AutoComplet.getFruitsAndVegetables,
                            suggestionsDecoration: SuggestionDecoration(
                              marginSuggestions: const EdgeInsets.all(8.0),
                              color: const Color.fromARGB(255, 236, 234, 234),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            onSuggestionSelected: (selectedItem) {
                              if (mounted) {
                                _searchController.text = selectedItem.searchKey;
                              }
                            },
                            suggestionItemBuilder: (context, searchFieldItem) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  searchFieldItem.searchKey,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            },
                          ),
                        ),
                      if (!isSearchMode)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: FutureBuilder(
                            future: _catList,
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return buildLoadingDropdown();
                              }

                              if (snapshot.hasData) {
                                dynamic jsonString =
                                    utf8.decode(snapshot.data.bodyBytes);
                                dynamic responseData = json.decode(jsonString);

                                if (responseData is List) {
                                  final reponse = responseData;
                                  final typeList = reponse
                                      .map((e) => CategorieProduit.fromMap(e))
                                      .where(
                                          (con) => con.statutCategorie == true)
                                      .toList();

                                  if (typeList.isEmpty) {
                                    return buildEmptyDropdown();
                                  }

                                  return buildDropdown(typeList);
                                } else {
                                  return buildEmptyDropdown();
                                }
                              }

                              return buildEmptyDropdown();
                            },
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
                         selectedCat != null
                  ? setState(() {
                      stockListeFuture1 = StockService().fetchStockByCategorieAndFiliere(
                          selectedCat!.idCategorieProduit!,
                          libelle,
                          detectedCountry != null
                              ? detectedCountry!
                              : "Mali");
                    }) :
                      setState(() {
                        stockListeFuture = fetchStock(
                            detectedCountry != null
                                ? detectedCountry!
                                : "Mali");
                      });
                      debugPrint("refresh page ${page}");
                    },
                    child: selectedCat == null
                ?
                     SingleChildScrollView(
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
                                stockList = snapshot.data!;
                                String searchText = "";
                                List<Stock> filteredSearch =
                                    stockList.where((cate) {
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
                                                        filteredSearch[index]
                                                                    .monnaie !=
                                                                null
                                                            ? "${filteredSearch[index].prix.toString()} ${filteredSearch[index].monnaie!.libelle}"
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
                    ) :  SingleChildScrollView(
                            controller: scrollableController1,
                            child: FutureBuilder(
                                future: stockListeFuture1,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return _buildShimmerEffect();
                                  }
                            
                                  if (!snapshot.hasData) {
                                    return const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                          child: Text("Aucun donné trouvé")),
                                    );
                                  } else {
                                    stockList = snapshot.data!;
                                    String searchText = "";
                                    List<Stock> filteredSearch =
                                        stockList.where((cate) {
                                      String nomCat =
                                          cate.nomProduit!.toLowerCase();
                                      searchText = _searchController.text
                                          .toLowerCase();
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                              childAspectRatio: 0.8,
                                            ),
                                            itemCount:
                                                filteredSearch.length + 1,
                                            itemBuilder: (context, index) {
                                              if (index <
                                                  filteredSearch.length) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailProduits(
                                                          stock:
                                                              filteredSearch[
                                                                  index],
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
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: SizedBox(
                                                            height: 85,
                                                            child: filteredSearch[index]
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
                                                                            child: CircularProgressIndicator()),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image
                                                                            .asset(
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
                                                            filteredSearch[
                                                                    index]
                                                                .nomProduit!,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          subtitle: Text(
                                                            "${filteredSearch[index].quantiteStock.toString()} ${filteredSearch[index].unite!.sigleUnite}",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          child: Text(
                                                            filteredSearch[index]
                                                                        .monnaie !=
                                                                    null
                                                                ? "${filteredSearch[index].prix.toString()} ${filteredSearch[index].monnaie!.libelle}"
                                                                : "${filteredSearch[index].prix.toString()} FCFA ",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black87,
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
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    32),
                                                        child: Center(
                                                            child:
                                                                const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                        )),
                                                      )
                                                    : Container();
                                              }
                                            },
                                          );
                                  }
                                }),
                          )
                    ))));
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

 
  DropdownButtonFormField<String> buildDropdown(
      List<CategorieProduit> typeList) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      items: typeList
          .map((e) => DropdownMenuItem(
                value: e.idCategorieProduit,
                child: Text(e.libelleCategorie!),
              ))
          .toList(),
      hint: Text("-- Filtre par categorie --"),
      value: typeValue,
      onChanged: (newValue) {
        setState(() {
          typeValue = newValue;
          if (newValue != null) {
            selectedCat = typeList.firstWhere(
              (element) => element.idCategorieProduit == newValue,
            );
          }
          page = 0;
          hasMore = true;
          fetchStockByCategorie(
              detectedCountry != null ? detectedCountry! : "Mali",
              refresh: true);
          if (page == 0 && isLoading == true) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              scrollableController1.jumpTo(0.0);
            });
          }
        });
      },
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  DropdownButtonFormField buildEmptyDropdown() {
    return DropdownButtonFormField(
      items: [],
      onChanged: null,
      decoration: InputDecoration(
        labelText: '-- Aucun categorie trouvé --',
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  DropdownButtonFormField buildLoadingDropdown() {
    return DropdownButtonFormField(
      items: [],
      onChanged: null,
      decoration: InputDecoration(
        labelText: 'Chargement...',
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
