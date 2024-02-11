import 'package:flutter/material.dart';

class RegisterEndScreen extends StatefulWidget {
  const RegisterEndScreen({super.key});

  @override
  State<RegisterEndScreen> createState() => _RegisterEndScreenState();
}

class _RegisterEndScreenState extends State<RegisterEndScreen> {



  String maillon = "";
  String password = "";
  String confirmPassword = "";
  String telephone = "";
  String adresse = "";
  String filiere = "";
  String localisation = "";
  bool _obscureText = true;

   List<String> options = ["Option 1", "Option 2", "Option 3"];

  // Valeur par défaut
  String selectedOption = "Option 1";

  TextEditingController localisationController = TextEditingController();
  TextEditingController entrepriseController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
  TextEditingController adresseController = TextEditingController();


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
                    const SizedBox(height: 5,),
                Container(
                 child: Row(
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
                ),
              Center(child: Image.asset('assets/images/logo-pr.png', height: 300, width: 150,)),
              //  Container(
              //    height: 40,
              //    decoration: BoxDecoration(
              //      color: Color.fromARGB(255, 240, 178, 107),
              //    ),
              //    child: Center(
              //      child: Row(
              //        mainAxisAlignment: MainAxisAlignment.center,
              //      children: [
              //       const  Text("J'ai déjà un compte .", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
              //        const SizedBox(width: 4,),
              //        GestureDetector(child: const Text("Se connecter", style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold) , )),
              //       ],
              //    ),
                 
              //    ),
                 
              //  ),
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
                    controller: entrepriseController,
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
                  // fin  téléphone 
                  const SizedBox(height: 10,),

                  //filier 
                            Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Filiere", style: TextStyle(color: (Colors.black), fontSize: 18),),
                ),
                TextFormField(
                    controller: localisationController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: "Filière",
                        hintText: "Votre filiere ",
                        
                        ),
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veillez entrez votre filière";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => filiere = val!,
                  ),
                  // fin  téléphone 
                  const SizedBox(height: 10,),
                  // end filiere acteur 
      
               const SizedBox(height: 10,),
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
              },
              child: Text(
                " Enregistrer ",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
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