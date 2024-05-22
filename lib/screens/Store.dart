import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddMagasinScreen.dart';
import 'package:koumi_app/screens/MyProduct.dart';
import 'package:koumi_app/screens/MyStores.dart';
import 'package:koumi_app/screens/Product.dart';
import 'package:koumi_app/screens/Products.dart';
import 'package:koumi_app/screens/ProductsByStores.dart';
import 'package:koumi_app/screens/ProduitActeur.dart';
import 'package:koumi_app/service/MagasinService.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _StoreScreenState extends State<StoreScreen> {
  late Acteur acteur = Acteur();
  late List<TypeActeur> typeActeurData = [];
  late String type;
  List<Magasin> magasinListe = [];
  late Future<List<Magasin>> magasinListeFuture;
  late Future<List<Magasin>> magasinListeFuture1;
  Niveau1Pays? selectedNiveau1Pays;
  String? typeValue;
  late Future _niveau1PaysList;
  bool isExist = false;
  String? email = "";

   ScrollController scrollableController = ScrollController();
  ScrollController scrollableController1 = ScrollController();

  int page = 0;
   bool isLoading = false;
   int size = 4;
  bool hasMore = true;

   Future<List<Magasin>> getAllMagasins() async {
      if(selectedNiveau1Pays != null){

      magasinListe = await MagasinService().fetchMagasinByNiveau1PaysWithPagination(selectedNiveau1Pays!.idNiveau1Pays!);
      }
      else{

      magasinListe = await MagasinService().fetchAllMagasin();
      }
    
    return magasinListe;
  }

 Future<List<Magasin>> fetchMagasin({bool refresh = false}) async {
    if (isLoading == true) return [];
   
    setState(() {
     isLoading = true;
    });

      if(mounted)
    if (refresh) {
      setState(() {
        magasinListe.clear();
       page = 0;
        hasMore = true;
      });
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Magasin/getAllMagasinWithPagination?page=${page}&size=${size}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
           hasMore = false;
          });
        } else {
          setState(() {
          List<Magasin> newMagasins = body.map((e) => Magasin.fromMap(e)).toList();
          magasinListe.addAll(newMagasins);
          });
        }

        debugPrint("response body all magasins with pagination ${page} par défilement soit ${magasinListe.length}");
       return magasinListe;
      } else {
        print('Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
        return [];
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des magasins: $e');
    } finally {
      setState(() {
       isLoading = false;
      });
    }
    return magasinListe;
  }



  Future<List<Magasin>> fetchMagasinByCategorie({bool refresh = false}) async {
    if (isLoading == true) return [];

    setState(() {
      isLoading = true;
    });

    if (refresh) {
      setState(() {
        magasinListe.clear();
       page = 0;
        hasMore = true;
      });
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/Magasin/getAllMagasinByNiveau1PaysWithPagination?idNiveau1Pays=${selectedNiveau1Pays!.idNiveau1Pays}&page=$page&size=$size'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
           hasMore = false;
          });
        } else {
          setState(() {
           List<Magasin> newMagasins = body.map((e) => Magasin.fromMap(e)).toList();
          magasinListe.addAll(newMagasins);
          });
        }

        debugPrint("response body all magasins  by niveau 1 pays with pagination ${page} par défilement soit ${magasinListe.length}");
      } else {
        print('Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des magasins: $e');
    } finally {
      setState(() {
       isLoading = false;
      });
    }
    return magasinListe;
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

    void _scrollListener() {
  
    if(scrollableController.position.pixels >=
          scrollableController.position.maxScrollExtent - 200 &&
      hasMore &&
      !isLoading && selectedNiveau1Pays == null){
      setState(() {
          // Rafraîchir les données ici
        page++;
        });
      debugPrint("yes - fetch all magasin");
      fetchMagasin().then((value) {
        setState(() {
          // Rafraîchir les données ici
          debugPrint("page inc all ${page}");
        });
      });
 
  }
    debugPrint("no");

}
   void _scrollListener1() {
  if ( scrollableController1.position.pixels >=
          scrollableController1.position.maxScrollExtent - 200 &&
      hasMore &&
      !isLoading && selectedNiveau1Pays != null) {
      debugPrint("yes - fetch by category");
      setState(() {
          // Rafraîchir les données ici
      page++;
        });
   
    fetchMagasinByCategorie().then((value) {
        setState(() {
          // Rafraîchir les données ici
          debugPrint("page inc all ${page}");
        });
      });
    } 
    debugPrint("no");

}

 

  @override
  void initState() {
    // acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    // typeActeurData = acteur.typeActeur!;
    // // selectedType == null;
    // type = typeActeurData.map((data) => data.libelle).join(', ');
    super.initState();
    verify();
    // magasinListeFuture = getAllMagasin();

    _niveau1PaysList =
        http.get(Uri.parse('$apiOnlineUrl/niveau1Pays/read'));
        // http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read'));
    magasinListeFuture = magasinListeFuture1 = getAllMagasins();
   WidgetsBinding.instance.addPostFrameCallback((_){
    //write or call your logic
    //code will run when widget rendering complete
  scrollableController.addListener(_scrollListener);
  });
  WidgetsBinding.instance.addPostFrameCallback((_){
    //write or call your logic
    //code will run when widget rendering complete
  scrollableController1.addListener(_scrollListener1);
  });
  }

  @override
  void dispose() {
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
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
            title: Text(
              'Tous les boutiques',
              style: const TextStyle(
                  color: d_colorGreen, fontWeight: FontWeight.bold),
            ),
            actions: !isExist
                ? null
                :                [
                  
          (typeActeurData
          .map((e) => e.libelle!.toLowerCase())
          .contains("commercant") ||
      typeActeurData
          .map((e) => e.libelle!.toLowerCase())
          .contains("admin") ||
      typeActeurData
          .map((e) => e.libelle!.toLowerCase())
          .contains("commerçant") ||
      typeActeurData
          .map((e) => e.libelle!.toLowerCase())
          .contains("producteur")) ?
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
                    "Ajouter magasin",
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
                        builder: (context) => AddMagasinScreen(
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
                    "Mes boutiques",
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
                        builder: (context) => MyStoresScreen(),
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
                    "Mes boutiques",
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
                        builder: (context) => MyStoresScreen(),
                      ),
                    );
                  },
                ),
              ),
            ];
          },
        ),   
                  ] ,),
        body: Container(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            
           return  <Widget>
            [
              SliverToBoxAdapter(
                child: Column(
                  children:[
      
            const SizedBox(height: 10),
          
           Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: FutureBuilder(
              future: _niveau1PaysList,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return DropdownButtonFormField(
                    items: [],
                    onChanged: null,
                    decoration: InputDecoration(
                      labelText: 'En cours de chargement ...',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text("Une erreur s'est produite veuillez reessayer");
                }
                if (snapshot.hasData) {
                  dynamic jsonString = utf8.decode(snapshot.data.bodyBytes);
                  dynamic responseData = json.decode(jsonString);
                  if (responseData is List) {
                    final reponse = responseData;
                    final niveau1PaysList = reponse
                        .map((e) => Niveau1Pays.fromMap(e))
                        .where((con) => con.statutN1 == true)
                        .toList();

                    if (niveau1PaysList.isEmpty) {
                      return DropdownButtonFormField(
                        items: [],
                        onChanged: null,
                        decoration: InputDecoration(
                          labelText: '-- Aucune region trouvé --',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }

                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      items: niveau1PaysList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.idNiveau1Pays,
                              child: Text(e.nomN1!),
                            ),
                          )
                          .toList(),
                      hint: Text("-- Filtre par region --"),
                      value: typeValue,
                      onChanged: (newValue) {
                        setState(() {
                          typeValue = newValue;
                          if (newValue != null) {
                            selectedNiveau1Pays = niveau1PaysList.firstWhere(
                              (element) => element.idNiveau1Pays == newValue,
                            );
                          }
                                                page = 0;
                hasMore = true;
                fetchMagasinByCategorie(refresh: true);
                  if (page == 0 && isLoading == true) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollableController1.jumpTo(0.0);
    });
  }
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  } else {
                    return DropdownButtonFormField(
                      items: [],
                      onChanged: null,
                      decoration: InputDecoration(
                        labelText: '-- Aucune region trouvé --',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                }
                return  DropdownButtonFormField(
                                    items: [],
                                    onChanged: null,
                                    decoration: InputDecoration(
                                      labelText: 'Probleme de connexion',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
              },
            ),
          ),
            const SizedBox(height: 10),
                  ]
                )
              ),
          
          ];
          
          
        },
        body: 
            RefreshIndicator(
              onRefresh:() async{
                                setState(() {
                   page=0;
                  // Rafraîchir les données ici
                });
                  debugPrint("refresh page ${page}");
                selectedNiveau1Pays != null ?
                setState(() {
                  magasinListeFuture1 = MagasinService().fetchMagasinByNiveau1PaysWithPagination(selectedNiveau1Pays!.idNiveau1Pays!);
                }) :
                setState(() {
                  magasinListeFuture = MagasinService().fetchAllMagasin();
                });
                              },
              child: selectedNiveau1Pays == null ?
               SingleChildScrollView(
                controller: scrollableController,
                 child: Consumer<MagasinService>(builder: (context, magasinService, child) {
                             return FutureBuilder<List<Magasin>>(
                  future:
                      magasinListeFuture,
                      
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildShimmerEffect();
                    }
                 
                    if (!snapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(child: Text("Aucun donné trouvé")),
                      );
                    } else {
                      magasinListe = snapshot.data!;
                      // Vous pouvez afficher une image ou un texte ici
                   
                 
                      String searchText = "";
                     
                      return magasinListe
                      // .where((element) => element.statutMagasin == true)
                      .isEmpty 
                          ? SingleChildScrollView(
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
                                        'Aucun magasin trouvé',
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
                          :
                       GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: magasinListe.length +1,
                        // isExist == true ? typeActeurData
                        //         .map((e) => e.libelle!.toLowerCase())
                        //         .contains("admin")
                        //     ? magasinListe.length+1
                        //     : magasinListe
                        //         .where((element) => element.statutMagasin == true && element.acteur?.statutActeur == true)
                        //         .length +1 : magasinListe
                        //         .where((element) => element.statutMagasin == true && element.acteur?.statutActeur == true)
                        //         .length +1,
                        itemBuilder: (context, index) {
                          if(index < magasinListe.length){
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductsByStoresScreen(
                                    
                                      id: magasinListe[index].idMagasin,
                                      nom: magasinListe[index].nomMagasin),
                                ),
                              );
                            },
                            child: Card(
                              margin: EdgeInsets.all(8),
                             
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      height: 72,
                                      child: magasinListe[index].photo == null || magasinListe[index].photo!.isEmpty
                                          ? Image.asset(
                                              "assets/images/default_image.png",
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                                    imageUrl:
                                                        "https://koumi.ml/api-koumi/Magasin/${magasinListe[index].idMagasin}/image",
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
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
                                      magasinListe[index].nomMagasin!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      overflow: TextOverflow.ellipsis,
                                      magasinListe[index].localiteMagasin!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  //  _buildItem(
                                  //         "Localité :", filtereSearch[index].localiteMagasin!),
                                  // typeActeurData
                                  //         .map((e) => e.libelle!.toLowerCase())
                                  //         .contains("admin")
                                  //     ?
                                  //     //  _buildItem(
                                  //     //     "Acteur :", e.acteur!.typeActeur!.map((e) => e.libelle!).join(','))
                                  //     Padding(
                                  //         padding: const EdgeInsets.symmetric(
                                  //             horizontal: 8.0),
                                  //         child: Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceBetween,
                                  //           children: [
                                  //             _buildEtat(magasinListe[index]
                                  //                 .statutMagasin!),
                                  //             SizedBox(
                                  //               width: 110,
                                  //             ),
                                  //             Expanded(
                                  //               child: PopupMenuButton<String>(
                                  //                 padding: EdgeInsets.zero,
                                  //                 itemBuilder: (context) =>
                                  //                     <PopupMenuEntry<String>>[
                                  //                   PopupMenuItem<String>(
                                  //                       child: ListTile(
                                  //                     leading: magasinListe[
                                  //                                     index]
                                  //                                 .statutMagasin ==
                                  //                             false
                                  //                         ? Icon(
                                  //                             Icons.check,
                                  //                             color: Colors.green,
                                  //                           )
                                  //                         : Icon(
                                  //                             Icons
                                  //                                 .disabled_visible,
                                  //                             color: Colors
                                  //                                 .orange[400]),
                                  //                     title: Text(
                                  //                       magasinListe[index]
                                  //                                   .statutMagasin ==
                                  //                               false
                                  //                           ? "Activer"
                                  //                           : "Desactiver",
                                  //                       style: TextStyle(
                                  //                         color: magasinListe[
                                  //                                         index]
                                  //                                     .statutMagasin ==
                                  //                                 false
                                  //                             ? Colors.green
                                  //                             : Colors.red,
                                  //                         fontWeight:
                                  //                             FontWeight.bold,
                                  //                       ),
                                  //                     ),
                                  //                     onTap: () async {
                                  //                       // Changement d'état du magasin ici
                 
                                  //                       magasinListe[index]
                                  //                                   .statutMagasin ==
                                  //                               false
                                  //                           ? await MagasinService()
                                  //                               .activerMagasin(
                                  //                                   magasinListe[
                                  //                                           index]
                                  //                                       .idMagasin!)
                                  //                               .then((value) => {
                                  //                                     // Mettre à jour la liste des magasins après le changement d'état
                                  //                                     Provider.of<MagasinService>(
                                  //                                             context,
                                  //                                             listen:
                                  //                                                 false)
                                  //                                         .applyChange(),
                                  //                                     setState(
                                  //                                         () {
                                  //                                       magasinListeFuture =
                                  //                                           MagasinService()
                                  //                                               .fetchAllMagasin();
                                  //                                     }),
                                  //                                     Navigator.of(
                                  //                                             context)
                                  //                                         .pop(),
                                  //                                   })
                                  //                               .catchError(
                                  //                                   (onError) => {
                                  //                                         ScaffoldMessenger.of(context)
                                  //                                             .showSnackBar(
                                  //                                           const SnackBar(
                                  //                                             content:
                                  //                                                 Row(
                                  //                                               children: [
                                  //                                                 Text("Une erreur s'est produit"),
                                  //                                               ],
                                  //                                             ),
                                  //                                             duration:
                                  //                                                 Duration(seconds: 5),
                                  //                                           ),
                                  //                                         ),
                                  //                                         Navigator.of(context)
                                  //                                             .pop(),
                                  //                                       })
                                  //                           : await MagasinService()
                                  //                               .desactiverMagasin(
                                  //                                   magasinListe[
                                  //                                           index]
                                  //                                       .idMagasin!)
                                  //                               .then((value) => {
                                  //                                     Provider.of<MagasinService>(
                                  //                                             context,
                                  //                                             listen:
                                  //                                                 false)
                                  //                                         .applyChange(),
                                  //                                     setState(
                                  //                                         () {
                                  //                                       magasinListeFuture =
                                  //                                           MagasinService()
                                  //                                               .fetchAllMagasin();
                                  //                                     }),
                                  //                                     Navigator.of(
                                  //                                             context)
                                  //                                         .pop(),
                                  //                                   });
                 
                                  //                       ScaffoldMessenger.of(
                                  //                               context)
                                  //                           .showSnackBar(
                                  //                         SnackBar(
                                  //                           content: Row(
                                  //                             children: [
                                  //                               Text(magasinListe[
                                  //                                               index]
                                  //                                           .statutMagasin ==
                                  //                                       false
                                  //                                   ? "Activer avec succèss "
                                  //                                   : "Desactiver avec succèss"),
                                  //                             ],
                                  //                           ),
                                  //                           duration: Duration(
                                  //                               seconds: 2),
                                  //                         ),
                                  //                       );
                                  //                     },
                                  //                   )),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       )
                                  //     : SizedBox(),
                                ],
                              ),
                            ),
                          );
                           }else{
                                                return isLoading == true ? 
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 32),
                                          child: Center(
                                            child:
                                            const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.orange,
                                ),
                                                              )
                                          ),
                                        ) : Container();
                                              }
                        },
                      );
                    }
                  });
                           }),
               ) :
            SingleChildScrollView(
              controller: scrollableController1,
              child: Consumer<MagasinService>(builder: (context, magasinService, child) {
              return FutureBuilder<List<Magasin>>(
                  future:
                      magasinListeFuture1,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return  _buildShimmerEffect();
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
                                        'Aucun magasin trouvé',
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
                      magasinListe = snapshot.data!;
                      // Vous pouvez afficher une image ou un texte ici
                   
              
                      String searchText = "";
                      
                      return magasinListe
                      // .where((element) => element.statutMagasin == true)
                      .isEmpty && isLoading == false
                          ? SingleChildScrollView(
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
                                        'Aucun magasin trouvé',
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
                          :  magasinListe.isEmpty && isLoading == true ?
                          _buildShimmerEffect() :
                       GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: magasinListe.length +1,
                        // isExist == true ? typeActeurData
                        //         .map((e) => e.libelle!.toLowerCase())
                        //         .contains("admin")
                        //     ? magasinListe.length
                        //     : magasinListe
                        //         .where((element) => element.statutMagasin == true && element.acteur?.statutActeur == true)
                        //         .length : magasinListe
                        //         .where((element) => element.statutMagasin == true && element.acteur?.statutActeur == true)
                        //         .length,
                        itemBuilder: (context, index) {
                        if(index < magasinListe.length){
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductsByStoresScreen(
                                    
                                      id: magasinListe[index].idMagasin,
                                      nom: magasinListe[index].nomMagasin),
                                ),
                              );
                            },
                            child: Card(
                              margin: EdgeInsets.all(8),
                             
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      height: 72,
                                      child: magasinListe[index].photo == null || magasinListe[index].photo!.isEmpty
                                          ? Image.asset(
                                              "assets/images/default_image.png",
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                                    imageUrl:
                                                        "https://koumi.ml/api-koumi/Magasin/${magasinListe[index].idMagasin}/image",
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
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
                                      magasinListe[index].nomMagasin!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      overflow: TextOverflow.ellipsis,
                                      magasinListe[index].localiteMagasin!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  //  _buildItem(
                                  //         "Localité :", filtereSearch[index].localiteMagasin!),
                                  
                                ],
                              ),
                            ),
                          );
                           }else{
                                                return isLoading == true ? 
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 32),
                                          child: Center(
                                            child:
                                            const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.orange,
                                ),
                                                              )
                                          ),
                                        ) : Container();
                                              }
                        },
                      );
                    }
                  });
                        }),
            ))))
        );
  }


   Widget _buildShimmerEffect(){
  return   Center(
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

  // Widget _buildItem(String title, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Expanded(
  //           child: Text(
  //             title,
  //             style: const TextStyle(
  //                 color: Colors.black87,
  //                 fontWeight: FontWeight.w800,
  //                 fontStyle: FontStyle.italic,
  //                 overflow: TextOverflow.ellipsis,
  //                 fontSize: 16),
  //           ),
  //         ),
  //         Expanded(
  //           child: Text(
  //             value,
  //             style: const TextStyle(
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.w800,
  //                 overflow: TextOverflow.ellipsis,
  //                 fontSize: 16),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

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
}
