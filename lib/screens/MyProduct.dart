
 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/screens/AddAndUpdateProductScreen.dart';
import 'package:koumi_app/screens/DetailProduits.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  // Future <void> verify() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   email = prefs.getString('emailActeur');
  //   if (email != null) {
  //     // Si l'email de l'acteur est présent, exécute checkLoggedIn
  //     acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
  //     typeActeurData = acteur.typeActeur!;
  //     type = typeActeurData.map((data) => data.libelle).join(', ');
  //     setState(() {
  //       isExist = true;
  
  //     });
  //   } else {
  //     setState(() {
  //       isExist = false;
  //     });
  //   }
  // }


  Future <List<Stock>> getAllStocksByMagasinAndActeur() async{
      if(selectedCat != null && widget.id != null){
        stockListe = await StockService().fetchProduitByCategorieProduitMagAndActeur(selectedCat!.idCategorieProduit!, widget.id!,acteur.idActeur!);
      }else if(selectedCat != null){
        stockListe = await StockService().fetchProduitByCategorieAndActeur(selectedCat!.idCategorieProduit!, acteur.idActeur!);
      } else if(widget.id != null && selectedCat == null){
        stockListe = await StockService().fetchStockByMagasin(widget.id!);
      }
      else{
              stockListe = await  StockService().fetchStockByActeur(
                        acteur.idActeur!);
      }
      return stockListe;
              
   }

   void updateStockList() async {
  try {
  
    setState(() {
      stockListeFuture = getAllStocksByMagasinAndActeur();
    });
  } catch (error) {
    print('Erreur lors de la mise à jour de la liste de stocks: $error');
  }
}


  @override
  void initState() {
    super.initState();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    // typeActeurData = acteur.typeActeur!;
    // // selectedType == null;
    // type = typeActeurData.map((data) => data.libelle).join(', ');
    

    _searchController = TextEditingController();
    _catList =
        http.get(Uri.parse('http://koumi.ml/api-koumi/Categorie/allCategorie'));
        // http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Categorie/allCategorie'));
        verifyParam();
     updateStockList();
      stockListeFuture =  getAllStocksByMagasinAndActeur();
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Disposez le TextEditingController lorsque vous n'en avez plus besoin
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
            'Mes Produit',
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
          actions:  [
             IconButton(
                onPressed: () {
                  setState(() {
                    stockListeFuture = getAllStocksByMagasinAndActeur();
                  });
                },
                icon: Icon(Icons.refresh)),
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
                                    "Ajouter produit",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () async {
                                               Navigator.of(
                                                                            context)
                                                                        .pop();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddAndUpdateProductScreen(isEditable: false,)));
                                  },
                                ),
                              ),
                              
                              
                            ];
                          },
                        )
                     
                ]),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 10),
     
          // const SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          //   child: FutureBuilder(
          //     future: _catList,
          //     builder: (_, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return DropdownButtonFormField(
          //           items: [],
          //           onChanged: null,
          //           decoration: InputDecoration(
          //             labelText: 'En cours de chargement ',
          //             contentPadding: const EdgeInsets.symmetric(
          //                 vertical: 10, horizontal: 20),
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //           ),
          //         );
          //       }
          //       if (snapshot.hasError) {
          //         return Text("Une erreur s'est produite veuillez reessayer");
          //       }
          //       if (snapshot.hasData) {
          //         dynamic jsonString =
          //                       utf8.decode(snapshot.data.bodyBytes);
          //                   dynamic responseData = json.decode(jsonString);
          //         if (responseData is List) {
          //           final reponse = responseData;
          //           final categorieList = reponse
          //               .map((e) => CategorieProduit.fromMap(e))
          //               .where((con) => con.statutCategorie == true)
          //               .toList();

          //           if (categorieList.isEmpty) {
          //             return DropdownButtonFormField(
          //               items: [],
          //               onChanged: null,
          //               decoration: InputDecoration(
          //                 labelText: '-- Aucune categorie trouvé --',
          //                 contentPadding: const EdgeInsets.symmetric(
          //                     vertical: 10, horizontal: 20),
          //                 border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(8),
          //                 ),
          //               ),
          //             );
          //           }

          //           return DropdownButtonFormField<String>(
          //             items: categorieList
          //                 .map(
          //                   (e) => DropdownMenuItem(
          //                     value: e.idCategorieProduit,
          //                     child: Text(e.libelleCategorie!),
          //                   ),
          //                 )
          //                 .toList(),
          //             hint: Text("-- Filtre par categorie --"),
          //             value: typeValue,
          //             onChanged: (newValue) {
          //               setState(() {
          //                 typeValue = newValue;
          //                 if (newValue != null) {
          //                   selectedCat = categorieList.firstWhere(
          //                     (element) => element.idCategorieProduit == newValue,
          //                   );
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
          //               labelText: '-- Aucune categorie trouvé --',
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
          //           labelText: '-- Aucune categorie trouvé --',
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
      Consumer<StockService>(builder: (context, stockService, child) {
            return FutureBuilder<List<Stock>>(
                future: stockListeFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
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
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(250, 250, 250, 250),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        offset: Offset(0, 2),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Container(
                                          height: 90,
                                          child: filtereSearch[index].photo == null || filtereSearch[index].photo!.isEmpty  
                                              ? Image.asset(
                                                  "assets/images/default_image.png",
                                                  fit: BoxFit.cover,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl:
                                                      "https://koumi.ml/api-koumi/Stock/${filtereSearch[index].idStock}/image",
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
                                          filtereSearch[index].nomProduit!,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                          overflow: TextOverflow.ellipsis,
                                         "${filtereSearch[index].quantiteStock!.toString()} ${filtereSearch[index].unite!.nomUnite} ",
                                          style:TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      
                                      ),
                                           Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          para.monnaie != null
                                              ? 
                                              "${filtereSearch[index].prix.toString()} ${para.monnaie}"
                                              :
                                               "${filtereSearch[index].prix.toString()} FCFA",
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      //  _buildItem(
                                      //         "Localité :", filtereSearch[index].localiteMagasin!),
                                          //  _buildItem(
                                          //     "Acteur :", e.acteur!.typeActeur!.map((e) => e.libelle!).join(','))
                                           Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                                                                                        child: Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               children: [
                                                 _buildEtat(filtereSearch[index].statutSotck!),
                                                 SizedBox(width: 120,),
                                                 Expanded(
                                                   child: PopupMenuButton<String>(
                                                     padding: EdgeInsets.zero,
                                                     itemBuilder: (context) =>
                                                         <PopupMenuEntry<String>>[
                                                       PopupMenuItem<String>(
                                                         child: ListTile(
                                                           leading: filtereSearch[index].statutSotck == false ? Icon(
                                                             Icons.check,
                                                             color: Colors.green,
                                                           ): Icon(
                                                            Icons.disabled_visible,
                                                            color:Colors.orange[400]
                                                           ),
                                                           title:  Text(
                                                            filtereSearch[index].statutSotck == false ? "Activer" : "Desactiver",
                                                             style: TextStyle(
                                                               color: filtereSearch[index].statutSotck == false ? Colors.green : Colors.red,
                                                               fontWeight: FontWeight.bold,
                                                             ),
                                                           ),
                                                           
                                                           onTap: () async {
                                                                             // Changement d'état du magasin ici
                                                                      
                                                                          filtereSearch[index].statutSotck == false ?  await StockService().activerStock(filtereSearch[index].idStock!).then((value) => {
                                                                               // Mettre à jour la liste des magasins après le changement d'état
                                                                               Provider.of<StockService>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .applyChange(),
                                                                               setState(() {
                                       stockListeFuture =  StockService().fetchStockByActeur(acteur.idActeur!);
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
                                                                                   "Une erreur s'est produit"),
                                                                             ],
                                                                           ),
                                                                           duration:
                                                                               Duration(seconds: 5),
                                                                         ),
                                                                       ),
                                                                       Navigator.of(context).pop(),
                                                                     }): await StockService()
                                                                 .desactiverStock(filtereSearch[index].idStock!)
                                                                 .then((value) => {
                                                                    Provider.of<StockService>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .applyChange(),
                                                                   setState(() {
                                       stockListeFuture =  StockService().fetchStockByActeur(acteur.idActeur!);
                                                                               }),
                                                                       Navigator.of(context).pop(),
                                                                 
                                                                     });
                                                   
                                                             ScaffoldMessenger.of(context)
                                                                 .showSnackBar(
                                                                SnackBar(
                                                                 content: Row(
                                                                   children: [
                                                                     Text(filtereSearch[index].statutSotck == false ? "Activer avec succèss " : "Desactiver avec succèss"),
                                                                   ],
                                                                 ),
                                                                 duration: Duration(seconds: 2),
                                                               ),
                                                             );
                                                           },
                                                         )
                                                      
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
                                                                     .deleteStock(
                                                                         filtereSearch[index].idStock!)
                                                                     .then((value) => {
                                                                            Provider.of<StockService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .applyChange(),
                                                                          setState(() {
                                                                         stockListeFuture = StockService().fetchStockByActeur(acteur.idActeur!);
                                                                           }),
                                                                           Navigator.of(context).pop(),

                                                                           ScaffoldMessenger.of(context)
                                                                               .showSnackBar(
                                                                          
                                                                             const SnackBar(
                                                                               content: Row(
                                                                                 children: [
                                                                                   Text(
                                                                                       "Produit supprimer avec succès"),
                                                                                 ],
                                                                               ),
                                                                               duration:
                                                                                   Duration(seconds: 2),
                                                                             ),
                                                                           
                                                                           )
                                                                         })
                                                                     .catchError((onError) => {
                                                                           ScaffoldMessenger.of(context)
                                                                               .showSnackBar(
                                                                             const SnackBar(
                                                                               content: Row(
                                                                                 children: [
                                                                                   Text(
                                                                                       "Impossible de supprimer"),
                                                                                 ],
                                                                               ),
                                                                               duration:
                                                                                   Duration(seconds: 2),
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
                                ),
                              );
                            },
                          );
                  }
                });
          }),
      
      //   Consumer<StockService>(builder: (context, stockService, child) {
      //       return FutureBuilder<List<Stock>>(
      //           future: stockListeFuture,
      //           // selectedCat != null
      //           //     ? stockService.fetchProduitByCategorieAndActeur(
      //           //         selectedCat!.idCategorieProduit!, acteur.idActeur!)
      //           //     : stockService.fetchStockByActeur(acteur.idActeur!),
      //           builder: (context, snapshot) {
      //             if (snapshot.connectionState == ConnectionState.waiting) {
      //               return const Center(
      //                 child: CircularProgressIndicator(
      //                   color: Colors.orange,
      //                 ),
      //               );
      //             }

      //             if (!snapshot.hasData) {
      //               return 
      // SingleChildScrollView(
      //     child: Padding(
      //       padding: EdgeInsets.all(10),
      //       child: Center(
      //         child: Column(
      //           children: [
      //             Image.asset('assets/images/notif.jpg'),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Text(
      //               'Aucun produit trouvé' ,
      //               style: TextStyle(
      //                 color: Colors.black,
      //                 fontSize: 17,
      //                 overflow: TextOverflow.ellipsis,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   );
      //             } else {
      //               stockListe = snapshot.data!;
      //                if (stockListe.isEmpty) {
      // // Vous pouvez afficher une image ou un texte ici
      // return 
      // SingleChildScrollView(
      //     child: Padding(
      //       padding: EdgeInsets.all(10),
      //       child: Center(
      //         child: Column(
      //           children: [
      //             Image.asset('assets/images/notif.jpg'),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Text(
      //               'Aucun produit trouvé' ,
      //               style: TextStyle(
      //                 color: Colors.black,
      //                 fontSize: 17,
      //                 overflow: TextOverflow.ellipsis,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   );
      //    }
      //               String searchText = "";
      //               List<Stock> filtereSearch =
      //                   stockListe.where((search) {
      //                 String libelle = search.nomProduit!.toLowerCase();
      //                 searchText = _searchController.text.trim().toLowerCase();
      //                 return libelle.contains(searchText);
      //               }).toList();
      //               return Wrap(
      //                 // spacing: 10, // Espacement horizontal entre les conteneurs
      //                 // runSpacing:
      //                 //     10, // Espacement vertical entre les lignes de conteneurs
      //                 children: filtereSearch
      //                   //  .where((element) => element.statutSotck == true)
      //                     .map((e) => Padding(
      //                           padding: EdgeInsets.all(10),
      //                           child: SizedBox(
      //                             width:
      //                                 MediaQuery.of(context).size.width * 0.45,
      //                             child: GestureDetector(
      //                               onTap: () {
      //                                 Navigator.push(
      //                                     context,
      //                                     MaterialPageRoute(
      //                                         builder: (context) =>
      //                                             DetailProduits(
      //                                                 stock: e)));
      //                               },
      //                               child: Container(
      //                                 decoration: BoxDecoration(
      //                               color: Color.fromARGB(250, 250, 250, 250),
      //                               borderRadius: BorderRadius.circular(15),
      //                               boxShadow: [
      //                                 BoxShadow(
      //                                   color: Colors.grey.withOpacity(0.3),
      //                                   offset: Offset(0, 2),
      //                                   blurRadius: 8,
      //                                   spreadRadius: 2,
      //                                 ),
      //                               ],
      //                             ),
      //                                 child: Column(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment.stretch,
      //                                   children: [
      //                                     ClipRRect(
      //                                       borderRadius:
      //                                           BorderRadius.circular(8.0),
      //                                       child: SizedBox(
      //                                         height: 90,
      //                                         child: e.photo == null
      //                                             ? Image.asset(
      //                                                 "assets/images/default_image.png",
      //                                                 fit: BoxFit.cover,
      //                                               )
      //                                             : Image.network(
      //                                                 "https://koumi.ml/api-koumi/Stock/${e.idStock}/image",
      //                                                 fit: BoxFit.cover,
      //                                                 errorBuilder:
      //                                                     (BuildContext
      //                                                             context,
      //                                                         Object
      //                                                             exception,
      //                                                         StackTrace?
      //                                                             stackTrace) {
      //                                                   return Image.asset(
      //                                                     'assets/images/default_image.png',
      //                                                     fit: BoxFit.cover,
      //                                                   );
      //                                                 },
      //                                               ),
      //                                       ),
      //                                     ),
      //                                     Padding(
      //                                       padding: const EdgeInsets.symmetric(
      //                                           horizontal: 10, vertical: 5),
      //                                       child: Text(
      //                                         e.nomProduit!,
      //                                         style: TextStyle(
      //                                           fontSize: 18,
      //                                           fontWeight: FontWeight.bold,
      //                                           color: d_colorGreen,
      //                                         ),
      //                                       ),
      //                                     ),
      //                                     // _buildEtat(e.statutSotck!),
      //                                     _buildItem(
      //                                         "Prix :", e.prix!.toString()),
      //                                     SizedBox(height: 2),
      //                                       Container(
      //                                             alignment:
      //                                                       Alignment.bottomRight,
      //                                          child: Padding(
      //                                                                                       padding: const EdgeInsets.symmetric(horizontal:8.0),
      //                                                                                       child: Row(
      //                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                              children: [
      //                                                _buildEtat(e.statutSotck!),
      //                                                SizedBox(width: 120,),
      //                                                Expanded(
      //                                                  child: PopupMenuButton<String>(
      //                                                    padding: EdgeInsets.zero,
      //                                                    itemBuilder: (context) =>
      //                                                        <PopupMenuEntry<String>>[
      //                                                     PopupMenuItem<String>(
      //                                                        child: ListTile(
      //                                                          leading: e.statutSotck == false? Icon(
      //                                                            Icons.check,
      //                                                            color: Colors.green,
      //                                                          ): Icon(
      //                                                           Icons.disabled_visible,
      //                                                           color:Colors.orange[400]
      //                                                          ),
      //                                                          title:  Text(
      //                                                           e.statutSotck == false ? "Activer" : "Desactiver",
      //                                                            style: TextStyle(
      //                                                              color: e.statutSotck == false ? Colors.green : Colors.red,
      //                                                              fontWeight: FontWeight.bold,
      //                                                            ),
      //                                                          ),
                                                               
      //                                                          onTap: () async {
      //                             // Changement d'état du magasin ici
                           
      //                          e.statutSotck == false ?  await StockService().activerStock(e.idStock!).then((value) => {
      //                               // Mettre à jour la liste des stock après le changement d'état
      //                               Provider.of<StockService>(
      //                                                                       context,
      //                                                                       listen:
      //                                                                           false)
      //                                                                   .applyChange(),
      //                               setState(() {
      //                                  stockListeFuture =  StockService().fetchStockByActeur(acteur.idActeur!);
      //                               }),
      //                               Navigator.of(context).pop(),
      //                                                                    })
      //                                                                .catchError((onError) => {
      //                                                                      ScaffoldMessenger.of(context)
      //                                                                          .showSnackBar(
      //                                                                        const SnackBar(
      //                                                                          content: Row(
      //                                                                            children: [
      //                                                                              Text(
      //                                                                                  "Une erreur s'est produit"),
      //                                                                            ],
      //                                                                          ),
      //                                                                          duration:
      //                                                                              Duration(seconds: 5),
      //                                                                        ),
      //                                                                      ),
      //                                                                      Navigator.of(context).pop(),
      //                                                                    }): await StockService()
      //                                                                .desactiverStock(e.idStock!)
      //                                                                .then((value) => {
      //                                                                   Provider.of<StockService>(
      //                                                                       context,
      //                                                                       listen:
      //                                                                           false)
      //                                                                   .applyChange(),
      //                                                                           setState(() {
      //                                                  stockListeFuture =  StockService().fetchStockByActeur(acteur.idActeur!);
      //                                                  }),
      //                                                                      Navigator.of(context).pop(),
                                                                     
      //                                                                    });
                                                       
      //                                                            ScaffoldMessenger.of(context)
      //                                                                .showSnackBar(
      //                                                               SnackBar(
      //                                                                content: Row(
      //                                                                  children: [
      //                                                                    Text(e.statutSotck == false ? "Activer avec succèss " : "Desactiver avec succèss"),
      //                                                                  ],
      //                                                                ),
      //                                                                duration: Duration(seconds: 2),
      //                                                              ),
      //                                                            );
      //                                                          },
      //                                                        )
                                                          
      //                                          ),
                                                          
                                                          
      //                                                    ],
      //                                                  ),
      //                                                ),
      //                                              ],
      //                                                                                       ),
      //                                                                                     ),
      //                                            ),
      //                                   ],
      //                                 ),
      //                               ),
      //                             ),
      //                           ),
      //                         ))
      //                     .toList(),
      //               );
      //             }
      //           });
      //     }) 
      //    ,
        ]),
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



}