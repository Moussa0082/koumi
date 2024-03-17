import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeVoiture.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/TypeVehicule.dart';
import 'package:koumi_app/service/VehiculeService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class NextAddVehicule extends StatefulWidget {
  final TypeVoiture typeVoiture;
  final String nomV;
  final String localite;
  final String description;
  final String nbKilo;
  final String capacite;
  
  const NextAddVehicule({super.key, required this.typeVoiture, required this.nomV, required this.localite, required this.description, required this.nbKilo, required this.capacite , });

  @override
  State<NextAddVehicule> createState() => _NextAddVehiculeState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _NextAddVehiculeState extends State<NextAddVehicule> {
  TextEditingController _etatController = TextEditingController();
  TextEditingController _prixController = TextEditingController();
  TextEditingController newDestinationController = TextEditingController();
  TextEditingController newPrixController = TextEditingController();
  List<Widget> destinationPrixFields = [];
  List<TextEditingController> destinationControllers = [];
  List<TextEditingController> prixControllers = [];

  late Map<String, int> prixParDestinations;
  final formkey = GlobalKey<FormState>();
  String? imageSrc;
  File? photo;
  late Acteur acteur;
  bool _isLoading = false;

  // Méthode pour ajouter une nouvelle destination et prix
  void addDestinationAndPrix() {
    // Créer un nouveau contrôleur pour chaque champ
    TextEditingController newDestinationController = TextEditingController();
    TextEditingController newPrixController = TextEditingController();

    setState(() {
      // Ajouter les nouveaux contrôleurs aux listes
      destinationControllers.add(newDestinationController);
      prixControllers.add(newPrixController);


    });
  }

  void _handleButtonPress() async {
    // Afficher l'indicateur de chargement
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    prixParDestinations = {};
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

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: formkey,
                  child: Column(
                    children: [
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
                            "Etat du véhicule",
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
                          controller: _etatController,
                          decoration: InputDecoration(
                            hintText: "Etat du véhicule",
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Destination et prix",
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: List.generate(
                                destinationControllers.length,
                                (index) => Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: destinationControllers[index],
                                        decoration: InputDecoration(
                                          hintText: "Destination",
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 20,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: prixControllers[index],
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          hintText: "Prix",
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 20,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Appeler la méthode pour ajouter une destination et un prix
                                    addDestinationAndPrix();
                                  },
                                  icon: Icon(Icons.add),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: destinationPrixFields,
                      ),
                      SizedBox(
                        child: IconButton(
                          onPressed: _showImageSourceDialog,
                          icon: const Icon(
                            Icons.add_a_photo_rounded,
                            size: 60,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () async {
                            final String nom = widget.nomV;
                            final String description =widget.description;
                            // final String prix = _prixController.text;
                            final String capacite = widget.capacite;
                            final String etat = _etatController.text;
                            final String localite = widget.localite;
                            final String nbKilometrage =widget.nbKilo;
                            final TypeVoiture type = widget.typeVoiture;
      
                            setState(() {
                              for (int i = 0;
                                  i < destinationControllers.length;
                                  i++) {
                                String destination =
                                    destinationControllers[i].text;
                                int prix =
                                    int.tryParse(prixControllers[i].text) ?? 0;
      
                                // Ajouter la destination et le prix à la nouvelle map
                                if (destination.isNotEmpty && prix > 0) {
                                  prixParDestinations.addAll({destination: prix});
                                }
                              }
                            });
      
                            if (formkey.currentState!.validate()) {
                              try {
                                setState(() {
                                  _isLoading = true;
                                });
                                if (photo != null && type == null) {
                                  await VehiculeService()
                                      .addVehicule(
                                          nomVehicule: nom,
                                          capaciteVehicule: capacite,
                                          localisation: localite,
                                          description: description,
                                          nbKilometrage: nbKilometrage,
                                          prixParDestination: prixParDestinations,
                                          etatVehicule: etat,
                                          typeVoiture: type,
                                          acteur: acteur)
                                      .then((value) => {
                                            Provider.of<VehiculeService>(context,
                                                    listen: false)
                                                .applyChange(),
                                           
                                            _etatController.clear(),
                                            setState(() {
                                              _isLoading = false;
                                             
                                            }),
                                            Navigator.of(context).pop(),
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Row(
                                                  children: [
                                                    Text(
                                                        "vehicule ajouté avec succèss"),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 5),
                                              ),
                                            )
                                          })
                                      .catchError((onError) =>
                                          {print(onError.toString())});
                                } else {
                                  await VehiculeService()
                                      .addVehicule(
                                          nomVehicule: nom,
                                          capaciteVehicule: capacite,
                                          prixParDestination: prixParDestinations,
                                          description: description,
                                          nbKilometrage: nbKilometrage,
                                          localisation: localite,
                                          etatVehicule: etat,
                                          typeVoiture: type,
                                          acteur: acteur)
                                      .then((value) => {
                                            Provider.of<VehiculeService>(context,
                                                    listen: false)
                                                .applyChange(),
                                            // _nomController.clear(),
                                            // _descriptionController.clear(),
                                            // _prixController.clear(),
                                            // _capaciteController.clear(),
                                            _etatController.clear(),
                                            setState(() {
                                              _isLoading = false;
                                              // typeVoiture == null;
                                            }),
                                             Navigator.of(context).pop(),
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Row(
                                                  children: [
                                                    Text(
                                                        "vehicule ajouté avec succèss"),
                                                  ],
                                                ),
                                                duration: Duration(seconds: 5),
                                              ),
                                            )
                                          })
                                      .catchError((onError) =>
                                          {print(onError.toString())});
                                }
                              } catch (e) {
                                final String errorMessage = e.toString();
                                print(errorMessage);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Text("Une erreur s'est produit"),
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
                          ))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
