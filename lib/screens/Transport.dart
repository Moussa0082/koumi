import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/models/TypeVoiture.dart';
import 'package:koumi_app/models/Vehicule.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/DetailTransport.dart';
import 'package:koumi_app/screens/PageTransporteur.dart';
import 'package:koumi_app/screens/VehiculesActeur.dart';
import 'package:koumi_app/service/VehiculeService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Transport extends StatefulWidget {
  const Transport({super.key});

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

  @override
  void initState() {
    // acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    // typeActeurData = acteur.typeActeur!;
    // // selectedType == null;
    // type = typeActeurData.map((data) => data.libelle).join(', ');
    verify();
    _searchController = TextEditingController();
    // _typeList = http.get(Uri.parse('https://koumi.ml/api-koumi/TypeVoiture/read'));
    _typeList =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/TypeVoiture/read'));
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
            'Transport',
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
          actions: !isExist
              ? null
              : [
                  (type.toLowerCase() == 'admin' ||
                          type.toLowerCase() == 'transporteur')
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VehiculeActeur()));
                                  },
                                ),
                              )
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
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 10),
          //     decoration: BoxDecoration(
          //       color: Colors.blueGrey[50], // Couleur d'arrière-plan
          //       borderRadius: BorderRadius.circular(25),
          //     ),
          //     child: Row(
          //       children: [
          //         Icon(Icons.search,
          //             color: Colors.blueGrey[400],
          //             size: 28), // Utiliser une icône de recherche plus grande
          //         SizedBox(width: 10),
          //         Expanded(
          //           child: TextField(
          //             controller: _searchController,
          //             onChanged: (value) {
          //               setState(() {});
          //             },
          //             decoration: InputDecoration(
          //               hintText: 'Rechercher',
          //               border: InputBorder.none,
          //               hintStyle: TextStyle(color: Colors.blueGrey[400]),
          //             ),
          //           ),
          //         ),
          //         // Ajouter un bouton de réinitialisation pour effacer le texte de recherche
          //         IconButton(
          //           icon: Icon(Icons.clear),
          //           onPressed: () {
          //             _searchController.clear();
          //             setState(() {});
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: FutureBuilder(
              future: _typeList,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return DropdownButtonFormField(
                    items: [],
                    onChanged: null,
                    decoration: InputDecoration(
                      labelText: '-- Aucun type de véhicule trouvé --',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                if (snapshot.hasData) {
                  dynamic responseData = json.decode(snapshot.data.body);
                  if (responseData is List) {
                    final reponse = responseData;
                    final vehiculeList = reponse
                        .map((e) => TypeVoiture.fromMap(e))
                        .where((con) => con.statutType == true)
                        .toList();

                    if (vehiculeList.isEmpty) {
                      return DropdownButtonFormField(
                        items: [],
                        onChanged: null,
                        decoration: InputDecoration(
                          labelText: '-- Aucun type de véhicule trouvé --',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }

                    return DropdownButtonFormField<String>(
                      items: vehiculeList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.idTypeVoiture,
                              child: Text(e.nom!),
                            ),
                          )
                          .toList(),
                      hint: Text("-- Filtre par type de véhicule --"),
                      value: typeValue,
                      onChanged: (newValue) {
                        setState(() {
                          typeValue = newValue;
                          if (newValue != null) {
                            selectedType = vehiculeList.firstWhere(
                              (element) => element.idTypeVoiture == newValue,
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
                        labelText: '-- Aucun type de véhicule trouvé --',
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
                    labelText: '-- Aucun type de véhicule trouvé --',
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
          Consumer<VehiculeService>(builder: (context, vehiculeService, child) {
            return FutureBuilder<List<Vehicule>>(
                future: selectedType != null
                    ? vehiculeService.fetchVehiculeByTypeVehicule(
                        selectedType!.idTypeVoiture!)
                    : vehiculeService.fetchVehicule(),
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
                    return Wrap(
                      // spacing: 10, // Espacement horizontal entre les conteneurs
                      // runSpacing:
                      //     10, // Espacement vertical entre les lignes de conteneurs
                      children: filtereSearch
                          // .where((element) => element.statutVehicule == true)
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
                                                  DetailTransport(
                                                      vehicule: e)));
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
                                                child: e.photoVehicule == null
                                                    ? Image.asset(
                                                        "assets/images/camion.png",
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        "http://10.0.2.2/${e.photoVehicule}",
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object
                                                                    exception,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Image.asset(
                                                            'assets/images/camion.png',
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
                                              e.nomVehicule,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: d_colorGreen,
                                              ),
                                            ),
                                          ),
                                          _buildItem("Statut:",
                                              '${e.statutVehicule ? 'Disponible' : 'Non disponible'}'),
                                          _buildItem(
                                              "Localité :", e.localisation),
                                          SizedBox(height: 10),
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
