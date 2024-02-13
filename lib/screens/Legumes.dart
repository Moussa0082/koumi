import 'package:flutter/material.dart';

class Legumes extends StatefulWidget {
  const Legumes({super.key});

  @override
  State<Legumes> createState() => _LegumesState();
}

class _LegumesState extends State<Legumes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Legumes'),
    );
  }
}