import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:koumi_app/models/CartItem.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/widgets/CustomText.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:koumi_app/widgets/SnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Panier extends StatefulWidget{
    

   Panier({super.key});

  @override
  State<Panier> createState() => _PanierState();
}

class _PanierState extends State<Panier> {


    // int itemCount = widget.cartItems?.length ?? 0;

    

   List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartString = prefs.getString('cart') ?? '[]';
    List<Map<String, dynamic>> cart = List<Map<String, dynamic>>.from(jsonDecode(cartString));
    setState(() {
      _cartItems = cart;
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index]['quantiteProduit']++;
    });
    _saveCart();
  }

  void _decrementQuantity(int index) {
    if (_cartItems[index]['quantiteProduit'] > 1) {
      setState(() {
        _cartItems[index]['quantiteProduit']--;
      });
      _saveCart();
    }
  }

  Future<void> _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartString = jsonEncode(_cartItems);
    prefs.setString('cart', cartString);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
        centerTitle:true,
      ),
      body: ListView.builder(
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: Image.asset("assets/images/mang.jpg") ,
                // leading: Image.network(_cartItems[index]['image'] ?? "assets/images/mang.jpg") ,
                title: Text(_cartItems[index]['nomProduit']),
                subtitle: Row(
                    mainAxisAlignment :MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children:[

                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => _decrementQuantity(index),
                    ),
                    Text('${_cartItems[index]['quantiteProduit']}', style:TextStyle(fontWeight:FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _incrementQuantity(index),
                    ),
                      ]
                    ),
                  Text('${_cartItems[index]['prix']} FCFA', style:TextStyle(fontSize:18, fontStyle:FontStyle.italic))

                    
                  ],
                ),
                // trailing: Text('${_cartItems[index]['prix']} FCFA'),
              ),
            ),
          );
        },
      ),
    );
  }

}