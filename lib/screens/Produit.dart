import 'package:flutter/material.dart';
import 'package:koumi_app/screens/Betails.dart';
import 'package:koumi_app/screens/Cereales.dart';
import 'package:koumi_app/screens/Fruits.dart';
import 'package:koumi_app/screens/Legumes.dart';

class Produit extends StatefulWidget {
  const Produit({super.key});

  @override
  State<Produit> createState() => _ProduitState();
}

const d_color = Color.fromRGBO(254, 243, 231, 1);

class _ProduitState extends State<Produit> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Produit par catégorie"),
          backgroundColor: d_color,
          bottom: const TabBar(
            indicatorColor: Colors.red, // Couleur de l'indicateur d'onglet
            labelColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(Icons.grass_outlined),
                child: Text(
                  'Céreales',
                ),
              ),
              Tab(
                icon: Icon(Icons.local_florist),
                child: Text('Fruits'),
              ),
              Tab(
                icon: Icon(Icons.eco),
                child: Text('Légumes'),
              ),
              Tab(
                icon: Icon(Icons.pets),
                child: Text('Bétails'),
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [Cereales(), Fruits(), Legumes(), Betails()],
        ),
      ),
    );
  }
}
