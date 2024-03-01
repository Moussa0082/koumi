import 'package:flutter/material.dart';

class Legumes extends StatefulWidget {
  const Legumes({super.key});

  @override
  State<Legumes> createState() => _LegumesState();
}

class _LegumesState extends State<Legumes> {
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
              "Légumes",
            )));
  }
}