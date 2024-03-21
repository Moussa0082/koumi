
import 'package:flutter/cupertino.dart';
import 'package:koumi_app/models/Stock.dart';

class DetailProduitScreen extends StatefulWidget {
   late Stock? stock;
   DetailProduitScreen({super.key, this.stock});

  @override
  State<DetailProduitScreen> createState() => _DetailProduitScreenState();
}

class _DetailProduitScreenState extends State<DetailProduitScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}