import 'package:flutter/material.dart';

class IntrantScreen extends StatefulWidget {
  const IntrantScreen({super.key});

  @override
  State<IntrantScreen> createState() => _IntrantScreenState();
}

class _IntrantScreenState extends State<IntrantScreen> {
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
              "Intrant",
            )));
  }
}