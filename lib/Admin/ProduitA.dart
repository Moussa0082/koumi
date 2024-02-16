import 'package:flutter/material.dart';

class ProduitA extends StatefulWidget {
  const ProduitA({super.key});

  @override
  State<ProduitA> createState() => _ProduitAState();
}

class _ProduitAState extends State<ProduitA> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Produit'),
    );
  }
}