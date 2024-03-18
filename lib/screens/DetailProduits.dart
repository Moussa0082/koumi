import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:koumi_app/models/CartItem.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/screens/Panier.dart';
import 'package:koumi_app/widgets/SnackBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';




class DetailProduits extends StatefulWidget {
  final Stock stock;
  const DetailProduits({super.key, required this.stock});

  @override
  State<DetailProduits> createState() => _DetailProduitsState();
}

  const double defaultPadding = 16.0;
const double defaultPadding_min = 5.0;
const double defaultBorderRadius = 12.0;


class _DetailProduitsState extends State<DetailProduits>  with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<Offset> _animation;
  List<CartItem> _cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   InkWell(
        //     onTap: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => CartScreen()));
        //     },
        //     child: Padding(
        //       padding:
        //           const EdgeInsets.only(left: 0, right: 15, top: 8, bottom: 8),
        //       child: Stack(
        //         children: [
        //           Align(
        //               alignment: Alignment.bottomCenter,
        //               child: Icon(Icons.shopping_cart_rounded,
        //                   color: Colors.blue, size: 25)),
        //           Positioned(
        //             top: 0,
        //             left: 0,
        //             right: 0,
        //             child: Consumer<ProductsVM>(
        //               builder: (context, value, child) => CartCounter(
        //                 count: value.lst.length.toString(),
        //               ),
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //   )
        // ],
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Icon(Icons.menu_rounded, color: Colors.blue, size: 25),
        // ),
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text("Détail Produit"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                "assets/icons/Heart.svg",
                height: 20,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Image.asset(
            "assets/images/pomme.png",
            height: MediaQuery.of(context).size.height * 0.200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: defaultPadding * 0.300),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(defaultPadding, defaultPadding * 2, defaultPadding, defaultPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(defaultBorderRadius * 3),
                  topRight: Radius.circular(defaultBorderRadius * 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 211, 179, 143),
                    ),
                    child: Center(
                      child: Text(
                        widget.stock.nomProduit!.toUpperCase(),
                        style: const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Forme : "),
                        Text("Tuberculé"),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Text(
                      "A Henley shirt is a collarless pullover shirt, by a round neckline and a placket about 3 to 5 inches (8 to 13 cm) long and usually having 2–5 buttons.",
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.stock.prix!.toInt()} €', // Convertir en entier
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 0,
                          maxRating: 5,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 20,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          _addToCart(widget.stock);
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.orange, shape: const StadiumBorder()),
                        child: const Text(
                          "Ajouter",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _addToCart(Stock stock) {
    var existingItem = _cartItems.firstWhere(
      (item) => item.stock == stock,
      orElse: () => CartItem(stock: stock),
    );

    if (existingItem.quantity == 1) {
      _cartItems.remove(existingItem);
      Snack.error(titre: "", message: "Produit déjà existant au panier");
    } else {
      existingItem.quantity++;
      Snack.success(titre: "", message: "Produit déjà existant au panier qté " + existingItem.quantity.toString());
    }
  }
  void _handleAddToCart() {
    CartItem cartItem = CartItem(stock: widget.stock, quantity: 1);
    _cartItems.add(cartItem);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Panier(cartItems: _cartItems)),
    );
  }


}



 class CartStorage {
  static const String _keyCartItems = 'cartItems';

  static Future<List<String>> getCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyCartItems) ?? [];
  }

  static Future<void> addToCart(String productId) async {
    final List<String> cartItems = await getCartItems();
    cartItems.add(productId);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyCartItems, cartItems);
  }

  static Future<void> removeFromCart(String productId) async {
    final List<String> cartItems = await getCartItems();
    cartItems.remove(productId);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyCartItems, cartItems);
  }
}