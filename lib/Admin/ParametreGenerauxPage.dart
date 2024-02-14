import 'package:flutter/material.dart';

class ParametreGenerauxPage extends StatefulWidget {
  const ParametreGenerauxPage({super.key});

  @override
  State<ParametreGenerauxPage> createState() => _ParametreGenerauxPageState();
}

class _ParametreGenerauxPageState extends State<ParametreGenerauxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parametre generaux"),
      ),
    );
  }
}