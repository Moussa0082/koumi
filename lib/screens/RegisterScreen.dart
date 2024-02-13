import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:koumi_app/models/TypeActeur.dart';
// import 'package:koumi_app/models/TypeActeur.dart';
import 'package:http/http.dart' as http;

import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/screens/RegisterNextScreen.dart';

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


  List<String> options = ["Option 1", "Option 2", "Option 3"];

  // Valeur par défaut
  String selectedOption = "Option 1";

  TextEditingController nomActeurController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController typeActeurController = TextEditingController();

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
               Form(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                        labelText: "Nom Complet",
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
                TextFormField(
                    controller: nomActeurController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: "Email",
                        hintText: "Entrez votre email",
                        // icon: const Icon(
                        //   Icons.mail,
                        //   color: Color(0xFFF2B6706),
                        //   size: 20,
                        // )
                        ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veillez entrez votre email";
                      } else {
                        return null;
                      }
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
                        labelText: "Téléphone",
                        hintText: " (+223) XX XX XX XX ",
                       
                        ),
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veillez entrez votre numéro de téléphone";
                      } else {
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
              height:70,
              width:double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:SizedBox(
                  child: FutureBuilder(
                                      future: _mesTypeActeur,
                                      builder: (_, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return DropdownButton(
                                            dropdownColor: Colors.orange,
                                              items: [], onChanged: (value) {}
              
                                          );
                                        }
                                        if (snapshot.hasError) {
                                          return Text("${snapshot.error}");
                                        }
                                        if (snapshot.hasData) {
                                          //debugPrint(snapshot.data.body.toString());
                                          final  reponse  =
                                          json.decode((snapshot.data.body))
                                          as List;
                                          final mesType = reponse
                                              .map((e) => TypeActeur.fromMap(e))
                                              .toList();
                                          //debugPrint(mesCategories.length.toString());
                                          return DropdownButton(
                                              items: mesType
                                                  .map((e) => DropdownMenuItem(
                                                child: Text(e.libelle, style:TextStyle(fontWeight: FontWeight.bold)),
                                                value: e.idTypeActeur,
                                              ))
                                                  .toList(),
                                              value: typeValue,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  typeValue = newValue;
                                                  monTypeActeur = mesType
                                                      .firstWhere((element) =>
                                                  element.idTypeActeur ==
                                                      newValue);
                                                  debugPrint(
                                                      monTypeActeur.idTypeActeur.toString());
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
                //end select type acteur 
     const  SizedBox(height: 10,),

                  Center(
                    child: ElevatedButton(
              onPressed: () {

                // Handle button press action here
                // if (widget.typeActeur != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  
                RegisterNextScreen(nomActeur: nomActeur, email: email,
                 telephone: telephone, libelle:monTypeActeur.libelle) ));
              //  } 
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


