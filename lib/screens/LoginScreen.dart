import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/ForgetPassScreen.dart';
import 'package:koumi_app/screens/RegisterScreen.dart';
import 'package:koumi_app/widgets/BottomNavBarAdmin.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String password = "";
  String email = "";
  bool _obscureText = true;
  bool light = true;
  // late Acteur acteur;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // TextEditingController Controller = TextEditingController();

  //  login methode start
  Future<void> loginUser() async {
    final String emailActeur = emailController.text;
    final String password = passwordController.text;
    const String baseUrl = 'http://10.0.2.2:9000/acteur/login';

    ActeurProvider acteurProvider =
        Provider.of<ActeurProvider>(context, listen: false);

    if (emailActeur.isEmpty || password.isEmpty) {
      const String errorMessage = "Veuillez remplir tous les champs ";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Erreur')),
            content: const Text(errorMessage),
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

    final Uri apiUrl =
        Uri.parse('$baseUrl?emailActeur=$emailActeur&password=$password');

    try {
      final response = await http.get(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(child: Text('Connexion en cours')),
              content: CupertinoActivityIndicator(
               color: (Colors.orange),
                radius: 22,
              ),
              actions: <Widget>[
                // Pas besoin de bouton ici
              ],
            );
          },
        );

        await Future.delayed(Duration(milliseconds: 1000));

        Navigator.of(context).pop();
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        emailController.clear();
        passwordController.clear();

        // Sauvegarder les données de l'utilisateur dans shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('emailActeur', emailActeur);
        prefs.setString('password', password);

        List<dynamic> typeActeurData = responseBody['typeActeur'];
        List<TypeActeur> typeActeurList =
            typeActeurData.map((data) => TypeActeur.fromMap(data)).toList();

        Acteur acteur = Acteur(
          idActeur: responseBody['idActeur'],
          resetToken: responseBody['resetToken'],
          tokenCreationDate: responseBody['tokenCreationDate'],
          codeActeur: responseBody['codeActeur'],
          nomActeur: responseBody['nomActeur'],
          adresseActeur: responseBody['adresseActeur'],
          telephoneActeur: responseBody['telephoneActeur'],
          latitude: responseBody['latitude'],
          longitude: responseBody['longitude'],
          photoSiegeActeur: responseBody['photoSiegeActeur'],
          logoActeur: responseBody['logoActeur'],
          whatsAppActeur: responseBody['whatsAppActeur'],
          niveau3PaysActeur: responseBody['niveau3PaysActeur'],
          dateAjout: responseBody['dateAjout'],
          dateModif: responseBody['dateModif'],
          personneModif: responseBody['personneModif'],
          localiteActeur: responseBody['localiteActeur'],
          maillonActeur: responseBody['maillonActeur'],
          emailActeur: emailActeur,
          filiereActeur: responseBody['filiereActeur'],
          statutActeur: responseBody['statutActeur'],
          typeActeur: typeActeurList,
          password: password,
        );
 
        acteurProvider.setActeur(acteur);

       final List<String> type =
            acteur.typeActeur.map((e) => e.libelle).toList();
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
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final errorMessage = responseBody['message'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(child: Text('Connexion échouée !')),
              content: Text(
                errorMessage, // Utiliser le message d'erreur du backend
                textAlign: TextAlign.justify,
                style: const TextStyle(color: Colors.black, fontSize: 20),
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
    } catch (e) {
      // Gérer les exceptionn
      debugPrint(e.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Erreur')),
            content: const Text(
              "Une erreur s'est produite veuillez réessayer", // Afficher l'exception
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

  Future<void> checkUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('emailActeur');
    String? passWord = prefs.getString('password');

    if (email != null && passWord != null) {
      // S'il existe des données utilisateur dans shared preferences, connectez automatiquement l'utilisateur
      emailController.text = email;
      passwordController.text = passWord;
      loginUser();
    }
  }

  @override
  void initState() {
    //  checkUserSession();
    super.initState();
  }
  // login methode end

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
                Center(
                    child: Image.asset(
                  'assets/images/logo.png',
                  height: 220,
                  width: 110,
                )),
                // connexion
                const Text(
                  " Connexion ",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xfff2b6706)),
                ),
                Form(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    // debut fullname
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Email *",
                        style: TextStyle(color: (Colors.black), fontSize: 18),
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        // labelText: "Adresse email",
                        hintText: "Entrez votre adresse email",
                        // icon: const Icon(
                        //   Icons.mail,
                        //   color: Color(0xFFF2B6706),
                        //   size: 20,
                        // )
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
                    // fin  adresse email

                    const SizedBox(
                      height: 10,
                    ),

                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Mot de passe *",
                        style: TextStyle(color: (Colors.black), fontSize: 18),
                      ),
                    ),
                    // debut  mot de pass
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        // labelText: "Mot de passe",
                        hintText: "Entrez votre mot de passe",
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
                          return "Veillez entrez votre  mot de passe";
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

                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 30,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Switch(
                                value: light,
                                activeColor: Colors.orange,
                                onChanged: (bool value) {
                                  // This is called when the user toggles the switch.
                                  setState(() {
                                    light = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "Se souvenir de moi",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgetPassScreen()));
                                  },
                                  child: const Text(
                                    "Mot de passe oublier ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue),
                                  ))),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle button press action here
                          loginUser();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFFF8A00), // Orange color code
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: const Size(250, 40),
                        ),
                        child: const Text(
                          " Se connecter ",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 240, 178, 107),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Je n'ai pas de compte .",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                             RegisterScreen()));
                              },
                              child: const Text(
                                "M'inscrire",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
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