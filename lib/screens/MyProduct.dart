
 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/screens/AddAndUpdateProductScreen.dart';
import 'package:koumi_app/screens/DetailProduits.dart';
import 'package:koumi_app/service/BottomNavigationService.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
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
  List<ParametreGeneraux> paraList = [];
  late ParametreGeneraux para = ParametreGeneraux();
  late String type;
  late TextEditingController _searchController;
  List<Stock>  stockListe = [];
  CategorieProduit? selectedCat;
  String? typeValue;
  late Future _catList;
  bool isExist = false;
  String? email = "";
    late Future <List<Stock>> stockListeFuture;

    ScrollController scrollableController = ScrollController();

   int page = 0;
   bool isLoading = false;
   int size = 4;
   bool hasMore = true;


   

    Future<List<Stock>> fetchStockByActeur(String idActeur,{bool refresh = false}) async {
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
      final response = await http.get(Uri.parse('$apiOnlineUrl/Stock/getAllStocksByActeurWithPagination?idActeur=$idActeur&page=${page}&size=${size}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
           hasMore = false;
          });
        } else {
          setState(() {
           List<Stock> newIntrant = body.map((e) => Stock.fromMap(e)).toList();
          stockListe.addAll(newIntrant);
          });
        }

        debugPrint("response body all intrant by acteur with pagination ${page} par défilement soit ${stockListe.length}");
      } else {
        print('Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des stocks: $e');
    } finally {
      setState(() {
       isLoading = false;
      });
    }
    return stockListe;
  }
    Future<List<Stock>> fetchStockByMagasinAndActeur(String idMagasin,String idActeur,{bool refresh = false}) async {
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
      final response = await http.get(Uri.parse('$apiOnlineUrl/Stock/getAllStocksByMagasinAndActeurWithPagination?idMagasin=$idMagasin&idActeur=$idActeur&page=${page}&size=${size}'));

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

        debugPrint("response body all stock by acteur with pagination ${page} par défilement soit ${stockListe.length}");
      } else {
        print('Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des stocks: $e');
    } finally {
      setState(() {
       isLoading = false;
      });
    }
    return stockListe;
  }

   Future<List<Stock>> fetchAllStock() async{
    if(widget.id != null){
           stockListe = await fetchStockByMagasinAndActeur(widget.id!,acteur.idActeur!);
    }else{
      stockListe = await fetchStockByActeur(acteur.idActeur!);
    }
    return stockListe;
  }

   
      void verifyParam() {
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;

    if (paraList.isNotEmpty) {
      para = paraList[0];
    } else {
      // Gérer le cas où la liste est null ou vide, par exemple :
      // Afficher un message d'erreur, initialiser 'para' à une valeur par défaut, etc.
    }
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
        stockListeFuture =  fetchAllStock();
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
      !isLoading && widget.id == null) {
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
    
  }else if(scrollableController.position.pixels >=
          scrollableController.position.maxScrollExtent - 200 &&
      hasMore &&
      !isLoading && widget.id != null){
       debugPrint("yes - fetch stock by magasin and acteur");
      setState(() {
          // Rafraîchir les données ici
      page++;
        });
      fetchStockByMagasinAndActeur(widget.id!,acteur.idActeur!).then((value) {
        setState(() {
          // Rafraîchir les données ici
        });
      });
  }else{
    debugPrint("no");

  }
     }

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_){
    //write or call your logic
    //code will run when widget rendering complete
  scrollableController.addListener(_scrollListener);
  });
    verify();

    // acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
            // stockListeFuture =  fetchAllStock();
    // typeActeurData = acteur.typeActeur!;
    // // selectedType == null;
    // type = typeActeurData.map((data) => data.libelle).join(', ');

    _searchController = TextEditingController();
    _catList =
        http.get(Uri.parse('$apiOnlineUrl/Categorie/allCategorie'));
        // http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Categorie/allCategorie'));
        verifyParam();
  }

  @override
  void dispose() {
    _searchController
        .dispose(); 
        // Disposez le TextEditingController lorsque vous n'en avez plus besoin
        scrollableController.dispose();
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
            'Mes Produits',
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
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
      body: 
      
      !isExist ?
       Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/lock.png",
                  width: 100,
                  height: 100),
              SizedBox(height: 20),
              Text(
                "Vous devez vous connecter pour vos produits",
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
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0),
                  overlayColor: MaterialStateProperty.all<Color>(
                      Colors.grey.withOpacity(0.2)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
    :
      RefreshIndicator(
         onRefresh:() async{
                                setState(() {
                   page =0;
                  // Rafraîchir les données ici
            stockListeFuture =  StockService().fetchStock();
                });
                  debugPrint("refresh page ${page}");
                              },
        child: Container(
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              
             return  <Widget>
              [
                SliverToBoxAdapter(
                  child: Column(
                    children:[
        
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
                        size: 28), // Utiliser une icône de recherche plus grande
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
                    ]
                  )
                ),
            
            ];
            
            
          },
          body: 
              RefreshIndicator(
                onRefresh:() async{
                                setState(() {
                   page =0;
                  // Rafraîchir les données ici
            stockListeFuture =  StockService().fetchStock();
                });
                    debugPrint("refresh page ${page}");
                                },
                child: SingleChildScrollView(
                                    controller: scrollableController,

                  child: 
                        Consumer<StockService>(builder: (context, stockService, child) {
            return FutureBuilder<List<Stock>>(
                future: stockListeFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerEffect();
                  }

                      if (!snapshot.hasData) {
                    return 
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
                    'Aucun produit trouvé' ,
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

                      if(stockListe.isEmpty){   
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
                    'Aucun magasin trouvé' ,
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
                       String searchText = "";
                    List<Stock> filtereSearch =
                        stockListe.where((search) {
                      String libelle = search.nomProduit!.toLowerCase();
                      searchText = _searchController.text.trim().toLowerCase();
                      return libelle.contains(searchText);
                    }).toList();
                      if(filtereSearch.isEmpty && _searchController.text.isNotEmpty){   
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
                    'Aucun magasin trouvé' ,
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
         

                        
                
                    return filtereSearch.isEmpty
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
                        :
    GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: 
                            filtereSearch
                                .length ,
                            itemBuilder: (context, index) {
                              if(index < stockListe.length){
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailProduits(
                                        stock:filtereSearch[index]
                                      ),
                                    ),
                                  );
                                },
                                child:Card(
  margin: EdgeInsets.all(8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: SizedBox(
          height: 72,
          child: filtereSearch[index].photo == null ||
                  filtereSearch[index].photo!.isEmpty
              ? Image.asset(
                  "assets/images/default_image.png",
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl:
                      "https://koumi.ml/api-koumi/Stock/${filtereSearch[index].idStock}/image",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/default_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
      ListTile(
        title: Text(
          filtereSearch[index].nomProduit!,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          para.monnaie != null
              ? "${filtereSearch[index].prix.toString()} ${para.monnaie}"
              : "${filtereSearch[index].prix.toString()} FCFA",
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildEtat(filtereSearch[index].statutSotck!),
            SizedBox(width: 100),
            Expanded(
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    child: ListTile(
                      leading: filtereSearch[index].statutSotck == false
                          ? Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.disabled_visible,
                              color: Colors.orange[400],
                            ),
                      title: Text(
                        filtereSearch[index].statutSotck == false
                            ? "Activer"
                            : "Desactiver",
                        style: TextStyle(
                          color: filtereSearch[index].statutSotck == false
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        // Changement d'état du magasin ici
                        filtereSearch[index].statutSotck == false
                            ? await StockService()
                                .activerStock(filtereSearch[index].idStock!)
                                .then((value) => {
                                      Provider.of<StockService>(context,
                                              listen: false)
                                          .applyChange(),
                                      setState(() {
                                        page ++;
                                        stockListeFuture = StockService()
                                            .fetchStockByActeur(
                                                acteur.idActeur!);
                                      }),
                                      Navigator.of(context).pop(),
                                    })
                                .catchError((onError) => {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Row(
                                            children: [
                                              Text(
                                                  "Une erreur s'est produite"),
                                            ],
                                          ),
                                          duration: Duration(seconds: 5),
                                        ),
                                      ),
                                      Navigator.of(context).pop(),
                                    })
                            : await StockService()
                                .desactiverStock(
                                    filtereSearch[index].idStock!)
                                .then((value) => {
                                      Provider.of<StockService>(context,
                                              listen: false)
                                          .applyChange(),
                                      setState(() {
                                        page++;
                                        stockListeFuture = StockService()
                                            .fetchStockByActeur(
                                                acteur.idActeur!);
                                      }),
                                      Navigator.of(context).pop(),
                                    });

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: [
                              Text(filtereSearch[index].statutSotck == false
                                  ? "Activer avec succèss "
                                  : "Desactiver avec succèss"),
                            ],
                          ),
                          duration: Duration(seconds: 2),
                        ));
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
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        await StockService()
                            .deleteStock(filtereSearch[index].idStock!)
                            .then((value) => {
                                  Provider.of<StockService>(context,
                                          listen: false)
                                      .applyChange(),
                                  setState(() {
                                    page++;
                                    stockListeFuture = StockService()
                                        .fetchStockByActeur(acteur.idActeur!);
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
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
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
  )
                              );
                            }else{
                               return isLoading == true ? 
                                         Padding(
                                           padding: const EdgeInsets.symmetric(horizontal: 32),
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
                  
                ),
              ),
          ),
        ),
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

