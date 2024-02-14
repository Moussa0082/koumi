import 'package:flutter/material.dart';

class ProduitActeur extends StatefulWidget {
  const ProduitActeur({super.key});

  @override
  State<ProduitActeur> createState() => _ProduitActeurState();
}

class _ProduitActeurState extends State<ProduitActeur> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Mes produits"),
    );
  }
}