import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class AddMagasinScreen extends StatefulWidget {
  const AddMagasinScreen({super.key});

  @override
  State<AddMagasinScreen> createState() => _AddMagasinScreenState();
}

class _AddMagasinScreenState extends State<AddMagasinScreen> {
  
  
   String nomMagasin = "";
   String contactMagasin = "";
   String niveau3PaysMagasin = "";
   String localiteMagasin = "";

     File? photo;
  String? imageSrc;

  late Niveau1Pays niveau1pays;

   List<String> regions = [];
  List<Niveau1Pays> niveau1Pays = [];
    String? niveauPaysValue;


  List<Map<String, dynamic>> regionsData = [];

    late Future niveau1PaysList;


  Set<String> loadedRegions = {}; // Ensemble pour garder une trace des régions pour lesquelles les magasins ont déjà été chargés

  void fetchRegions() async {
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      
      // Filtrer les éléments avec statutN1 == true
        setState(() {
          niveau1Pays = data
              .where((niv) => niv['statutN1'] == true)
              .map((item) => Niveau1Pays(
                    idNiveau1Pays: item['idNiveau1Pays'] as String,
                    nomN1: item['nomN1'] as String,
                  ))
              .toList();
        });
      
    } else {
      throw Exception('Failed to load regions');
    }
  } catch (e) {
    print('Error fetching regions: $e');
  }
}

      Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
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
      this.photo = image;
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
          title: Text("Photo d'identité"),
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
              const SizedBox(width:40),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 238, 234, 234),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_outlined), onPressed: (){
          Navigator.pop(context);
        },),
        centerTitle: true,
        title: Text(
          "Ajouter magasin",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(10),
        child: Container(
          child: Form(child: Column(
            children: [

              // Nom magasin 
              Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Nom Magasin *", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
              ),
            TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
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
                    const SizedBox(height:10),

                    //Contact magasin
                     Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Contact Magasin *", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
              ),
            TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
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

                    const SizedBox(height:10),

                    //Contact localiteMagasin
                     Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Localité Magasin *", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
              ),
            TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
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
                       const SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    _showImageSourceDialog();
                  },
                  child: (photo == null) ?
                  Image.asset("assets/images/cam.png"):
                  Image.file(
                  photo!,
                  height:100,
                  width: 200,
                  fit: BoxFit.cover,
                    ),
                  ),
                       const SizedBox(height: 10,),
                        FutureBuilder(
                        future: http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read')),
  builder: (_, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text("${snapshot.error}");
    }
    if (snapshot.hasData) {
      final response = json.decode(snapshot.data!.body);
      final niveau1PaysList = response
          .map((e) => Niveau1Pays.fromMap(e))
          .where((con) => con.statutN1 == true)
          .toList();
      if (niveau1PaysList.isEmpty) {
        return Text(
          'Aucun pays disponible',
          style: TextStyle(overflow: TextOverflow.ellipsis),
        );
      }

      return DropdownButtonFormField<String>(
        items: niveau1PaysList
            .map(
              (e) => DropdownMenuItem(
            value: e.idNiveau1Pays,
            child: Text(e.nomN1!),
          ),
        )
            .toList(),
        value: niveauPaysValue,
        onChanged: (newValue) {
          setState(() {
            niveauPaysValue = newValue;
            if (newValue != null) {
              niveau1pays = niveau1PaysList.firstWhere(
                      (element) => element.idNiveau1Pays == newValue);
              debugPrint(
                  "con select ${niveau1Pays.toString()}");
              // typeSelected = true;
            }
          });
        },
                              decoration: InputDecoration(
                                labelText: 'Sélectionner un sous région',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }
                          return Text(
                            'Aucune donnée disponible',
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          );
                        },
                      ),
                       const SizedBox(height: 10,),
                      Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle button press action here
                         
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFFF8A00), // Orange color code
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: const Size(250, 40),
                        ),
                        child: const Text(
                          " Ajouter ",
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
    );
  }
}
