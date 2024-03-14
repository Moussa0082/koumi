import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeVoiture.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/VehiculeService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddVehiculeTransport extends StatefulWidget {
  final TypeVoiture? typeVoitures;
  const AddVehiculeTransport({
    super.key,
    this.typeVoitures,
  });

  @override
  State<AddVehiculeTransport> createState() => _AddVehiculeTransportState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AddVehiculeTransportState extends State<AddVehiculeTransport> {
  TextEditingController _prixController = TextEditingController();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _capaciteController = TextEditingController();
  TextEditingController _etatController = TextEditingController();
  TextEditingController _localiteController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  late Map<String, int> prixParDestinations;
  final formkey = GlobalKey<FormState>();
  String? imageSrc;
  String? typeValue;
  late Future _typeList;
  late TypeVoiture typeVoiture;
  late TypeVoiture type;
  File? photo;
  late Acteur acteur;
  bool _isLoading = false;

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
    type = widget.typeVoitures!;
    _typeList = http.get(Uri.parse(
        'http://10.0.2.2:9000/api-koumi/TypeVoiture/listeByActeur/${acteur.idActeur!}'));
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
            'Ajout de véhicule transport',
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                // height: 150,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: photo != null
                        ? Image.file(
                            photo!,
                            fit: BoxFit.fitWidth,
                            height: 150,
                            width: 300,
                          )
                        : Container()),
              ),
              SizedBox(
                height: 30,
              ),
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
                            "Nom du véhicule",
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
                      type == null
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 22,
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Type de véhicule",
                                  style: TextStyle(
                                      color: (Colors.black), fontSize: 18),
                                ),
                              ),
                            )
                          : Container(),
                      type == null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: FutureBuilder(
                                future: _typeList,
                                builder: (_, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return DropdownButtonFormField(
                                      items: [],
                                      onChanged: null,
                                      decoration: InputDecoration(
                                        labelText:
                                            'Aucun type de véhicule trouvé',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                      final vehiculeList = reponse
                                          .map((e) => TypeVoiture.fromMap(e))
                                          .where(
                                              (con) => con.statutType == true)
                                          .toList();

                                      if (vehiculeList.isEmpty) {
                                        return DropdownButtonFormField(
                                          items: [],
                                          onChanged: null,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Aucun type de véhicule trouvé',
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        );
                                      }

                                      return DropdownButtonFormField<String>(
                                        items: vehiculeList
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e.idTypeVoiture,
                                                child: Text(e.nom),
                                              ),
                                            )
                                            .toList(),
                                        value: typeValue,
                                        onChanged: (newValue) {
                                          setState(() {
                                            typeValue = newValue;
                                            if (newValue != null) {
                                              typeVoiture =
                                                  vehiculeList.firstWhere(
                                                (element) =>
                                                    element.idTypeVoiture ==
                                                    newValue,
                                              );
                                            }
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText:
                                              'Sélectionner un type de véhicule',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 20),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return DropdownButtonFormField(
                                        items: [],
                                        onChanged: null,
                                        decoration: InputDecoration(
                                          labelText:
                                              'Aucun type de véhicule trouvé',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 20),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  return DropdownButtonFormField(
                                    items: [],
                                    onChanged: null,
                                    decoration: InputDecoration(
                                      labelText:
                                          'Aucun type de véhicule trouvé',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(),
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
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez remplir les champs";
                            }
                            return null;
                          },
                          controller: _localiteController,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "Ex : Bamako, segou",
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
                            "Capacité de la véhicule",
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
                          controller: _capaciteController,
                          decoration: InputDecoration(
                            hintText: "capacité",
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
                            "Etat du véhicule",
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
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Destination et prix",
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _destinationController,
                                decoration: InputDecoration(
                                  hintText: "Destination",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _prixController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  hintText: "Prix",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  String destination =
                                      _destinationController.text;
                                  int prix =
                                      int.tryParse(_prixController.text) ?? 0;

                                  if (destination.isNotEmpty && prix > 0) {
                                    // Ajouter la destination et le prix à la liste prixParDestinations
                                    prixParDestinations
                                        .addAll({destination: prix});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Text(
                                                "Prix et destination ajouté à la liste"),
                                          ],
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                    print(prixParDestinations.toString());

                                    _destinationController.clear();
                                    _prixController.clear();
                                  }
                                });
                              },
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                            final String nom = _nomController.text;
                            final String description =
                                _descriptionController.text;
                            final String prix = _prixController.text;
                            final String capacite = _capaciteController.text;
                            final String etat = _etatController.text;
                            final String localite = _localiteController.text;

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
                                          prixParDestination:
                                              prixParDestinations,
                                          etatVehicule: etat,
                                          typeVoiture: typeVoiture,
                                          acteur: acteur)
                                      .then((value) => {
                                            Provider.of<VehiculeService>(
                                                    context,
                                                    listen: false)
                                                .applyChange(),
                                            _nomController.clear(),
                                            _descriptionController.clear(),
                                            _prixController.clear(),
                                            _capaciteController.clear(),
                                            _etatController.clear(),
                                            setState(() {
                                              _isLoading = false;
                                              typeVoiture == null;
                                            }),
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
                                          prixParDestination:
                                              prixParDestinations,
                                          localisation: localite,
                                          etatVehicule: etat,
                                          typeVoiture: type,
                                          acteur: acteur)
                                      .then((value) => {
                                            Provider.of<VehiculeService>(
                                                    context,
                                                    listen: false)
                                                .applyChange(),
                                            _nomController.clear(),
                                            _descriptionController.clear(),
                                            _prixController.clear(),
                                            _capaciteController.clear(),
                                            _etatController.clear(),
                                            setState(() {
                                              _isLoading = false;
                                              typeVoiture == null;
                                            }),
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
