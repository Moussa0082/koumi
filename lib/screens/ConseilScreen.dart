import 'package:flutter/material.dart';

class ConseilScreen extends StatefulWidget {
  const ConseilScreen({super.key});

  @override
  State<ConseilScreen> createState() => _ConseilScreenState();
}

class _ConseilScreenState extends State<ConseilScreen> {
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
              "Conseil",
            )));
  }
}