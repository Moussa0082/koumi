import 'package:flutter/material.dart';

class MagasinScreen extends StatefulWidget {
  const MagasinScreen({super.key});

  @override
  State<MagasinScreen> createState() => _MagasinScreenState();
}

class _MagasinScreenState extends State<MagasinScreen> {
  @override 
  Widget build(BuildContext context) {
    return Container(
      child: Text("Magasin"),
    );
  }
}