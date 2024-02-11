import 'package:flutter/material.dart';

class AlerteScreen extends StatefulWidget {
  const AlerteScreen({super.key});

  @override
  State<AlerteScreen> createState() => _AlerteScreenState();
}

class _AlerteScreenState extends State<AlerteScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Alerte"),
    );
  }
}