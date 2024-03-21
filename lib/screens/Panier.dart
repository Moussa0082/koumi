import 'package:flutter/material.dart';
import 'package:koumi_app/models/CartItem.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/widgets/CustomText.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:koumi_app/widgets/SnackBar.dart';


class Panier extends StatefulWidget{
    final List<CartItem>? cartItems;
    final Stock? stock;
   final Function()? handleAddToCart;

   Panier({super.key, this.cartItems, this.stock, this.handleAddToCart});

  @override
  State<Panier> createState() => _PanierState();
}

class _PanierState extends State<Panier> {



 @override
  Widget build(BuildContext context) {
    int itemCount = widget.cartItems?.length ?? 0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        actions: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  // Action à effectuer lorsque l'utilisateur appuie sur l'icône de panier
                },
                child: Icon(Icons.shopping_cart, size: 30), // Utilisation de l'icône de panier
              ),
              if (itemCount > 0)
                Positioned(
                  top: -7,
                  right: -1,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      itemCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (itemCount < 1)
                Positioned(
                  top: -7,
                  right: -1,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
        centerTitle: true,
        toolbarHeight: 100,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        //   icon: Icon(Icons.arrow_back_ios),
        // ),
        title: Text(
          "Panier",
        ),
      ),
      body: widget.cartItems != null && widget.cartItems!.isNotEmpty
          ? SingleChildScrollView(
              child: ListView.builder(
                itemCount: widget.cartItems!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.asset(
                      widget.cartItems![index].stock.photo!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(widget.cartItems![index].stock.nomProduit!),
                    subtitle: Text(
                        'Quantité: ${widget.cartItems![index].quantity}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          widget.cartItems!.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset('assets/images/notif.jpg'),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Aucun produit trouvé au panier',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: widget.cartItems != null &&
              widget.cartItems!.isNotEmpty
          ? Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Implement your checkout logic here
                },
                child: Text('Payer'),
              ),
            )
          : SizedBox(),
    );
  }

}