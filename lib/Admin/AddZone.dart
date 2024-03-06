import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/ZoneProductionService.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddZone extends StatefulWidget {
  const AddZone({super.key});

  @override
  State<AddZone> createState() => _AddZoneState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AddZoneState extends State<AddZone> {
  final formkey = GlobalKey<FormState>();
  TextEditingController nomController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  String? imageSrc;
  File? photo;
  late Acteur acteur;
  
  @override
  void initState() {
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    super.initState();
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
        title: const Text(
          "Ajouter d'une Zone",
          style: TextStyle(
              color: d_colorGreen,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: photo != null
                  ? Image.file(
                      photo!,
                       fit: BoxFit.fitWidth,
                      height: 150,
                      width: 300,
                    )
                  : Image.asset(
                      "assets/images/zoneProd.jpg",
                       fit: BoxFit.fitWidth,
                      height: 150,
                      width: 300,
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Nom de la zone",
                      style: TextStyle(color: (Colors.black), fontSize: 18),
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
                      controller: nomController,
                      decoration: InputDecoration(
                        hintText: "Nom de la zone",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 10),
                  const Text(
                    "Latitude",
                    style: TextStyle(color: (Colors.black), fontSize: 18),
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
                      controller: latitudeController,
                      decoration: InputDecoration(
                        hintText: "Latitude",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 10),
                  const Text(
                    "Longitude",
                    style: TextStyle(color: (Colors.black), fontSize: 18),
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
                      controller: longitudeController,
                      decoration: InputDecoration(
                        hintText: "Longitude",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: IconButton(
                        onPressed: _showImageSourceDialog,
                        icon: const Icon(
                          Icons.add_a_photo_rounded,
                          size: 100,
                        ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                      onPressed: () async {
                        final String nom = nomController.text;
                        final String latitude = latitudeController.text;
                        final String longitude = longitudeController.text;
                        print("acteur : ${acteur.toString()}");
                       
                        try {
                         
                          if (photo == null) {
                            await ZoneProductionService()
                                .addZone(
                                    nomZoneProduction: nom,
                                    latitude: latitude,
                                    longitude: longitude,
                                    acteur: acteur)
                                .then((value) => {
                                      Provider.of<ZoneProductionService>(
                                              context,
                                              listen: false)
                                          .applyChange(),
                                      nomController.clear(),
                                      latitudeController.clear(),
                                      longitudeController.clear(),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Row(
                                            children: [
                                              Text("Ajouter avec succèss"),
                                            ],
                                          ),
                                          // duration: const Duration(seconds: 5),
                                        ),
                                      ),
                                      Navigator.of(context).pop(),
                                    })
                                .catchError((onError) {
                              print(onError.message);
                            });
                          } else {
                            await ZoneProductionService()
                                .addZone(
                                    nomZoneProduction: nom,
                                    latitude: latitude,
                                    longitude: longitude,
                                    photoZone: photo,
                                    acteur: acteur)
                                .then((value) => {
                                      Provider.of<ZoneProductionService>(
                                              context,
                                              listen: false)
                                          .applyChange(),
                                      nomController.clear(),
                                      latitudeController.clear(),
                                      longitudeController.clear(),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Row(
                                            children: [
                                              Text("Ajouter avec succèss"),
                                            ],
                                          ),
                                          // duration: const Duration(seconds: 5),
                                        ),
                                      ),
                                      Navigator.of(context).pop(),
                                    })
                                .catchError((onError) {
                              print(onError.toString());
                            });
                          }
                        } catch (e) {
                          print(e.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Row(
                                children: [
                                  Text("Cette zone est existe déjà"),
                                ],
                              ),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: d_colorGreen, // Orange color code
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(290, 45),
                      ),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Ajouter",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              ))
        ]),
      ),
    );
  }
}
