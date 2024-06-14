import 'dart:convert';

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
import 'package:koumi_app/screens/ListeIntrantByActeur.dart';
import 'package:koumi_app/service/IntrantService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class IntrantScreen extends StatefulWidget {
  const IntrantScreen({super.key});

  @override
  State<IntrantScreen> createState() => _IntrantScreenState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _IntrantScreenState extends State<IntrantScreen> {
  bool isExist = false;
  late Acteur acteur = Acteur();
  String? email = "";
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late TextEditingController _searchController;
  List<Intrant> intrantListe = [];
  // List<ParametreGeneraux> paraList = [];
  // late ParametreGeneraux para = ParametreGeneraux();
  String? catValue;
  late Future _typeList;
  CategorieProduit? selectedType;
  ScrollController scrollableController = ScrollController();
  ScrollController scrollableController1 = ScrollController();
  bool isSearchMode = true;
  int page = 0;
  bool isLoading = false;
  int size = 4;
  bool hasMore = true;
  late Future<List<Intrant>> intrantListeFuture;
  late Future<List<Intrant>> intrantListeFuture1;

  bool isLoadingLibelle = true;
  // String? monnaie;

//   Future<String> getMonnaieByActor(String id) async {
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

  void _scrollListener() {
    if (scrollableController.position.pixels >=
            scrollableController.position.maxScrollExtent - 200 &&
        hasMore &&
        !isLoading &&
        selectedType == null) {
      // Incrementez la page et récupérez les stocks généraux
      setState(() {
        // Rafraîchir les données ici
        page++;
      });
      debugPrint("yes - fetch all intrants");
      fetchIntrant().then((value) {
        setState(() {
          // Rafraîchir les données ici
          debugPrint("page inc all ${page}");
        });
      });
      // }
      // }
      // else {
    }
    debugPrint("no");
  }

  void _scrollListener1() {
    if (scrollableController1.position.pixels >=
            scrollableController1.position.maxScrollExtent - 200 &&
        hasMore &&
        !isLoading &&
        selectedType != null) {
      // if (selectedCat != null) {
      // Incrementez la page et récupérez les stocks par catégorie
      debugPrint("yes - fetch by category");
      setState(() {
        // Rafraîchir les données ici
        page++;
      });

      fetchIntrantByCategorie().then((value) {
        setState(() {
          // Rafraîchir les données ici
          debugPrint("page inc all ${page}");
        });
      });
    }
    debugPrint("no");
  }

  Future<List<Intrant>> fetchIntrant({bool refresh = false}) async {
    if (isLoading == true) return [];

    setState(() {
      isLoading = true;
    });

    if (mounted) if (refresh) {
      setState(() {
        intrantListe.clear();
        page = 0;
        hasMore = true;
      });
    }

    try {
      final response = await http.get(Uri.parse(
          '$apiOnlineUrl/intrant/getAllIntrantsWithPagination?page=${page}&size=${size}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          setState(() {
            List<Intrant> newIntrants =
                body.map((e) => Intrant.fromMap(e)).toList();
            intrantListe.addAll(newIntrants);
          });
        }

        debugPrint(
            "response body all intrant with pagination ${page} par défilement soit ${intrantListe.length}");
        return intrantListe;
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
    return intrantListe;
  }

  Future<List<Intrant>> fetchIntrantByCategorie({bool refresh = false}) async {
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
          '$apiOnlineUrl/intrant/getAllIntrantsByCategorieWithPagination?idCategorie=${selectedType!.idCategorieProduit}&page=$page&size=$size'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          setState(() {
            List<Intrant> newIntrants =
                body.map((e) => Intrant.fromMap(e)).toList();
            intrantListe.addAll(newIntrants);
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
    if (selectedType != null) {
      intrantListe = await IntrantService()
          .fetchIntrantByCategorieWithPagination(
              selectedType!.idCategorieProduit!);
    }

    return intrantListe;
  }

  @override
  void initState() {
    super.initState();
    verify();
    // paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
    //     .parametreList!;

    // if (paraList.isNotEmpty) {
    //   para = paraList[0];
    // }
    _searchController = TextEditingController();
    _typeList = http.get(Uri.parse('$apiOnlineUrl/Categorie/allCategorie'));
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
    intrantListeFuture = IntrantService().fetchIntrant();
    intrantListeFuture1 = getAllIntrant();
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
              "Intrant agricole ",
              style: TextStyle(
                color: d_colorGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: !isExist
                ? null
                :
                // (type.toLowerCase() == 'admin' ||
                //             type.toLowerCase() == 'fournisseur' ||
                //             type.toLowerCase() == 'fournisseurs') ||
                //         type.toLowerCase() == 'commerçant' ||
                //         type.toLowerCase() == 'commercant'
                (typeActeurData
                            .map((e) => e.libelle!.toLowerCase())
                            .contains("fournisseur") ||
                        typeActeurData
                            .map((e) => e.libelle!.toLowerCase())
                            .contains("admin") ||
                        typeActeurData
                            .map((e) => e.libelle!.toLowerCase())
                            .contains("fournisseurs"))
                    ? [
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddIntrant()));
                                  },
                                ),
                              ),
                              PopupMenuItem<String>(
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.remove_red_eye,
                                    color: d_colorGreen,
                                  ),
                                  title: const Text(
                                    "Mes intrants ",
                                    style: TextStyle(
                                      color: d_colorGreen,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ListeIntrantByActeur()));
                                  },
                                ),
                              )
                            ];
                          },
                        )
                      ]
                    : null),
        body: Container(
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverToBoxAdapter(
                        child: Column(children: [
                      // const SizedBox(height: 10),
                      // Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(horizontal: 10),
                      //     decoration: BoxDecoration(
                      //       color:
                      //           Colors.blueGrey[50], // Couleur d'arrière-plan
                      //       borderRadius: BorderRadius.circular(25),
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         Icon(Icons.search,
                      //             color: Colors
                      //                 .blueGrey[400]), // Couleur de l'icône
                      //         SizedBox(
                      //             width:
                      //                 10), // Espacement entre l'icône et le champ de recherche
                      //         Expanded(
                      //           child: TextField(
                      //             controller: _searchController,
                      //             onChanged: (value) {
                      //               setState(() {});
                      //             },
                      //             decoration: InputDecoration(
                      //               hintText: 'Rechercher',
                      //               border: InputBorder.none,
                      //               hintStyle: TextStyle(
                      //                   color: Colors.blueGrey[
                      //                       400]), // Couleur du texte d'aide
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 10),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 10, horizontal: 20),
                      //   child: FutureBuilder(
                      //     future: _typeList,
                      //     builder: (_, snapshot) {
                      //       if (snapshot.connectionState ==
                      //           ConnectionState.waiting) {
                      //         return DropdownButtonFormField(
                      //           items: [],
                      //           onChanged: null,
                      //           decoration: InputDecoration(
                      //             labelText: 'Chargement...',
                      //             contentPadding: const EdgeInsets.symmetric(
                      //                 vertical: 10, horizontal: 20),
                      //             border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(8),
                      //             ),
                      //           ),
                      //         );
                      //       }

                      //       if (snapshot.hasData) {
                      //         dynamic jsonString =
                      //             utf8.decode(snapshot.data.bodyBytes);
                      //         dynamic responseData = json.decode(jsonString);

                      //         // dynamic responseData = json.decode(snapshot.data.body);
                      //         if (responseData is List) {
                      //           final reponse = responseData;
                      //           final typeList = reponse
                      //               .map((e) => CategorieProduit.fromMap(e))
                      //               .where((con) => con.statutCategorie == true)
                      //               .toList();

                      //           if (typeList.isEmpty) {
                      //             return DropdownButtonFormField(
                      //               items: [],
                      //               onChanged: null,
                      //               decoration: InputDecoration(
                      //                 labelText: '-- Aucun categorie trouvé --',
                      //                 contentPadding:
                      //                     const EdgeInsets.symmetric(
                      //                         vertical: 10, horizontal: 20),
                      //                 border: OutlineInputBorder(
                      //                   borderRadius: BorderRadius.circular(8),
                      //                 ),
                      //               ),
                      //             );
                      //           }

                      //           return DropdownButtonFormField<String>(
                      //             isExpanded: true,
                      //             items: typeList
                      //                 .map(
                      //                   (e) => DropdownMenuItem(
                      //                     value: e.idCategorieProduit,
                      //                     child: Text(e.libelleCategorie!),
                      //                   ),
                      //                 )
                      //                 .toList(),
                      //             hint: Text("-- Filtre par categorie --"),
                      //             value: catValue,
                      //             onChanged: (newValue) {
                      //               setState(() {
                      //                 catValue = newValue;
                      //                 if (newValue != null) {
                      //                   selectedType = typeList.firstWhere(
                      //                     (element) =>
                      //                         element.idCategorieProduit ==
                      //                         newValue,
                      //                   );
                      //                 }

                      //                 page = 0;
                      //                 hasMore = true;
                      //                 fetchIntrantByCategorie(refresh: true);
                      //                 if (page == 0 && isLoading == true) {
                      //                   SchedulerBinding.instance
                      //                       .addPostFrameCallback((_) {
                      //                     scrollableController1.jumpTo(0.0);
                      //                   });
                      //                 }
                      //               });
                      //             },
                      //             decoration: InputDecoration(
                      //               contentPadding: const EdgeInsets.symmetric(
                      //                   vertical: 10, horizontal: 20),
                      //               border: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(8),
                      //               ),
                      //             ),
                      //           );
                      //         } else {
                      //           return DropdownButtonFormField(
                      //             items: [],
                      //             onChanged: null,
                      //             decoration: InputDecoration(
                      //               labelText: '-- Aucun categorie trouvé --',
                      //               contentPadding: const EdgeInsets.symmetric(
                      //                   vertical: 10, horizontal: 20),
                      //               border: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(8),
                      //               ),
                      //             ),
                      //           );
                      //         }
                      //       }
                      //       return DropdownButtonFormField(
                      //         items: [],
                      //         onChanged: null,
                      //         decoration: InputDecoration(
                      //           labelText: '-- Aucun categorie trouvé --',
                      //           contentPadding: const EdgeInsets.symmetric(
                      //               vertical: 10, horizontal: 20),
                      //           border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(8),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ToggleButtons(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('Recherche'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('Filtre'),
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
                        // Rafraîchir les donnée& a
                        //-+s ici
                      });
                      debugPrint("refresh page ${page}");
                      selectedType == null
                          ? setState(() {
                              intrantListeFuture =
                                  IntrantService().fetchIntrant();
                            })
                          : setState(() {
                              intrantListeFuture1 = IntrantService()
                                  .fetchIntrantByCategorieWithPagination(
                                      selectedType!.idCategorieProduit!);
                            });
                    },
                    child: selectedType == null
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
                                      intrantListe = snapshot.data!;
                                      String searchText = "";
                                      List<Intrant> filteredSearch =
                                          intrantListe.where((cate) {
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
                                              itemCount: filteredSearch.length +
                                                  1,
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
                                                      // decoration: BoxDecoration(
                                                      //   color: Color.fromARGB(250, 250, 250, 250),
                                                      //   borderRadius: BorderRadius.circular(15),
                                                      //   boxShadow: [
                                                      //     BoxShadow(
                                                      //       color: Colors.grey.withOpacity(0.3),
                                                      //       offset: Offset(0, 2),
                                                      //       blurRadius: 8,
                                                      //       spreadRadius: 2,
                                                      //     ),
                                                      //   ],
                                                      // ),
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
                                                                          "https://koumi.ml/api-koumi/intrant/${intrantListe[index].idIntrant}/image",
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
                                                          // Align(
                                                          //   alignment: Alignment.bottomRight,
                                                          //   child: Padding(
                                                          //     padding: const EdgeInsets.all(8.0),
                                                          //     child: Container(
                                                          //       width:
                                                          //           30, // Largeur du conteneur réduite
                                                          //       height:
                                                          //           30, // Hauteur du conteneur réduite
                                                          //       decoration: BoxDecoration(
                                                          //         color:
                                                          //             d_colorGreen, // Couleur de fond du bouton
                                                          //         borderRadius: BorderRadius.circular(
                                                          //             15), // Coins arrondis du bouton
                                                          //       ),
                                                          //       child: IconButton(
                                                          //         onPressed: () {
                                                          //           //                                        if (e.acteur.idActeur! == acteur.idActeur!){
                                                          //           // Snack.error(titre: "Alerte", message: "Désolé!, Vous ne pouvez pas commander un intrant qui vous appartient");
                                                          //           // }else{
                                                          //           //   Provider.of<CartProvider>(context, listen: false)
                                                          //           // .addToCartInt(e, 1, "");
                                                          //           // }
                                                          //         },
                                                          //         icon: Icon(
                                                          //             Icons.add), // Icône du panier
                                                          //         color: Colors
                                                          //             .white, // Couleur de l'icône
                                                          //         iconSize:
                                                          //             20, // Taille de l'icône réduite
                                                          //         padding: EdgeInsets
                                                          //             .zero, // Aucune marge intérieure
                                                          //         splashRadius:
                                                          //             15, // Rayon de l'effet de pression réduit
                                                          //         tooltip:
                                                          //             'Ajouter au panier', // Info-bulle au survol de l'icône
                                                          //       ),
                                                          //     ),
                                                          //   ),
                                                          // ),
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      intrantListe = snapshot.data!;
   String searchText = "";
                                      List<Intrant> filteredSearch =
                                          intrantListe.where((cate) {
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
                                          : filteredSearch
                                                      .where((element) =>
                                                          element
                                                              .statutIntrant ==
                                                          true)
                                                      .isEmpty &&
                                                  isLoading == true
                                              ? _buildShimmerEffect()
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
                                                  itemCount: filteredSearch
                                                          .where((element) =>
                                                              element
                                                                  .statutIntrant ==
                                                              true)
                                                          .length +
                                                      1,
                                                  itemBuilder:
                                                      (context, index) {
                                                    if (index <
                                                        filteredSearch.length) {
                                                      var e = filteredSearch
                                                          .where((element) =>
                                                              element
                                                                  .statutIntrant ==
                                                              true)
                                                          .elementAt(index);
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DetailIntrant(
                                                                intrant: e,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Card(
                                                          margin:
                                                              EdgeInsets.all(8),
                                                          // decoration: BoxDecoration(
                                                          //   color: Color.fromARGB(250, 250, 250, 250),
                                                          //   borderRadius: BorderRadius.circular(15),
                                                          //   boxShadow: [
                                                          //     BoxShadow(
                                                          //       color: Colors.grey.withOpacity(0.3),
                                                          //       offset: Offset(0, 2),
                                                          //       blurRadius: 8,
                                                          //       spreadRadius: 2,
                                                          //     ),
                                                          //   ],
                                                          // ),
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
                                                                  child: e.photoIntrant ==
                                                                              null ||
                                                                          e.photoIntrant!
                                                                              .isEmpty
                                                                      ? Image
                                                                          .asset(
                                                                          "assets/images/default_image.png",
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )
                                                                      : CachedNetworkImage(
                                                                          imageUrl:
                                                                              "https://koumi.ml/api-koumi/intrant/${e.idIntrant}/image",
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          placeholder: (context, url) =>
                                                                              const Center(child: CircularProgressIndicator()),
                                                                          errorWidget: (context, url, error) =>
                                                                              Image.asset(
                                                                            'assets/images/default_image.png',
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                ),
                                                              ),
                                                              // SizedBox(height: 8),
                                                              ListTile(
                                                                title: Text(
                                                                  e.nomIntrant!,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
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
                                                                  "${e.quantiteIntrant.toString()} ${e.unite}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        15),
                                                                child: Text(
                                                                  e.monnaie !=
                                                                          null
                                                                      ? "${e.prixIntrant.toString()} ${e.monnaie!.libelle}"
                                                                      : "${e.prixIntrant.toString()} FCFA",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                              )
                                                              // Align(
                                                              //   alignment: Alignment.bottomRight,
                                                              //   child: Padding(
                                                              //     padding: const EdgeInsets.all(8.0),
                                                              //     child: Container(
                                                              //       width:
                                                              //           30, // Largeur du conteneur réduite
                                                              //       height:
                                                              //           30, // Hauteur du conteneur réduite
                                                              //       decoration: BoxDecoration(
                                                              //         color:
                                                              //             d_colorGreen, // Couleur de fond du bouton
                                                              //         borderRadius: BorderRadius.circular(
                                                              //             15), // Coins arrondis du bouton
                                                              //       ),
                                                              //       child: IconButton(
                                                              //         onPressed: () {
                                                              //           //                                        if (e.acteur.idActeur! == acteur.idActeur!){
                                                              //           // Snack.error(titre: "Alerte", message: "Désolé!, Vous ne pouvez pas commander un intrant qui vous appartient");
                                                              //           // }else{
                                                              //           //   Provider.of<CartProvider>(context, listen: false)
                                                              //           // .addToCartInt(e, 1, "");
                                                              //           // }
                                                              //         },
                                                              //         icon: Icon(
                                                              //             Icons.add), // Icône du panier
                                                              //         color: Colors
                                                              //             .white, // Couleur de l'icône
                                                              //         iconSize:
                                                              //             20, // Taille de l'icône réduite
                                                              //         padding: EdgeInsets
                                                              //             .zero, // Aucune marge intérieure
                                                              //         splashRadius:
                                                              //             15, // Rayon de l'effet de pression réduit
                                                              //         tooltip:
                                                              //             'Ajouter au panier', // Info-bulle au survol de l'icône
                                                              //       ),
                                                              //     ),
                                                              //   ),
                                                              // ),
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
                                                                  color: Colors
                                                                      .orange,
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
      value: catValue,
      onChanged: (newValue) {
        setState(() {
          catValue = newValue;
          if (newValue != null) {
            selectedType = typeList.firstWhere(
              (element) => element.idCategorieProduit == newValue,
            );
          }

          page = 0;
          hasMore = true;
          fetchIntrantByCategorie(refresh: true);
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
