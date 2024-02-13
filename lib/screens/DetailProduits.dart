import 'package:flutter/material.dart';
import 'package:koumi_app/models/Stock.dart';

class DetailProduits extends StatefulWidget {
  final Stock stock;
  const DetailProduits({super.key, required this.stock});

  @override
  State<DetailProduits> createState() => _DetailProduitsState();
}

class _DetailProduitsState extends State<DetailProduits> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
