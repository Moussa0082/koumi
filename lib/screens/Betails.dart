import 'package:flutter/material.dart';

class Betails extends StatefulWidget {
  const Betails({super.key});

  @override
  State<Betails> createState() => _BetailsState();
}

class _BetailsState extends State<Betails> {
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
              "Betail",
            )));
  }
}