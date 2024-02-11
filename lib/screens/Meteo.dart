import 'package:flutter/material.dart';

class Meteo extends StatefulWidget {
  const Meteo({super.key});

  @override
  State<Meteo> createState() => _MeteoState();
}

class _MeteoState extends State<Meteo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Meteo"),
    );
  }
}