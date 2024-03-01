import 'package:flutter/material.dart';

class ProduitA extends StatefulWidget {
  const ProduitA({super.key});

  @override
  State<ProduitA> createState() => _ProduitAState();
}

class _ProduitAState extends State<ProduitA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 100,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios)),
            title: const Text(
              "Produit",
            )));
  }
}