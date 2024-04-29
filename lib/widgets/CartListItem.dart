
 import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/models/CartItem.dart';
import 'package:koumi_app/providers/CartProvider.dart';
import 'package:provider/provider.dart';

class CartListItem extends StatefulWidget {
  final CartItem cartItem;
  final int index;
  const CartListItem({super.key, required this.cartItem, required this.index});

  @override
  State<CartListItem> createState() => _CartListItemState();
}

class _CartListItemState extends State<CartListItem> {
  String currency = "FCFA";
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 0.5,
            blurRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
     widget.cartItem.isStock == true? ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: widget.cartItem.stock!.photo != null
      ?  CachedNetworkImage(
          imageUrl: 
           widget.cartItem.stock!.photo!,
          fit: BoxFit.cover,
          width: 67,
          height: 100,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Image.asset("assets/images/default_image.png", width: 67,
          height: 100,),
        )
      : Image.asset("assets/images/default_image.png", width: 67,
          height: 100,),
) :
 ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: widget.cartItem.intrant!.photoIntrant != null
      ?  CachedNetworkImage(
          imageUrl: 
           widget.cartItem.intrant!.photoIntrant!,
          fit: BoxFit.cover,
          width: 67,
          height: 100,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Image.asset("assets/images/default_image.png", width: 67,
          height: 100,),
        )
      : Image.asset("assets/images/default_image.png", width: 67,
          height: 100,),
),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   widget.cartItem.isStock == true ? widget.cartItem.stock!.nomProduit! : widget.cartItem.intrant!.nomIntrant,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "${widget.cartItem.isStock == true ? widget.cartItem.stock!.prix!.toInt() : widget.cartItem.intrant!.prixIntrant} F",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Expanded(child: Container()),
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              // color: Theme.of(context).colorScheme.primary,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(
                                    1.0,
                                    1.0,
                                  ),
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              color: Colors.white,
                              iconSize: 16,
                              onPressed: () {
                              widget.cartItem.isStock == true ? Provider.of<CartProvider>(context,
                                        listen: false)
                                    .increaseCartItemQuantity(widget.index) :Provider.of<CartProvider>(context,
                                        listen: false)
                                    .increaseCartItemIntQuantity(widget.index) ;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                           widget.cartItem.isStock == true ? widget.cartItem.quantiteStock.toString() : widget.cartItem.quantiteIntrant.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              // color: Theme.of(context).colorScheme.primary,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(
                                    1.0,
                                    1.0,
                                  ),
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.remove),
                              color: Colors.white,
                              iconSize: 16,
                              onPressed: () {
                                if (quantity >= 1) {
                                widget.cartItem.isStock == true ?  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .decreaseCartItemQuantity(widget.index): Provider.of<CartProvider>(context,
                                          listen: false)
                                      .decreaseCartItemIntQuantity(widget.index);
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
