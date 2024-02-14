import 'package:flutter/material.dart';

class TypeActeurPage extends StatefulWidget {
  const TypeActeurPage({super.key});

  @override
  State<TypeActeurPage> createState() => _TypeActeurPageState();
}

class _TypeActeurPageState extends State<TypeActeurPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Type acteur")),
    );
  }
}
