import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';
import 'package:koumi_app/screens/ResetPassScreen.dart';
import 'package:koumi_app/service/ActeurService.dart';

class CodeConfirmScreen extends StatefulWidget {
   final bool? isVisible;
   final String? emailActeur;
   final String? whatsAppActeur;
   CodeConfirmScreen({super.key, this.isVisible, this.emailActeur, this.whatsAppActeur});

  @override
  State<CodeConfirmScreen> createState() => _CodeConfirmScreenState();
}

class _CodeConfirmScreenState extends State<CodeConfirmScreen> {
 bool _isMounted = false;
  
     
  String email = "";
  String otpCode = "";

   int _time = 120;
late Timer timere;
  String pinCode = '';

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
   

    if (widget.isVisible!) {
      await ActeurService.verifyOtpCodeEmail(widget.emailActeur!, pinCode, context);
      debugPrint("Code virifier par mail");
    hideLoadingDialog(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => CodeConfirmScreen(isVisible:widget.isVisible!, emailActeur: widget.emailActeur!, whatsAppActeur: widget.whatsAppActeur!)));
    } else {
      await ActeurService.verifyOtpCodeWhatsApp(widget.whatsAppActeur!, pinCode, context);
      debugPrint("Code verifier par whats app");
    hideLoadingDialog(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassScreen(isVisible:widget.isVisible!, emailActeur: widget.emailActeur!,whatsAppActeur: widget.whatsAppActeur!)));
    }

    // Fermez la boîte de dialogue de chargement après l'envoi du code
  } catch (e) {
    // En cas d'erreur, fermez également la boîte de dialogue de chargement
    hideLoadingDialog(context);
    // Gérez l'erreur ici
  }
 }
  

void startTimer() {
  timere = Timer.periodic(const Duration(seconds: 1), (timer) {
    setState(() {
      if (_time > 0) {
        _time--;
      } else {
        timere.cancel();
      }
    });
  });
}

 // Fonction pour imprimer le code PIN saisi dans la console
void printPinCode() {
  for (var controller in otpControllers) {
    pinCode += controller.text;
  }
  print('Code saisi: $pinCode');
}

String get timerText {
  int minutes = _time ~/ 60;
  int seconds = _time % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}


    @override
  void initState() {
   startTimer();
    super.initState();
    _isMounted = false;
    
  }
  
  void _safeSetState(Function() fn) {
  if (_isMounted) {
    setState(fn);
  }
}

  TextEditingController codeController = TextEditingController();
  // TextEditingController Controller = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/logo-pr.png',
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                 widget.isVisible! ? "Entrer le code envoyer à votre email" : "Entrer le code envoyer par whatsApp",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  padding: EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(child: _textFieldOTP(first: true, last: false, index:0)),
    Expanded(child: _textFieldOTP(first: false, last: false, index:1)),
    Expanded(child: _textFieldOTP(first: false, last: false, index:2)),
    Expanded(child: _textFieldOTP(first: false, last: true, index:3)),
  ],
),
                      SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                           onPressed: () async {
                  // Imprimer le code saisi
                //   if(otpCode.length <3){
                //      ScaffoldMessenger.of(context).showSnackBar(
                // SnackBar(
                //   content: Text('Veuillez saisir 4 chiffres.'),
                //   duration: Duration(seconds: 2),
                //  ),
                // );
                //   }
                handleSendButton(context);
                  printPinCode();
    
                       },
                          
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.orange),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Verifier',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
               
                
                 Center(child: Text("Expire dans " + "$timerText", style: TextStyle(fontSize: 15),)), 
                 SizedBox(width: 10,),
               
            
                 Text(
                  "Vous n'avez pas reçu code?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),

                Text(
                  "Envoyer à nouveau",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 // Fonction pour construire un champ de texte OTP
// Déclarer une liste de contrôleurs de texte pour chaque champ de texte OTP
List<TextEditingController> otpControllers = List.generate(4, (index) => TextEditingController());

// Fonction pour construire un champ de texte OTP
Widget _textFieldOTP({required bool first, bool? last, required int index}) {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: Container(
      height: 70,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          controller: otpControllers[index], // Utiliser le contrôleur de texte correspondant
          onChanged: (value) {
            // Mettre à jour la valeur dans le contrôleur de texte
            otpControllers[index].text = value;
            otpControllers[index].selection = TextSelection.fromPosition(
              TextPosition(offset: value.length),
            );

            // Vérifier si la longueur du code saisie est de 1
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.orange),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    ),
  );
}


}