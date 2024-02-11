import 'package:flutter/material.dart';
import 'package:koumi_app/screens/RegisterEndScreen.dart';

class RegisterEndScreen extends StatefulWidget {
  const RegisterEndScreen({super.key});

  @override
  State<RegisterEndScreen> createState() => _RegisterEndScreenState();
}

class _RegisterEndScreenState extends State<RegisterEndScreen> {



  String password = "";
  String confirmPassword = "";
  
  String filiere = "";
  bool _obscureText = true;

   List<String> options = ["Option 1", "Option 2", "Option 3"];

  // Valeur par défaut
  String selectedOption = "Option 1";

  TextEditingController filiereController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


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
                      // icon: const Icon(
                      //   Icons.lock_outline,
                      //   color: Color(0xFF9A6ABB),
                      //   size: 20,
                      // )
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
            onPressed: () {
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