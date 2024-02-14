import 'package:flutter/material.dart';

class ProfilA extends StatefulWidget {
  const ProfilA({super.key});

  @override
  State<ProfilA> createState() => _ProfilAState();
}

class _ProfilAState extends State<ProfilA> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('profil'),
    );
  }
}