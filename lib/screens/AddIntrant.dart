import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/screens/NextAddIntrat.dart';
import 'package:koumi_app/service/CategorieService.dart';
import 'package:koumi_app/service/SpeculationService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddIntrant extends StatefulWidget {
  const AddIntrant({super.key});

  @override
  State<AddIntrant> createState() => _AddIntrantState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AddIntrantState extends State<AddIntrant> {
  TextEditingController _nomController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _quantiteController = TextEditingController();
  TextEditingController _prixController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool _isLoading = false;
  final formkey = GlobalKey<FormState>();
  late Acteur acteur;
  String? imageSrc;
  File? photo;
  List<CategorieProduit> categorieList = [];
  List<Speculation> speculationList = [];
  String? speValue;
  late Future _speculationList;
  late Speculation speculation;
  String? catValue;
  late Future _categorieList;
  late ParametreGeneraux para = ParametreGeneraux();
  List<ParametreGeneraux> paraList = [];
  // late CategorieProduit categorieProduit;
  late CategorieProduit categorieProduit = CategorieProduit();
  late Future<List<CategorieProduit>> _liste;

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = path.basename(imagePath);
    final image = File('${directory.path}/$name');
    return image;
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await getImage(source);
    if (image != null) {
      setState(() {
        photo = image;
        imageSrc = image.path;
      });
    }
  }

  Future<File?> getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return null;

    return File(image.path);
  }

  Future<void> _showImageSourceDialog() async {
    final BuildContext context = this.context;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: AlertDialog(
            title: const Text('Choisir une source'),
            content: Wrap(
              alignment: WrapAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Fermer le dialogue
                    _pickImage(ImageSource.camera);
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.camera_alt, size: 40),
                      Text('Camera'),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Fermer le dialogue
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.image, size: 40),
                      Text('Galerie photo'),
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

  void _handleButtonPress() async {
    // Afficher l'indicateur de chargement
    setState(() {
      _isLoading = true;
    });
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

  @override
  void initState() {
    super.initState();
    verifyParam();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    _categorieList = fetchCategorieList(); // _categorieList = http.get(
    _speculationList = http.get(Uri.parse(
        // 'http://10.0.2.2:9000/api-koumi/Speculation/getAllSpeculationByCategorie/${categorieProduit.idCategorieProduit}'));
        'https://koumi.ml/api-koumi/Speculation/getAllSpeculationByCategorie/${categorieProduit.idCategorieProduit}'));
  }

  Future<List<CategorieProduit>> fetchCategorieList() async {
    final response = await CategorieService().fetchCategorie();
    return response;
  }

//   @override
//   void initState() {
//     super.initState();
//     acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
//     _fetchData();
//   }

// //  late List<dynamic> _categorieList;
// //   late List<dynamic> _speculationList;

//   Future<void> _fetchData() async {

//     setState(() {

//       _speculationList =  http.get(Uri.parse(
//         'http://10.0.2.2:9000/api-koumi/Speculation/getAllSpeculationByCategorie/${categorieProduit.idCategorieProduit}'));

//     });
//   }

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
              'Ajout d\'intrant ',
              style: const TextStyle(
                  color: d_colorGreen, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: formkey,
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Chosir une catégorie",
                          style: TextStyle(color: (Colors.black), fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Consumer<CategorieService>(
                        builder: (context, catService, child) {
                          return FutureBuilder(
                            future: _categorieList,
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
                                List<CategorieProduit> catList =
                                    snapshot.data as List<CategorieProduit>;

                                if (catList.isEmpty) {
                                  return DropdownButtonFormField(
                                    items: [],
                                    onChanged: null,
                                    decoration: InputDecoration(
                                      labelText: 'Aucune catégorie trouvé',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                }

                                return DropdownButtonFormField<String>(
                                  items: catList
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.idCategorieProduit,
                                          child: Text(e.libelleCategorie!),
                                        ),
                                      )
                                      .toList(),
                                  value: catValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      speValue =
                                          null; // Réinitialisez la valeur de la spéculation sélectionnée
                                      catValue = newValue;
                                      if (newValue != null) {
                                        categorieProduit = catList.firstWhere(
                                          (element) =>
                                              element.idCategorieProduit ==
                                              newValue,
                                        );

                                        // _speculationList = SpeculationService().fetchSpeculationByCategorie(newValue);
                                        _speculationList = http.get(Uri.parse(
                                            'https://koumi.ml/api-koumi/Speculation/getAllSpeculationByCategorie/${newValue}'));
                                        // 'http://10.0.2.2:9000/api-koumi/Speculation/getAllSpeculationByCategorie/${newValue}'));
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Sélectionner une catégorie',
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
                                    labelText: 'Aucune catégorie trouvé',
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
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Chosir une spéculation",
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
                              dynamic jsonString =
                                  utf8.decode(snapshot.data.bodyBytes);
                              dynamic responseData = json.decode(jsonString);
                              // dynamic responseData =
                              //     json.decode(snapshot.data.body);

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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                }

                                return DropdownButtonFormField<String>(
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Nom de l'intrant",
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
                        controller: _nomController,
                        decoration: InputDecoration(
                          hintText: "nom",
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
                          "Description",
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
                        controller: _descriptionController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Description",
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
                          "Quantite (paquets)",
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
                        controller: _quantiteController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: "Quantité intant",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () async {
                          final String nom = _nomController.text;
                          final String description =
                              _descriptionController.text;
                          final double quantite =
                              double.tryParse(_quantiteController.text) ?? 0.0;

                          if (formkey.currentState!.validate()) {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NextAddIntrat(
                                            nom: nom,
                                            description: description,
                                            quantite: quantite,
                                            speculation: speculation)))
                                .then((value) => {
                                      _nomController.clear(),
                                      _descriptionController.clear(),
                                      _quantiteController.clear(),
                                      setState(() {
                                        speValue = null;
                                        catValue = null;
                                      }),
                                    });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Orange color code
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: const Size(290, 45),
                        ),
                        child: Text(
                          "Suivant",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ]),
                )
              ],
            ),
          ),
        ));
  }
}


 // Consumer<CategorieService>(
                    //     builder: (context, catService, child) {
                    //   return FutureBuilder(
                    //     future: _categorieList,
                    //     builder: (_, snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.waiting) {
                    //         return CircularProgressIndicator();
                    //       }
                    //       if (snapshot.hasError) {
                    //         return Text("${snapshot.error}");
                    //       }
                    //       if (snapshot.hasData) {
                    //         dynamic responseData =
                    //             json.decode(snapshot.data.body);
                    //         if (responseData is List) {
                    //           final reponse = responseData;
                    //           final catList = reponse
                    //               .map((e) => CategorieProduit.fromMap(e))
                    //               .where((con) => con.statutCategorie == true)
                    //               .toList();

                    //           if (catList.isEmpty) {
                    //             return DropdownButtonFormField(
                    //               items: [],
                    //               onChanged: null,
                    //               decoration: InputDecoration(
                    //                 labelText: 'Aucune catégorie trouvé',
                    //                 border: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(8),
                    //                 ),
                    //               ),
                    //             );
                    //           }

                    //           return DropdownButtonFormField<String>(
                    //             items: catList
                    //                 .map(
                    //                   (e) => DropdownMenuItem(
                    //                     value: e.idCategorieProduit,
                    //                     child: Text(e.libelleCategorie!),
                    //                   ),
                    //                 )
                    //                 .toList(),
                    //             value: catValue,
                    //             onChanged: (newValue) {
                    //               setState(() {
                    //                 speValue =
                    //                     null; // Réinitialisez la valeur de la spéculation sélectionnée
                    //                 catValue =
                    //                     newValue; // Assurez-vous que catValue contient l'ID de la catégorie sélectionnée
                    //                 if (newValue != null) {
                    //                   categorieProduit = catList.firstWhere(
                    //                     (element) =>
                    //                         element.idCategorieProduit ==
                    //                         newValue,
                    //                   );
                    //                   // Maintenant, vous pouvez récupérer les spéculations associées à cette catégorie
                    //                   _speculationList = SpeculationService()
                    //                       .fetchSpeculationByCategorie(
                    //                           newValue);
                    //                 }
                    //               });
                    //             },
                    //             decoration: InputDecoration(
                    //               labelText: 'Sélectionner une catégorie',
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
                    //               labelText: 'Aucune catégorie trouvé',
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
                    //           labelText: 'Aucune catégorie trouvé',
                    //           border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(8),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   );
                    // }),

                     // Consumer<SpeculationService>(
                    //     builder: (context, speculationService, child) {
                    //   return FutureBuilder(
                    //     future: _speculationList,
                    //     // future: speculationService.fetchSpeculationByCategorie(categorieProduit.idCategorieProduit!),
                    //     builder: (_, snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.waiting) {
                    //         return CircularProgressIndicator();
                    //       }
                    //       if (snapshot.hasError) {
                    //         return Text("${snapshot.error}");
                    //       }
                    //       if (snapshot.hasData) {
                    //         dynamic responseData = snapshot.data!.body;

                    //         if (responseData is List) {
                    //           final reponse = responseData;
                    //           final specList = reponse
                    //               .map((e) => Speculation.fromMap(e))
                    //               .where((con) => con.statutSpeculation == true)
                    //               .toList();

                    //           if (specList.isEmpty) {
                    //             return DropdownButtonFormField(
                    //               items: [],
                    //               onChanged: null,
                    //               decoration: InputDecoration(
                    //                 labelText: 'Aucune speculation trouvé',
                    //                 border: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(8),
                    //                 ),
                    //               ),
                    //             );
                    //           }

                    //           return DropdownButtonFormField<String>(
                    //             items: specList
                    //                 .map(
                    //                   (e) => DropdownMenuItem(
                    //                     value: e.idSpeculation,
                    //                     child: Text(e.nomSpeculation!),
                    //                   ),
                    //                 )
                    //                 .toList(),
                    //             value: speValue,
                    //             onChanged: (newValue) {
                    //               setState(() {
                    //                 speValue = newValue;
                    //                 if (newValue != null) {
                    //                   speculation = specList.firstWhere(
                    //                     (element) =>
                    //                         element.idSpeculation == newValue,
                    //                   );
                    //                 }
                    //               });
                    //             },
                    //             decoration: InputDecoration(
                    //               labelText: 'Sélectionner une speculation',
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
                    //               labelText: 'Aucune speculation trouvé',
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
                    //           labelText: 'Aucune speculation trouvé',
                    //           border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(8),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   );
                    // }),