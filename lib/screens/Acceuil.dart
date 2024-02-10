import 'package:flutter/material.dart';
import 'package:koumi_app/widgets/Carrousel.dart';
import 'package:koumi_app/widgets/CustomAppBar.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(appBar: CustomAppBar(),
    body: SingleChildScrollView(
      child: Column(
        children: [
             Container(
              constraints: BoxConstraints(
                  maxHeight: 400), // Définissez une hauteur maximale
              child: Carrousel(),
            ),
        ],
      ),
    ),
    
    );
  }
}
