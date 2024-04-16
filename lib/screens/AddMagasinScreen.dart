import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/MagasinService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../models/ParametreGeneraux.dart';

class AddMagasinScreen extends StatefulWidget {
  bool? isEditable;
  String? nomMagasin = "";
  String? contactMagasin = "";
  String? localiteMagasin = "";
  String? idMagasin = "";
  File? photo;
  late Niveau1Pays? niveau1Pays;
  AddMagasinScreen(
      {super.key,
      this.isEditable,
      this.idMagasin,
      this.nomMagasin,
      this.contactMagasin,
      this.localiteMagasin,
      this.photo,
      this.niveau1Pays});

  @override
  State<AddMagasinScreen> createState() => _AddMagasinScreenState();
}

class _AddMagasinScreenState extends State<AddMagasinScreen> {
  late Acteur acteur = Acteur();
  String nomMagasin = "";
  String contactMagasin = "";
  // String niveau3PaysMagasin = "";
  String localiteMagasin = "";

  File? photos;
  String? imageSrc;

   Niveau1Pays niveau1Pays = Niveau1Pays();

  List<String> regions = [];
  String? niveauPaysValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nomMagasinController = TextEditingController();
  TextEditingController contactMagasinController = TextEditingController();
  TextEditingController localiteMagasinController = TextEditingController();
  late ParametreGeneraux para;
  List<ParametreGeneraux> paraList = [];
  List<Map<String, dynamic>> regionsData = [];
  bool isLoading = false;

  late Future niveau1PaysList;
  final String message = "Encore quelques secondes";

  Set<String> loadedRegions =
      {}; // Ensemble pour garder une trace des régions pour lesquelles les magasins ont déjà été chargés

//   void fetchRegions() async {
//   try {
//     final response = await http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read'));
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);

//       // Filtrer les éléments avec statutN1 == true
//         setState(() {
//           niveau1Pays = data
//               .where((niv) => niv['statutN1'] == true)
//               .map((item) => Niveau1Pays(
//                     idNiveau1Pays: item['idNiveau1Pays'] as String,
//                     nomN1: item['nomN1'] as String,
//                   ))
//               .toList();
//         });

