import 'dart:io';

import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';



import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/screens/RegisterEndScreen.dart';
import 'package:koumi_app/service/ActeurService.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';

class RegisterEndScreen extends StatefulWidget {

    String nomActeur, email,telephone, adresse , maillon , localistaion, numeroWhatsApp , pays;
   late List<TypeActeur> typeActeur;
  //  late List<TypeActeur> idTypeActeur;

   RegisterEndScreen({
   super.key, required this.nomActeur, 
   required this.email, required this.telephone, 
   required this.typeActeur, required this.adresse, 
   required this.maillon, required this.numeroWhatsApp,
   required this.localistaion, required this.pays});

  @override
  State<RegisterEndScreen> createState() => _RegisterEndScreenState();
}

class _RegisterEndScreenState extends State<RegisterEndScreen> {

 bool isLoading = false;
   

  String password = "";
  String confirmPassword = "";
  
  String filiere = "";
  bool _obscureText = true;

  String? image1Src;
  String? image2Src;
  File? image1;
  File? image2;

  TextEditingController filiereController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
            Center(child: Image.asset('assets/images/logo-pr.png')),
           const SizedBox(height: 5,),
            Text("Completer votre profil", style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold,
        
              ),
              ),
             Form(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                      return "Veillez entrez votre nouveau mot de passe";
                    }
                    if (val.length < 4) {
                      return 'Le mot de passe doit contenir au moins 4 caractères';
                    } else {
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
                child: Text("Mot de passe", style: TextStyle(color: (Colors.black), fontSize: 18),),
              ),
              // debut  mot de pass
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: "Confirmer mot de passe",
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
                    } else {
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
            onPressed: isLoading
      ? null // Désactiver le bouton lorsque le chargement est en cours
      : () async {
        setState(() {
          isLoading = true; // Afficher le CircularProgressIndicator
        });
              // Handle button press action here
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
  
  // utilisateur = utilisateur;
  
      // if(_formKey.currentState!.validate()){

  // Utilize your backend service to send the request
  ActeurService acteurService = ActeurService();
   // Si widget.typeActeur est bien une liste de TypeActeur

try {

          // String type = typeActeurList.toString();
  if(image1 != null && image2 != null){
    
    await acteurService.creerActeur(
    logoActeur: image1 as File,
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
  }

  // Do something with the updated demand if needed
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
  // print("Demande envoyée avec succès: ${updatedDemande.toString()}");
  debugPrint("yes ");
  // Navigate to the next page if necessary
  // BuildContext context = this.context;
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
} finally {
          // Après la requête (réussie ou non), masquez le CircularProgressIndicator
          setState(() {
            isLoading = false;
          });
        }
                            // }
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