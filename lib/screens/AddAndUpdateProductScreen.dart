
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Filiere.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddAndUpdateProductEndScreen.dart';
import 'package:path_provider/path_provider.dart' ;
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class AddAndUpdateProductScreen extends StatefulWidget {
  bool? isEditable ;
   AddAndUpdateProductScreen({super.key, this.isEditable});

  @override
  State<AddAndUpdateProductScreen> createState() => _AddAndUpdateProductScreenState();
}

 const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AddAndUpdateProductScreenState extends State<AddAndUpdateProductScreen> {

     final formkey = GlobalKey<FormState>();
     TextEditingController _prixController = TextEditingController();
     TextEditingController _quantiteController = TextEditingController();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _formController = TextEditingController();
  TextEditingController _origineController = TextEditingController();

  late Acteur acteur;
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late TextEditingController _searchController;
  List<Filiere> filiereListe = [];
   String? imageSrc;
  File? photo;

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
  void initState() {
    // acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    // typeActeurData = acteur.typeActeur!;
    // type = typeActeurData.map((data) => data.libelle).join(', ');
    _searchController = TextEditingController();

    super.initState();
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
            widget.isEditable! ?  'Modifier de produit' :  'Ajout de produit' ,
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
         ),
      body: SingleChildScrollView(
        child: Column(children: [
          // const SizedBox(height: 10),
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
          //             color: Colors.blueGrey[400]), // Couleur de l'icône
          //         SizedBox(
          //             width:
          //                 10), // Espacement entre l'icône et le champ de recherche
          //         Expanded(
          //           child: TextField(
          //             controller: _searchController,
          //             onChanged: (value) {
          //               setState(() {});
          //             },
          //             decoration: InputDecoration(
          //               hintText: 'Rechercher',
          //               border: InputBorder.none,
          //               hintStyle: TextStyle(
          //                   color: Colors
          //                       .blueGrey[400]), // Couleur du texte d'aide
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 10),
          Column(
            children: [
              // SizedBox(
              //   // height: 150,
              //   child: Padding(
              //       padding: const EdgeInsets.only(left: 10.0),
              //       child: photo != null
              //           ? Image.file(
              //               photo!,
              //               fit: BoxFit.fitWidth,
              //               height: 100,
              //               width: 150,
              //             )
              //           : Container()),
              // ),
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
                            "Nom produit",
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
                            hintText: "Nom produit",
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
                            "Forme produit",
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
                              return "Veuillez remplir le champ forme du produit";
                            }
                            return null;
                          },
                          controller: _formController,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "Forme produit",
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
                            "Origine du produit",
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
                              return "Veuillez remplir le champ origine du produit";
                            }
                            return null;
                          },
                          controller: _origineController,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "Ex : Bamako, Kayes",
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
                            "Prix du produit",
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
                              return "Veuillez saisir le prix du produit";
                            }
                            return null;
                          },
                          controller: _prixController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: "Prix du produit",
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
                            "Quantite Produit",
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
                              return "Veuillez saisir la quantite du produit";
                            }
                            return null;
                          },
                          controller: _quantiteController,
                          keyboardType: TextInputType.text,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: "Quantite produit",
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
                      
                      SizedBox(
                        child: photo != null
                        ? Image.file(
                            photo!,
                            fit: BoxFit.fitWidth,
                            height: 100,
                            width: 150,
                          )
                        :  IconButton(
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
                            // final String nom = _nomController.text;
                            // final String description =
                            //     _descriptionController.text;
                            // final String prix = _prixController.text;
                            // final String capacite = _capaciteController.text;
                            // final String etat = _etatController.text;
                            // final String localite = _localiteController.text;

                            // if (formkey.currentState!.validate()) {
                              Get.to(AddAndUpdateProductEndSreen(isEditable: false,));
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange, // Orange color code
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: const Size(290, 45),
                          ),
                          child: Text(
                           widget.isEditable! ? "Modifier": "Ajouter"  ,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          
                            SizedBox(
                        height: 10,
                      ),

                    ],
                  ))
            ],
          ),
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