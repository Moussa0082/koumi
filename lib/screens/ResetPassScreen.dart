import 'package:flutter/material.dart';
import 'package:koumi_app/screens/LoginScreen.dart';

class ResetPassScreen extends StatefulWidget {
  const ResetPassScreen({super.key});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  
  String password = "";
   bool _obscureText = true;
   String confirmPassword = "";


  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
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
            Center(child: Image.asset('assets/images/fg-pass.png')),
            // connexion
               const Text(" Saisisser votre nouveau mot de passe  ", style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold , color: Color(0xFFF2B6706)),),
             Form(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const SizedBox(height: 10,),
              // debut mot de passe
                 Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Text("Nouveau mot de passe", style: TextStyle(color: (Colors.black), fontSize: 18),),
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
                  keyboardType: TextInputType.phone,
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
                child: Text("Confirm mot de passe", style: TextStyle(color: (Colors.black), fontSize: 18),),
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
                  keyboardType: TextInputType.phone,
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
              // fin confirm password            
            ],
            ),
          ),
        
             const SizedBox(height: 15,),
                Center(
                  child: ElevatedButton(
            onPressed: () {
              // Handle button press action here
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen() ));
            },
            child:  Text(
              " Modifier ",
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
            ]
                ),
              )
    )
    );
  }

}