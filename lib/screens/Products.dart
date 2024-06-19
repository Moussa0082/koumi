import 'dart:async';
import 'dart:convert';

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
import 'package:koumi_app/providers/CountryProvider.dart';
import 'package:koumi_app/screens/AddAndUpdateProductScreen.dart';
import 'package:koumi_app/screens/DetailProduits.dart';
import 'package:koumi_app/screens/MyProduct.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProductsScreen extends StatefulWidget {
  String? id, nom;
  String? detectedCountry;
   ProductsScreen({super.key , this.id, this.nom, this.detectedCountry});


  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);
const d_colorPage = Color.fromRGBO(255, 255, 255, 1);

class _ProductsScreenState extends State<ProductsScreen> {
  // static const String baseUrl = '$apiOnlineUrl/Stock';
  //  static const String baseUrl = 'http://10.0.2.2:9000/api-koumi/Stock';

  late Acteur acteur = Acteur();
  late List<TypeActeur> typeActeurData = [];
  // List<ParametreGeneraux> paraList = [];
  // late ParametreGeneraux para = ParametreGeneraux();
  late String type;
  bool isSearchMode = true;
  late TextEditingController _searchController;
  List<Stock> stockListe = [];
  late Future<List<Stock>> stockListeFuture;
  late Future<List<Stock>> stockListeFuture1;
  late Future<List<Stock>> stockListeFutureNew;
  CategorieProduit? selectedCat;
  String? typeValue;
  late Future _catList;
  bool isExist = false;
  String? email = "";
  ScrollController scrollableController = ScrollController();
  ScrollController scrollableController1 = ScrollController();

  int page = 0;
  bool isLoading = false;
  int size = 4;
  bool hasMore = true;

  bool isLoadingLibelle = true;
  CountryProvider? countryProvider;
  // String? monnaie;

//    Future<String> getMonnaieByActor(String id) async {
//     final response = await http.get(Uri.parse('$apiOnlineUrl/acteur/monnaie/$id'));

//     if (response.statusCode == 200) {
//       print("libelle : ${response.body}");
//       return response.body;  // Return the body directly since it's a plain string
//     } else {
//       throw Exception('Failed to load monnaie');
//     }
// }

//  Future<void> fetchPaysDataByActor() async {
//     try {
//       String monnaies = await getMonnaieByActor(acteur.idActeur!);

//       setState(() {
//         monnaie = monnaies;
//         isLoadingLibelle = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoadingLibelle = false;
//         });
//       print('Error: $e');
//     }
//   }

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
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

  Future<List<Stock>> getAllStock() async {
     if (selectedCat != null) {
      stockListe = await 
          StockService().fetchStockByCategorie(selectedCat!.idCategorieProduit!,widget.detectedCountry != null ? widget.detectedCountry! : "Mali");

    }

    return stockListe;
  }

  Future<List<Stock>> getAllStocks() async {
      
      stockListe = await StockService().fetchStock(widget.detectedCountry != null ? widget.detectedCountry! : "Mali");
      

    return stockListe;
  }

