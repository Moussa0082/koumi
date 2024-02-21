import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/screens/CodeConfirmScreen.dart';
import 'package:koumi_app/service/ActeurService.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> with AutomaticKeepAliveClientMixin<ForgetPassScreen>{
     // Override wantKeepAlive to return true
  @override
  bool get wantKeepAlive => true;

     
  String email = "";
  String whatsApp = "";
  
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
    ActeurService acteurService = ActeurService();
    final emailActeur = emailController.text;
    final whatsAppActeur = whatsAppController.text;
    // if(){

    // }

    if (isVisible) {
      await ActeurService.sendOtpCodeEmail(emailActeur,context);
      debugPrint("Code envoyé par mail");
    hideLoadingDialog(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => CodeConfirmScreen(isVisible:isVisible, emailActeur: emailController.text, whatsAppActeur: whatsAppController.text)));
    } else {
      await ActeurService.sendOtpCodeWhatsApp(whatsAppActeur,context);
      debugPrint("Code envoyé par whats app");
    hideLoadingDialog(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => CodeConfirmScreen(isVisible:isVisible, emailActeur: emailController.text,whatsAppActeur: whatsAppController.text)));
    }

    // Fermez la boîte de dialogue de chargement après l'envoi du code
  } catch (e) {
    // En cas d'erreur, fermez également la boîte de dialogue de chargement
    hideLoadingDialog(context);
    // Gérez l'erreur ici
  }
}


   
  TextEditingController emailController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
   bool isVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isVisible = !isVisible;
  }

  @override
  Widget build(BuildContext context) {
     super.build(context);
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
               const Text(" Mot de passe oublier  ", style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold , color: Color(0xFFF2B6706)),),
             Form(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const SizedBox(height: 10,),
              // debut email ou whats app  
              Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Text( isVisible ? " Email *" : "Whats App *" , style: TextStyle(color:  (Colors.black), fontSize: 18),),
              ),

          Visibility(
  visible: isVisible, 
  child: TextFormField(
    controller: emailController,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      labelText: "Email",
      hintText: "Entrez votre adresse email",
    ),
    keyboardType: TextInputType.text,
    validator: (val) {
      if (val == null || val.isEmpty) {
        return "Veillez entrez votre adresse email";
      } else {
        return null;
      }
    },
    onSaved: (val) => email = val!,
  ),
),
Visibility(
  visible: !isVisible, 
  child: TextFormField(
    controller: whatsAppController,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      labelText: "Numéro WhatsApp",
      hintText: "Entrez votre numéro WhatsApp",
    ),
    keyboardType: TextInputType.phone,
    validator: (val) {
      if (val == null || val.isEmpty) {
        return "Veillez entrez votre numéro WhatsApp";
      } else {
        return null;
      }
    },
    onSaved: (val) => whatsApp = val!,
  ),
),

              
            ],
            ),
          ),

          TextButton(
  onPressed: ()  {

      setState(() {
        isVisible = !isVisible;
      });
    
  },
  child: Text(
    isVisible ? "Envoyer le code par WhatsApp" : "Envoyer le code par email",
    style: TextStyle(fontSize: 16),
  ),
),
             const SizedBox(height: 15,),
                Center(
                  child: ElevatedButton(
            onPressed: ()  {

              handleSendButton(context);
            },
            child:  Text(
              " Envoyer ",
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