import 'dart:io';
import 'package:path/path.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';



import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/screens/LoginSuccessScreen.dart';
import 'package:koumi_app/screens/RegisterEndScreen.dart';
import 'package:koumi_app/service/ActeurService.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';
import 'package:path_provider/path_provider.dart';

class RegisterEndScreen extends StatefulWidget {

    String nomActeur, email,telephone, adresse , maillon , localistaion, numeroWhatsApp , pays;
    File? image1;
   late List<TypeActeur> typeActeur;
  //  late List<TypeActeur> idTypeActeur;

   RegisterEndScreen({
   super.key, required this.nomActeur, 
   this.image1,
   required this.email, required this.telephone, 
   required this.typeActeur, required this.adresse, 
   required this.maillon, required this.numeroWhatsApp,
   required this.localistaion, required this.pays});

  @override
  State<RegisterEndScreen> createState() => _RegisterEndScreenState();
}

class _RegisterEndScreenState extends State<RegisterEndScreen> {

 bool isLoading = false;
   
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String password = "";
  String confirmPassword = "";
  
  String filiere = "";
  bool _obscureText = true;

  
  String? image2Src;
  File? image2;

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
      this.image2 = image;
      image2Src = image.path;
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

  TextEditingController filiereController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

                       // Fonction pour afficher la boîte de dialogue de chargement
 void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Empêche de fermer la boîte de dialogue en cliquant en dehors
    builder: (BuildContext context) {
      return const AlertDialog(
        title:  Center(child: Text('Envoi en cours')),
        content: CupertinoActivityIndicator(
          color: Colors.orange,
          radius: 22,
        ),
        actions: <Widget>[
          // Pas besoin de bouton ici
        ],
      );
    },
  );
}

