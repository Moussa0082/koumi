import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Commande.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/DetailCommande.dart';
import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/service/BottomNavigationService.dart';
import 'package:koumi_app/service/CommandeService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommandeScreen extends StatefulWidget {
  const CommandeScreen({super.key});

  @override
  State<CommandeScreen> createState() => _CommandeScreenState();
}


const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _CommandeScreenState extends State<CommandeScreen> {
  
 late Acteur acteur = Acteur();
  
  List<Commande> commandeList = [];
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late Future<List<Commande>> _liste;
  // List<ParametreGeneraux> paraList = [];
  // late Niveau1Pays niveau1;
  // late Pays pays;
  // String? paysValue;
  // late Future _paysList;
  // String? n1Value;
  // late Future _niveauList;
  late TextEditingController _searchController;


  bool isExist = false;
  String? email = "";

  void verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('emailActeur');
    if (email != null) {
      // Si l'email de l'acteur est présent, exécute checkLoggedIn
      acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
      // typeActeurData = acteur.typeActeur!;
      // type = typeActeurData.map((data) => data.libelle).join(', ');
      setState(() {
        isExist = true;
          _liste = getAllCommandeByActeur(acteur.idActeur!);
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }


  Future<List<Commande>> getAllCommandeByActeur(String idActeur) async {
    final response = await CommandeService().fetchCommandeByActeur(idActeur);
    return response;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    verify();

    // paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
    //     .parametreList!;
    // para = paraList[0];
    // _paysList = http.get(Uri.parse('https://koumi.ml/api-koumi/pays/read'));
    // _paysList = http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/pays/read'));
    // _niveauList =
    //     http.get(Uri.parse('https://koumi.ml/api-koumi/niveau1Pays/read'));
        // http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read'));
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
          "Commande",
          style:
              const TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   PopupMenuButton<String>(
        //     padding: EdgeInsets.zero,
        //     itemBuilder: (context) => <PopupMenuEntry<String>>[
        //       PopupMenuItem<String>(
        //         child: ListTile(
        //           leading: const Icon(
        //             Icons.add,
        //             color: Colors.green,
        //           ),
        //           title: Text(
        //             "Ajouter un ${para.libelleNiveau2Pays}",
        //             style: TextStyle(
        //                 color: Colors.green,
        //                 fontWeight: FontWeight.bold,
        //                 overflow: TextOverflow.ellipsis),
        //           ),
        //           onTap: () async {
        //             _showDialog();
        //           },
        //         ),
        //       ),
        //     ],
        //   )
        // ],
      ),
      body: 
       !isExist
            ? Center(
                child: Container(
                  padding: EdgeInsets.all(
                      20), // Ajouter un padding pour l'espace autour du contenu

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/lock.png",
                          width: 100,
                          height:
                              100), // Ajuster la taille de l'image selon vos besoins
                      SizedBox(
                          height:
                              20), // Ajouter un espace entre l'image et le texte
                      Text(
                        "Vous devez vous connecter pour voir vos commandes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                          height:
                              20), // Ajouter un espace entre le texte et le bouton
                      ElevatedButton(
                        onPressed: () {
                          Future.microtask(() {
                            Provider.of<BottomNavigationService>(context,
                                    listen: false)
                                .changeIndex(0);
                          });
                          Get.to(LoginScreen(),
                              duration: Duration(
                                  seconds:
                                      1), //duration of transitions, default 1 sec
                              transition: Transition.leftToRight);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          elevation: MaterialStateProperty.all<double>(
                              0), // Supprimer l'élévation du bouton
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.grey.withOpacity(
                                  0.2)), // Couleur de l'overlay du bouton lorsqu'il est pressé
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color:
                                      d_colorGreen), // Bordure autour du bouton
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
      SingleChildScrollView(
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
                      color: Colors.blueGrey[400]), // Couleur de l'icône
                  SizedBox(
                      width:
                          10), // Espacement entre l'icône et le champ de recherche
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
                            color: Colors
                                .blueGrey[400]), // Couleur du texte d'aide
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Consumer<CommandeService>(builder: (context, commandeService, child) {
            return FutureBuilder(
                future: _liste,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                          child:
                              Text("Aucune commande trouvé")),
                    );
                  } else {
                    commandeList = snapshot.data!;
                    String searchText = "";
                    List<Commande> filtereSearch =
                        commandeList.where((search) {
                      String code = search.codeCommande!;
                      String date = search.dateCommande!;
                      searchText = _searchController.text;
                      return searchText.contains(code);
                    }).toList();
                    return 
                      commandeList.isEmpty
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
                                      'Aucune commande trouvé',
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
                    Column(
                        children: commandeList
                            .map((e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => DetailCommandeScreen (),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
                                      Navigator.of(context).push(_createRoute());
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            offset: const Offset(0, 2),
                                            blurRadius: 5,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: Image.asset("assets/images/cmd.png",
                                            fit: BoxFit.cover,
                                            height:40,
                                            width:40),
                                            title: Text(e.codeCommande!,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                            subtitle: Text(
                                                e.dateCommande!,
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.italic,
                                                )),
                                          ),
                                          // Consumer<Niveau1Service>(
                                          //   builder:
                                          //     (context, niveauSer, child) {
                                          //   return FutureBuilder(
                                          //       future: Niveau3Service()
                                          //           .fetchNiveau3ByNiveau2(
                                          //               e.idNiveau2Pays!),
                                          //       builder: (context, snapshot) {
                                          //         if (snapshot
                                          //                 .connectionState ==
                                          //             ConnectionState.waiting) {
                                          //           return const Center(
                                          //             child:
                                          //                 CircularProgressIndicator(
                                          //               color: Colors.orange,
                                          //             ),
                                          //           );
                                          //         }

                                          //         if (!snapshot.hasData) {
                                          //           return Padding(
                                          //             padding:
                                          //                 EdgeInsets.symmetric(
                                          //                     horizontal: 15),
                                          //             child: Row(
                                          //               mainAxisAlignment:
                                          //                   MainAxisAlignment
                                          //                       .spaceBetween,
                                          //               children: [
                                          //                 Text(
                                          //                     "Nombres ${para.libelleNiveau3Pays} :",
                                          //                     style: TextStyle(
                                          //                       color: Colors
                                          //                           .black87,
                                          //                       fontSize: 17,
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w500,
                                          //                       fontStyle:
                                          //                           FontStyle
                                          //                               .italic,
                                          //                     )),
                                          //                 Text("0",
                                          //                     style: TextStyle(
                                          //                       color: Colors
                                          //                           .black87,
                                          //                       fontSize: 18,
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w800,
                                          //                     ))
                                          //               ],
                                          //             ),
                                          //           );
                                          //         } else {
                                          //           niveau3List =
                                          //               snapshot.data!;
                                          //           return Padding(
                                          //             padding:
                                          //                 EdgeInsets.symmetric(
                                          //                     horizontal: 15),
                                          //             child: Row(
                                          //               mainAxisAlignment:
                                          //                   MainAxisAlignment
                                          //                       .spaceBetween,
                                          //               children: [
                                          //                 Text(
                                          //                     "Nombres ${para.libelleNiveau3Pays} :",
                                          //                     style: TextStyle(
                                          //                       color: Colors
                                          //                           .black87,
                                          //                       fontSize: 17,
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w500,
                                          //                       fontStyle:
                                          //                           FontStyle
                                          //                               .italic,
                                          //                     )),
                                          //                 Text(
                                          //                     niveau3List.length
                                          //                         .toString(),
                                          //                     style: TextStyle(
                                          //                       color: Colors
                                          //                           .black87,
                                          //                       fontSize: 18,
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w800,
                                          //                     ))
                                          //               ],
                                          //             ),
                                          //           );
                                          //         }
                                          //       });
                                          // }),
                                           Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildEtat(e
                                                .statutCommande!),
                                            SizedBox(
                                              width: 270,
                                            ),
                                            Expanded(
                                              child: PopupMenuButton<String>(
                                                padding: EdgeInsets.zero,
                                                itemBuilder: (context) =>
                                                    <PopupMenuEntry<String>>[
                                                  PopupMenuItem<String>(
                                                      child: ListTile(
                                                    leading: e
                                                .statutCommande! ==
                                                            false
                                                        ? Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .disabled_visible,
                                                            color: Colors
                                                                .orange[400]),
                                                    title: Text(
                                                      e
                                                .statutCommande! ==
                                                              false
                                                          ? "Relancer"
                                                          : "Annuler",
                                                      style: TextStyle(
                                                        color: e
                                                .statutCommande! ==
                                                                false
                                                            ? Colors.green
                                                            : Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      // Changement d'état du magasin ici

                                                      e
                                                .statutCommande! ==
                                                              false
                                                          ? await CommandeService()
                                                              .enableCommande(
                                                                  e.idCommande!)
                                                              .then((value) => {
                                                                    // Mettre à jour la liste des magasins après le changement d'état
                                                                    Provider.of<CommandeService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .applyChange(),
                                                                    setState(
                                                                        () {
                                                                      _liste =
                                                                          getAllCommandeByActeur(acteur.idActeur!);
                                                                    }),
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                  })
                                                              .catchError(
                                                                  (onError) => {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          const SnackBar(
                                                                            content:
                                                                                Row(
                                                                              children: [
                                                                                Text("Une erreur s'est produit"),
                                                                              ],
                                                                            ),
                                                                            duration:
                                                                                Duration(seconds: 5),
                                                                          ),
                                                                        ),
                                                                        Navigator.of(context)
                                                                            .pop(),
                                                                      })
                                                          : await CommandeService()
                                                              .disableCommane(
                                                                  e.idCommande!)
                                                              .then((value) => {
                                                                    Provider.of<CommandeService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .applyChange(),
                                                                    setState(
                                                                        () {
                                                                      _liste =
                                                                          getAllCommandeByActeur(acteur.idActeur!);
                                                                    }),
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                  });

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Row(
                                                            children: [
                                                              Text(e.statutCommande ==
                                                                      false
                                                                  ? "Relancer avec succèss "
                                                                  : "Annuler avec succèss"),
                                                            ],
                                                          ),
                                                          duration: Duration(
                                                              seconds: 2),
                                                        ),
                                                      );
                                                    },
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                            .toList());
                  }
                });
          })
        ]),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(
                    "Ajouter la quantité livrée",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez remplir ce champ";
                          }
                          return null;
                        },
                        controller: libelleController,
                        decoration: InputDecoration(
                          labelText: "Quantité livrer ",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                     
                      SizedBox(height: 16),
                      // Consumer<Niveau1Service>(
                      //   builder: (context, niveauService, child) {
                      //     return FutureBuilder(
                      //       future: _niveauList,
                      //       builder: (_, snapshot) {
                      //         if (snapshot.connectionState ==
                      //             ConnectionState.waiting) {
                      //           return DropdownButtonFormField(
                      //             items: [],
                      //             onChanged: null,
                      //             decoration: InputDecoration(
                      //               labelText: 'Chargement...',
                      //               border: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(8),
                      //               ),
                      //             ),
                      //           );
                      //         }
                              
                      //         if (snapshot.hasData) {
                      //            dynamic jsonString =
                      //               utf8.decode(snapshot.data.bodyBytes);
                      //           dynamic reponse = json.decode(jsonString);

                      //           // final reponse = json.decode(snapshot.data.body);
                      //           if (reponse is List) {
                      //             final niveauList = reponse
                      //                 .map((e) => Niveau1Pays.fromMap(e))
                      //                 .where((con) => con.statutN1 == true)
                      //                 .toList();

                      //             if (niveauList.isEmpty) {
                      //               return DropdownButtonFormField(
                      //                 items: [],
                      //                 onChanged: null,
                      //                 decoration: InputDecoration(
                      //                   labelText:
                      //                       'Aucun ${para.libelleNiveau1Pays} trouvé',
                      //                   border: OutlineInputBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(8),
                      //                   ),
                      //                 ),
                      //               );
                      //             }

                      //             return DropdownButtonFormField<String>(
                      //               items: niveauList
                      //                   .map(
                      //                     (e) => DropdownMenuItem(
                      //                       value: e.idNiveau1Pays,
                      //                       child: Text(e.nomN1 ?? ''),
                      //                     ),
                      //                   )
                      //                   .toList(),
                      //               value: n1Value,
                      //               onChanged: (newValue) {
                      //                 setState(() {
                      //                   n1Value = newValue;
                      //                   if (newValue != null) {
                      //                     niveau1 = niveauList.firstWhere(
                      //                         (element) =>
                      //                             element.idNiveau1Pays ==
                      //                             newValue);
                      //                     debugPrint(
                      //                         "niveau select :${niveau1.toString()}");
                      //                     // typeSelected = true;
                      //                   }
                      //                 });
                      //               },
                      //               decoration: InputDecoration(
                      //                 labelText:
                      //                     'Sélectionner un ${para.libelleNiveau1Pays}',
                      //                 border: OutlineInputBorder(
                      //                   borderRadius: BorderRadius.circular(8),
                      //                 ),
                      //               ),
                      //             );
                      //           }
                      //         }
                      //         return DropdownButtonFormField(
                      //           items: [],
                      //           onChanged: null,
                      //           decoration: InputDecoration(
                      //             labelText:
                      //                 'Aucun ${para.libelleNiveau1Pays} trouvé',
                      //             border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(8),
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),
                      SizedBox(height: 16),
                      // TextFormField(
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return "Veuillez remplir ce champ";
                      //     }
                      //     return null;
                      //   },
                      //   controller: descriptionController,
                      //   maxLines: null,
                      //   decoration: InputDecoration(
                      //     labelText: "Description",
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 20),
                      // ElevatedButton.icon(
                      //   onPressed: () async {
                      //     final String libelle = libelleController.text;
                      //     final String description = descriptionController.text;
                      //     if (formkey.currentState!.validate()) {
                      //       try {
                      //         await Niveau2Service()
                      //             .addNiveau2Pays(
                      //               nomN2: libelle,
                      //               descriptionN2: description,
                      //               niveau1Pays: niveau1,
                      //             )
                      //             .then((value) => {
                      //                   Provider.of<Niveau2Service>(context,
                      //                           listen: false)
                      //                       .applyChange(),
                      //                       Navigator.of(context).pop(),
                      //                          ScaffoldMessenger.of(context).showSnackBar(
                      //            SnackBar(
                      //             content: Row(
                      //               children: [
                      //                 Text("${para.libelleNiveau2Pays} ajouté avec success"),
                      //               ],
                      //             ),
                      //             duration: Duration(seconds: 5),
                      //           ),
                      //         ),
                      //                   libelleController.clear(),
                      //                   descriptionController.clear(),
                      //                   setState(() {
                      //                     niveau1 == null;
                      //                   }),
                                        
                      //                 });
                      //       } catch (e) {
                      //         final String errorMessage = e.toString();
                      //           ScaffoldMessenger.of(context).showSnackBar(
                      //           SnackBar(
                      //             content: Row(
                      //               children: [
                      //                 Text(
                      //                     "${para.libelleNiveau2Pays} existe déjà"),
                      //               ],
                      //             ),
                      //             duration: Duration(seconds: 5),
                      //           ),
                      //         );
                      //       }
                      //     }
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.green, // Orange color code
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //     ),
                      //     minimumSize: const Size(290, 45),
                      //   ),
                      //   icon: const Icon(
                      //     Icons.add,
                      //     color: Colors.white,
                      //   ),
                      //   label: const Text(
                      //     "Ajouter",
                      //     style: TextStyle(
                      //       fontSize: 20,
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w700,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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