  void _scrollListener() {
    if (scrollableController.position.pixels >=
            scrollableController.position.maxScrollExtent - 200 &&
        hasMore &&
        !isLoading &&
        selectedCat == null) {
      // Incrementez la page et récupérez les stocks généraux
      setState(() {
        // Rafraîchir les données ici
        page++;
        });
      debugPrint("yes - fetch all stocks by pays");
      fetchStock(widget.detectedCountry != null ? widget.detectedCountry! : "Mali").then((value) {

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
      setState(() {
          // Rafraîchir les données ici
      page++;
        });
   
    fetchStockByCategorie(widget.detectedCountry != null ? widget.detectedCountry! : "Mali").then((value) {

        setState(() {
          // Rafraîchir les données ici
          debugPrint("page inc all ${page}");
        });
      });
    }
    debugPrint("no");
  }

  Future<List<Stock>> fetchStock(String niveau3PaysActeur, {bool refresh = false}) async {
    if (isLoading == true) return [];

    setState(() {
      isLoading = true;
    });

    if (mounted) if (refresh) {
      setState(() {
        stockListe.clear();
        page = 0;
        hasMore = true;
      });
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Stock/getStocksByPaysWithPagination?niveau3PaysActeur=$niveau3PaysActeur&page=${page}&size=${size}'));


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
            "response body all stock with pagination ${page} par défilement soit ${stockListe.length}");
        return stockListe;
      } else {
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
        return [];
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


  Future<List<Stock>> fetchStockByCategorie(String niveau3PaysActeur, {bool refresh = false}) async {

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
      final response = await http.get(Uri.parse('$apiOnlineUrl/Stock/getAllStocksByCategorieAndPaysWithPagination?idCategorie=${selectedCat!.idCategorieProduit}&niveau3PaysActeur=$niveau3PaysActeur&page=$page&size=$size'));


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

        debugPrint("response body all stock by categorie and pays with pagination ${page} par défilement soit ${stockListe.length}");

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

  // void verifyParam() {
  //   paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
  //       .parametreList!;

  //   if (paraList.isNotEmpty) {
  //     para = paraList[0];
  //   } else {
  //     // Gérer le cas où la liste est null ou vide, par exemple :
  //     // Afficher un message d'erreur, initialiser 'para' à une valeur par défaut, etc.
  //   }
  // }

  @override
  void initState() {
    // acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    // typeActeurData = acteur.typeActeur!;
    // // selectedType == null;
    // type = typeActeurData.map((data) => data.libelle).join(', ');
    super.initState();
    //  scrollableController = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //write or call your logic
      //code will run when widget rendering complete
      scrollableController.addListener(_scrollListener);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //write or call your logic
      //code will run when widget rendering complete
      scrollableController1.addListener(_scrollListener1);
    });
    verify();
    // fetchPaysDataByActor();
    _searchController = TextEditingController();
    _catList = http.get(Uri.parse('$apiOnlineUrl/Categorie/allCategorie'));
    // updateStockList();
    stockListeFuture = getAllStocks();
    stockListeFuture1 = getAllStock();
    // stockListeFutureNew = getAll();
    //  getAllStocks();
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
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          centerTitle: true,
          toolbarHeight: 100,
          // leading: IconButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
          title: Text(
            'Tous les Produits',
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
          actions: !isExist
              ? null
              : [
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddAndUpdateProductScreen(
                                          isEditable: false,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              PopupMenuItem<String>(
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.green,
                                  ),
                                  title: const Text(
                                    "Mes produits",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyProductScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ];
                          },
                        )
                      : PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context) {
                            return <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.green,
                                  ),
                                  title: const Text(
                                    "Mes produits",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyProductScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ];
                          },
                        ),
                ]),
      body: Container(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                  child: Column(children: [
                const SizedBox(height: 10),

               
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ToggleButtons(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Rechercher'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          Icon(Icons.search, color: Colors.blueGrey[400]),
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
                                hintStyle:
                                    TextStyle(color: Colors.blueGrey[400]),
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
                          dynamic responseData = json.decode(jsonString);

                          if (responseData is List) {
                            final reponse = responseData;
                            final typeList = reponse
                                .map((e) => CategorieProduit.fromMap(e))
                                .where((con) => con.statutCategorie == true)
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
              // selectedCat != null ?StockService().fetchStockByCategorieWithPagination(selectedCat!.idCategorieProduit!) :
              selectedCat != null
                  ? setState(() {
                      stockListeFuture1 = StockService()
                          .fetchStockByCategorie(
                              selectedCat!.idCategorieProduit!, widget.detectedCountry != null ? widget.detectedCountry! : "Mali");
                    })
                  : setState(() {
                      stockListeFuture = StockService().fetchStock(widget.detectedCountry != null ? widget.detectedCountry! : "Mali");
                    });
            },
            child: selectedCat == null
                ? SingleChildScrollView(
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
                            if (snapshot.hasError == true) {
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
                                        Text(
                                          'Aucun produit trouvé une erreur s\'est produite',
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
                            // if (isLoading== true && hasMore == true)
                            // {
                            //   return Center(child: CircularProgressIndicator());
                            // }
                            if (!snapshot.hasData) {
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
                              String searchText = "";
                              List<Stock> filteredSearch =
                                  stockListe.where((cate) {
                                String nomCat = cate.nomProduit!.toLowerCase();
                                searchText =
                                    _searchController.text.toLowerCase();
                                return nomCat.contains(searchText);
                              }).toList();
                              return filteredSearch
                                      // .where((element) => element.statutSotck == true && element.acteur!.statutActeur! == true)
                                      .isEmpty
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
                                  : Center(
                                      child: GridView.builder(
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
                                        // itemCount: stockListe.length + (isLoading ? 1 : 0),
                                        itemBuilder: (context, index) {
                                          //     if (index == stockListe.length) {
                                          // return
                                          // _buildShimmerEffects()
                                          // // Center(
                                          // //   child: CircularProgressIndicator(
                                          // //     color: Colors.orange,
                                          // //   ),
                                          // // )
                                          // ;
                                          //     }

                                          if (index < filteredSearch.length) {
                                            // var e = stockListe
                                            //     // .where((element) =>
                                            //     //     element.statutSotck == true)
                                            //     .elementAt(index-1);
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
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Container(
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
                                                                      "https://koumi.ml/api-koumi/Stock/${stockListe[index].idStock}/image",
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
                                                      // SizedBox(height: 8),
                                                      ListTile(
                                                        title: Text(
                                                          filteredSearch[index]
                                                              .nomProduit!,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        subtitle: Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          "${filteredSearch[index].quantiteStock!.toString()} ${filteredSearch[index].unite!.nomUnite} ",
                                                          style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 15),
                                                        child: Text(
                                                          filteredSearch[index]
                                                                      .monnaie !=
                                                                  null
                                                              ? "${filteredSearch[index].prix.toString()} ${filteredSearch[index].monnaie!.libelle}"
                                                              : "${filteredSearch[index].prix.toString()} FCFA",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black87,
                                                          ),
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
                                                        vertical: 32),
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
                                      ),
                                    );
                            }
                          });
                    }),
                  )
                : SingleChildScrollView(
                    controller: scrollableController1,
                    child: Consumer<StockService>(
                        builder: (context, stockService, child) {
                      return FutureBuilder<List<Stock>>(
                          future: stockListeFuture1,
                          // StockService().fetchStockByCategorieWithPagination(selectedCat!.idCategorieProduit!),
                          // fetchStockByCategorie(selectedCat!.idCategorieProduit!) ,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _buildShimmerEffect();
                              // const Center(
                              //   child: CircularProgressIndicator(
                              //     color: Colors.orange,
                              //   ),
                              // );
                            }
                            if (snapshot.hasError == true) {
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
                                        Text(
                                          'Aucun produit trouvé une erreur s\'est produite',
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

                            if (!snapshot.hasData) {
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
                              String searchText = "";
                              List<Stock> filteredSearch =
                                  stockListe.where((cate) {
                                String nomCat = cate.nomProduit!.toLowerCase();
                                searchText =
                                    _searchController.text.toLowerCase();
                                return nomCat.contains(searchText);
                              }).toList();

                              return filteredSearch
                                          // .where((element) => element.statutSotck == true )
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
                                  : filteredSearch
                                              // .where((element) => element.statutSotck == true )
                                              .isEmpty &&
                                          isLoading == true
                                      ? _buildShimmerEffect()
                                      : Center(
                                          child: GridView.builder(
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
                                            itemCount: filteredSearch.length + 1,
                                            //  itemCount: stockListe.length + (!isLoading ? 1 : 0),
                                            itemBuilder: (context, index) {
                                              //   if (index == stockListe.length) {
                                              // return
                                              // _buildShimmerEffect()
                                              // // Center(
                                              // //   child: CircularProgressIndicator(
                                              // //     color: Colors.orange,
                                              // //   ),
                                              // // )
                                              // ;
                                              //     }

                                              if (index < filteredSearch.length) {
                                                return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailProduits(
                                                            stock: filteredSearch[
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
                                                            child: Container(
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
                                                                          "https://koumi.ml/api-koumi/Stock/${stockListe[index].idStock}/image",
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
                                                              filteredSearch[index]
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
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              "${filteredSearch[index].quantiteStock!.toString()} ${filteredSearch[index].unite!.nomUnite} ",
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
                                                                  : "${filteredSearch[index].prix.toString()} FCFA",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ));
                                              } else {
                                                return isLoading == true
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 32),
                                                        child: Center(
                                                            child: const Center(
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
                                          ),
                                        );
                            }
                          });
                    }),
                  ),
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

  // Define the _buildShimmerEffects function
  Widget _buildShimmerEffects() {
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
                overflow: TextOverflow.ellipsis,
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
          fetchStockByCategorie(widget.detectedCountry != null ? widget.detectedCountry! : "Mali",refresh: true);
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
