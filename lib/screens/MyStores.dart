import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddAndUpdateProductScreen.dart';
import 'package:koumi_app/screens/AddMagasinScreen.dart';
import 'package:koumi_app/screens/DetailProduits.dart';
import 'package:koumi_app/screens/MagasinActeur.dart';
import 'package:koumi_app/screens/MyProduct.dart';
import 'package:koumi_app/screens/Product.dart';
import 'package:koumi_app/screens/ProduitActeur.dart';
import 'package:koumi_app/service/MagasinService.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyStoresScreen extends StatefulWidget {
  const MyStoresScreen({super.key});

  @override
  State<MyStoresScreen> createState() => _MyStoresScreenState();
}
 
  const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _MyStoresScreenState extends State<MyStoresScreen> {
  

   late Acteur acteur;
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late TextEditingController _searchController;
  List<Magasin>  magasinListe = [];
  Niveau1Pays? selectedNiveau1Pays;
  String? typeValue;
  late Future _niveau1PaysList;
  late Future <List<Magasin>>  magasinListeFuture;
  bool isExist = false;
  String? email = "";


  //  Future <void>verify() async {
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
  //     // Fetch magasins after setting the actor
  //   } else {
  //     setState(() {
  //       isExist = false;
  //     });
  //   }
  // }

  
Future<List<Magasin>> fetchMagasins() async {
  try {
    if (selectedNiveau1Pays != null) {
      magasinListe = await MagasinService().fetchMagasinByRegionAndActeur(acteur.idActeur!, selectedNiveau1Pays!.idNiveau1Pays!);
    } else {
      magasinListe = await MagasinService().fetchMagasinByActeur(acteur.idActeur!);
    }
    // Once magasins are fetched, setState to trigger UI update
    // setState(() {});
  } catch (error) {
    // Handle error
    print('Error fetching magasins: $error');
  }
  return magasinListe;
}

  @override
  void initState() {
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    // typeActeurData = acteur.typeActeur!;
    // // selectedType == null;
    // type = typeActeurData.map((data) => data.libelle).join(', ');

    _searchController = TextEditingController();
    _niveau1PaysList =
        http.get(Uri.parse('https://koumi.ml/api-koumi/niveau1Pays/read'));
        // http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read'));
    super.initState();

    magasinListeFuture = fetchMagasins();
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
            'Mes boutiques',
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
          actions:  [
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
                                    "Ajouter Magasin",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () async {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             AddMagasinScreen(isEditable: false,)));
                                     Navigator.push(
                                                          context,
                                                          PageRouteBuilder(
                                                            pageBuilder: (context, animation, secondaryAnimation) =>
                                                                AddMagasinScreen(
                                                             isEditable: false,
                                                            ),
                                                            transitionsBuilder:
                                                                (context, animation, secondaryAnimation, child) {
                                                              var begin =
                                  Offset(0.0, 1.0); // Commencer en bas de l'écran
                                                              var end = Offset.zero; // Finir en haut de l'écran
                                                              var curve = Curves.ease;
                                                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                                                              return SlideTransition(
                                                                position: animation.drive(tween),
                                                                child: child,
                                                              );
                                                            },
                                                            transitionDuration: const Duration(
                                                                milliseconds: 1900), // Durée de la transition
                                                          ),
                                                        );
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
                 dynamic jsonString =
                                utf8.decode(snapshot.data.bodyBytes);
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
              },
            ),
          ),
          const SizedBox(height: 10),

          Consumer<MagasinService>(builder: (context, magasinService, child) {
            return FutureBuilder<List<Magasin>>(
                future: 
                magasinListeFuture,
                // selectedNiveau1Pays != null
                //     ? magasinService.fetchMagasinByRegionAndActeur(acteur.idActeur!,selectedNiveau1Pays!.idNiveau1Pays!)
                //     : magasinService.fetchMagasinByActeur(
                //         acteur.idActeur!),
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
                    magasinListe = snapshot.data!;
                                                   if (magasinListe.isEmpty) {
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
                    List<Magasin> filtereSearch =
                        magasinListe.where((search) {
                      String libelle = search.nomMagasin!.toLowerCase();
                      searchText = _searchController.text.trim().toLowerCase();
                      return libelle.contains(searchText);
                    }).toList();
                    return Wrap(
                      // spacing: 10, // Espacement horizontal entre les conteneurs
                      // runSpacing:
                      //     10, // Espacement vertical entre les lignes de conteneurs
                      children: filtereSearch
                        //  .where((element) => element.statutMagasin == true)
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
                                                  MyProductScreen(
                                                    id:e.idMagasin!, nom:e.nomMagasin
                                                      )));
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
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: SizedBox(
                                              height: 90,
                                              child: e.photo == null
                                                  ? Image.asset(
                                                      "assets/images/magasin.png",
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      "https://koumi.ml/api-koumi/Magasin/${e.idMagasin}/image",
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (BuildContext
                                                                  context,
                                                              Object
                                                                  exception,
                                                              StackTrace?
                                                                  stackTrace) {
                                                        return Image.asset(
                                                          'assets/images/magasin.png',
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Text(
                                              e.nomMagasin!,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: d_colorGreen,
                                              ),
                                            ),
                                          ),
                                          // _buildEtat(e.statutMagasin!),
                                         SizedBox(height: 1),
                                           Container(
                                                  alignment:
                                                            Alignment.bottomRight,
                                               child: Padding(
                                                                                            padding: const EdgeInsets.symmetric(horizontal:8.0),
                                                                                            child: Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children: [
                                                     _buildEtat(e.statutMagasin!),
                                                     SizedBox(width: 120,),
                                                     Expanded(
                                                       child: PopupMenuButton<String>(
                                                         padding: EdgeInsets.zero,
                                                         itemBuilder: (context) =>
                                                             <PopupMenuEntry<String>>[
                                                           PopupMenuItem<String>(
                                                             child: ListTile(
                                                               leading: e.statutMagasin == false? Icon(
                                                                 Icons.check,
                                                                 color: Colors.green,
                                                                 //FlyBox-3BA0B5
                                                               ): Icon(
                                                                Icons.disabled_visible,
                                                                color:Colors.orange[400]
                                                               ),
                                                               title:  Text(
                                                                e.statutMagasin == false ? "Activer" : "Desactiver",
                                                                 style: TextStyle(
                                                                   color: e.statutMagasin == false ? Colors.green : Colors.red,
                                                                   fontWeight: FontWeight.bold,
                                                                 ),
                                                               ),
                                                               
                                                               onTap: () async {
                                  // Changement d'état du magasin ici
                           
                               e.statutMagasin == false ?  await MagasinService().activerMagasin(e.idMagasin!).then((value) => {
                                    // Mettre à jour la liste des magasins après le changement d'état
                                    Provider.of<MagasinService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .applyChange(),
                                    setState(() {
                                     magasinListeFuture =  MagasinService().fetchMagasinByActeur(acteur.idActeur!);
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
                                                                         }): await MagasinService()
                                                                     .desactiverMagasin(e.idMagasin!)
                                                                     .then((value) => {
                                                                        Provider.of<MagasinService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .applyChange(),
                                                                                setState(() {
                                                       magasinListeFuture =  MagasinService().fetchMagasinByActeur(acteur.idActeur!);
                                                       }),
                                                                           Navigator.of(context).pop(),
                                                                     
                                                                         });
                                                       
                                                                 ScaffoldMessenger.of(context)
                                                                     .showSnackBar(
                                                                    SnackBar(
                                                                     content: Row(
                                                                       children: [
                                                                         Text(e.statutMagasin == false ? "Activer avec succèss " : "Desactiver avec succèss"),
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
                                                               leading: Icon(
                                                                 Icons.disabled_visible,
                                                                 color: Colors.green[400],
                                                               ),
                                                               title: Text(
                                                                 "Modifier",
                                                                 style: TextStyle(
                                                                   color: Colors.green[400],
                                                                   fontWeight: FontWeight.bold,
                                                                 ),
                                                               ),
                                                               onTap: () async {
                                                                 Navigator.push(
                                                                   context,
                                                                   PageRouteBuilder(
                                                                     pageBuilder: (context, animation,
                                                                         secondaryAnimation) {
                                                                       return FadeTransition(
                                                                         opacity: animation,
                                                                         child: ScaleTransition(
                                                                           scale: animation,
                                                                           child: AddMagasinScreen(
                                                                             idMagasin: e.idMagasin,
                                                                             isEditable: true,
                                                                             nomMagasin:
                                                                                 e.nomMagasin,
                                                                             contactMagasin:
                                                                                 e.contactMagasin,
                                                                             localiteMagasin:
                                                                                 e.localiteMagasin,
                                                                             niveau1Pays:
                                                                                 e.niveau1Pays!,
                                                                             // photo: filteredMagasins[index]['photo']!,
                                                                           ),
                                                                         ),
                                                                       );
                                                                     },
                                                                     transitionsBuilder: (context,
                                                                         animation,
                                                                         secondaryAnimation,
                                                                         child) {
                                                                       return child;
                                                                     },
                                                                     transitionDuration: const Duration(
                                                                         milliseconds:
                                                                             1500), // Durée de la transition
                                                                   ),
                                                                 );
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
                                                                 await MagasinService()
                                                                     .deleteMagasin(
                                                                         e.idMagasin!)
                                                                     .then((value) => {
                                                                          Provider.of<MagasinService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .applyChange(),
                                                                           setState(() {
                                                                          magasinListeFuture =  MagasinService().fetchMagasinByActeur(acteur.idActeur!);
                                                                          }),
                                                                           Navigator.of(context).pop(),

                                                                           ScaffoldMessenger.of(context)
                                                                               .showSnackBar(
                                                                          
                                                                             const SnackBar(
                                                                               content: Row(
                                                                                 children: [
                                                                                   Text(
                                                                                       "Magasin supprimer avec succès"),
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
                                                 )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  }
                });
          }),
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
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16),
            ),
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