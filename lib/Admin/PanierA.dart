import 'package:flutter/material.dart';

class PanierA extends StatefulWidget {
  const PanierA({super.key});

  @override
  State<PanierA> createState() => _PanierAState();
}

class _PanierAState extends State<PanierA> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("PanierA"),
    );
  }
}