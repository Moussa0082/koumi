import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/service/ActeurService.dart';

class ResetPassScreen extends StatefulWidget {
   final bool? isVisible;
   final String? emailActeur;
   final String? whatsAppActeur;
   ResetPassScreen({super.key, this.isVisible, this.emailActeur, this.whatsAppActeur});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  
  String password = "";
   bool _obscureText = true;
   String confirmPassword = "";



  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
   



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

   // Fonction pour vérifier la connectivité réseau
   Future<bool> checkInternetConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
   }

// Fonction pour afficher un message d'erreur si la connexion Internet n'est pas disponible
      void showNoInternetDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Erreur de connexion'),
        content: const Text('Veuillez vérifier votre connexion Internet et réessayer.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

   // Fonction pour gérer le bouton Envoyer
void handleSendButton(BuildContext context) async {
  bool isConnected = await checkInternetConnectivity();
  if (!isConnected) {
    showNoInternetDialog(context);
    return;
  }

  // Si la connexion Internet est disponible, poursuivez avec l'envoi du code
  // Affichez la boîte de dialogue de chargement
  showLoadingDialog(context);

  try {
    

            
    if (widget.isVisible!) {
      debugPrint("Code envoyé par mail");
     await ActeurService.resetPasswordEmail(widget.emailActeur!, passwordController.text);

    hideLoadingDialog(context);
        // Gérez le cas où l'email ou le mot de passe est vide.
        showDialog(
          context:  context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(child: Text('Erreur')),
              content:const  Text("Mot de passe modifier avec succès"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen() ));
                  },
                  child:const  Text('OK'),
                ),
              ],
            );
          },
        );
    } else {
             await ActeurService.resetPasswordWhatsApp(widget.whatsAppActeur!, passwordController.text);
      debugPrint("Code envoyé par whats app");
    hideLoadingDialog(context);
         showDialog(
          context:  context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(child: Text('Succès')),
              content:const  Text("Mot  de passe modifier avec succès"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen() ));
                  },
                  child:const  Text('OK'),
                ),
              ],
            );
          },
        );
    }

    // Fermez la boîte de dialogue de chargement après l'envoi du code
  } catch (e) {
    // En cas d'erreur, fermez également la boîte de dialogue de chargement
    hideLoadingDialog(context);
       showDialog(
          context:  context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(child: Text('Erreur')),
              content:  Text("Erreur : $e"),
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
    // Gérez l'erreur ici
  }
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
            onPressed: () async{
              // Handle button press action here
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
              title: const Center(child: Text('Erreur')),
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
    handleSendButton(context);
             
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