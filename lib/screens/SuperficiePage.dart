import 'package:flutter/material.dart';

class SuperficiePage extends StatefulWidget {
  const SuperficiePage({super.key});

  @override
  State<SuperficiePage> createState() => _SuperficiePageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _SuperficiePageState extends State<SuperficiePage> {
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
            icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
        title: const Text(
          "Supercifie cultiver",
          style: TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}