import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/Admin/DetailMateriel.dart';
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Materiel.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/models/TypeMateriel.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/CountryProvider.dart';
import 'package:koumi_app/screens/AddMateriel.dart';
import 'package:koumi_app/screens/ListeMaterielByActeur.dart';
import 'package:koumi_app/service/MaterielService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Location extends StatefulWidget {
  String? detectedCountry;
   Location({super.key, this.detectedCountry});

  @override
  State<Location> createState() => _LocationState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _LocationState extends State<Location> {
  // late TypeMateriel type = TypeMateriel();
  List<Materiel> materielListe = [];
  late Acteur acteur;
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late Future<List<Materiel>> materielListeFuture;
  late Future<List<Materiel>> materielListeFuture1;
  late TextEditingController _searchController;

  bool isExist = false;
  String? email = "";
  String? typeValue;
  TypeMateriel? selectedType;
  late Future _typeList;
  bool isSearchMode = true;
  CountryProvider? countryProvider;
  //   List<ParametreGeneraux> paraList = [];
  // late ParametreGeneraux para = ParametreGeneraux();

  ScrollController scrollableController = ScrollController();
  ScrollController scrollableController1 = ScrollController();

  int page = 0;
  bool isLoading = false;
  int size = 4;
  bool hasMore = true;

  bool isLoadingLibelle = true;
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

  void _scrollListener() {
    if (scrollableController.position.pixels >=
            scrollableController.position.maxScrollExtent - 200 &&
        hasMore &&
        !isLoading &&
        selectedType == null) {
      // Incrementez la page et récupérez les location généraux
      setState(() {
        // Rafraîchir les données ici
        page++;
        });
      debugPrint("yes - fetch all materiel by pays");
      fetchMateriel(widget.detectedCountry != null ? widget.detectedCountry! : "Mali").then((value) {

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
        selectedType != null) {
      // if (selectedCat != null) {
      // Incrementez la page et récupérez les stocks par catégorie
      debugPrint("yes - fetch by type and pays");
      setState(() {
          // Rafraîchir les données ici
      page++;
        });
   
    fetchMaterielByType(widget.detectedCountry != null ? widget.detectedCountry! : "Mali").then((value) {

        setState(() {
          // Rafraîchir les données ici
        });
      });
    }
    debugPrint("no");
  }





 Future<List<Materiel>> fetchMateriel(String niveau3PaysActeur,{bool refresh = false}) async {

    if (isLoading == true) return [];

    setState(() {
      isLoading = true;
    });

    if (mounted) 
    if (refresh) {
      setState(() {
        materielListe.clear();
        page = 0;
        hasMore = true;
      });
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Materiel/getMaterielsByPaysWithPagination?niveau3PaysActeur=$niveau3PaysActeur&page=${page}&size=${size}'));


      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          setState(() {
            List<Materiel> newMateriels =
                body.map((e) => Materiel.fromMap(e)).toList();
            materielListe.addAll(newMateriels);
          });
        }

        debugPrint(
            "response body all materiel with pagination ${page} par défilement soit ${materielListe.length}");
        return materielListe;
      } else {
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
        return [];
      }
    } catch (e) {
      print(
          'Une erreur s\'est produite lors de la récupération des materiels: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return materielListe;
  }



  Future<List<Materiel>> fetchMaterielByType(String niveau3PaysActeur, {bool refresh = false}) async {

    if (isLoading == true) return [];

    setState(() {
      isLoading = true;
    });

    if (refresh) {
      setState(() {
        materielListe.clear();
        page = 0;
        hasMore = true;
      });
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Materiel/getMaterielsByPaysAndTypeMaterielWithPagination?idTypeMateriel=${selectedType!.idTypeMateriel}&niveau3PaysActeur=$niveau3PaysActeur&page=$page&size=$size'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          setState(() {
            List<Materiel> newMateriels =
                body.map((e) => Materiel.fromMap(e)).toList();
            materielListe.addAll(newMateriels);
          });
        }

        debugPrint(
            "response body all materiel by type mateirle and pays with pagination ${page} par défilement soit ${materielListe.length}");
      } else {
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print(
          'Une erreur s\'est produite lors de la récupération des materiel: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return materielListe;
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
   
    Future<List<Materiel>> getAllMateriel() async {
     if (selectedType != null) {
      materielListe = await 
          MaterielService().fetchMaterielByTypeAndPaysWithPagination(selectedType!.idTypeMateriel!,widget.detectedCountry != null ? widget.detectedCountry! : "Mali");
    }else{
     materielListe = await MaterielService().fetchMateriel(widget.detectedCountry != null ? widget.detectedCountry! : "Mali");

    }

    return materielListe;
  }

  @override
  void initState() {
    super.initState();
    verify();
    
    // fetchPaysDataByActor();
        widget.detectedCountry != null ?
   debugPrint("pays fetch location materiel page ${widget.detectedCountry!} ")
     : 
     debugPrint("null pays non fetch location materiel page");
    _searchController = TextEditingController();
    _typeList = http.get(Uri.parse('$apiOnlineUrl/TypeMateriel/read'));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //code will run when widget rendering complete
      scrollableController.addListener(_scrollListener);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //code will run when widget rendering complete
      scrollableController1.addListener(_scrollListener1);
    });
    materielListeFuture = materielListeFuture1 = getAllMateriel();
  }


 @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Accédez au fournisseur ici
    countryProvider = Provider.of<CountryProvider>(context, listen: false);
  }


  @override
  void dispose() {
    scrollableController.dispose();
    scrollableController1.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(

        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 100,
            title: Text(
              "Location Matériel",
              style: const TextStyle(
                  color: d_colorGreen, fontWeight: FontWeight.bold),
            ),
            actions: !isExist
                ? null
                : [
                    PopupMenuButton<String>(
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
                                "Ajouter matériel ",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () async {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddMateriel()));
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
                                "Mes matériels ",
                                style: TextStyle(
                                  color: Colors.green,
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
                                            ListeMaterielByActeur()));
                              },
                            ),
                          )
                        ];
                      },
                    )
                  ]),
        body: Container(
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverToBoxAdapter(
                        child: Column(children: [
                      const SizedBox(height: 10),
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
                      //         if (responseData is List) {
                      //           final reponse = responseData;
                      //           final typeList = reponse
                      //               .map((e) => TypeMateriel.fromMap(e))
                      //               .where((con) => con.statutType == true)
                      //               .toList();

                      //           if (typeList.isEmpty) {
                      //             return DropdownButtonFormField(
                      //               items: [],
                      //               onChanged: null,
                      //               decoration: InputDecoration(
                      //                 labelText:
                      //                     '-- Aucun type de matériel trouvé --',
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
                      //                     value: e.idTypeMateriel,
                      //                     child: Text(e.nom!),
                      //                   ),
                      //                 )
                      //                 .toList(),
                      //             hint:
                      //                 Text("-- Filtre par type de matériel --"),
                      //             value: typeValue,
                      //             onChanged: (newValue) {
                      //               setState(() {
                      //                 typeValue = newValue;
                      //                 if (newValue != null) {
                      //                   selectedType = typeList.firstWhere(
                      //                     (element) =>
                      //                         element.idTypeMateriel ==
                      //                         newValue,
                      //                   );
                      //                 }
                      //                 page = 0;
                      //                 hasMore = true;
                      //                 fetchMaterielByType(refresh: true);
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
                      //               labelText:
                      //                   '-- Aucun type de matériel trouvé --',
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
                      //           labelText:
                      //               '-- Aucun type de matériel trouvé --',
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
                                      .map((e) => TypeMateriel.fromMap(e))
                                      .where(
                                          (con) => con.statutType == true)
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
                        isLoading = false;
                        // Rafraîchir les données ici
                      });
                      debugPrint("refresh page ${page}");
                      // selectedType != null ?StockService().fetchStockByCategorieWithPagination(selectedCat!.idCategorieProduit!) :
                      selectedType == null
                          ? setState(() {
                              materielListeFuture = MaterielService()
                                  .fetchMateriel(widget.detectedCountry != null ? widget.detectedCountry! : "Mali" ,refresh: true);
                            })
                          : setState(() {
                              materielListeFuture1 = MaterielService()
                                  .fetchMaterielByTypeAndPaysWithPagination(
                                      selectedType!.idTypeMateriel!,widget.detectedCountry != null ? widget.detectedCountry! : "Mali",
                                      refresh: true);
                            });
                    },
                    child: selectedType == null
                        ? SingleChildScrollView(
                            controller: scrollableController,
                            child: Consumer<MaterielService>(
                              builder: (context, materielService, child) {
                                return FutureBuilder(
                                    future: materielListeFuture,
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
                                                    'Aucun materiel trouvé',
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
                                        // dynamic jsonString =
                                        //     utf8.decode(snapshot.data!.bodyBytes);
                                        // dynamic responseData = json.decode(jsonString);
                                        materielListe = snapshot.data!;
                                        String searchText = "";
                                        List<Materiel> filteredSearch =
                                            materielListe.where((cate) {
                                          String nomCat =
                                              cate.nom.toLowerCase();
                                          searchText = _searchController.text
                                              .toLowerCase();
                                          return nomCat.contains(searchText);
                                        }).toList();
                                        return filteredSearch
                                                // .where((element) => element.statut == true)
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
                                                          'Aucun materiel trouvé',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 17,
                                                            overflow:
                                                                TextOverflow
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
                                                // itemCount: stockListe.length + (isLoading ? 1 : 0),
                                                // itemCount: materielListe.length + (isLoading ? 1 : 0),

                                                itemBuilder: (context, index) {
                                                  if (index <
                                                      filteredSearch.length) {
                                                    // var e = materielListe
                                                    // .where(
                                                    //     (element) => element.statut == true)
                                                    // .elementAt(index);
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    DetailMateriel(
                                                                        materiel:
                                                                            filteredSearch[index])));
                                                      },
                                                      child: Card(
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
                                                                child: filteredSearch[index].photoMateriel ==
                                                                            null ||
                                                                        filteredSearch[index]
                                                                            .photoMateriel!
                                                                            .isEmpty
                                                                    ? Image
                                                                        .asset(
                                                                        "assets/images/default_image.png",
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        height:
                                                                            85,
                                                                      )
                                                                    : CachedNetworkImage(
                                                                        imageUrl:
                                                                            "https://koumi.ml/api-koumi/Materiel/${materielListe[index].idMateriel}/image",
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                const Center(child: CircularProgressIndicator()),
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
                                                                filteredSearch[
                                                                        index]
                                                                    .nom,
                                                                style:
                                                                    TextStyle(
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
                                                                filteredSearch[
                                                                        index]
                                                                    .localisation,
                                                                style:
                                                                    TextStyle(
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
                                                                          15),
                                                              child: Text(
                                                                "${filteredSearch[index].prixParHeure.toString()} ${filteredSearch[index].monnaie!.libelle}",
                                                                style:
                                                                    TextStyle(
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
                              },
                            ),
                          )
                        : SingleChildScrollView(
                            controller: scrollableController1,
                            child: Consumer<MaterielService>(
                              builder: (context, materielService, child) {
                                return FutureBuilder(
                                    future: materielListeFuture1,
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
                                                    'Aucun matériel trouvé',
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
                                        // dynamic jsonString =
                                        //     utf8.decode(snapshot.data!.bodyBytes);
                                        // dynamic responseData = json.decode(jsonString);
                                        materielListe = snapshot.data!;
                                        String searchText = "";
                                        List<Materiel> filteredSearch =
                                            materielListe.where((cate) {
                                          String nomCat =
                                              cate.nom.toLowerCase();
                                          searchText = _searchController.text
                                              .toLowerCase();
                                          return nomCat.contains(searchText);
                                        }).toList();
                                        return filteredSearch
                                                    // .where((element) => element.statut == true)
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
                                                          'Aucun materiel trouvé',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 17,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : filteredSearch.isEmpty &&
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
                                                            // .where((element) => element.statut == true)
                                                            .length +
                                                        1,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (index <
                                                          filteredSearch
                                                              .length) {
                                                        var e = filteredSearch
                                                            // .where(
                                                            // (element) => element.statut == true)
                                                            .elementAt(index);
                                                        return GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        DetailMateriel(
                                                                            materiel:
                                                                                filteredSearch[index])));
                                                          },
                                                          child: Card(
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
                                                                  child:
                                                                      SizedBox(
                                                                    height: 75,
                                                                    child: filteredSearch[index].photoMateriel ==
                                                                                null ||
                                                                            filteredSearch[index]
                                                                                .photoMateriel!
                                                                                .isEmpty
                                                                        ? Image
                                                                            .asset(
                                                                            "assets/images/default_image.png",
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            height:
                                                                                85,
                                                                          )
                                                                        : CachedNetworkImage(
                                                                            imageUrl:
                                                                                "https://koumi.ml/api-koumi/Materiel/${materielListe[index].idMateriel}/image",
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            placeholder: (context, url) =>
                                                                                const Center(child: CircularProgressIndicator()),
                                                                            errorWidget: (context, url, error) =>
                                                                                Image.asset(
                                                                              'assets/images/default_image.png',
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                                // SizedBox(height: 8),
                                                                ListTile(
                                                                  title: Text(
                                                                    filteredSearch[
                                                                            index]
                                                                        .nom,
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
                                                                  subtitle:
                                                                      Text(
                                                                    filteredSearch[
                                                                            index]
                                                                        .localisation,
                                                                    style:
                                                                        TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
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
                                                                    "${filteredSearch[index].prixParHeure.toString()} ${filteredSearch[index].monnaie!.libelle}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
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
                                                                padding: const EdgeInsets
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
                              },
                            ),
                          )))));
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

 DropdownButtonFormField<String> buildDropdown(
      List<TypeMateriel> typeList) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      items: typeList
          .map((e) => DropdownMenuItem(
                value: e.idTypeMateriel,
                child: Text(e.nom!),
              ))
          .toList(),
      hint: Text("-- Filtre par categorie --"),
      value: typeValue,
      onChanged: (newValue) {
        setState(() {
          typeValue = newValue;
          if (newValue != null) {
            selectedType = typeList.firstWhere(
              (element) => element.idTypeMateriel == newValue,
            );
          }
          page = 0;
          hasMore = true;
          fetchMaterielByType(widget.detectedCountry != null ? widget.detectedCountry! : "Mali" ,refresh: true);
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
        labelText: '-- Aucun type  trouvé --',
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
