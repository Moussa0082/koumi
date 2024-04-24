import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/CartProvider.dart';
import 'package:koumi_app/screens/AddAndUpdateProductScreen.dart';
import 'package:koumi_app/screens/DetailProduits.dart';
import 'package:koumi_app/screens/MyProduct.dart';
import 'package:koumi_app/screens/MyStores.dart';
import 'package:koumi_app/screens/ProduitActeur.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:koumi_app/widgets/SnackBar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductScreen extends StatefulWidget {
  String? id, nom;
   ProductScreen({super.key, this.id, this.nom});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}
 
  const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _ProductScreenState extends State<ProductScreen> {
  

   late Acteur acteur = Acteur();
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late TextEditingController _searchController;
  List<Stock>  stockListe = [];
  late Future <List<Stock>> stockListeFuture;
  CategorieProduit? selectedCat;
  String? typeValue;
  late Future _catList;
  bool isExist = false;
  String? email = "";

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

   Future <List<Stock>> getAllStock() async{
      if(selectedCat != null){
              stockListe = await  StockService().fetchProduitByCategorie(
                        selectedCat!.idCategorieProduit!);
      } if(widget.id != null){
              stockListe = await StockService().fetchStockByMagasin(widget.id!);
      }else if(selectedCat?.idCategorieProduit != null && widget.id != null){
              stockListe = await  StockService().fetchProduitByCategorieAndMagasin(
                        selectedCat!.idCategorieProduit!, widget.id!);
      }
      else{
              stockListe = await StockService().fetchStock();
      }
      return stockListe;
   }

   

  @override
  void initState() {
    // acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    // typeActeurData = acteur.typeActeur!;
    // // selectedType == null;
    // type = typeActeurData.map((data) => data.libelle).join(', ');
    verify();
    _searchController = TextEditingController();
    _catList =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Categorie/allCategorie'));
    super.initState();
    stockListeFuture = getAllStock();
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
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
          title: Text(
            'Tous les Produit',
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
                              // PopupMenuItem<String>(
                              //   child: ListTile(
                              //     leading: const Icon(
                              //       Icons.remove_red_eye,
                              //       color: Colors.green,
                              //     ),
                              //     title: const Text(
                              //       "Ajouter produit",
                              //       style: TextStyle(
                              //         color: Colors.green,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //     onTap: () async {
                              //       Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   AddAndUpdateProductScreen(isEditable: false,)));
                              //     },
                              //   ),
                              // ),
                              PopupMenuItem<String>(
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.green,
                                  ),
                                  title: const Text(
                                    "Mes proudits",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyProductScreen()));
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: FutureBuilder(
              future: _catList,
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
                  dynamic responseData = json.decode(snapshot.data.body);
                  if (responseData is List) {
                    final reponse = responseData;
                    final categorieList = reponse
                        .map((e) => CategorieProduit.fromMap(e))
                        .where((con) => con.statutCategorie == true)
                        .toList();

                    if (categorieList.isEmpty) {
                      return DropdownButtonFormField(
                        items: [],
                        onChanged: null,
                        decoration: InputDecoration(
                          labelText: '-- Aucune categorie trouvé --',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }

                    return DropdownButtonFormField<String>(
                      items: categorieList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.idCategorieProduit,
                              child: Text(e.libelleCategorie!),
                            ),
                          )
                          .toList(),
                      hint: Text("-- Filtre par categorie --"),
                      value: typeValue,
                      onChanged: (newValue) {
                        setState(() {
                          typeValue = newValue;
                          // if (newValue != null) {
                          //   selectedCat = categorieList.firstWhere(
                          //     (element) => element.idCategorieProduit == newValue,
                          //   );
                          // }
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
                        labelText: '-- Aucune categorie trouvé --',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                }
                return DropdownButtonFormField(
                  items: [],
                  onChanged: null,
                  decoration: InputDecoration(
                    labelText: '-- Aucune categorie trouvé --',
                    contentPadding: const EdgeInsets.symmetric(
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
         
          Consumer<StockService>(builder: (context, stockService, child) {
            return FutureBuilder<List<Stock>>(
                future: stockListeFuture,
                // selectedCat != null
                //     ? stockService.fetchProduitByCategorie(
                //         selectedCat!.idCategorieProduit!)
                    // : stockService.fetchStock(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(child: Text("Aucun donné trouvé")),
                    );
                  } else {
                    stockListe = snapshot.data!;
                                                   if (stockListe.isEmpty) {
      // Vous pouvez afficher une image ou un texte ici
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
         }
                    String searchText = "";
                    List<Stock> filtereSearch =
                        stockListe.where((search) {
                      String libelle = search.nomProduit!.toLowerCase();
                      searchText = _searchController.text.trim().toLowerCase();
                      return libelle.contains(searchText);
                    }).toList();
                    
                    return Wrap(
                      // spacing: 10, // Espacement horizontal entre les conteneurs
                      // runSpacing:
                      //     10, // Espacement vertical entre les lignes de conteneurs
                      children: 
                      typeActeurData.map((e) => e.libelle!.toLowerCase()).contains("admin") ?
                      filtereSearch
                        //  .where((element) => element.statutSotck == true)
                          .map((e) => Padding(
                                padding: EdgeInsets.all(10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailProduits(
                                                      stock: e)));
                                    },
                                    child: Container(
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: SizedBox(
                                                height: 90,
                                                child: e.photo == null
                                                    ? Image.asset(
                                                        "assets/images/mang.jpg",
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        "https://koumi.ml/api-koumi/Stock/${e.idStock}/image",
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object
                                                                    exception,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Image.asset(
                                                            'assets/images/mang.jpg.png',
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Text(
                                              e.nomProduit!,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: d_colorGreen,
                                              ),
                                            ),
                                          ),
                                          // _buildEtat(e.statutSotck!),
                                          // _buildItem(
                                          //     "Prix :", e.prix!.toString()),
                                          SizedBox(height: 1),
                                           Padding(
  padding: const EdgeInsets.symmetric(horizontal: 4.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        '${e.prix!.toInt()} FCFA', // Convertir en entier
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, overflow:TextOverflow.ellipsis),
      ),
      Container(
        width: 30, // Largeur du conteneur réduite
        height: 30, // Hauteur du conteneur réduite
        decoration: BoxDecoration(
          color: Colors.blue, // Couleur de fond du bouton
          borderRadius: BorderRadius.circular(15), // Coins arrondis du bouton
        ),
        child: IconButton(
          onPressed: () {
            // Action à effectuer lorsque le bouton est pressé
            if (e.acteur!.idActeur! == acteur.idActeur!){
                        Snack.error(titre: "Alerte", message: "Désolé!, Vous ne pouvez pas commander un produit qui vous appartient");
                        }else{
                          Provider.of<CartProvider>(context, listen: false)
                        .addToCart(e, 1, "");
                        }
            // Par exemple, ajouter le produit au panier
          },
          icon: Icon(Icons.add), // Icône du panier
          color: Colors.white, // Couleur de l'icône
          iconSize: 20, // Taille de l'icône réduite
          padding: EdgeInsets.zero, // Aucune marge intérieure
          splashRadius: 15, // Rayon de l'effet de pression réduit
          tooltip: 'Ajouter au panier', // Info-bulle au survol de l'icône
        ),
      ),
    ],
  ),
),

  typeActeurData.map((e) => e.libelle!.toLowerCase()).contains("admin") ?
                                          //  _buildItem(
                                          //     "Acteur :", e.acteur!.typeActeur!.map((e) => e.libelle!).join(','))
                                           Container(
                                                  alignment:
                                                            Alignment.bottomRight,
                                               child: Padding(
                                                                                            padding: const EdgeInsets.symmetric(horizontal:8.0),
                                                                                            child: Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children: [
                                                     _buildEtat(e.statutSotck!),
                                                     SizedBox(width: 120,),
                                                     Expanded(
                                                       child: PopupMenuButton<String>(
                                                         padding: EdgeInsets.zero,
                                                         itemBuilder: (context) =>
                                                             <PopupMenuEntry<String>>[
                                                           PopupMenuItem<String>(
                                                             child: ListTile(
                                                               leading: e.statutSotck == false? Icon(
                                                                 Icons.check,
                                                                 color: Colors.green,
                                                               ): Icon(
                                                                Icons.disabled_visible,
                                                                color:Colors.orange[400]
                                                               ),
                                                               title:  Text(
                                                                e.statutSotck == false ? "Activer" : "Desactiver",
                                                                 style: TextStyle(
                                                                   color: e.statutSotck == false ? Colors.green : Colors.red,
                                                                   fontWeight: FontWeight.bold,
                                                                 ),
                                                               ),
                                                               
                                                               onTap: () async {
                                  // Changement d'état du magasin ici
                           
                               e.statutSotck == false ?  await StockService().activerStock(e.idStock!).then((value) => {
                                    // Mettre à jour la liste des stock après le changement d'état
                                    Provider.of<StockService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .applyChange(),
                                    setState(() {
                                      stockListeFuture =  StockService().fetchStock();
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
                                                                     .desactiverStock(e.idStock!)
                                                                     .then((value) => {
                                                                        Provider.of<StockService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .applyChange(),
                                                                                setState(() {
                                                       stockListeFuture =  StockService().fetchStock();
                                                       }),
                                                                           Navigator.of(context).pop(),
                                                                     
                                                                         });
                                                       
                                                                 ScaffoldMessenger.of(context)
                                                                     .showSnackBar(
                                                                    SnackBar(
                                                                     content: Row(
                                                                       children: [
                                                                         Text(e.statutSotck == false ? "Activer avec succèss " : "Desactiver avec succèss"),
                                                                       ],
                                                                     ),
                                                                     duration: Duration(seconds: 2),
                                                                   ),
                                                                 );
                                                               },
                                                             )
                                                          
                                               ),
                                                           
                                                          
                                                         ],
                                                       ),
                                                     ),
                                                   ],
                                                                                            ),
                                                                                          ),
                                                 )
                                          : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList():
                           filtereSearch
                         .where((element) => element.statutSotck == true)
                          .map((e) => Padding(
                                padding: EdgeInsets.all(10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailProduits(
                                                      stock: e)));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            offset: const Offset(0, 2),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: SizedBox(
                                                height: 90,
                                                child: e.photo == null
                                                    ? Image.asset(
                                                        "assets/images/mang.jpg",
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        "http://10.0.2.2/${e.photo}",
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object
                                                                    exception,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Image.asset(
                                                            'assets/images/mang.jpg.png',
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Text(
                                              e.nomProduit!,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: d_colorGreen,
                                              ),
                                            ),
                                          ),
                                          // _buildEtat(e.statutSotck!),
                                          // _buildItem(
                                          //     "Prix :", e.prix!.toString()),
                                          SizedBox(height: 1),
                                           Padding(
  padding: const EdgeInsets.symmetric(horizontal: 4.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        '${e.prix!.toInt()} FCFA', // Convertir en entier
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, overflow:TextOverflow.ellipsis),
      ),
      Container(
        width: 30, // Largeur du conteneur réduite
        height: 30, // Hauteur du conteneur réduite
        decoration: BoxDecoration(
          color: Colors.blue, // Couleur de fond du bouton
          borderRadius: BorderRadius.circular(15), // Coins arrondis du bouton
        ),
        child: IconButton(
          onPressed: () {
            // Action à effectuer lorsque le bouton est pressé
            if (e.acteur!.idActeur! == acteur.idActeur!){
                        Snack.error(titre: "Alerte", message: "Désolé!, Vous ne pouvez pas commander un produit qui vous appartient");
                        }else{
                          Provider.of<CartProvider>(context, listen: false)
                        .addToCart(e, 1, "");
                        }
            // Par exemple, ajouter le produit au panier
          },
          icon: Icon(Icons.add), // Icône du panier
          color: Colors.white, // Couleur de l'icône
          iconSize: 20, // Taille de l'icône réduite
          padding: EdgeInsets.zero, // Aucune marge intérieure
          splashRadius: 15, // Rayon de l'effet de pression réduit
          tooltip: 'Ajouter au panier', // Info-bulle au survol de l'icône
        ),
      ),
    ],
  ),
),

                                          //  _buildItem(
                                          //     "Acteur :", e.acteur!.typeActeur!.map((e) => e.libelle!).join(','))
                                           
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList()
                          ,
                    );
                  }
                });
          }) 
          
          ,
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