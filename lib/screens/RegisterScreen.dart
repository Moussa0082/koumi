import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/models/TypeActeur.dart';
// import 'package:koumi_app/models/TypeActeur.dart';
import 'package:http/http.dart' as http;

import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/screens/RegisterNextScreen.dart';
import 'package:shimmer/shimmer.dart';

class RegisterScreen extends StatefulWidget {

   
   RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  String nomActeur = "";
  String telephone = "";
  String email = "";
  String? typeValue;
  late TypeActeur monTypeActeur;
  late Future _mesTypeActeur;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String _errorMessage = "";

    String dropdownvalue = 'Item 1';    
  
  // List of items in our dropdown menu 
  var items = [     
    'Item 2', 
    
  ]; 

  TextEditingController nomActeurController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController typeActeurController = TextEditingController();

   void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email ne doit pas être vide";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Email non valide";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }


   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mesTypeActeur  =
        http.get(Uri.parse('http://10.0.2.2:9000/typeActeur/read'));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
              Center(child: Image.asset('assets/images/logo.png', height: 200, width: 100,)),
               Container(
                 height: 40,
                 decoration: BoxDecoration(
                   color: Color.fromARGB(255, 240, 178, 107),
                 ),
                 child: Center(
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    const  Text("J'ai déjà un compte .",
                     style: TextStyle(color: Colors.white, fontSize: 18, 
                     fontWeight: FontWeight.bold),),
                     const SizedBox(width: 4,),
                     GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
                      },
                      child: const Text("Se connecter", 
                      style: TextStyle(color: Colors.blue, 
                      fontSize: 18, 
                      fontWeight: FontWeight.bold) ,
                       ),
                       ),
                    ],
                 ),
                 
                 ),
                 
               ),
               const SizedBox(height: 10,),
                 const Text("Inscription", style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold , color: Color(0xFFF2B6706)),),
               Form(
                key:_formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const SizedBox(height: 10,),
                // debut fullname 
                Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Nom Complet *", style: TextStyle(color:  (Colors.black), fontSize: 18),),
                ),
                TextFormField(
                    controller: nomActeurController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        // labelText: "Nom Complet",
                        hintText: "Entrez votre prenom et nom",
                       
                        ),
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veillez entrez votre prenom et nom";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => nomActeur = val!,
                  ),
                  // fin  adresse fullname
  
                      const SizedBox(height: 10,),
                //Email debut 
                Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Email *", style: TextStyle(color:  (Colors.black), fontSize: 18),),
                ),
                Center(
                  child: Text(_errorMessage),
                ),
                TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        // labelText: "Email",
                        hintText: "Entrez votre email",
                        ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veillez entrez votre email";
                      } else if(_errorMessage == "Email non valide"){
                        return "Veillez entrez une email valide";
                      }
                      else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                        validateEmail(val);
                      },
                    onSaved: (val) => email = val!,
                  ),
                  // fin  adresse email
                      const SizedBox(height: 10,),

                      Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Téléphone *", style: TextStyle(color: (Colors.black), fontSize: 18),),
                ),
                TextFormField(
                    controller: telephoneController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        // labelText: "Téléphone",
                        hintText: " (+223) XX XX XX XX ",
                       
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
                    onSaved: (val) => telephone = val!,
                  ),
                  // fin  téléphone 
              const SizedBox(height: 10,),
                       Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Type Acteur *", style: TextStyle(color: (Colors.black), fontSize: 18),),
                ),

                const SizedBox(height: 5),

                //  selcet type acteur 
                 
          Container(
  height: 70,
  width: double.infinity,
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: FutureBuilder(
      future: _mesTypeActeur,
      builder: (_, snapshot) {
        try {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: DropdownButton(
                dropdownColor: Colors.orange,
                items: [],
                onChanged: (value) {},
              ),
            );
          }
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          if (snapshot.hasData) {
            final reponse = json.decode((snapshot.data.body)) as List;
            final mesType = reponse
                .map((e) => TypeActeur.fromMap(e))
                .where((typeActeur) =>
                    typeActeur.statutTypeActeur == true &&
                    typeActeur.libelle != 'Admin') // Filtrer les types d'acteurs actifs et différents de l'administrateur
                .toList();

            List<DropdownMenuItem<String>> dropdownItems = [];

            if (mesType.isNotEmpty) {
              dropdownItems = mesType
                  .map((e) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          e.libelle,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: e.idTypeActeur,
                      ))
                  .toList();
            } else {
              dropdownItems.add(DropdownMenuItem(
                child: Text('Aucun type d\'acteur disponible'),
                value: null,
              ));
            }
            return DropdownButton(
              alignment: AlignmentDirectional.center,
              items: dropdownItems,
              value: typeValue,
              onChanged: (newValue) {
                setState(() {
                  typeValue = newValue;
                  if (newValue != null) {
                    monTypeActeur = mesType.firstWhere(
                        (element) => element.idTypeActeur == newValue);
                    debugPrint(monTypeActeur.idTypeActeur.toString());
                  }
                });
              },
            );
          }
          return Text('Aucune donnée disponible');
        } catch (e) {
          // Gérer l'absence de connexion ici
          return Center(child: Text('Type d\'acteur non disponible,\n verifier votre connexion internet ', style: TextStyle(fontSize: 15),));
        }
      },
    ),
  ),
),


                //end select type acteur 
     const  SizedBox(height: 10,),

                  Center(
                    child: ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                 
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  
                RegisterNextScreen(nomActeur: nomActeurController.text, email: emailController.text,
                 telephone: telephoneController.text, typeActeur: [monTypeActeur],) ));
              
                }
               },
              child:  Text(
                " Suivant ",
                style:  TextStyle(
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
      ),
    );
  }


   

}