// Fonction pour fermer la boîte de dialogue de chargement
void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop(); // Ferme la boîte de dialogue
}

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("Adresse : " + widget.adresse + " Maillon : " + widget.maillon + " Type : ${widget.typeActeur}"+
    " Localisation :  " + widget.localistaion + " Whats app : " + widget.numeroWhatsApp + "Email :" + widget.email
  
    );
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
                  SizedBox(height: 15,),
              Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 IconButton(
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
               ],
              ),
                       Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(
      height:100,
      width: 200, // Spécifiez une largeur fixe pour le conteneur
      child: (image2 == null) ?
        Center(child: Image.asset('assets/images/logo-pr.png')) :
        SizedBox(
          height: 50,
          child: Image.file(
            image2!,
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
              child: Text("Choisir la photo du siège", style: TextStyle(
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
              
                    Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Text("Filiere", style: TextStyle(color: (Colors.black), fontSize: 18),),
              ),
              TextFormField(
                  controller: filiereController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: "Filiere",
                      hintText: "Votre filiere ",
                      
                      ),
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Veillez entrez votre filiere";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => filiere = val!,
                ),
                // fin  filiere
                 const SizedBox(height: 10,),
                // debut mot de passe
                 Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Text("Mot de passe", style: TextStyle(color: (Colors.black), fontSize: 18),),
              ),
              // debut  mot de pass
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: "Nouveau mot de passe",
                      hintText: "Entrez votre nouveau mot de passe",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText =
                                !_obscureText; // Inverser l'état du texte masqué
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons
                                  .visibility, // Choisir l'icône basée sur l'état du texte masqué
                          color: Colors.grey,
                        ),
                      ),
                     
                      ),
                  keyboardType: TextInputType.text,
                  obscureText: _obscureText,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Veillez entrez votre  mot de passe ";
                    }
                    if (val.length < 4) {
                      return 'Le mot de passe doit contenir au moins 4 caractères';
                    } 
                    else if (val.length > 4) {
                      return 'Le mot de passe ne doit pas 4 caractères';
                    } 
                     else {
                      return null;
                    }
                  },
                  onSaved: (val) => password = val!,
                ),
                // fin mot de pass 
        
              // confirm password 
               const SizedBox(height: 10,),
                // debut mot de passe
                 Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Text("Confirm mot de passe", style: TextStyle(color: (Colors.black), fontSize: 18),),
              ),
              // debut  mot de pass
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Entrez votre confirmer votre mot de passe",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText =
                                !_obscureText; // Inverser l'état du texte masqué
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons
                                  .visibility, // Choisir l'icône basée sur l'état du texte masqué
                          color: Colors.grey,
                        ),
                      ),
                      
                      ),
                  keyboardType: TextInputType.text,
                  obscureText: _obscureText,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Veillez entrez votre  mot de passe à nouveau";
                    }
                    if (val.length < 4) {
                      return 'Le mot de passe doit contenir au moins 4 caractères';
                    } 
                    else if (val.length > 4) {
                      return 'Le mot de passe ne doit pas 4 caractères';
                    } 
                    else {
                      return null;
                    }
                  },
                  onSaved: (val) => password = val!,
                ),
                // fin mot de pass

              // fin confirm password 

              const SizedBox(height: 10,),
                Center(
                  child: ElevatedButton(

            onPressed: 
            
      //       isLoading
      // ? null // Désactiver le bouton lorsque le chargement est en cours
      // :
       () async {
        // setState(() {
        //   isLoading = true; // Afficher le CircularProgressIndicator
        // });
        if(_formKey.currentState!.validate()){

  final nomActeur = widget.nomActeur;
  final emailActeur = widget.email;
  final adresse = widget.adresse;
  final telephone = widget.telephone;
  final whatsAppActeur = widget.numeroWhatsApp;
  final maillon = widget.maillon;
  final localisation = widget.localistaion;
  final  typeActeur = widget.typeActeur;
  final pays = widget.pays;
  final filiere = filiereController.text;
  final password = passwordController.text;
  final confirmPassword = confirmPasswordController.text;
  
                  if (password != confirmPassword) {

      // Gérez le cas où l'email ou le mot de passe est vide.
       const String errorMessage = "Les mot de passe ne correspondent pas ";
        // Gérez le cas où l'email ou le mot de passe est vide.
        showDialog(
          context:  context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(child: Text('Erreur', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
              content:const  Text(errorMessage),
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
      return;
    }
  // Utilize your backend service to send the request
  ActeurService acteurService = ActeurService();
   // Si widget.typeActeur est bien une liste de TypeActeur
   showLoadingDialog(context);
try {

          // String type = typeActeurList.toString();
  if(widget.image1 != null && image2 != null){
    
    await acteurService.creerActeur(
    logoActeur: widget.image1 as File,
    photoSiegeActeur: image2 as File,
    nomActeur: nomActeur,
    adresseActeur: adresse,
    telephoneActeur: telephone,
    whatsAppActeur: whatsAppActeur,
    niveau3PaysActeur: pays,
    localiteActeur: localisation,
    emailActeur: emailActeur,
    filiereActeur: filiere,
    typeActeur: widget.typeActeur, // Convertir les IDs en chaînes de caractères
    password: password,
    maillonActeur: maillon,
  );
  hideLoadingDialog(context);
   showDialog(
          context:  context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(child: Text('Succès')),
              content:const  Text("Inscription réussi avec succès"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
 Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginSuccessScreen()),
  );                  },
                  child:const  Text('OK'),
                ),
              ],
            );
          },
        );
  }else{
    await acteurService.creerActeur(
    nomActeur: nomActeur,
    adresseActeur: adresse,
    telephoneActeur: telephone,
    whatsAppActeur: whatsAppActeur,
    niveau3PaysActeur: pays,
    localiteActeur: localisation,
    emailActeur: emailActeur,
    filiereActeur: filiere,
    typeActeur: typeActeur,
    password: password,
    maillonActeur: maillon,
  );
  hideLoadingDialog(context);
   showDialog(
          context:  context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(child: Text('Succès')),
              content:const  Text("Inscription réussi avec succès"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
 Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginSuccessScreen()),
  );                  },
                  child:const  Text('OK'),
                  
                ),
              ],
            );
          },
        );
  }
 
  // print("Demande envoyée avec succès: ${updatedDemande.toString()}");
  debugPrint("yes ");
  // Navigate to the next page if necessary
} catch (error) {
  // Handle any exceptions that might occur during the request
  final String errorMessage = error.toString();
  debugPrint("no " + errorMessage);
   showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text("Erreur lors de l'inscription"),
    content: Text(errorMessage),
    actions: [
      TextButton(
        child: Text("OK"),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  ),
);
  // print("Erreur: $error");
} 
   }
              // Handle button press action here
            },
            child: Text(
              " Enregister ",
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