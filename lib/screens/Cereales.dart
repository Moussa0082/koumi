import 'package:flutter/material.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/screens/DetailProduits.dart';

class Cereales extends StatefulWidget {
  const Cereales({super.key});

  @override
  State<Cereales> createState() => _CerealesState();
}

class _CerealesState extends State<Cereales> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes produits"),
      ),
      body: ListView(children: [
        SizedBox(
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            children: [
              // _buildAcceuilCard();
              ],
          ),
        )
      ]),
    );
  }

  Widget _buildAcceuilCard(String imgLocation, String nomProduit, String prix,
      String quantite, Stock stock) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
            margin: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5.0,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.28,
                        child: Image.asset(
                          "assets/images/$imgLocation",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 10, color: Colors.white30),
                      const SizedBox(height: 8),
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nomProduit,
                            style: TextStyle(
                              fontSize: 17,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Prix",
                                style: TextStyle(
                                  fontSize: 17,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${prix} FCFA",
                                style: TextStyle(
                                  fontSize: 17,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Quantité",
                                style: TextStyle(
                                  fontSize: 17,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                quantite,
                                style: TextStyle(
                                  fontSize: 17,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailProduits(stock: stock)));
                            },
                            child: const Text("Voir"),
                          ),
                        ],
                      ),
                    ]))));
  }
}
