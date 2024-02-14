import 'package:flutter/material.dart';

class ActeurScreen extends StatefulWidget {
  const ActeurScreen({super.key});

  @override
  State<ActeurScreen> createState() => _ActeurScreenState();
}

class _ActeurScreenState extends State<ActeurScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Acteur'),
    );
  }
}