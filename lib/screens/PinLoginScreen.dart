 import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:http/http.dart' as http;

import 'package:koumi_app/widgets/BottomNavBarAdmin.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
 

    String enteredPin = '';
  bool isPinVisible = false;
  bool isLoading= false;
  
   late SharedPreferences prefs;

//   Future<Acteur> connexionActeurWithPin(String codeActeur, String password) async {
//   final Uri uri = Uri.parse('http://votre_api/pinLogin?codeActeur=$codeActeur&password=$password');

//   try {
//     final response = await http.get(uri);

//     if (response.statusCode == 200) {
//       // Si la requête réussit, retournez le corps de la réponse converti en un objet Acteur
//       return acteurFromJson(response.body);
//     } else {
//       // Si la requête échoue, lancez une exception avec le statut de la réponse
//       throw Exception('Failed to load data, status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     // Si une erreur se produit lors de l'envoi de la requête, lancez une exception avec le message d'erreur
//     throw Exception('Failed to load data: $e');
//   }
// }

  _handleButtonPress () async{
  setState(() {
    isLoading = true;
  });
  await loginUser().then((_){
   setState(() {
     isLoading = false;
   });
  });
 }


   Future<void> loginUser() async {


    // const String baseUrl = 'https://koumi.ml/api-koumi/acteur/login';
    const String baseUrl = 'http://10.0.2.2:9000/api-koumi/acteur/pinLogin';

    const String defaultProfileImage = 'assets/images/profil.jpg';

    ActeurProvider acteurProvider =
        Provider.of<ActeurProvider>(context, listen: false);
        prefs = await SharedPreferences.getInstance();

   // Récupérer le codeActeur depuis SharedPreferences
  String? codeActeur = prefs.getString('codeActeur');

  // Vérifier si le codeActeur est présent dans SharedPreferences
  if (codeActeur == null || codeActeur.isEmpty) {
    // Afficher une erreur si le codeActeur est manquant
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Erreur')),
          content: const Text(
            "Code acteur non trouvé dans les préférences de l'utilisateur",
            textAlign: TextAlign.justify,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
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
    return;
  }

  // Construire l'URL de l'API avec le codeActeur récupéré
  final Uri apiUrl = Uri.parse('$baseUrl?codeActeur=$codeActeur&password=$enteredPin');

  try {
    final response = await http.get(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    );

      if (response.statusCode == 200) {
       
        final responseBody = json.decode(utf8.decode(response.bodyBytes));


        // Sauvegarder les données de l'utilisateur dans shared preferences
       prefs = await SharedPreferences.getInstance();
        final password = responseBody['password'];
        final emailActeur = responseBody['emailActeur'];
        prefs.setString('emailActeur', emailActeur);
        prefs.setString('password', password);
        // prefs.setString('nomActeur', responseBody['nomActeur']);
        // Vérifier si l'image de profil est présente, sinon, enregistrer l'image par défaut dans SharedPreferences

        // if (logoActeur == null) {
        //   prefs.setString('logoActeur', defaultProfileImage);
        // }
        // if (photoSiegeActeur == null) {
        //   prefs.setString('photoSiegeActeur', defaultProfileImage);
        // }
        final nomActeur = responseBody['nomActeur'];
        final idActeur = responseBody['idActeur'];
        final adresseActeur = responseBody['adresseActeur'];
        final telephoneActeur = responseBody['telephoneActeur'];
        final whatsAppActeur = responseBody['whatsAppActeur'];

        final niveau3PaysActeur = responseBody['niveau3PaysActeur'];
        final localiteActeur = responseBody['localiteActeur'];

        prefs.setString('nomActeur', nomActeur);
        prefs.setString('idActeur', idActeur);
        //  prefs.setString('resetToken', responseBody['resetToken']);
        //  prefs.setString('codeActeur', responseBody['codeActeur']);
        prefs.setString('adresseActeur', adresseActeur);
        prefs.setString('telephoneActeur', telephoneActeur);
        prefs.setString('whatsAppActeur', whatsAppActeur);

        prefs.setString('niveau3PaysActeur', niveau3PaysActeur);
        prefs.setString('localiteActeur', localiteActeur);
        // Enregistrer la liste des types d'utilisateur dans SharedPreferences

        // Enregistrer la liste des types d'utilisateur dans SharedPreferences

        List<dynamic> typeActeurData = responseBody['typeActeur'];
        List<TypeActeur> typeActeurList =
            typeActeurData.map((data) => TypeActeur.fromMap(data)).toList();
// Extraire les libellés des types d'utilisateur et les ajouter à une nouvelle liste de chaînes
        List<String> userTypeLabels =
            typeActeurList.map((typeActeur) => typeActeur.libelle!).toList();

// Enregistrer la liste des libellés des types d'utilisateur dans SharedPreferences
        prefs.setStringList('userType', userTypeLabels);
        Acteur acteur = Acteur(
          idActeur: responseBody['idActeur'],
          nomActeur: responseBody['nomActeur'],
          adresseActeur: responseBody['adresseActeur'],
          // codeActeur: responseBody['codeActeur'],
          telephoneActeur: responseBody['telephoneActeur'],
          whatsAppActeur: responseBody['whatsAppActeur'],
          niveau3PaysActeur: responseBody['niveau3PaysActeur'],
          dateAjout: responseBody['dateAjout'],
          localiteActeur: responseBody['localiteActeur'],
          emailActeur: emailActeur,
          statutActeur: responseBody['statutActeur'],
          typeActeur: typeActeurList,
          password: password,
        );

        acteurProvider.setActeur(acteur);

        final List<String> type =
            acteur.typeActeur!.map((e) => e.libelle!).toList();
        if (type.contains('admin') || type.contains('Admin')) {
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const BottomNavBarAdmin()),
);

        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavigationPage()),
          );
        }
      } else {
        // Traitement en cas d'échec
                            enteredPin = '';
                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(
                                                                                content: Center(child: Text("Code pin incorrecte ")),
                                                                                duration: Duration(seconds: 2),
                                                                              ),
                                                                            );
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final errorMessage = responseBody['message'];
        print(errorMessage);
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: const Center(child: Text('Connexion échouée !')),
        //       content: Text(
        //         'Coe pin incorrect',
        //         // errorMessage,
        //         textAlign: TextAlign.justify,
        //         style: const TextStyle(color: Colors.black, fontSize: 20),
        //       ),
        //       actions: <Widget>[
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //           child: const Text('OK'),
        //         ),
        //       ],
        //     );
        //   },
        // );
      }
    } catch (e) {
      // Gérer les exceptionn
      debugPrint(e.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Erreur')),
            content: const Text(
              "Une erreur s'est produite veuillez vérifier votre connexion internet", // Afficher l'exception
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
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
  }


  /// this widget will be use for each digit
  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: () {
          setState(()  {
            if (enteredPin.length < 6) {
              enteredPin += number.toString();
            }

            debugPrint("Pin : $enteredPin");
    
          });
            if (enteredPin.length == 6) {
              _handleButtonPress();
            }
        },
        child: Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios))),
        backgroundColor: const Color(0xFFFFFFFF),
        body: SafeArea(
      minimum: EdgeInsets.only(top: 20),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 50,),
              const Center(
                child: Text(
                  'Entrer votre code pin',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 105),
          
              /// pin code area
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6,
                  (index) {
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      width: isPinVisible ? 40 : 16,
                      height: isPinVisible ? 40 : 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: index < enteredPin.length
                            ? isPinVisible
                                ? Colors.green
                                : CupertinoColors.activeBlue
                            : CupertinoColors.activeBlue.withOpacity(0.1),
                      ),
                      child: isPinVisible && index < enteredPin.length
                          ? Center(
                              child: Text(
                                enteredPin[index],
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : null,
                    );
                  },
                ),
              ),
          
              /// visiblity toggle button
              IconButton(
                onPressed: () {
                  setState(() {
                    isPinVisible = !isPinVisible;
                  });
                },
                icon: Icon(
                  isPinVisible ? Icons.visibility_off : Icons.visibility,
                ),
              ),
          
              SizedBox(height: isPinVisible ? 50.0 : 8.0),
          
              /// digits
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      3,
                      (index) => numButton(1 + 3 * i + index),
                    ).toList(),
                  ),
                ),
          
              /// 0 digit with back remove
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextButton(onPressed: null, child: SizedBox()),
                    numButton(0),
                    TextButton(
                      onPressed: () {
                        setState(
                          () {
                            if (enteredPin.isNotEmpty) {
                              enteredPin =
                                  enteredPin.substring(0, enteredPin.length - 1);
                            }
                           debugPrint("Pin : $enteredPin");
          
                          },
                        );
                      },
                      child: const Icon(
                        Icons.backspace,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
          
          
              /// reset button
              TextButton(
                onPressed: () {
                  setState(() {
                    enteredPin = '';
                    if(enteredPin.length < 1){
              Get.snackbar("Alerte", "Le champ de saisi est déjà vide !");
                    }
                  });
                },
                child: const Text(
                  'Réinitialiser',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  

}