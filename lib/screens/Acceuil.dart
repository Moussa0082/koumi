import 'package:flutter/material.dart';
import 'package:koumi_app/screens/ActeurScreen.dart';
import 'package:koumi_app/screens/AlerteScreen.dart';
import 'package:koumi_app/screens/CommandeScreen.dart';
import 'package:koumi_app/screens/ConseilScreen.dart';
import 'package:koumi_app/screens/IntrantScreen.dart';
import 'package:koumi_app/screens/Location.dart';
import 'package:koumi_app/screens/MagasinScreen.dart';
import 'package:koumi_app/screens/Meteo.dart';
import 'package:koumi_app/screens/Transport.dart';
import 'package:koumi_app/widgets/Carrousel.dart';
import 'package:koumi_app/widgets/CustomAppBar.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: const CustomAppBar(),
      body: ListView(
        children: [
          SizedBox(height: 200, child: Carrousel()),
          const SizedBox(
            height: 35,
          ),
          SizedBox(
            // height: double.maxFinite,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: [
                _buildAccueilCard("Intrants", "intrant.png", 1),
                _buildAccueilCard("Conseils", "conseil.png", 2),
                _buildAccueilCard("Commandes", "commande.png", 3),
                _buildAccueilCard("Magasin", "magasin.png", 4),
                _buildAccueilCard("Meteo", "meteo.png", 5),
                _buildAccueilCard("Transports", "transport.png", 6),
                _buildAccueilCard("Locations", "location.png", 7),

                _buildAccueilCard("Alertes", "alerte.png", 8),
                _buildAccueilCard("Acteurs", "acteur.png", 9),
                // _buildAccueilCard("Statistique", "statistique_logo.png", 4)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAccueilCard(String titre, String imgLocation, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: InkWell(
          onTap: () {
            if (index == 9) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ActeurScreen()));
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Meteo()));
            } else if (index == 4) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MagasinScreen()));
            } else if (index == 3) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CommandeScreen()));
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
              width: 150,
              height: 150,
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
                  const SizedBox(height: 8),
                  Text(
                    titre,
                    style: const TextStyle(
                      fontSize: 17,
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
