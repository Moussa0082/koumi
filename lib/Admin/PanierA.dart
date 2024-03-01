import 'package:flutter/material.dart';

class PanierA extends StatefulWidget {
  const PanierA({super.key});

  @override
  State<PanierA> createState() => _PanierAState();
}

class _PanierAState extends State<PanierA> {
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
              "Panier",
             
            )));
  }
}
