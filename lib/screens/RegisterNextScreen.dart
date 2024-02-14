import 'package:flutter/material.dart';
import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/screens/RegisterEndScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterNextScreen extends StatefulWidget {

  String nomActeur, email,telephone;
  late TypeActeur typeActeur;
    
     


   RegisterNextScreen({super.key, required this.nomActeur, required this.email, required this.telephone,  required this.typeActeur});

  @override
  State<RegisterNextScreen> createState() => _RegisterNextScreenState();
}

class _RegisterNextScreenState extends State<RegisterNextScreen> {



  String maillon = "";
  
  String telephone = "";
  String adresse = "";
  String localisation = "";
  bool _obscureText = true;

  String? paysValue;
  late Pays monPays;
  late Future _mesPays;

  // Valeur par défaut
  String selectedOption = "Option 1";

  TextEditingController localisationController = TextEditingController();
  TextEditingController maillonController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
    TextEditingController paysController = TextEditingController();
  TextEditingController adresseController = TextEditingController();


    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("Nom complet : " + widget.nomActeur + 
    "telephone : " + widget.telephone + " Email :" + widget.email +  "type " + widget.typeActeur.libelle );
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
               
                
                          
            Center(child: Image.asset('assets/images/logo-pr.png')),
               ],
              ),
           const SizedBox(height: 5,),
            Text("Completer votre profil", style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold,
          
              ),
              ),
          
             Form(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                    if (val == null || val.isEmpty) {
                      return "Veillez entrez votre numéro whats app";
                    } else {
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
                                          final mesPays = reponse
                                              .map((e) =>Pays.fromMap(e))
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>  RegisterEndScreen(
                nomActeur: widget.nomActeur, email: widget.email, telephone: widget.telephone, 
                typeActeur: widget.typeActeur, adresse:adresseController.text, maillon:maillonController.text,
                numeroWhatsApp: whatsAppController.text, localistaion: localisationController.text,
                 pays: paysController.text,
                )));
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