import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/DetailProduits.dart';
import 'package:koumi_app/service/BottomNavigationService.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'LoginScreen.dart';

class MyProductScreen extends StatefulWidget {
  String? id, nom;
  MyProductScreen({super.key, this.id, this.nom});

  @override
  State<MyProductScreen> createState() => _MyProductScreenState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _MyProductScreenState extends State<MyProductScreen> {
  late Acteur acteur = Acteur();
  late List<TypeActeur> typeActeurData = [];

  late String type;
  late TextEditingController _searchController;
  List<Stock> stockListe = [];
  CategorieProduit? selectedCat;
  String? typeValue;
  late Future _catList;
  bool isSearchMode = true;
  bool isExist = false;
  String? email = "";
  late Future<List<Stock>> stockListeFuture;
  late Future<List<Stock>> stockListeFuture1;

  ScrollController scrollableController = ScrollController();
  ScrollController scrollableController1 = ScrollController();

  int page = 0;
  bool isLoading = false;
  int size = sized;
  bool hasMore = true;

  bool isLoadingLibelle = true;

  Future<List<Stock>> fetchStockByActeur(String idActeur,
      {bool refresh = false}) async {
    // if (_stockService.isLoading == true) return [];

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
          '$apiOnlineUrl/Stock/getAllStocksByActeurWithPagination?idActeur=$idActeur&page=${page}&size=${size}'));
      debugPrint(
          '$apiOnlineUrl/Stock/getAllStocksByActeurWithPagination?idActeur=$idActeur&page=${page}&size=${size}');
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
            "response body all stocks by acteur with pagination ${page} par défilement soit ${stockListe.length}");
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

  Future<List<Stock>> fetchStockByMagasinAndActeur(
      String idMagasin, String idActeur,
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
          '$apiOnlineUrl/Stock/getAllStocksByMagasinAndActeurWithPagination?idMagasin=$idMagasin&idActeur=$idActeur&page=${page}&size=${size}'));
      debugPrint(
          'page :  $apiOnlineUrl/Stock/getAllStocksByMagasinAndActeurWithPagination?idMagasin=$idMagasin&idActeur=$idActeur&page=${page}&size=${size}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          setState(() {
            List<Stock> newStock = body.map((e) => Stock.fromMap(e)).toList();
            stockListe.addAll(newStock);
          });
        }

        debugPrint(
            "response body all stock by acteur with pagination ${page} par défilement soit ${stockListe.length}");
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

  // Future<List<Stock>> getAllStockByCategorie() async {
  //   if (selectedCat != null) {
  //     stockListe = await StockService().fetchStockByCategorieActeur(
  //         selectedCat!.idCategorieProduit!, acteur.idActeur!);
  //   }

  //   return stockListe;
  // }

  Future<List<Stock>> fetchAllStock() async {
    if (widget.id != null) {
      stockListe =
          await fetchStockByMagasinAndActeur(widget.id!, acteur.idActeur!);
    } else {
      stockListe = await StockService().fetchStockByActeur(acteur.idActeur!);
    }
    return stockListe;
  }

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
        stockListeFuture = fetchAllStock();
        // stockListeFuture1 = getAllStockByCategorie();
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
        !isLoading &&
        widget.id == null) {
      // if (selectedCat != null) {
      // Incrementez la page et récupérez les stocks par catégorie
      debugPrint("yes - fetch stock by acteur");
      setState(() {
        // Rafraîchir les données ici
        page++;
      });
      fetchStockByActeur(acteur.idActeur!).then((value) {
        setState(() {
          // Rafraîchir les données ici
        });
      });
    } else if (scrollableController.position.pixels >=
            scrollableController.position.maxScrollExtent - 200 &&
        hasMore &&
        !isLoading &&
        widget.id != null) {
      debugPrint("yes - fetch stock by magasin and acteur");
      setState(() {
        // Rafraîchir les données ici
        page++;
      });
      fetchStockByMagasinAndActeur(widget.id!, acteur.idActeur!).then((value) {
        setState(() {
          // Rafraîchir les données ici
        });
      });
    } else {
      debugPrint("no");
    }
  }

  // Future<List<Stock>> fetchStockByCat(String idActeur,
  //     {bool refresh = false}) async {
  //   if (isLoading == true) return [];

  //   setState(() {
  //     isLoading = true;
  //   });

  //   if (refresh) {
  //     setState(() {
  //       stockListe.clear();
  //       page = 0;
  //       hasMore = true;
  //     });
  //   }

  //   try {
  //     final response = await http.get(Uri.parse(
  //         '$apiOnlineUrl/Stock/getStocksByCategorieAndActeur?idCategorie=${selectedCat!.idCategorieProduit}&idActeur=$idActeur&page=$page&size=$size'));
  //     debugPrint(
  //         '$apiOnlineUrl/Stock/getStocksByCategorieAndActeur?idCategorie=${selectedCat!.idCategorieProduit}&idActeur=$idActeur&page=$page&size=$size');
  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
  //       final List<dynamic> body = jsonData['content'];

  //       if (body.isEmpty) {
  //         setState(() {
  //           hasMore = false;
  //         });
  //       } else {
  //         List<Stock> newStocks = body.map((e) => Stock.fromMap(e)).toList();
  //         setState(() {
  //           stockListe.addAll(newStocks.where((newStock) => !stockListe
  //               .any((existStock) => existStock.idStock == newStock.idStock)));
  //         });
  //       }

  //       debugPrint(
  //           "response body all stock by categorie and pays with pagination ${page} par défilement soit ${stockListe.length}");
  //     } else {
  //       print(
  //           'Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
  //     }
  //   } catch (e) {
  //     print(
  //         'Une erreur s\'est produite lors de la récupération des stocks: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  //   return stockListe;
  // }

  // void _scrollListener1() {
  //   if (scrollableController1.position.pixels >=
  //           scrollableController1.position.maxScrollExtent - 200 &&
  //       hasMore &&
  //       !isLoading &&
  //       selectedCat != null) {
  //     // if (selectedCat != null) {
  //     // Incrementez la page et récupérez les stocks par catégorie
  //     debugPrint("yes - fetch by category and pays");
  //     if (mounted)
  //       setState(() {
  //         // Rafraîchir les données ici
  //         page++;
  //       });

  //     fetchStockByCat(acteur.idActeur!).then((value) {
  //       setState(() {
  //         // Rafraîchir les données ici
  //         debugPrint("page inc all ${page}");
  //       });
  //     });
  //   }
  //   debugPrint("no");
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //write or call your logic
      //code will run when widget rendering complete
      scrollableController.addListener(_scrollListener);
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   //write or call your logic
    //   //code will run when widget rendering complete
    //   scrollableController1.addListener(_scrollListener1);
    // });
    verify();

    _searchController = TextEditingController();
    _catList = http.get(Uri.parse('$apiOnlineUrl/Categorie/allCategorie'));
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Disposez le TextEditingController lorsque vous n'en avez plus besoin
    scrollableController.dispose();
    scrollableController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        centerTitle: true,
        toolbarHeight: 100,

        title: Text(
          'Mes Produits',
          style: const TextStyle(
              color: d_colorGreen, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        // actions: !isExist ? null :  [
        //    IconButton(
        //       onPressed: () {
        //         setState(() {
        //           stockListeFuture = fetchAllStock();
        //         });
        //       },
        //       icon: Icon(Icons.refresh)),

        //       ]
      ),
      body: !isExist
          ? Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/lock.png",
                        width: 100, height: 100),
                    SizedBox(height: 20),
                    Text(
                      "Vous devez vous connecter pour voir vos produits",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Future.microtask(() {
                          Provider.of<BottomNavigationService>(context,
                                  listen: false)
                              .changeIndex(0);
                        });
                        Get.to(LoginScreen(),
                            duration: Duration(seconds: 1),
                            transition: Transition.leftToRight);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        elevation: MaterialStateProperty.all<double>(0),
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.grey.withOpacity(0.2)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: d_colorGreen),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          "Se connecter",
                          style: TextStyle(fontSize: 16, color: d_colorGreen),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  page = 0;
                  // stockListeFuture1 = getAllStockByCategorie();
                  stockListeFuture = fetchAllStock();
                });
                debugPrint("refresh page ${page}");
              },
              child: Container(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text('Rechercher'),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text('Filtrer'),
                              ),
                            ],
                            isSelected: [isSearchMode, !isSearchMode],
                            onPressed: (index) {
                              setState(() {
                                isSearchMode = index == 0;
                              });
                            },
                          ),
                        ),
                        if (isSearchMode)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[50],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.search,
                                      color: Colors.blueGrey[400]),
                                  SizedBox(width: 10),
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
                                            color: Colors.blueGrey[400]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                  dynamic responseData =
                                      json.decode(jsonString);

                                  if (responseData is List) {
                                    final reponse = responseData;
                                    final typeList = reponse
                                        .map((e) => CategorieProduit.fromMap(e))
                                        .where((con) =>
                                            con.statutCategorie == true)
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
                        // selectedCat != null
                        //     ? setState(() {
                        //         stockListeFuture1 = StockService()
                        //             .fetchStockByCategorieActeur(
                        //                 selectedCat!.idCategorieProduit!,
                        //                 acteur.idActeur!);
                        //       })
                        //     :
                        setState(() {
                          page = 0;

                          stockListeFuture = StockService()
                              .fetchStockByActeur(acteur.idActeur!);
                        });
                        debugPrint("refresh page ${page}");
                      },
                      child: SingleChildScrollView(
                        controller: scrollableController,
                        child: Consumer<StockService>(
                            builder: (context, stockService, child) {
                          return FutureBuilder<List<Stock>>(
                              future: stockListeFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return _buildShimmerEffect();
                                }

                                if (!snapshot.hasData) {
                                  return SingleChildScrollView(
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
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  stockListe = snapshot.data!;
                                  // Vous pouvez afficher une image ou un texte ici

                                  if (stockListe.isEmpty) {
                                    SingleChildScrollView(
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
                                                'Aucun magasin trouvé',
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
                                    );
                                  }
                                  String searchText = "";
                                  List<Stock> filtereSearch =
                                      stockListe.where((search) {
                                    String libelle =
                                        search.nomProduit!.toLowerCase();
                                    searchText = _searchController.text
                                        .trim()
                                        .toLowerCase();
                                    return libelle.contains(searchText);
                                  }).toList();
                                  if (filtereSearch.isEmpty &&
                                      _searchController.text.isNotEmpty) {
                                    SingleChildScrollView(
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
                                                'Aucun magasin trouvé',
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
                                    );
                                  }

                                  return filtereSearch.isEmpty
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
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10,
                                            childAspectRatio: 0.8,
                                          ),
                                          itemCount: filtereSearch.length + 1,
                                          itemBuilder: (context, index) {
                                            if (index < filtereSearch.length) {
                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailProduits(
                                                                stock:
                                                                    filtereSearch[
                                                                        index]),
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
                                                            height: 72,
                                                            child: filtereSearch[index]
                                                                            .photo ==
                                                                        null ||
                                                                    filtereSearch[
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
                                                                        "https://koumi.ml/api-koumi/Stock/${filtereSearch[index].idStock}/image",
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
                                                                        Image
                                                                            .asset(
                                                                      'assets/images/default_image.png',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                          ),
                                                        ),
                                                        ListTile(
                                                          title: Text(
                                                            filtereSearch[index]
                                                                .nomProduit!,
                                                            style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontSize: 15,
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
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          child: Text(
                                                            filtereSearch[index]
                                                                        .monnaie !=
                                                                    null
                                                                ? "${filtereSearch[index].prix.toString()} ${filtereSearch[index].monnaie!.libelle}"
                                                                : "${filtereSearch[index].prix.toString()} FCFA",
                                                            style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                                      8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              _buildEtat(
                                                                  filtereSearch[
                                                                          index]
                                                                      .statutSotck!),
                                                              SizedBox(
                                                                  width: 100),
                                                              Expanded(
                                                                child:
                                                                    PopupMenuButton<
                                                                        String>(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  itemBuilder:
                                                                      (context) =>
                                                                          <PopupMenuEntry<
                                                                              String>>[
                                                                    PopupMenuItem<
                                                                        String>(
                                                                      child:
                                                                          ListTile(
                                                                        leading: filtereSearch[index].statutSotck ==
                                                                                false
                                                                            ? Icon(
                                                                                Icons.check,
                                                                                color: Colors.green,
                                                                              )
                                                                            : Icon(
                                                                                Icons.disabled_visible,
                                                                                color: Colors.orange[400],
                                                                              ),
                                                                        title:
                                                                            Text(
                                                                          filtereSearch[index].statutSotck == false
                                                                              ? "Activer"
                                                                              : "Desactiver",
                                                                          style:
                                                                              TextStyle(
                                                                            color: filtereSearch[index].statutSotck == false
                                                                                ? Colors.green
                                                                                : Colors.orange[400],
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () async {
                                                                          // Changement d'état du magasin ici
                                                                          filtereSearch[index].statutSotck == false
                                                                              ? await StockService()
                                                                                  .activerStock(filtereSearch[index].idStock!)
                                                                                  .then((value) => {
                                                                                        Provider.of<StockService>(context, listen: false).applyChange(),
                                                                                        setState(() {
                                                                                          page++;
                                                                                          stockListeFuture = StockService().fetchStockByActeur(acteur.idActeur!);
                                                                                        }),
                                                                                        Navigator.of(context).pop(),
                                                                                      })
                                                                                  .catchError((onError) => {
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          const SnackBar(
                                                                                            content: Row(
                                                                                              children: [
                                                                                                Text("Une erreur s'est produite"),
                                                                                              ],
                                                                                            ),
                                                                                            duration: Duration(seconds: 5),
                                                                                          ),
                                                                                        ),
                                                                                        Navigator.of(context).pop(),
                                                                                      })
                                                                              : await StockService().desactiverStock(filtereSearch[index].idStock!).then((value) => {
                                                                                    Provider.of<StockService>(context, listen: false).applyChange(),
                                                                                    setState(() {
                                                                                      page++;
                                                                                      stockListeFuture = StockService().fetchStockByActeur(acteur.idActeur!);
                                                                                    }),
                                                                                    Navigator.of(context).pop(),
                                                                                  });

                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            content:
                                                                                Row(
                                                                              children: [
                                                                                Text(filtereSearch[index].statutSotck == false ? "Activer avec succèss " : "Desactiver avec succèss"),
                                                                              ],
                                                                            ),
                                                                            duration:
                                                                                Duration(seconds: 2),
                                                                          ));
                                                                        },
                                                                      ),
                                                                    ),
                                                                    PopupMenuItem<
                                                                        String>(
                                                                      child:
                                                                          ListTile(
                                                                        leading:
                                                                            const Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                        title:
                                                                            const Text(
                                                                          "Modifier la quantité",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () async {
                                                                          Navigator.of(context)
                                                                              .pop();

                                                                          afficherBottomSheet(
                                                                              context,
                                                                              filtereSearch[index]);
                                                                        },
                                                                      ),
                                                                    ),
                                                                    PopupMenuItem<
                                                                        String>(
                                                                      child:
                                                                          ListTile(
                                                                        leading:
                                                                            const Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                        title:
                                                                            const Text(
                                                                          "Supprimer",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () async {
                                                                          await StockService()
                                                                              .deleteStock(filtereSearch[index].idStock!)
                                                                              .then((value) => {
                                                                                    Provider.of<StockService>(context, listen: false).applyChange(),
                                                                                    setState(() {
                                                                                      page++;
                                                                                      stockListeFuture = StockService().fetchStockByActeur(acteur.idActeur!);
                                                                                    }),
                                                                                    Navigator.of(context).pop(),
                                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                                      const SnackBar(
                                                                                        content: Row(
                                                                                          children: [
                                                                                            Text("Produit supprimer avec succès"),
                                                                                          ],
                                                                                        ),
                                                                                        duration: Duration(seconds: 2),
                                                                                      ),
                                                                                    )
                                                                                  })
                                                                              .catchError((onError) => {
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
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ));
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
                      )),
                ),
              ),
            ),
    );
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
      hint: Text("-- Filtre par catégorie --"),
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
          // fetchStockByCat(acteur.idActeur!, refresh: true);
          // if (page == 0 && isLoading == true) {
          //   SchedulerBinding.instance.addPostFrameCallback((_) {
          //     scrollableController1.jumpTo(0.0);
          //   });
          // }
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
        labelText: '-- Aucun catégorie trouvé --',
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

// Méthode pour afficher la feuille inférieure (bottom sheet)
  void afficherBottomSheet(BuildContext context, Stock? stock) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: DialodEdit(stock: stock),
          ),
        );
      },
    );
  }
}

class DialodEdit extends StatefulWidget {
  Stock? stock;
  DialodEdit({super.key, this.stock});

  @override
  State<DialodEdit> createState() => _DialodEditState();
}

class _DialodEditState extends State<DialodEdit> {
  TextEditingController quantiteController = TextEditingController();
  late Stock stocks;
  String? idStock;
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    stocks = widget.stock!;
    idStock = stocks.idStock;
    quantiteController.text = stocks.quantiteStock!.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Form(
          key: formkey,
          child: Column(children: [
            Text(
              "Modification de la quantité",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Veuillez remplir ce champ";
                }
                return null;
              },
              controller: quantiteController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "Quantité",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final qte = quantiteController.text;

                    final qteF = double.tryParse(qte);
                    print(qte);
                    if (formkey.currentState!.validate()) {
                      try {
                        await StockService()
                            .updateQuantiteStock(
                                id: stocks.idStock!, quantite: qteF!)
                            .then((value) => {
                                Navigator.of(context).pop(),
                                  Provider.of<StockService>(context,
                                          listen: false)
                                      .applyChange(),
                                       ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                Text("Quantité modifier avec success"),
                              ],
                            ),
                            duration: Duration(seconds: 5),
                          ),
                        )
                                })
                            .catchError((onError) => {print(onError)});
                      } catch (e) {
                        final String errorMessage = e.toString();
                        print(errorMessage);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                Text("Une erreur s'est produit"),
                              ],
                            ),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: d_colorGreen,

                    // fixedSize: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                  ),
                  child: Text(
                    "Modifier",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                  ),
                  child: Text(
                    "Annuler",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ])),
    );
  }
}
