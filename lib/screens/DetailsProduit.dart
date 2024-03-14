
 import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';

class DetailsProduit extends StatefulWidget {
  const DetailsProduit({super.key});

  @override
  State<DetailsProduit> createState() => _DetailsProduitState();
}

   const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _DetailsProduitState extends State<DetailsProduit> {


   late Acteur acteur;
  late List<TypeActeur> typeActeurData = [];
  late String type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 100,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
          title: Text(
            'Detail Produit',
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
          actions: [
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              itemBuilder: (context) {
                print("Type: $type");
                return type.toLowerCase() == 'admin' ||
                        type.toLowerCase() == 'transporteurs' ||
                        type.toLowerCase() == 'transporteur'
                    ? <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          child: ListTile(
                            leading: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.green,
                            ),
                            title: const Text(
                              "Mes véhicule",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () async {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => VehiculeActeur()));
                            },
                          ),
                        ),
                      ]
                    : <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          child: ListTile(
                            leading: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.green,
                            ),
                            title: const Text(
                              "Voir les transporteurs",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () async {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             PageTransporteur()));
                            },
                          ),
                        ),
                      ];
              },
            )
          ]),
    );
  }
}