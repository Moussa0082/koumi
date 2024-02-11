import 'package:flutter/material.dart';
import 'package:koumi_app/screens/RegisterEndScreen.dart';
import 'package:koumi_app/screens/RegisterScreen.dart';

class RegisterNextScreen extends StatefulWidget {
  const RegisterNextScreen({super.key});

  @override
  State<RegisterNextScreen> createState() => _RegisterNextScreenState();
}

class _RegisterNextScreenState extends State<RegisterNextScreen> {



  String maillon = "";
  
  String telephone = "";
  String adresse = "";
  String localisation = "";
  bool _obscureText = true;

   List<String> options = ["Option 1", "Option 2", "Option 3"];

  // Valeur par défaut
  String selectedOption = "Option 1";

  TextEditingController localisationController = TextEditingController();
  TextEditingController maillonController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
  TextEditingController adresseController = TextEditingController();


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
                  controller: localisationController,
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
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: DropdownButton<String>(
              menuMaxHeight: 90,
                           isExpanded: true,
                           value: selectedOption,
                           items: options.map((option) {
                    return  DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                    });
              },
                           
             ),
                         ),
              //end select  
                           const  SizedBox(height: 10,),
             
                Center(
                  child: ElevatedButton(
                           onPressed: () {
              // Handle button press action here
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const RegisterEndScreen()));
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