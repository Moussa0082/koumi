import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/screens/RegisterEndScreen.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:path/path.dart';


import 'package:shimmer/shimmer.dart';

class RegisterNextScreen extends StatefulWidget {

  String nomActeur, email,telephone;
  late List<TypeActeur> typeActeur;
    
 


   RegisterNextScreen({super.key, required this.nomActeur, required this.email, required this.telephone,  required this.typeActeur});

  @override
  State<RegisterNextScreen> createState() => _RegisterNextScreenState();
}

class _RegisterNextScreenState extends State<RegisterNextScreen> {



      final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String maillon = "";
  
  String telephone = "";
  String adresse = "";
  String localisation = "";
  bool _obscureText = true;

  String? paysValue;
  late Pays monPays;
  late Future _mesPays;
  File? image1;
  String? image1Src;

  // Valeur par défaut
  String selectedOption = "Option 1";

  TextEditingController localisationController = TextEditingController();
  TextEditingController maillonController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
  TextEditingController paysController = TextEditingController();
  TextEditingController adresseController = TextEditingController();


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
      this.image1 = image;
      image1Src = image.path;
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
    // TODO: implement initState
    super.initState();
    String typeActeurNames = '';
for (TypeActeur typeActeur in widget.typeActeur) {
  typeActeurNames += typeActeur.libelle + ', ';
}

debugPrint("Nom complet : ${widget.nomActeur}, Téléphone : ${widget.telephone}, Email : ${widget.email}, Types d'acteurs : $typeActeurNames");
 
  _mesPays  =
        http.get(Uri.parse('http://10.0.2.2:9000/pays/read'));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Alignement vertical en haut
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              SizedBox(height: 15,),
              Align(
                alignment: Alignment.topLeft,
                child:  IconButton(
               onPressed: () {
                 // Fonction de retour
                 Navigator.pop(context);
               },
               icon: Icon(
                 Icons.arrow_back,
                 color: Colors.black,
                 size: 30,
               ),
               iconSize: 30,
               splashRadius: 20,
               padding: EdgeInsets.zero,
               constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                          ),
              ),
           Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    SizedBox(
      height:100,
      width: 200, // Spécifiez une largeur fixe pour le conteneur
      child: (image1 == null) ?
        Center(child: Image.asset('assets/images/logo-pr.png')) :
        SizedBox(
          height: 100,
          width:100,
          child: Image.file(
            image1!,
            height:100,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
    ),
  ],
),

           const SizedBox(height: 5,),
            GestureDetector(
              onTap: (){
                _showImageSourceDialog();
              },
              child: Text("Choisir le logo", style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold,
                        
                ),
                ),
            ),
          
             Form(
              key:_formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
             const SizedBox(height: 10,),
              // debut fullname 
              Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Text("Adresse  *", style: TextStyle(color: (Colors.black), fontSize: 18),),
              ),
              TextFormField(
                  controller: adresseController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: "Votre adresse",
                      hintText: "Entrez votre adresse de residence",
                      
                      ),
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Veillez entrez votre adresse de residence";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => adresse = val!,
                ),
                // fin  adresse fullname
               
                    const SizedBox(height: 10,),
              //Email debut 
              Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Text("Maillon ", style: TextStyle(color: (Colors.black), fontSize: 18),),
              ),
              TextFormField(
                  controller: maillonController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: "Maillon",
                      hintText: "Entrez votre maillon",
                     
                      ),
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Veillez entrez votre maillon";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => maillon = val!,
                ),
                // fin  adresse email
                    const SizedBox(height: 10,),
             
                    Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Text("Localisation", style: TextStyle(color: (Colors.black), fontSize: 18),),
              ),
              TextFormField(
                  controller: localisationController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: "Localisation",
                      hintText: "Votre localisation ",
                      
                      ),
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Veillez entrez votre localisation";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => localisation = val!,
                ),
                // fin  localisation 
                const SizedBox(height: 10,),
             
                // debut whatsApp acteur 
                
                    Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Text("Numéro WhtasApp", style: TextStyle(color: (Colors.black), fontSize: 18),),
              ),
              TextFormField(
                  controller: whatsAppController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: "Numero whatsApp",
                      hintText: "Votre numéro whtas app ",
                      
                      ),
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                     if (val == null || val.isEmpty ) {
                        return "Veillez entrez votre numéro de téléphone";
                      } 
                      else if (val.length< 8) {
                        return "Veillez entrez 8 au moins chiffres";
                      } 
                      else if (val.length> 11) {
                        return "Le numéro ne doit pas depasser 11 chiffres";
                      } 
                      else {
                        return null;
                      }
                  },
                  onSaved: (val) => localisation = val!,
                ),
                // fin whatsApp acteur 
                   
                     Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Text("Pays *", style: TextStyle(color: (Colors.black), fontSize: 18),),
              ),
             
              //  selcet le niveau 3 pays 
                       Container(
              height:70,
              width:double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:SizedBox(
                  child: FutureBuilder(
                                      future: _mesPays,
                                      builder: (_, snapshot) {
                                                  List<DropdownMenuItem<String>> dropdownItems = [];
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Shimmer.fromColors(
                                                  baseColor: const Color.fromARGB(185, 224, 224, 224)!,
                                            highlightColor: Colors.grey[100]!,
                                            child: DropdownButton(
                                              dropdownColor: Colors.orange,
                                                items: [], onChanged: (value) {}
                                                          
                                            ),
                                          );
                                        }else {
                              dropdownItems.add(DropdownMenuItem(
                                child: Text('Aucun pays disponible'),
                                value: null,
                              ));
                            }
                                        if (snapshot.hasError) {
                                          return Text("${snapshot.error}");
                                        }
                                        if (snapshot.hasData) {
                                          //debugPrint(snapshot.data.body.toString());
                                          final  reponse  =
                                          json.decode((snapshot.data.body))
                                          as List;
                                          final mesPays = reponse
                                              .map((e) =>Pays.fromMap(e))
                                              .where((e)=> e.statutPays == true)
                                              .toList();
                                          //debugPrint(mesCategories.length.toString());
                                          return DropdownButton(
                                              items: mesPays
                                                  .map((e) => DropdownMenuItem(
                                                child: Text(e.nomPays, style:TextStyle(fontWeight: FontWeight.bold)),
                                                value: e.idPays,
                                              ),)
                                                  .toList(),
                                              
                                              value: paysValue,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  paysValue = newValue;
                                                  monPays = mesPays
                                                      .firstWhere((element) =>
                                                  element.idPays ==
                                                      newValue);
                                                  debugPrint(
                                                      monPays.idPays.toString());
                                                });
                                              });
                                        }
                                        return DropdownButton(
                                            items: const [], onChanged: (value) {});
                                      },
                                    )
                ),
              ),
            ),
              //end select  
                           const  SizedBox(height: 10,),
             
                Center(
                  child: ElevatedButton(
                           onPressed: () {
              // Handle button press action here
              if(_formKey.currentState!.validate()){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>  RegisterEndScreen(
                nomActeur: widget.nomActeur, email: widget.email, telephone: widget.telephone, 
                typeActeur: widget.typeActeur, adresse:adresseController.text, maillon:maillonController.text,
                numeroWhatsApp: whatsAppController.text, localistaion: localisationController.text,
                 pays: paysController.text,
                )));
              }
                           },
           child: Text(
              " Suivant ",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
                           ),
                           style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8A00), // Orange color code
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minimumSize: Size(250, 40),
                           ),
                         ),
                    ),
             
                           ],
             )),
          
            ],
          ),
        ),
      ),
    );
  }
}