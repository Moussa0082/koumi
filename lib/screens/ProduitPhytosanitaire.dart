import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddIntrant.dart';
import 'package:koumi_app/screens/DetailIntrant.dart';
import 'package:koumi_app/service/IntrantService.dart';
import 'package:koumi_app/widgets/AutoComptet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProduitPhytosanitaire extends StatefulWidget {
  String? detectedCountry;

  ProduitPhytosanitaire({super.key, this.detectedCountry});

  @override
  State<ProduitPhytosanitaire> createState() => _ProduitPhytosanitaireState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _ProduitPhytosanitaireState extends State<ProduitPhytosanitaire> {
  int page = 0;
  bool isLoading = false;
  late TextEditingController _searchController;
  ScrollController scrollableController = ScrollController();
  int size = sized;
  bool isExist = false;
  late Acteur acteur = Acteur();
  String? email = "";
  late List<TypeActeur> typeActeurData = [];
  late String type;
  bool hasMore = true;
  late Future<List<Intrant>> intrantListeFuture;
  late Future<List<Intrant>> intrantListeFuture1;
  List<Intrant> intrantListe = [];
  List<Intrant> intrantList = [];
  String? catValue;
  late Future _typeList;
  bool isSearchMode = true;
  CategorieProduit? selectedCat;
  // CategorieProduit? selectedType;
  ScrollController scrollableController1 = ScrollController();

  String libelle = "Produits phytosanitaire";

  void _scrollListener() {
    debugPrint("Scroll position: ${scrollableController.position.pixels}");
    if (scrollableController.position.pixels >=
            scrollableController.position.maxScrollExtent - 200 &&
        hasMore &&
        !isLoading) {
      setState(() {
        page++;
      });

      fetchIntrantByCategorie(
              widget.detectedCountry != null ? widget.detectedCountry! : "Mali")
          .then((value) {
        setState(() {
          debugPrint("page inc all $page");
        });
      });
    }
    debugPrint("no");
  }

  Future<List<Intrant>> fetchIntrantByCategorie(String pays,
      {bool refresh = false}) async {
    if (isLoading == true) return [];

    setState(() {
      isLoading = true;
    });

    if (refresh) {
      setState(() {
        intrantListe.clear();
        page = 0;
        hasMore = true;
      });
    }

    try {
      final response = await http.get(Uri.parse(
          '$apiOnlineUrl/intrant/listeIntrantByLibelleCategorie?libelle=$libelle&pays=$pays&page=$page&size=$size'));
      debugPrint(
          '$apiOnlineUrl/intrant/listeIntrantByLibelleCategorie?libelle=$libelle&pays=$pays&page=$page&size=$size');
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          List<Intrant> newIntrants =
              body.map((e) => Intrant.fromMap(e)).toList();

          setState(() {
            // Ajouter uniquement les nouveaux intrants qui ne sont pas déjà dans la liste
            intrantListe.addAll(newIntrants.where((newIntrant) =>
                !intrantListe.any((existingIntrant) =>
                    existingIntrant.idIntrant == newIntrant.idIntrant)));
          });
        }

        debugPrint(
            "response body all intrants by categorie with pagination ${page} par défilement soit ${intrantListe.length} et code ${response.statusCode}");
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
    return intrantListe;
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
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

  Future<List<Intrant>> getAllIntrant() async {
    if (selectedCat != null) {
      intrantListe = await IntrantService().fetchIntrantByCategorieAndFilieres(
          selectedCat!.idCategorieProduit!, libelle, widget.detectedCountry!);
    }

    return intrantListe;
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

      fetchIntrantByCategorieAndFiliere(
              widget.detectedCountry != null ? widget.detectedCountry! : "Mali")
          .then((value) {
        setState(() {
          // Rafraîchir les données ici
          debugPrint("page inc all ${page}");
        });
      });
    }
    debugPrint("no");
  }

  Future<List<Intrant>> fetchIntrantByCategorieAndFiliere(String pays,
      {bool refresh = false}) async {
    if (isLoading == true) return [];

    setState(() {
      isLoading = true;
    });

    if (refresh) {
      setState(() {
        intrantListe.clear();
        page = 0;
        hasMore = true;
      });
    }

    try {
      // for (String libelle in libelles) {
      final response = await http.get(Uri.parse(
          '$apiOnlineUrl/intrant/listeIntrantByLibelleFiliereAndIcategorie?idCategorie=${selectedCat!.idCategorieProduit}&libelle=$libelle&pays=$pays&page=$page&size=$size'));
      debugPrint(
          '$apiOnlineUrl/intrant/listeIntrantByLibelleFiliereAndIcategorie?idCategorie=${selectedCat!.idCategorieProduit}&libelle=$libelle&pays=$pays&page=$page&size=$size');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          List<Intrant> newIntrants =
              body.map((e) => Intrant.fromMap(e)).toList();

          setState(() {
            // Ajouter uniquement les nouveaux intrants qui ne sont pas déjà dans la liste
            intrantListe.addAll(newIntrants.where((newIntrant) =>
                !intrantListe.any((existingIntrant) =>
                    existingIntrant.idIntrant == newIntrant.idIntrant)));
          });
        }

        debugPrint(
            "response body all intrants by categorie with pagination ${page} par défilement soit ${intrantListe.length}");
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
    return intrantListe;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollableController.addListener(_scrollListener);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollableController1.addListener(_scrollListener1);
    });

    _typeList = http.get(Uri.parse(
        '$apiOnlineUrl/Categorie/allCategorieByLibelleFiliere/$libelle'));
    intrantListeFuture1 = getAllIntrant();
    intrantListeFuture = fetchIntrantByCategorie(
        widget.detectedCountry != null ? widget.detectedCountry! : "Mali");
    verify();
  }

  Future<void> _getResultFromNextScreen1(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddIntrant()));
    log(result.toString());
    if (result == true) {
      print("Rafraichissement en cours");
      setState(() {
        intrantListeFuture = IntrantService().fetchIntrantByPays(
            widget.detectedCountry != null ? widget.detectedCountry! : "Mali");
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
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
              "Produits phytosanitaires",
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
                          intrantListeFuture = fetchIntrantByCategorie(
                              widget.detectedCountry != null
                                  ? widget.detectedCountry!
                                  : "Mali");
                        },
                        icon: const Icon(Icons.refresh, color: d_colorGreen)),
                  ]
                : (typeActeurData
                            .map((e) => e.libelle!.toLowerCase())
                            .contains("fournisseur") ||
                        typeActeurData
                            .map((e) => e.libelle!.toLowerCase())
                            .contains("admin") ||
                        typeActeurData
                            .map((e) => e.libelle!.toLowerCase())
                            .contains("fournisseurs"))
                    ? [
                        IconButton(
                            onPressed: () {
                              intrantListeFuture = fetchIntrantByCategorie(
                                  widget.detectedCountry != null
                                      ? widget.detectedCountry!
                                      : "Mali");
                            },
                            icon:
                                const Icon(Icons.refresh, color: d_colorGreen)),
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context) {
                            return <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.add,
                                    color: d_colorGreen,
                                  ),
                                  title: const Text(
                                    "Ajouter intrant ",
                                    style: TextStyle(
                                      color: d_colorGreen,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    _getResultFromNextScreen1(context);
                                  },
                                ),
                              ),
                              // PopupMenuItem<String>(
                              //   child: ListTile(
                              //     leading: const Icon(
                              //       Icons.remove_red_eye,
                              //       color: d_colorGreen,
                              //     ),
                              //     title: const Text(
                              //       "Mes intrants ",
                              //       style: TextStyle(
                              //         color: d_colorGreen,
                              //         fontSize: 18,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //     onTap: () async {
                              //       Navigator.of(context).pop();
                              //       _getResultFromNextScreen2(context);
                              //     },
                              //   ),
                              // )
                            ];
                          },
                        )
                      ]
                    : [
                        IconButton(
                            onPressed: () {
                              intrantListeFuture = fetchIntrantByCategorie(
                                  widget.detectedCountry != null
                                      ? widget.detectedCountry!
                                      : "Mali");
                            },
                            icon:
                                const Icon(Icons.refresh, color: d_colorGreen)),
                      ]),
        body: Container(
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverToBoxAdapter(
                        child: Column(children: [
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
                                  child: Autocomplete<String>(
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text.isEmpty) {
                                        return const Iterable<String>.empty();
                                      }
                                      return AutoComplet.getAgriculturalInputs()
                                          .where((String option) {
                                        return option.toLowerCase().contains(
                                            textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (String selection) {
                                      _searchController.text = selection;
                                      setState(() {});
                                    },
                                    fieldViewBuilder: (BuildContext context,
                                        TextEditingController
                                            fieldTextEditingController,
                                        FocusNode fieldFocusNode,
                                        VoidCallback onFieldSubmitted) {
                                      return TextField(
                                        controller: fieldTextEditingController,
                                        focusNode: fieldFocusNode,
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Rechercher',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Colors.blueGrey[400]),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
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
                            future: _typeList,
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return buildLoadingDropdown();
                              }

                              if (snapshot.hasData) {
                                dynamic jsonString =
                                    utf8.decode(snapshot.data.bodyBytes);
                                dynamic responseData = json.decode(jsonString);
                                //
                                // }
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
                              intrantListeFuture = IntrantService()
                                  .fetchIntrantByCategorieAndFilieres(
                                      selectedCat!.idCategorieProduit!,
                                      libelle,
                                      widget.detectedCountry!);
                            })
                          : setState(() {
                              intrantListeFuture = fetchIntrantByCategorie(
                                  widget.detectedCountry != null
                                      ? widget.detectedCountry!
                                      : "Mali");
                            });
                    },
                    child: selectedCat == null
                        ? SingleChildScrollView(
                            controller: scrollableController,
                            child: Consumer<IntrantService>(
                                builder: (context, intrantService, child) {
                              return FutureBuilder(
                                  future: intrantListeFuture,
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
                                      intrantList = snapshot.data!;
                                      String searchText = "";
                                      List<Intrant> filteredSearch =
                                          intrantList.where((cate) {
                                        String nomCat =
                                            cate.nomIntrant!.toLowerCase();
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
                                                              DetailIntrant(
                                                            intrant:
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
                                                                              .photoIntrant ==
                                                                          null ||
                                                                      filteredSearch[
                                                                              index]
                                                                          .photoIntrant!
                                                                          .isEmpty
                                                                  ? Image.asset(
                                                                      "assets/images/default_image.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : CachedNetworkImage(
                                                                      imageUrl:
                                                                          "https://koumi.ml/api-koumi/intrant/${filteredSearch[index].idIntrant}/image",
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
                                                                  .nomIntrant!,
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
                                                              "${filteredSearch[index].quantiteIntrant.toString()} ${filteredSearch[index].unite}",
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
                                                                  ? "${filteredSearch[index].prixIntrant.toString()} ${filteredSearch[index].monnaie!.libelle}"
                                                                  : "${filteredSearch[index].prixIntrant.toString()} FCFA ",
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
                                  });
                            }),
                          )
                        : SingleChildScrollView(
                            controller: scrollableController1,
                            child: Consumer<IntrantService>(
                                builder: (context, intrantService, child) {
                              return FutureBuilder(
                                  future: intrantListeFuture1,
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
                                      intrantList = snapshot.data!;
                                      String searchText = "";
                                      List<Intrant> filteredSearch =
                                          intrantList.where((cate) {
                                        String nomCat =
                                            cate.nomIntrant!.toLowerCase();
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
                                                              DetailIntrant(
                                                            intrant:
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
                                                                              .photoIntrant ==
                                                                          null ||
                                                                      filteredSearch[
                                                                              index]
                                                                          .photoIntrant!
                                                                          .isEmpty
                                                                  ? Image.asset(
                                                                      "assets/images/default_image.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : CachedNetworkImage(
                                                                      imageUrl:
                                                                          "https://koumi.ml/api-koumi/intrant/${filteredSearch[index].idIntrant}/image",
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
                                                                  .nomIntrant!,
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
                                                              "${filteredSearch[index].quantiteIntrant.toString()} ${filteredSearch[index].unite}",
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
                                                                  ? "${filteredSearch[index].prixIntrant.toString()} ${filteredSearch[index].monnaie!.libelle}"
                                                                  : "${filteredSearch[index].prixIntrant.toString()} FCFA ",
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
      value: catValue,
      onChanged: (newValue) {
        setState(() {
          catValue = newValue;
          if (newValue != null) {
            selectedCat = typeList.firstWhere(
              (element) => element.idCategorieProduit == newValue,
            );
          }

          page = 0;
          hasMore = true;
          fetchIntrantByCategorieAndFiliere(
              widget.detectedCountry != null ? widget.detectedCountry! : "Mali",
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
        labelText: '-- Aucune catégorie trouvé --',
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