//     } else {
//       throw Exception('Failed to load regions');
//     }
//   } catch (e) {
//     print('Error fetching regions: $e');
//   }
// }
  Future<void> updateMagasin() async {
    final nomMagasin = nomMagasinController.text;
    final contactMagasin = contactMagasinController.text;
    final localiteMagasin = localiteMagasinController.text;
    MagasinService magasinService = MagasinService();
    try {
      if (photos != null) {
        await magasinService
            .updateMagasin(
                idMagasin: widget.idMagasin!,
                nomMagasin: nomMagasin,
                contactMagasin: contactMagasin,
                localiteMagasin: localiteMagasin,
                photo: widget.photo,
                acteur: acteur,
                niveau1Pays: widget.niveau1Pays!)
            .then((value) => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Center(child: Text('Succès')),
                      content: const Text("Magasin mis à jour avec succès"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            nomMagasinController.clear();
                            contactMagasinController.clear();
                            localiteMagasinController.clear();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                ));
      } else {
        await magasinService
            .updateMagasin(
                idMagasin: widget.idMagasin!,
                nomMagasin: nomMagasin,
                contactMagasin: contactMagasin,
                localiteMagasin: localiteMagasin,
                acteur: acteur,
                niveau1Pays: widget.niveau1Pays!)
            .then((value) => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Center(child: Text('Succès')),
                      content: const Text("Magasin mis à jour avec succès"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            nomMagasinController.clear();
                            contactMagasinController.clear();
                            localiteMagasinController.clear();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                ));
      }
    } catch (e) {
      debugPrint("Erreur : $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Erreur')),
            content: Text("Une erreur s'est produite veuiller réessayer $e"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _handleButtonPress() async {
    // Afficher l'indicateur de chargement
    setState(() {
      isLoading = true;
    });

    if (widget.isEditable! == false) {
      await addMagasin().then((_) {
        // Cacher l'indicateur de chargement lorsque votre fonction est terminée
        setState(() {
          isLoading = false;
        });
      });
    } else {
      await updateMagasin().then((_) {
        // Cacher l'indicateur de chargement lorsque votre fonction est terminée
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<void> addMagasin() async {
    final nomMagasin = nomMagasinController.text;
    final contactMagasin = contactMagasinController.text;
    final localiteMagasin = localiteMagasinController.text;
    MagasinService magasinService = MagasinService();
    try {
      if (photos != null) {
        await magasinService
            .creerMagasin(
                nomMagasin: nomMagasin,
                contactMagasin: contactMagasin,
                localiteMagasin: localiteMagasin,
                photo: photos,
                acteur: acteur,
                niveau1Pays: niveau1Pays)
            .then((value) => {
                      Provider.of<MagasinService>(
                                                                                   context,
                                                                                   listen: false)
                                                                               .applyChange(),
                  nomMagasinController.clear(),
                  contactMagasinController.clear(),
                  localiteMagasinController.clear(),
                  setState(() {
                    // niveau1Pays == null;
                    photos == null;
                  }),
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Text("Ajouté avec succèss "),
                        ],
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  ),
                  // Navigator.of(context).pop(),
                });
      } else {
        await magasinService
            .creerMagasin(
                nomMagasin: nomMagasin,
                contactMagasin: contactMagasin,
                localiteMagasin: localiteMagasin,
                acteur: acteur,
                niveau1Pays: niveau1Pays)
            .then((value) => {
                      Provider.of<MagasinService>(
                                                                                   context,
                                                                                   listen: false)
                                                                               .applyChange(),
                  nomMagasinController.clear(),
                  contactMagasinController.clear(),
                  localiteMagasinController.clear(),
                  setState(() {
                    niveauPaysValue == "Sélectionner une région";
                  }),
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Text("Activer avec succèss "),
                        ],
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  ),
                });
      }
    } catch (e) {
      debugPrint("Erreur : $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Erreur')),
            content: Text("Une erreur s'est produite veuiller réessayer "),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = path.basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  Future<File?> getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return null;

    return File(image.path);
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await getImage(source);
    if (image != null) {
      setState(() {
        this.photos = image;
        imageSrc = image.path;
      });
    }
  }

  Future<void> _showImageSourceDialog() async {
    final BuildContext context = this.context;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: AlertDialog(
            title: Text("Choisir une source"),
            content: Wrap(
              alignment: WrapAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Fermer le dialogue
                    _pickImage(ImageSource.camera);
                  },
                  child: Column(
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
                  child: Column(
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

  @override
  void initState() {
    super.initState();
    if (widget.isEditable! == true) {
      nomMagasinController.text = widget.nomMagasin!;
      contactMagasinController.text = widget.contactMagasin!;
      localiteMagasinController.text = widget.localiteMagasin!;
      // photos = widget.photo!;
      niveauPaysValue = widget.niveau1Pays!.idNiveau1Pays;
      debugPrint("Id Magasin " +
          widget.idMagasin! +
          "bool" +
          widget.isEditable!.toString());
    }
    debugPrint("bool" + widget.isEditable!.toString());
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    niveau1PaysList =
        http.get(Uri.parse('https://koumi.ml/api-koumi/niveau1Pays/read'));
    // http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read'));
  }

  @override
  Widget build(BuildContext context) {
    const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);

    return LoadingOverlay(
      isLoading: isLoading,
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
            widget.isEditable! == false
                ? "Ajouter magasin"
                : "Modifier magasin",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nom magasin
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Nom Magasin *",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                      ),
                      TextFormField(
                        controller: nomMagasinController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: "Entrez le nom du magasin",
                        ),
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Veillez entrez le nom du magasin";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => nomMagasin = val!,
                      ),
                      // fin  nom magasin
                      const SizedBox(height: 10),

                      //Contact magasin
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Contact Magasin *",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                      ),
                      TextFormField(
                        controller: contactMagasinController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: "Entrez le contact du magasin",
                        ),
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Veillez entrez le contact du magasin";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => contactMagasin = val!,
                      ),
                      // fin contact magasin

                      const SizedBox(height: 10),

                      //Contact localiteMagasin
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Localité Magasin *",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                      ),
                      TextFormField(
                        controller: localiteMagasinController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: "Exemple : Bamako , Kayes , Segou",
                        ),
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Veillez entrez la localité du magasin";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => localiteMagasin = val!,
                      ),
                      // fin localite magasin
                      const SizedBox(height: 10),

                      //Contact magasin
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Region *",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                      ),
                      FutureBuilder(
                        future: niveau1PaysList,
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return DropdownButtonFormField(
                              items: [],
                              onChanged: null,
                              decoration: InputDecoration(
                                labelText: 'Aucune region trouvé',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return Text("Une erreur s'est produite veuillez réessayer plus tard");
                          }
                          if (snapshot.hasData) {
                            dynamic responseData =
                                json.decode(snapshot.data.body);
                            if (responseData is List) {
                              final reponse = responseData;
                              final niveau1List = reponse
                                  .map((e) => Niveau1Pays.fromMap(e))
                                  .where((con) => con.statutN1 == true)
                                  .toList();

                              if (niveau1List.isEmpty) {
                                return DropdownButtonFormField(
                                  items: [],
                                  onChanged: null,
                                  decoration: InputDecoration(
                                    labelText: 'Aucun  region trouvé',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              }

                              return DropdownButtonFormField<String>(
                            //     validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Veuillez sélectionner une region.';
                            //   }
                            //   return null;
                            // },
                                 items: niveau1List
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value:widget.isEditable! == false ? e.idNiveau1Pays : widget.niveau1Pays!.idNiveau1Pays,
                                        child: Text(e.nomN1!),
                                      ),
                                    )
                                    .toList(),
                                value: niveau1Pays.idNiveau1Pays  ,        
                                       onChanged: (newValue) {
                                  setState(() {
                                  niveau1Pays.idNiveau1Pays = newValue;
                                    if (newValue != null) {
                                      niveau1Pays.nomN1 =
                                          niveau1List.map((e) => e.nomN1).first;
                                      print("niveau 1 : ${niveau1Pays}");
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: widget.isEditable! == false ? 'Selectionner une region' : widget.niveau1Pays!.nomN1,
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
                                  labelText: 'Aucune region trouvé',
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
                              labelText: 'Aucune region trouvé',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      (photos == null)
                          ? IconButton(
                              onPressed: _showImageSourceDialog,
                              icon: Icon(Icons.camera_alt_sharp),
                              iconSize: 50,
                            )
                          : Image.file(
                              photos!,
                              height: 100,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                      Text("Choisir une image"),

                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Handle button press action here
                            if (_formKey.currentState!.validate()) {
                              _handleButtonPress();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFFF8A00), // Orange color code
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: const Size(250, 40),
                          ),
                          child: Text(
                            widget.isEditable! == false
                                ? " Ajouter "
                                : " Modifier ",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
