import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Niveau3Pays.dart';
import 'package:koumi_app/models/TypeMateriel.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/MaterielService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddMaterielByType extends StatefulWidget {
  final TypeMateriel? typeMateriel;
  const AddMaterielByType({super.key, this.typeMateriel});

  @override
  State<AddMaterielByType> createState() => _AddMaterielByTypeState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AddMaterielByTypeState extends State<AddMaterielByType> {
  TextEditingController _nomController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _etatController = TextEditingController();
  TextEditingController _prixController = TextEditingController();
  //  Map<int, int> prixParHeures = {};
  // List<Widget> heurePrixFields = [];
  // List<TextEditingController> heureControllers = [];
  // List<TextEditingController> prixControllers = [];
  final formkey = GlobalKey<FormState>();
  String? imageSrc;
  File? photo;
  late Acteur acteur;
  bool _isLoading = false;
  late Future _niveau3List;
  String? n3Value;
  String niveau3 = '';
  late Future _typeList;
  String? typeValue;
  late TypeMateriel typeMateriel;
  late TypeMateriel type;
  bool isExist = false;

  // void addDestinationAndPrix() {
  //   // Créer un nouveau contrôleur pour chaque champ
  //   TextEditingController newDestinationController = TextEditingController();
  //   TextEditingController newPrixController = TextEditingController();

  //   setState(() {
  //     // Ajouter les nouveaux contrôleurs aux listes
  //     heureControllers.add(newDestinationController);
  //     prixControllers.add(newPrixController);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    verifyTypeMateriel();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    _typeList =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/TypeMateriel/read'));
    _niveau3List =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/nivveau3Pays/read'));
  }

  void verifyTypeMateriel() {
    if (widget.typeMateriel != null) {
      type = widget.typeMateriel!;
      setState(() {
        isExist = true;
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 100,
          // leading: IconButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
          title: Text(
            "Ajout matériel",
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Nom du matériel",
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
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
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
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
                            "Localité",
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: FutureBuilder(
                          future: _niveau3List,
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return DropdownButtonFormField(
                                items: [],
                                onChanged: null,
                                decoration: InputDecoration(
                                  labelText: 'Aucun localité trouvé',
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
                              dynamic responseData =
                                  json.decode(snapshot.data.body);
                              if (responseData is List) {
                                final reponse = responseData;
                                final niveau3List = reponse
                                    .map((e) => Niveau3Pays.fromMap(e))
                                    .where((con) => con.statutN3 == true)
                                    .toList();

                                if (niveau3List.isEmpty) {
                                  return DropdownButtonFormField(
                                    items: [],
                                    onChanged: null,
                                    decoration: InputDecoration(
                                      labelText: 'Aucun localité trouvé',
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
                                  items: niveau3List
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.idNiveau3Pays,
                                          child: Text(e.nomN3),
                                        ),
                                      )
                                      .toList(),
                                  value: n3Value,
                                  onChanged: (newValue) {
                                    setState(() {
                                      n3Value = newValue;
                                      if (newValue != null) {
                                        niveau3 = niveau3List
                                            .map((e) => e.nomN3)
                                            .first;
                                        print("niveau 3 : ${niveau3}");
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Selectionner une localité',
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
                                    labelText: 'Aucun localité trouvé',
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
                                labelText: 'Aucun localité trouvé',
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
                            "Etat matériel",
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
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
                          controller: _etatController,
                          decoration: InputDecoration(
                            hintText: "Etat du matériel",
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
                            "Prix par heure",
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
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
                          controller: _prixController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: "Prix par heure",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: photo != null
                              ? Image.file(
                                  photo!,
                                  fit: BoxFit.fitWidth,
                                  height: 150,
                                  width: 300,
                                )
                              : SizedBox(
                                  child: IconButton(
                                    onPressed: _showImageSourceDialog,
                                    icon: const Icon(
                                      Icons.add_a_photo_rounded,
                                      size: 60,
                                    ),
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
                            final String etat = _etatController.text;
                            final int prixParHeures =
                                int.tryParse(_prixController.text) ?? 0;
                            if (formkey.currentState!.validate()) {
                              try {
                                setState(() {
                                  _isLoading = true;
                                });
                                if (photo != null) {
                                  await MaterielService()
                                      .addMateriel(
                                          prixParHeure: prixParHeures,
                                          nom: nom,
                                          description: description,
                                          localisation: niveau3,
                                          etatMateriel: etat,
                                          typeMateriel: type,
                                          photoMateriel: photo,
                                          acteur: acteur)
                                      .then((value) => {
                                            Provider.of<MaterielService>(
                                                    context,
                                                    listen: false)
                                                .applyChange(),
                                            _etatController.clear(),
                                            _nomController.clear(),
                                            _descriptionController.clear(),
                                            setState(() {
                                              _isLoading = false;
                                              n3Value = null;
                                            }),
                                            Navigator.pop(context),
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Row(
                                                  children: [
                                                    Text(
                                                      "Matériel ajouté avec succèss",
                                                      style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 5),
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
                                                      "Une erreur s'est produite",
                                                      style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 5),
                                              ),
                                            )
                                          });
                                } else {
                                  await MaterielService()
                                      .addMateriel(
                                          prixParHeure: prixParHeures,
                                          nom: nom,
                                          description: description,
                                          localisation: niveau3,
                                          etatMateriel: etat,
                                          typeMateriel: type,
                                          acteur: acteur)
                                      .then((value) => {
                                            Provider.of<MaterielService>(
                                                    context,
                                                    listen: false)
                                                .applyChange(),
                                            _etatController.clear(),
                                            _nomController.clear(),
                                            _descriptionController.clear(),
                                            setState(() {
                                              _isLoading = false;
                                              n3Value = null;
                                            }),
                                            Navigator.pop(context),
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Row(
                                                  children: [
                                                    Text(
                                                      "Matériel ajouté avec succèss",
                                                      style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 5),
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
                                                      "Une erreur s'est produite",
                                                      style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 5),
                                              ),
                                            )
                                          });
                                }
                              } catch (e) {
                                print("Error: " + e.toString());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Text(
                                          "Une erreur est survenu lors de l'ajout",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 5),
                                  ),
                                );
                              }
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
                            "Ajouter",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}


//  Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 22,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "Prix par heure",
//                                   style: TextStyle(
//                                       color: Colors.black, fontSize: 18),
//                                 ),
//                                 IconButton(
//                                   onPressed: () {
//                                     // Appeler la méthode pour ajouter une destination et un prix
//                                     addDestinationAndPrix();
//                                   },
//                                   icon: Icon(Icons.add),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 10),
//                             Column(
//                               children: List.generate(
//                                 heureControllers.length,
//                                 (index) => Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextFormField(
//                                           controller: heureControllers[index],
//                                           keyboardType: TextInputType.number,
//                                           inputFormatters: <TextInputFormatter>[
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly,
//                                           ],
//                                           decoration: InputDecoration(
//                                             hintText: "Heure",
//                                             contentPadding:
//                                                 const EdgeInsets.symmetric(
//                                               vertical: 10,
//                                               horizontal: 20,
//                                             ),
//                                             border: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       Expanded(
//                                         child: TextFormField(
//                                           controller: prixControllers[index],
//                                           keyboardType: TextInputType.number,
//                                           inputFormatters: <TextInputFormatter>[
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly,
//                                           ],
//                                           decoration: InputDecoration(
//                                             hintText: "Prix",
//                                             contentPadding:
//                                                 const EdgeInsets.symmetric(
//                                               vertical: 10,
//                                               horizontal: 20,
//                                             ),
//                                             border: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Column(
//                         children: heurePrixFields,
//                       ),