import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Campagne.dart';
import 'package:koumi_app/models/Niveau3Pays.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/Superficie.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/CampagneService.dart';
import 'package:koumi_app/service/Niveau3Service.dart';
import 'package:koumi_app/service/SpeculationService.dart';
import 'package:koumi_app/service/SuperficieService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:provider/provider.dart';

class UpdateSuperficie extends StatefulWidget {
  final Superficie superficie;
  const UpdateSuperficie({super.key, required this.superficie});

  @override
  State<UpdateSuperficie> createState() => _UpdateSuperficieState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _UpdateSuperficieState extends State<UpdateSuperficie> {
  TextEditingController _localiteController = TextEditingController();
  TextEditingController _superficieHaController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  List<Widget> listeIntrantFields = [];
  List<TextEditingController> intrantController = [];
  List<String> selectedIntrant = [];
  List<String> newSelectedIntrant = [];
  String? speValue;
  String? catValue;
  String niveau3 = '';
  String? n3Value;
  late Future _niveau3List;
  // late Future<List<Campagne>> _liste;
  late Future _liste;

  late Future _speculationList;
  late Speculation speculation;
  late Campagne campagne;
  DateTime selectedDate = DateTime.now();
  late Acteur acteur;
  bool _isLoading = false;
  late Superficie superficies;

  @override
  void initState() {
    super.initState();

    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    _liste = getCampListe(); // _categorieList = http.get(
    //     Uri.parse('http://10.0.2.2:9000/api-koumi/Categorie/allCategorie'));
    _speculationList = http.get(Uri.parse(
        'https://koumi.ml/api-koumi/Speculation/getAllSpeculation'));
        // 'http://10.0.2.2:9000/api-koumi/Speculation/getAllSpeculation'));
    // _speculationList = fetchSpeculationList();
    _niveau3List =
        http.get(Uri.parse('https://koumi.ml/api-koumi/nivveau3Pays/read'));
        // http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/nivveau3Pays/read'));
    superficies = widget.superficie;
    _localiteController.text = superficies.localite!;
    _superficieHaController.text = superficies.superficieHa!;
    _dateController.text = superficies.dateSemi!;
    speValue = superficies.speculation!.idSpeculation!;
    catValue = superficies.campagne!.idCampagne!;
    speculation = superficies.speculation!;
    campagne = superficies.campagne!;
    superficies.intrants!.forEach((element) {
      TextEditingController _intrantController =
          TextEditingController(text: element);

      intrantController.add(_intrantController);
    });
  }

  List<String?> selectedIntrantList = [];

  void addNewIntrant() {
    TextEditingController newIntrantController = TextEditingController();

    setState(() {
      intrantController.add(newIntrantController);
      selectedIntrantList.add(null);
    });
  }

  void ajouterIntrant() {
    for (int i = 0; i < selectedIntrantList.length; i++) {
      String item = selectedIntrant[i];
      if (item.isNotEmpty) {
        newSelectedIntrant.addAll({item});
      }
    }
  }

  Future<List<Niveau3Pays>> fetchniveauList() async {
    final response = await Niveau3Service().fetchNiveau3Pays();
    return response;
  }

  Future<List<Campagne>> getCampListe() async {
    final response =
        await CampagneService().fetchCampagneByActeur(acteur.idActeur!);
    return response;
  }

  Future<List<Speculation>> fetchSpeculationList() async {
    final response = await SpeculationService().fetchSpeculation();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
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
            'Modification  ',
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Superficie (Hectare)",
                        style: TextStyle(color: (Colors.black), fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez remplir les champs";
                        }
                        return null;
                      },
                      controller: _superficieHaController,
                      decoration: InputDecoration(
                        hintText: "Superficie ",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Localité",
                        style: TextStyle(color: (Colors.black), fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez remplir les champs";
                        }
                        return null;
                      },
                      controller: _localiteController,
                      decoration: InputDecoration(
                        hintText: "Localité ",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Spéculation",
                        style: TextStyle(color: (Colors.black), fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Consumer<SpeculationService>(
                        builder: (context, speculationService, child) {
                      return FutureBuilder(
                        future: _speculationList,
                        // future: speculationService.fetchSpeculationByCategorie(categorieProduit.idCategorieProduit!),
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                            dynamic responseData =
                                json.decode(snapshot.data.body);

                            if (responseData is List) {
                              List<Speculation> speList = responseData
                                  .map((e) => Speculation.fromMap(e))
                                  .toList();

                              if (speList.isEmpty) {
                                return DropdownButtonFormField(
                                  items: [],
                                  onChanged: null,
                                  decoration: InputDecoration(
                                    labelText: 'Aucune speculation trouvé',
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
                                items: speList
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e.idSpeculation,
                                        child: Text(e.nomSpeculation!),
                                      ),
                                    )
                                    .toList(),
                                value: speValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    speValue = newValue;
                                    if (newValue != null) {
                                      speculation = speList.firstWhere(
                                        (element) =>
                                            element.idSpeculation == newValue,
                                      );
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Sélectionner une speculation',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            } else {
                              // Handle case when response data is not a list
                              return DropdownButtonFormField(
                                items: [],
                                onChanged: null,
                                decoration: InputDecoration(
                                  labelText: 'Aucune speculation trouvé',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                          } else {
                            return DropdownButtonFormField(
                              items: [],
                              onChanged: null,
                              decoration: InputDecoration(
                                labelText: 'Aucune speculation trouvé',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Campagne",
                        style: TextStyle(color: (Colors.black), fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: FutureBuilder(
                      future: _liste,
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          List<Campagne> campListe = snapshot.data;

                          if (campListe.isEmpty) {
                            return DropdownButtonFormField(
                              items: [],
                              onChanged: null,
                              decoration: InputDecoration(
                                labelText: 'Aucune campagne trouvé',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }

                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            items: campListe
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.idCampagne,
                                    child: Text(e.nomCampagne),
                                  ),
                                )
                                .toList(),
                            value: catValue,
                            onChanged: (newValue) {
                              setState(() {
                                catValue = newValue;
                                if (newValue != null) {
                                  campagne = campListe.firstWhere(
                                    (element) => element.idCampagne == newValue,
                                  );
                                }
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Sélectionner une campagne',
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
                              labelText: 'Aucune campagne trouvé',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Date de semence",
                        style: TextStyle(color: (Colors.black), fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez remplir les champs";
                        }
                        return null;
                      },
                      controller: _dateController,
                      decoration: InputDecoration(
                        hintText: 'Sélectionner la date',
                        prefixIcon: const Icon(
                          Icons.date_range,
                          color: d_colorGreen,
                          size: 30.0,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100));
                        if (pickedDate != null) {
                          print(pickedDate);
                          String formattedDate =
                              DateFormat('yyyy-MM-dd HH:mm').format(pickedDate);
                          print(formattedDate);
                          setState(() {
                            _dateController.text = formattedDate;
                          });
                        } else {}
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Intrant utilisé",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            IconButton(
                                onPressed: addNewIntrant,
                                icon: Icon(Icons.add))
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: List.generate(
                            intrantController.length,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Veuillez remplir les champs";
                                  }
                                  return null;
                                },
                                controller: intrantController[index],
                                decoration: InputDecoration(
                                  hintText: "Intrant utilisé",
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  // Column(
                  //   children: listeIntrantFields,
                  // ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  final String superficie = _superficieHaController.text;
                  final String date = _dateController.text;
                  final String localite = _localiteController.text;
                  
                  setState(() {
                    //parcourir pour recuperer les elements modifier
                     for (int i = 0; i < intrantController.length; i++) {
                      String item = intrantController[i].text;
                      if (item.isNotEmpty) {
                        newSelectedIntrant.addAll({item});
                      }
                    }

                    //parcourir pour recuperer les nouvellers elements
                     for (int i = 0; i < selectedIntrantList.length; i++) {
                      String item = intrantController[i].text;
                      if (item.isNotEmpty) {
                        newSelectedIntrant.addAll({item});
                      }
                    }
                  });
                  try {
                    setState(() {
                      _isLoading = true;
                    });
                    await SuperficieService()
                        .updateSuperficie(idSuperficie: superficies.idSuperficie!, localite: localite, superficieHa: superficie, dateSemi: date, personneModif: acteur.nomActeur!, intrants: newSelectedIntrant, speculation: speculation, campagne: campagne)
                        .then((value) => {
                              Provider.of<SuperficieService>(context,
                                      listen: false)
                                  .applyChange(),
                              _superficieHaController.clear(),
                              _dateController.clear(),
                              _localiteController.clear(),
                              _dateController.clear(),
                            
                              setState(() {
                                catValue = null;
                                speValue = null;
                                n3Value = null;
                              }),
                              Navigator.of(context).pop()
                            })
                        .catchError((onError) => {});
                  } catch (e) {
                    final String errorMessage = e.toString();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Text("Une erreur s'est produit"),
                          ],
                        ),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: d_colorOr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: const Size(290, 45),
                ),
                child: Text(
                  "Modifier",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
