import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/MagasinService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';


class AddMagasinScreen extends StatefulWidget {
  const AddMagasinScreen({super.key});

  @override
  State<AddMagasinScreen> createState() => _AddMagasinScreenState();
}

class _AddMagasinScreenState extends State<AddMagasinScreen> {
  
   late Acteur acteur;
   String nomMagasin = "";
   String contactMagasin = "";
   String niveau3PaysMagasin = "";
   String localiteMagasin = "";

     File? photos;
  String? imageSrc;

  late Niveau1Pays niveau1Pays;
  bool _isLoading = false;

   List<String> regions = [];
    String? niveauPaysValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController nomMagasinController = TextEditingController();
    TextEditingController contactMagasinController = TextEditingController();
    TextEditingController localiteMagasinController = TextEditingController();


  List<Map<String, dynamic>> regionsData = [];

    late Future niveau1PaysList;


  Set<String> loadedRegions = {}; // Ensemble pour garder une trace des régions pour lesquelles les magasins ont déjà été chargés

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

   void _handleButtonPress() async{
  // Afficher l'indicateur de chargement
  setState(() {
    _isLoading = true;
  });

   await addMagasin().then((_) {
    // Cacher l'indicateur de chargement lorsque votre fonction est terminée
    setState(() {
      _isLoading = false;
    });
  });

    
   
   
  }


   Future<void> addMagasin() async{
     final nomMagasin = nomMagasinController.text;
                            final contactMagasin = contactMagasinController.text;
                            final localiteMagasin = localiteMagasinController.text;
                            MagasinService magasinService = MagasinService();
                            try {
                              if(photos != null){
                              await magasinService.creerMagasin(
                                nomMagasin: nomMagasin,
                               contactMagasin: contactMagasin,
                                localiteMagasin: localiteMagasin, 
                                acteur: acteur ,
                                photo: photos,
                                niveau1Pays: niveau1Pays
                                ).then((value) => 
                                
                                 showDialog(
            context:  context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Center(child: Text('Succès')),
                content:const  Text("Magasin ajouté avec succès"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                        },
                    child:const  Text('OK'),
                  ),
                ],
              );
            },
           )
                                );
          
                      }else{
                              
                        await magasinService.creerMagasin(
                          nomMagasin: nomMagasin, 
                          contactMagasin: contactMagasin, 
                          localiteMagasin: localiteMagasin,
                            acteur: acteur, 
                            niveau1Pays: niveau1Pays);
                      }
                            } catch (e) {
                              debugPrint("Erreur : $e");
                                 showDialog(
            context:  context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Center(child: Text('Erreur')),
                content:  Text("Une erreur s'est produite veuiller réessayer : $e"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                 },
                    child:const  Text('OK'),
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
  void initState() {
    super.initState();
   acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    niveau1PaysList = http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/niveau1Pays/read'));

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
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(10),
          child: Container(
            child: Form(
            key: _formKey,
              child:
             Column(
              children: [
        
                // Nom magasin 
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Nom Magasin *", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                ),
              TextFormField(
                controller:nomMagasinController,
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
                controller: contactMagasinController,
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
                controller:localiteMagasinController,
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
                         const SizedBox(height: 15,),
                          FutureBuilder(
                          future: niveau1PaysList,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
        return Text("${snapshot.error}");
            }
            if (snapshot.hasData) {
        final response = json.decode(snapshot.data.body) as List;
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
                niveau1Pays = niveau1PaysList.firstWhere(
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
        
                  GestureDetector(
                    onTap: (){
                      _showImageSourceDialog();
                    },
                    child: (photos == null) ?
                    Image.asset("assets/images/cam.png"):
                    Image.file(
                    photos!,
                    height:100,
                    width: 200,
                    fit: BoxFit.cover,
                      ),
                    ),
                         
                         const SizedBox(height: 10,),
                        Center(
                        child: ElevatedButton(
                          onPressed: () async{
                            // Handle button press action here
                           if(_formKey.currentState!.validate()){
                          final nomMagasin = nomMagasinController.text;
                            final contactMagasin = contactMagasinController.text;
                            final localiteMagasin = localiteMagasinController.text;

                            if(photos != null){
                                try {
        
                              await MagasinService().creerMagasin(
                                nomMagasin: nomMagasin,
                               contactMagasin: contactMagasin,
                                localiteMagasin: localiteMagasin, 
                                acteur: acteur ,
                                photo: photos,
                                niveau1Pays: niveau1Pays
                                );
                           }catch(e){
                              print(e.toString());
                           }
                          
                            }else{
                              try {
        
                              await MagasinService().creerMagasin(
                                nomMagasin: nomMagasin,
                               contactMagasin: contactMagasin,
                                localiteMagasin: localiteMagasin, 
                                acteur: acteur ,
                                niveau1Pays: niveau1Pays
                                );
                           }catch(e){
                              print(e.toString());
                           }
                            }   
                          
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
      ),
    );
  }
}
