import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/models/Vehicule.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddVehicule.dart';
import 'package:koumi_app/screens/DetailTransport.dart';
import 'package:koumi_app/service/VehiculeService.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';


class VehiculeActeur extends StatefulWidget {
  const VehiculeActeur({super.key});

  @override
  State<VehiculeActeur> createState() => _VehiculeActeurState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _VehiculeActeurState extends State<VehiculeActeur> {
  late Acteur acteur;
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late TextEditingController _searchController;
  List<Vehicule> vehiculeListe = [];
  late Future<List<Vehicule>> _liste;
  // late Future liste;

  Future<List<Vehicule>> getVehicule(String id) async {
    final response = await VehiculeService().fetchVehiculeByActeur(id);

    return response;
  }


    ScrollController scrollableController = ScrollController();

   int page = 0;
   bool isLoading = false;
   int size = 4;
   bool hasMore = true;

 
    Future<List<Vehicule>> fetchVehiculeByActeur(String idActeur,{bool refresh = false}) async {
    // if (_stockService.isLoading == true) return [];

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
      final response = await http.get(Uri.parse('$apiOnlineUrl/vehicule/getAllVehiculesByActeurWithPagination?idActeur=$idActeur&page=${page}&size=${size}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
           hasMore = false;
          });
        } else {
          setState(() {
           List<Vehicule> newVehicule = body.map((e) => Vehicule.fromMap(e)).toList();
          vehiculeListe.addAll(newVehicule);
          });
        }

        debugPrint("response body all vehicule by acteur with pagination ${page} par défilement soit ${vehiculeListe.length}");
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
    return vehiculeListe;
  }  



  @override
  void initState() {
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    typeActeurData = acteur.typeActeur!;
    type = typeActeurData.map((data) => data.libelle).join(', ');
    _searchController = TextEditingController();
    _liste = fetchVehiculeByActeur(acteur.idActeur!);

    super.initState();
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
            'Mes véhicules',
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
          actions: [
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              itemBuilder: (context) => <PopupMenuEntry<String>>[
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddVehicule()));
                    },
                  ),
                ),
              ],
            )
          ]),
      body: RefreshIndicator(
         onRefresh:() async{
                                setState(() {
                   page =0;
                  // Rafraîchir les données ici
             _liste = fetchVehiculeByActeur(acteur.idActeur!);
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
               _liste = fetchVehiculeByActeur(acteur.idActeur!);
                  });
                    debugPrint("refresh page ${page}");
                                },
                child: SingleChildScrollView(
                  controller: scrollableController,
                  child: 
  
                    Consumer<VehiculeService>(builder: (context, vehiculeService, child) {
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
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(child: Text("Aucun donné trouvé")),
                    );
                  } else {
                    vehiculeListe = snapshot.data!;
                    String searchText = "";
                    List<Vehicule> filtereSearch =
                        vehiculeListe.where((search) {
                      String libelle = search.nomVehicule.toLowerCase();
                      searchText = _searchController.text.toLowerCase();
                      return libelle.contains(searchText);
                    }).toList();
                    return 
                    vehiculeListe.isEmpty ?
                      
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
                    'Aucune vehiucle trouvé' ,
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
                      itemCount: filtereSearch.length,
                      itemBuilder: (context, index) {
                        var e = filtereSearch
                            .where((element) => element.statutVehicule == true)
                            .elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailTransport(vehicule: e)));
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: SizedBox(
                                    height: 72,
                                    child: e.photoVehicule == null ||  e.photoVehicule!.isEmpty
                                        ? Image.asset(
                                            "assets/images/default_image.png",
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl:
                                                "https://koumi.ml/api-koumi/vehicule/${e.idVehicule}/image",
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
                                    e.nomVehicule,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                   maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    e.localisation,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildEtat(e.statutVehicule),
                                      PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context) =>
                                            <PopupMenuEntry<String>>[
                                          PopupMenuItem<String>(
                                            child: ListTile(
                                              leading: e.statutVehicule == false
                                                  ? Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                    )
                                                  : Icon(
                                                      Icons.disabled_visible,
                                                      color: Colors.orange[400],
                                                    ),
                                              title: Text(
                                                e.statutVehicule == false
                                                    ? "Activer"
                                                    : "Desactiver",
                                                style: TextStyle(
                                                  color:
                                                      e.statutVehicule == false
                                                          ? Colors.green
                                                          : Colors.orange[400],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onTap: () async {
                                                
                                                e.statutVehicule == false
                                                    ? await VehiculeService()
                                                        .activerVehicules(
                                                            e.idVehicule)
                                                        .then((value) => {
                                                              Provider.of<VehiculeService>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .applyChange(),
                                                              setState(() {
                                                                _liste =
                                                                    getVehicule(
                                                                        acteur
                                                                            .idActeur!);
                                                              }),
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Row(
                                                                    children: [
                                                                      Text(
                                                                          "Activer avec succèss "),
                                                                    ],
                                                                  ),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                ),
                                                              )
                                                            })
                                                        .catchError(
                                                            (onError) => {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      content:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                              "Une erreur s'est produit"),
                                                                        ],
                                                                      ),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              5),
                                                                    ),
                                                                  ),
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                                })
                                                    : await VehiculeService()
                                                        .desactiverVehicules(
                                                            e.idVehicule)
                                                        .then((value) => {
                                                              Provider.of<VehiculeService>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .applyChange(),
                                                              setState(() {
                                                                _liste =
                                                                    getVehicule(
                                                                        acteur
                                                                            .idActeur!);
                                                              }),
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                            })
                                                        .catchError(
                                                            (onError) => {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      content:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                              "Une erreur s'est produit"),
                                                                        ],
                                                                      ),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              5),
                                                                    ),
                                                                  ),
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                                });

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Row(
                                                      children: [
                                                        Text(
                                                            "Désactiver avec succèss "),
                                                      ],
                                                    ),
                                                    duration:
                                                        Duration(seconds: 2),
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
                                                await VehiculeService()
                                                    .deleteVehicule(
                                                        e.idVehicule)
                                                    .then((value) => {
                                                          Provider.of<VehiculeService>(
                                                                  context,
                                                                  listen: false)
                                                              .applyChange(),
                                                          setState(() {
                                                            _liste = getVehicule(
                                                                acteur
                                                                    .idActeur!);
                                                          }),
                                                          Navigator.of(context)
                                                              .pop(),
                                                        })
                                                    .catchError((onError) => {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Row(
                                                                children: [
                                                                  Text(
                                                                      "Impossible de supprimer"),
                                                                ],
                                                              ),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
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
                      },
                    );
                  }
                });
          })
                )
              )
              )
              )));
              
    
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
                overflow: TextOverflow.ellipsis,
                fontSize: 18),
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

/*


*/