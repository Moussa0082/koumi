import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/Admin/DetailMateriel.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Materiel.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/models/TypeMateriel.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddMateriel.dart';
import 'package:koumi_app/screens/ListeMaterielByActeur.dart';
import 'package:koumi_app/service/MaterielService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Location extends StatefulWidget {
  const Location({super.key});
  
  @override
  State<Location> createState() => _LocationState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _LocationState extends State<Location> {
  // late TypeMateriel type = TypeMateriel();
  List<Materiel> materielListe = [];
  late Acteur acteur;
  late List<TypeActeur> typeActeurData = [];
  late String type;
  bool isExist = false;
  String? email = "";
  String? typeValue;
  TypeMateriel? selectedType;
  late Future _typeList;

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
    super.initState();
    verify();
    _typeList =
        http.get(Uri.parse('https://koumi.ml/api-koumi/TypeMateriel/read'));
    // http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/TypeMateriel/read'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 100,
          title: Text(
            "Location Matériel",
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
                        PopupMenuItem<String>(
                          child: ListTile(
                            leading: const Icon(
                              Icons.add,
                              color: Colors.green,
                            ),
                            title: const Text(
                              "Ajouter matériel ",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddMateriel()));
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
                              "Mes matériels ",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ListeMaterielByActeur()));
                            },
                          ),
                        )
                      ];
                    },
                  )
                ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                        labelText: 'Chargement...',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    dynamic jsonString = utf8.decode(snapshot.data.bodyBytes);
                    dynamic responseData = json.decode(jsonString);
                    if (responseData is List) {
                      final reponse = responseData;
                      final typeList = reponse
                          .map((e) => TypeMateriel.fromMap(e))
                          .where((con) => con.statutType == true)
                          .toList();

                      if (typeList.isEmpty) {
                        return DropdownButtonFormField(
                          items: [],
                          onChanged: null,
                          decoration: InputDecoration(
                            labelText: '-- Aucun type de matériel trouvé --',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }

                      return DropdownButtonFormField<String>(
                        items: typeList
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.idTypeMateriel,
                                child: Text(e.nom!),
                              ),
                            )
                            .toList(),
                        hint: Text("-- Filtre par type de matériel --"),
                        value: typeValue,
                        onChanged: (newValue) {
                          setState(() {
                            typeValue = newValue;
                            if (newValue != null) {
                              selectedType = typeList.firstWhere(
                                (element) => element.idTypeMateriel == newValue,
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
                          labelText: '-- Aucun type de matériel trouvé --',
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
                      labelText: '-- Aucun type de matériel trouvé --',
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
            Consumer<MaterielService>(
              builder: (context, materielService, child) {
                return FutureBuilder(
                    future: selectedType != null
                        ? materielService
                            .fetchMaterielByType(selectedType!.idTypeMateriel!)
                        : materielService.fetchMateriel(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        // dynamic jsonString =
                        //     utf8.decode(snapshot.data!.bodyBytes);
                        // dynamic responseData = json.decode(jsonString);
                        materielListe = snapshot.data!;

                        return materielListe
                                .where(
                                    (element) => element.statut == false)
                                .isEmpty
                            ? Padding(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                    child: Text("Aucun matériel trouvé")),
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
                            itemCount: materielListe
                                .where(
                                    (element) => element.statut == true)
                                .length,
                            itemBuilder: (context, index) {
                              var e = materielListe
                                  .where((element) =>
                                      element.statut == true)
                                  .elementAt(index);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailMateriel(
                                                              materiel: e)));
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
                                        child: SizedBox(
                                          height: 100,
                                          child:  e.photoMateriel ==
                                                              null
                                                          ? Image.asset(
                                                              "assets/images/default_image.png",
                                                              fit: BoxFit.cover,
                                                              height: 90,
                                                            )
                                                          : Image.network(
                                                              "https://koumi.ml/api-koumi/Materiel/${e.idMateriel}/image",
                                                              fit: BoxFit.cover,
                                                              height: 90,
                                                              errorBuilder: (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                                return Image
                                                                    .asset(
                                                                  'assets/images/default_image.png',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 90,
                                                                );
                                                              },
                                                            ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      ListTile(
                                          title: Text(
                                             e.nom,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                            // maxLines: 1,
                                            // overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                             e.localisation,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                         
                                          ),

                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                      } else{
                         return const Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: Text("Aucun matériel trouvé")),
                        );
                      }
                    });
              },
            )
          ],
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

  Widget _buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
