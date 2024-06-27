import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/models/TypeVoiture.dart';
import 'package:koumi_app/models/Vehicule.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/CountryProvider.dart';
import 'package:koumi_app/screens/AddVehicule.dart';
import 'package:koumi_app/screens/DetailTransport.dart';
import 'package:koumi_app/screens/PageTransporteur.dart';
import 'package:koumi_app/screens/VehiculesActeur.dart';
import 'package:koumi_app/service/VehiculeService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Transport extends StatefulWidget {
  String? detectedCountry;
  Transport({super.key, this.detectedCountry});

  @override
  State<Transport> createState() => _TransportState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _TransportState extends State<Transport> {
  late Acteur acteur;
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late TextEditingController _searchController;
  List<Vehicule> vehiculeListe = [];
  TypeVoiture? selectedType;
  String? typeValue;
  late Future _typeList;
  bool isExist = false;
  String? email = "";
  int page = 0;
  bool isLoading = false;
  bool isSearchMode = true;
  int size = sized;
  bool hasMore = true;
  ScrollController scrollableController = ScrollController();
  ScrollController scrollableController1 = ScrollController();
  late Future<List<Vehicule>> vehiculeListeFuture;
  late Future<List<Vehicule>> vehiculeListeFuture1;
  CountryProvider? countryProvider;

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
      debugPrint("yes - fetch all by pays vehicule");
      fetchVehicule(
              widget.detectedCountry != null ? widget.detectedCountry! : "Mali")
          .then((value) {
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
      debugPrint("yes - fetch by type and pays");
      setState(() {
        // Rafraîchir les données ici
        page++;
      });

      fetchVehiculeByTypeVoitureWithPagination(selectedType!.idTypeVoiture!,
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

  Future<List<Vehicule>> fetchVehiculeByTypeVoitureWithPagination(
      String idTypeVoiture, String niveau3PaysActeur,
      {bool refresh = false}) async {
    if (isLoading) return [];
    setState(() {
      isLoading = true;
    });

    if (refresh) {
      setState(() {
        vehiculeListe.clear();
        page = 0;
        hasMore = true;
      });
    }

    try {
      final response = await http.get(Uri.parse(
          '$apiOnlineUrl/vehicule/getVehiculesByPaysAndTypeVoitureWithPagination?idTypeVoiture=$idTypeVoiture&niveau3PaysActeur=$niveau3PaysActeur&page=$page&size=$size'));

      if (response.statusCode == 200) {
        // debugPrint("url: $response");
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          setState(() {
            List<Vehicule> newVehicule =
                body.map((e) => Vehicule.fromMap(e)).toList();
            vehiculeListe.addAll(newVehicule);
            // page++;
          });
        }

        debugPrint(
            "response body vehicle by type vehicule with pagination $page par défilement soit ${vehiculeListe.length}");
        return vehiculeListe;
      } else {
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
        return [];
      }
    } catch (e) {
      print(
          'Une erreur s\'est produite lors de la récupération des vehicules: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return vehiculeListe;
  }

  Future<List<Vehicule>> fetchVehicule(String niveau3PaysActeur,
      {bool refresh = false}) async {
    if (isLoading) return [];

    setState(() {
      isLoading = true;
    });

    if (refresh) {
      setState(() {
        vehiculeListe.clear();
        page = 0;
        hasMore = true;
      });
    }

    try {
      final response = await http.get(Uri.parse(
          '$apiOnlineUrl/vehicule/getVehiculesByPaysWithPagination?niveau3PaysActeur=$niveau3PaysActeur&page=$page&size=$size'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          setState(() {
            List<Vehicule> newVehicule =
                body.map((e) => Vehicule.fromMap(e)).toList();
            vehiculeListe.addAll(newVehicule);
            // page++;
          });
        }

        debugPrint(
            "response body all vehicle with pagination $page par défilement soit ${vehiculeListe.length}");
        return vehiculeListe;
      } else {
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
        return [];
      }
    } catch (e) {
      print(
          'Une erreur s\'est produite lors de la récupération des vehicules: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return vehiculeListe;
  }

  Future<List<Vehicule>> getAllVehicule() async {
    if (selectedType != null) {
      vehiculeListe = await VehiculeService()
          .fetchVehiculeByTypeVoitureWithPagination(
              selectedType!.idTypeVoiture!,
              widget.detectedCountry != null
                  ? widget.detectedCountry!
                  : "Mali");
    }

    return vehiculeListe;
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
        // vehiculeListeFuture1 = VehiculeService().fetchVehiculeByTypeVoitureWithPagination(selectedType!.idTypeVoiture!);
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

  @override
  void initState() {
    // acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    // typeActeurData = acteur.typeActeur!;
    // // selectedType == null;
    // type = typeActeurData.map((data) => data.libelle).join(', ');
    verify();
    widget.detectedCountry != null
        ? debugPrint("pays fetch transport page ${widget.detectedCountry!} ")
        : debugPrint("null pays non fetch transport page");
    vehiculeListeFuture = VehiculeService().fetchVehicule(
        widget.detectedCountry != null ? widget.detectedCountry! : "Mali");
    _searchController = TextEditingController();
    _typeList = http.get(Uri.parse('$apiOnlineUrl/TypeVoiture/read'));
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
    vehiculeListeFuture = VehiculeService().fetchVehicule(
        widget.detectedCountry != null ? widget.detectedCountry! : "Mali");
    vehiculeListeFuture1 = getAllVehicule();

    super.initState();
  }

  Future<void> _getResultFromNextScreen1(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddVehicule()));
    log(result.toString());
    if (result == true) {
      print("Rafraichissement en cours");
      setState(() {
        vehiculeListeFuture = VehiculeService().fetchVehicule(
            widget.detectedCountry != null ? widget.detectedCountry! : "Mali");
      });
    }
  }

  Future<void> _getResultFromNextScreen2(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => VehiculeActeur()));
    log(result.toString());
    if (result == true) {
      print("Rafraichissement en cours");
      setState(() {
        vehiculeListeFuture = VehiculeService().fetchVehicule(
            widget.detectedCountry != null ? widget.detectedCountry! : "Mali");
      });
    }
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Disposez le TextEditingController lorsque vous n'en avez plus besoin
    scrollableController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Accédez au fournisseur ici
    countryProvider = Provider.of<CountryProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 100,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
            title: Text(
              'Transport',
              style: const TextStyle(
                  color: d_colorGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            actions: !isExist
                ? [
                    IconButton(
                        onPressed: () {
                          vehiculeListeFuture = VehiculeService().fetchVehicule(
                              widget.detectedCountry != null
                                  ? widget.detectedCountry!
                                  : "Mali");
                        },
                        icon: const Icon(Icons.refresh, color: d_colorGreen)),
                  ]
                : [
                    IconButton(
                        onPressed: () {
                          vehiculeListeFuture = VehiculeService().fetchVehicule(
                              widget.detectedCountry != null
                                  ? widget.detectedCountry!
                                  : "Mali");
                        },
                        icon: const Icon(Icons.refresh, color: d_colorGreen)),
                    (typeActeurData
                                .map((e) => e.libelle!.toLowerCase())
                                .contains("transporteur") ||
                            typeActeurData
                                .map((e) => e.libelle!.toLowerCase())
                                .contains("admin"))
                        // (type.toLowerCase() == 'admin' ||
                        //         type.toLowerCase() == 'transporteur')
                        ? PopupMenuButton<String>(
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
                                      "Transporteurs",
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
                                                  PageTransporteur()));
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
                                      "Mes véhicules",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: () async {
                                      Navigator.of(context).pop();
                                      _getResultFromNextScreen2(context);
                                    },
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.add,
                                      color: Colors.green,
                                    ),
                                    title: const Text(
                                      "Ajouter un vehicule",
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
                                      "Transporteurs",
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
                                                  PageTransporteur()));
                                    },
                                  ),
                                ),
                              ];
                            },
                          )
                  ]),
        body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                page = 0;
              });
              selectedType == null
                  ? setState(() {
                      vehiculeListeFuture = VehiculeService().fetchVehicule(
                          widget.detectedCountry != null
                              ? widget.detectedCountry!
                              : "Mali");
                    })
                  : setState(() {
                      vehiculeListeFuture1 = VehiculeService()
                          .fetchVehiculeByTypeVoitureWithPagination(
                              selectedType!.idTypeVoiture!,
                              widget.detectedCountry != null
                                  ? widget.detectedCountry!
                                  : "Mali");
                    });
            },
            child: Container(
                child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                      child: Column(children: [
                    const SizedBox(height: 10),

                    // const SizedBox(height: 10),
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    //       child: FutureBuilder(
                    //         future: _typeList,
                    //         builder: (_, snapshot) {
                    //           if (snapshot.connectionState == ConnectionState.waiting) {
                    //             return DropdownButtonFormField(
                    //               items: [],
                    //               onChanged: null,
                    //               decoration: InputDecoration(
                    //                 labelText: 'Chargement...',
                    //                 contentPadding: const EdgeInsets.symmetric(
                    //                     vertical: 10, horizontal: 20),
                    //                 border: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(8),
                    //                 ),
                    //               ),
                    //             );
                    //           }

                    //           if (snapshot.hasData) {
                    //             dynamic jsonString = utf8.decode(snapshot.data.bodyBytes);
                    //             dynamic responseData = json.decode(jsonString);
                    //             // dynamic responseData = json.decode(snapshot.data.body);
                    //             if (responseData is List) {
                    //               final reponse = responseData;
                    //               final vehiculeList = reponse
                    //                   .map((e) => TypeVoiture.fromMap(e))
                    //                   .where((con) => con.statutType == true)
                    //                   .toList();

                    //               if (vehiculeList.isEmpty) {
                    //                 return DropdownButtonFormField(
                    //                   items: [],
                    //                   onChanged: null,
                    //                   decoration: InputDecoration(
                    //                     labelText: '-- Aucun type de véhicule trouvé --',
                    //                     contentPadding: const EdgeInsets.symmetric(
                    //                         vertical: 10, horizontal: 20),
                    //                     border: OutlineInputBorder(
                    //                       borderRadius: BorderRadius.circular(8),
                    //                     ),
                    //                   ),
                    //                 );
                    //               }

                    //               return DropdownButtonFormField<String>(
                    //                 isExpanded: true,
                    //                 items: vehiculeList
                    //                     .map(
                    //                       (e) => DropdownMenuItem(
                    //                         value: e.idTypeVoiture,
                    //                         child: Text(e.nom!),
                    //                       ),
                    //                     )
                    //                     .toList(),
                    //                 hint: Text("-- Filtre par type de véhicule --"),
                    //                 value: typeValue,
                    //                 onChanged: (newValue) {
                    //                   setState(() {
                    //                     typeValue = newValue;
                    //                     if (newValue != null) {
                    //                       selectedType = vehiculeList.firstWhere(
                    //                         (element) => element.idTypeVoiture == newValue,
                    //                       );
                    //                     }
                    //                     page = 0;
                    //           hasMore = true;
                    //           fetchVehiculeByTypeVoitureWithPagination(selectedType!.idTypeVoiture!,refresh: true);
                    //             if (page == 0 && isLoading == true) {
                    //     SchedulerBinding.instance.addPostFrameCallback((_) {
                    // scrollableController1.jumpTo(0.0);
                    //     });
                    //   }
                    //                   });
                    //                 },
                    //                 decoration: InputDecoration(
                    //                   contentPadding: const EdgeInsets.symmetric(
                    //                       vertical: 10, horizontal: 20),
                    //                   border: OutlineInputBorder(
                    //                     borderRadius: BorderRadius.circular(8),
                    //                   ),
                    //                 ),
                    //               );
                    //             } else {
                    //               return DropdownButtonFormField(
                    //                 items: [],
                    //                 onChanged: null,
                    //                 decoration: InputDecoration(
                    //                   labelText: '-- Aucun type de véhicule trouvé --',
                    //                   contentPadding: const EdgeInsets.symmetric(
                    //                       vertical: 10, horizontal: 20),
                    //                   border: OutlineInputBorder(
                    //                     borderRadius: BorderRadius.circular(8),
                    //                   ),
                    //                 ),
                    //               );
                    //             }
                    //           }
                    //           return DropdownButtonFormField(
                    //             items: [],
                    //             onChanged: null,
                    //             decoration: InputDecoration(
                    //               labelText: '-- Aucun type de véhicule trouvé --',
                    //               contentPadding: const EdgeInsets.symmetric(
                    //                   vertical: 10, horizontal: 20),
                    //               border: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(8),
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     ),
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
                                    .map((e) => TypeVoiture.fromMap(e))
                                    .where((con) => con.statutType == true)
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
                  });
                  selectedType == null
                      ? setState(() {
                          vehiculeListeFuture = VehiculeService().fetchVehicule(
                              widget.detectedCountry != null
                                  ? widget.detectedCountry!
                                  : "Mali");
                        })
                      : setState(() {
                          vehiculeListeFuture1 = VehiculeService()
                              .fetchVehiculeByTypeVoitureWithPagination(
                                  selectedType!.idTypeVoiture!,
                                  widget.detectedCountry != null
                                      ? widget.detectedCountry!
                                      : "Mali");
                        });
                },
                child: selectedType == null
                    ? SingleChildScrollView(
                        controller: scrollableController,
                        child: Consumer<VehiculeService>(
                            builder: (context, vehiculeService, child) {
                          return FutureBuilder<List<Vehicule>>(
                              future: vehiculeListeFuture,
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
                                  vehiculeListe = snapshot.data!;
                                  String searchText = "";
                                  List<Vehicule> filtereSearch =
                                      vehiculeListe.where((search) {
                                    String libelle =
                                        search.nomVehicule.toLowerCase();
                                    searchText =
                                        _searchController.text.toLowerCase();
                                    return libelle.contains(searchText);
                                  }).toList();
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
                                                    'Aucune vehiucle de transport trouvé',
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
                                                              DetailTransport(
                                                                  vehicule:
                                                                      filtereSearch[
                                                                          index])));
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
                                                        child: SizedBox(
                                                          height: 85,
                                                          child: filtereSearch[
                                                                              index]
                                                                          .photoVehicule ==
                                                                      null ||
                                                                  filtereSearch[
                                                                          index]
                                                                      .photoVehicule!
                                                                      .isEmpty
                                                              ? Image.asset(
                                                                  "assets/images/default_image.png",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : CachedNetworkImage(
                                                                  imageUrl:
                                                                      "https://koumi.ml/api-koumi/vehicule/${filtereSearch[index].idVehicule}/image",
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
                                                          filtereSearch[index]
                                                              .nomVehicule,
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
                                                          "${filtereSearch[index].nbKilometrage.toString()} Km",
                                                          style: TextStyle(
                                                            fontSize: 15,
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
                                                          filtereSearch[index]
                                                              .localisation,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black87,
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
                      )
                    : SingleChildScrollView(
                        controller: scrollableController1,
                        child: Consumer<VehiculeService>(
                            builder: (context, vehiculeService, child) {
                          return FutureBuilder<List<Vehicule>>(
                              future: vehiculeListeFuture1,
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
                                  vehiculeListe = snapshot.data!;
                                  String searchText = "";
                                  List<Vehicule> filtereSearch =
                                      vehiculeListe.where((search) {
                                    String libelle =
                                        search.nomVehicule.toLowerCase();
                                    searchText =
                                        _searchController.text.toLowerCase();
                                    return libelle.contains(searchText);
                                  }).toList();
                                  return filtereSearch.isEmpty &&
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
                                                    'Aucune vehiucle de transport trouvé',
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
                                      : filtereSearch.isEmpty &&
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
                                              itemCount:
                                                  filtereSearch.length + 1,
                                              itemBuilder: (context, index) {
                                                if (index <
                                                    filtereSearch.length) {
                                                  var e = filtereSearch
                                                      .where((element) =>
                                                          element
                                                              .statutVehicule ==
                                                          true)
                                                      .elementAt(index);
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DetailTransport(
                                                                      vehicule:
                                                                          e)));
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
                                                              child: e.photoVehicule ==
                                                                          null ||
                                                                      e.photoVehicule!
                                                                          .isEmpty
                                                                  ? Image.asset(
                                                                      "assets/images/default_image.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : CachedNetworkImage(
                                                                      imageUrl:
                                                                          "https://koumi.ml/api-koumi/vehicule/${e.idVehicule}/image",
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
                                                              e.nomVehicule,
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
                                                              "${e.nbKilometrage.toString()} Km",
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
                                                              e.localisation,
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
                      ),
              ),
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

  DropdownButtonFormField<String> buildDropdown(List<TypeVoiture> typeList) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      items: typeList
          .map((e) => DropdownMenuItem(
                value: e.idTypeVoiture,
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
              (element) => element.idTypeVoiture == newValue,
            );
          }
          page = 0;
          hasMore = true;
          fetchVehiculeByTypeVoitureWithPagination(selectedType!.idTypeVoiture!,
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
        labelText: '-- Aucun type trouvé --',
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

/*
 stockListe
                            // .where((element) => element.statutSotck == true )
                            .isEmpty && isLoading == false
                                ? 
                                SingleChildScrollView(
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
                                  )
                                :  stockListe
                            // .where((element) => element.statutSotck == true )
                            .isEmpty && isLoading == true
                                ? _buildShimmerEffect() :
*/
