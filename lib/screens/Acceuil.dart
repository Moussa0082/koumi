import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/admin/AlerteScreen.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/CommandeScreen.dart';
import 'package:koumi_app/screens/ConseilScreen.dart';
import 'package:koumi_app/screens/IntrantScreen.dart';
import 'package:koumi_app/screens/Location.dart';
import 'package:koumi_app/screens/MesCommande.dart';
import 'package:koumi_app/screens/MyProduct.dart';
import 'package:koumi_app/screens/Product.dart';
import 'package:koumi_app/screens/Products.dart';
import 'package:koumi_app/screens/Store.dart';
import 'package:koumi_app/screens/Transport.dart';
import 'package:koumi_app/screens/Weather.dart';
import 'package:koumi_app/widgets/AlertAcceuil.dart';
import 'package:koumi_app/widgets/Carrousel.dart';
import 'package:koumi_app/widgets/CustomAppBar.dart';
import 'package:koumi_app/widgets/Default_Acceuil.dart';
import 'package:koumi_app/widgets/connection_verify.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AccueilState extends State<Accueil> {
  late Acteur acteur = Acteur();

  String? email = "";
  bool isExist = false;

  void verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('emailActeur');
    if (email != null) {
      // Si l'email de l'acteur est présent, exécute checkLoggedIn
      acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
      setState(() {
        isExist = true;
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verify();
    // final acteurProvider = Provider.of<ActeurProvider>(context, listen: false).isLogged;
    // Get.put(ConnectionVerify(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: const CustomAppBar(),
      body: ListView(
        children: [
          SizedBox(height: 180, child:  Carrousel()),
          // SizedBox(height: 180, child: isExist ? Carrousel(): Carrousels()),
          // const SizedBox(
          //   height: 10,
          // ),
          // isExist ? SizedBox(height: 100, child: Carrousel()) : Carrousels(),
          const SizedBox(
            height: 10,
          ),
          isExist ?
          SizedBox(
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 5,
              childAspectRatio: 0.9,
              children: _buildCards(),
            ),
          ) : DefautAcceuil(),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  List<Widget> _buildCards() {
    List<Widget> cards = [
      _buildAccueilCard("Intrants", "intrant.png", 1),
      _buildAccueilCard("Commandes", "commande.png", 3),
      _buildAccueilCard("Magasin", "magasin.png", 4),
      // _buildAccueilCard("Météo", "meteo.png", 5),
      _buildAccueilCard("Transports", "transport.png", 6),
      _buildAccueilCard("Locations", "location.png", 7),
      _buildAccueilCard("Produits", "produit.png", 9),
    ];

    if (isExist) {
      cards.insert(1, _buildAccueilCard("Conseils", "conseil.png", 2));
      // cards.insert(4, _buildAccueilCard("Transport", "transport.png", 6));
      cards.insert(4, _buildAccueilCard("Meteo", "meteo.png", 5));
      cards.insert(7, _buildAccueilCard("Alertes", "alerte.png", 8));
    }

    return cards;
  }

  Widget _buildAccueilCard(String titre, String imgLocation, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
          onTap: () {
            if (index == 9) {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductsScreen()));
             
            } else if (index == 8) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AlerteScreen()));
            } else if (index == 7) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Location()));
            } else if (index == 6) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Transport()));
            } else if (index == 5) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WeatherScreen()));
            } else if (index == 4) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const StoreScreen()));
            } else if (index == 3) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MesCommande()));
            } else if (index == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConseilScreen()));
            } else if (index == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const IntrantScreen()));
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: 155,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5.0,
                    color: Color.fromRGBO(0, 0, 0, 0.25), // Opacité de 10%
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: Image.asset(
                      "assets/images/$imgLocation",
                      fit: BoxFit
                          .cover, // You can adjust the BoxFit based on your needs
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    titre,
                    style: const TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
