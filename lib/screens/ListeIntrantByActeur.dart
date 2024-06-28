import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/DetailIntrant.dart';
import 'package:koumi_app/service/IntrantService.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ListeIntrantByActeur extends StatefulWidget {
  const ListeIntrantByActeur({super.key});

  @override
  State<ListeIntrantByActeur> createState() => _ListeIntrantByActeurState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _ListeIntrantByActeurState extends State<ListeIntrantByActeur> {
  late Acteur acteur;
  late TextEditingController _searchController;
  List<Intrant> intrantListe = [];
  late Future futureList;

  // List<ParametreGeneraux> paraList = [];
  // late ParametreGeneraux para = ParametreGeneraux();

  int page = 0;
  bool isLoading = false;
  int size = sized;
  bool hasMore = true;
  ScrollController scrollableController = ScrollController();

  bool isLoadingLibelle = true;

  Future<List<Intrant>> fetchIntrantByActeur(String idActeur,
      {bool refresh = false}) async {
    // if (_stockService.isLoading == true) return [];

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
          '$apiOnlineUrl/intrant/getAllIntrantsByActeurWithPagination?idActeur=$idActeur&page=${page}&size=${size}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          setState(() {
            List<Intrant> newIntrant =
                body.map((e) => Intrant.fromMap(e)).toList();
            intrantListe.addAll(newIntrant);
          });
        }

        debugPrint(
            "response body all intrant by acteur with pagination ${page} par défilement soit ${intrantListe.length}");
      } else {
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print(
          'Une erreur s\'est produite lors de la récupération des intrant: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return intrantListe;
  }

  void _scrollListener() {
    if (scrollableController.position.pixels >=
            scrollableController.position.maxScrollExtent - 200 &&
        hasMore &&
        !isLoading) {
      // if (selectedCat != null) {
      // Incrementez la page et récupérez les stocks par catégorie
      debugPrint("yes - fetch intrant by acteur");
      setState(() {
        // Rafraîchir les données ici
        page++;
      });
      fetchIntrantByActeur(acteur.idActeur!).then((value) {
        setState(() {
          // Rafraîchir les données ici
        });
      });
    } else {
      debugPrint("no");
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    futureList = fetchIntrantByActeur(acteur.idActeur!);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollableController.addListener(_scrollListener);
    });
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
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text(
          "Mes intrants",
          style: TextStyle(
            color: d_colorGreen,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                  child: Column(children: [
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
                            color: Colors.blueGrey[400],
                            size:
                                28), // Utiliser une icône de recherche plus grande
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
                              hintStyle: TextStyle(color: Colors.blueGrey[400]),
                            ),
                          ),
                        ),
                        // Ajouter un bouton de réinitialisation pour effacer le texte de recherche
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
                const SizedBox(height: 10),
              ])),
            ];
          },
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                hasMore = true;
                page = 0;
                // Rafraîchir les données ici
                futureList = IntrantService()
                    .fetchIntrantByActeurWithPagination(acteur.idActeur!,
                        refresh: true);
              });
              debugPrint("refresh page ${page}");
            },
            child: SingleChildScrollView(
                controller: scrollableController,
                child: Consumer<IntrantService>(
                    builder: (context, intrantService, child) {
                  return FutureBuilder(
                      future: futureList,
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
                                    Image.asset('assets/images/notif.jpg'),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Aucun intrant trouvé',
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
                          intrantListe = snapshot.data!;
                          String searchText = "";
                          List<Intrant> filtereSearch =
                              intrantListe.where((search) {
                            String libelle = search.nomIntrant!.toLowerCase();
                            searchText = _searchController.text.toLowerCase();
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
                                            'Aucun intrant trouvé',
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
                                  itemCount: filtereSearch.length + 1,
                                  itemBuilder: (context, index) {
                                    // var e = intrantListe.elementAt(index);
                                    if (index < filtereSearch.length) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailIntrant(
                                                intrant: filtereSearch[index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          margin: EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: SizedBox(
                                                  height: 72,
                                                  child: filtereSearch[index]
                                                                  .photoIntrant ==
                                                              null ||
                                                          filtereSearch[index]
                                                              .photoIntrant!
                                                              .isEmpty
                                                      ? Image.asset(
                                                          "assets/images/default_image.png",
                                                          fit: BoxFit.cover,
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              "https://koumi.ml/api-koumi/intrant/${filtereSearch[index].idIntrant}/image",
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            'assets/images/default_image.png',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              ListTile(
                                                title: Text(
                                                  filtereSearch[index]
                                                      .nomIntrant!,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text(
                                                  "${filtereSearch[index].prixIntrant.toString()} ${filtereSearch[index].monnaie!.libelle}",
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 15,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    _buildEtat(
                                                        filtereSearch[index]
                                                            .statutIntrant!),
                                                    PopupMenuButton<String>(
                                                      padding: EdgeInsets.zero,
                                                      itemBuilder: (context) =>
                                                          <PopupMenuEntry<
                                                              String>>[
                                                        PopupMenuItem<String>(
                                                          child: ListTile(
                                                            leading: filtereSearch[
                                                                            index]
                                                                        .statutIntrant ==
                                                                    false
                                                                ? Icon(
                                                                    Icons.check,
                                                                    color: Colors
                                                                        .green,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .disabled_visible,
                                                                    color: Colors
                                                                            .orange[
                                                                        400],
                                                                  ),
                                                            title: Text(
                                                              filtereSearch[index]
                                                                          .statutIntrant ==
                                                                      false
                                                                  ? "Activer"
                                                                  : "Desactiver",
                                                              style: TextStyle(
                                                                color: filtereSearch[index]
                                                                            .statutIntrant ==
                                                                        false
                                                                    ? Colors
                                                                        .green
                                                                    : Colors.orange[
                                                                        400],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              filtereSearch[index]
                                                                          .statutIntrant ==
                                                                      false
                                                                  ? await IntrantService()
                                                                      .activerIntrant(
                                                                          filtereSearch[index]
                                                                              .idIntrant!)
                                                                      .then(
                                                                          (value) =>
                                                                              {
                                                                                Navigator.of(context).pop(),
                                                                                Provider.of<IntrantService>(context, listen: false).applyChange(),
                                                                                setState(() {
                                                                                  page++;
                                                                                  futureList = IntrantService().fetchIntrantByActeurWithPagination(acteur.idActeur!);
                                                                                }),
                                                                                // Navigator.of(context).pop(),
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  const SnackBar(
                                                                                    content: Row(
                                                                                      children: [
                                                                                        Text("Activer avec succèss "),
                                                                                      ],
                                                                                    ),
                                                                                    duration: Duration(seconds: 2),
                                                                                  ),
                                                                                )
                                                                              })
                                                                      .catchError(
                                                                          (onError) =>
                                                                              {
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  const SnackBar(
                                                                                    content: Row(
                                                                                      children: [
                                                                                        Text("Une erreur s'est produit"),
                                                                                      ],
                                                                                    ),
                                                                                    duration: Duration(seconds: 5),
                                                                                  ),
                                                                                ),
                                                                              })
                                                                  : await IntrantService()
                                                                      .desactiverIntrant(
                                                                          filtereSearch[index]
                                                                              .idIntrant!)
                                                                      .then(
                                                                          (value) =>
                                                                              {
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  const SnackBar(
                                                                                    content: Row(
                                                                                      children: [
                                                                                        Text("Désactiver avec succèss "),
                                                                                      ],
                                                                                    ),
                                                                                    duration: Duration(seconds: 2),
                                                                                  ),
                                                                                ),
                                                                                Navigator.of(context).pop(),
                                                                                Provider.of<IntrantService>(context, listen: false).applyChange(),
                                                                                setState(() {
                                                                                  page++;
                                                                                  futureList = IntrantService().fetchIntrantByActeurWithPagination(acteur.idActeur!);
                                                                                }),
                                                                              })
                                                                      .catchError(
                                                                          (onError) =>
                                                                              {
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  const SnackBar(
                                                                                    content: Row(
                                                                                      children: [
                                                                                        Text("Une erreur s'est produit"),
                                                                                      ],
                                                                                    ),
                                                                                    duration: Duration(seconds: 5),
                                                                                  ),
                                                                                ),
                                                                                // Navigator.of(context).pop(),
                                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        PopupMenuItem<String>(
                                                          child: ListTile(
                                                            leading: const Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                            title: const Text(
                                                              "Supprimer",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              await IntrantService()
                                                                  .deleteIntrant(
                                                                      filtereSearch[index]
                                                                          .idIntrant!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Navigator.of(context).pop(),
                                                                            Provider.of<IntrantService>(context, listen: false).applyChange(),
                                                                            setState(() {
                                                                              page++;
                                                                              futureList = IntrantService().fetchIntrantByActeurWithPagination(acteur.idActeur!);
                                                                            }),
                                                                          })
                                                                  .catchError(
                                                                      (onError) =>
                                                                          {
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
                                                  ],
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
                                                  const EdgeInsets.symmetric(
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
                })),
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

  Widget _buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
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
}
