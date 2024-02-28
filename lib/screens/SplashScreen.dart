
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/screens/RegisterScreen.dart';
import 'package:koumi_app/widgets/AnimatedBackground.dart';
import 'package:koumi_app/widgets/BottomNavBarAdmin.dart';

import 'package:koumi_app/widgets/BottomNavigationPage.dart';

import 'package:koumi_app/widgets/AnimatedBackground.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
const d_colorPage = Color.fromRGBO(255, 255, 255, 1);

class _SplashScreenState extends State<SplashScreen> {

late Acteur acteur;

  @override
void initState() {
  super.initState();
   // Vérifie d'abord si l'email de l'acteur est présent dans SharedPreferences
    checkEmailInSharedPreferences();
  }

  void checkEmailInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailActeur = prefs.getString('emailActeur');
    if (emailActeur != null) {
      // Si l'email de l'acteur est présent, exécute checkLoggedIn
      checkLoggedIn();
    } else {
      // Si l'email de l'acteur n'est pas présent, redirige directement vers l'écran de connexion
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void checkLoggedIn() async {
  // Initialise les données de l'utilisateur à partir de SharedPreferences
  await Provider.of<ActeurProvider>(context, listen: false).initializeActeurFromSharedPreferences();

  // Récupère l'objet Acteur
  acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;

  // Vérifie si l'utilisateur est déjà connecté
  if (acteur != null) {
    // Vérifie si l'utilisateur est un administrateur
    if (acteur.typeActeur.any((type) => type.libelle == 'admin' || type.libelle == 'Admin')) {
      Timer(
        const Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BottomNavBarAdmin()),
        ),
      );
    } else {
      Timer(
        const Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BottomNavigationPage()),
        ),
      );
    }
  }
  //  else {
  //   // Redirige vers l'écran de connexion si l'utilisateur n'est pas connecté
  //   Timer(
  //     const Duration(seconds: 5),
  //     () => Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (_) => const LoginScreen()),
  //     ),
  //   );
  // }
  }





  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: d_colorPage,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
         const  AnimatedBackground(),
        const SizedBox(height:10),
          Center(child: Image.asset('assets/images/logo.png', height: 350, width: 250,)),
         CircularProgressIndicator(
          backgroundColor: (Color.fromARGB(255, 245, 212, 169)),
          color: (Colors.orange),
         ),
        ],
      ),
    );
  }
}

