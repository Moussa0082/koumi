import 'package:flutter/material.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/screens/ComplementAlimentaire.dart';
import 'package:koumi_app/screens/ConseilScreen.dart';
import 'package:koumi_app/screens/EngraisAndApport.dart';
import 'package:koumi_app/screens/FruitsAndLegumes.dart';
import 'package:koumi_app/screens/Location.dart';
import 'package:koumi_app/screens/Products.dart';
import 'package:koumi_app/screens/ProduitElevage.dart';
import 'package:koumi_app/screens/ProduitPhytosanitaire.dart';
import 'package:koumi_app/screens/ProduitTransforme.dart';
import 'package:koumi_app/screens/SemenceAndPlant.dart';
import 'package:koumi_app/screens/Store.dart';
import 'package:koumi_app/screens/Transport.dart';
import 'package:koumi_app/screens/Weather.dart';

class DefautAcceuil extends StatefulWidget {
  const DefautAcceuil({super.key});

  @override
  State<DefautAcceuil> createState() => _DefautAcceuilState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _DefautAcceuilState extends State<DefautAcceuil> {
  // late Future<List<CategorieProduit>> _liste;

  // Future<List<CategorieProduit>> getCat() async {
  //   return await CategorieService().fetchCategorie();
  // }

  @override
  void initState() {
    super.initState();
    // _liste = getCat();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 5,
        childAspectRatio:
            2, // Ajustez cette valeur pour contrôler le rapport d'aspect
        children: _buildCards(),
      ),
    );
  }

  List<Widget> _buildCards() {
    List<Widget> cards = [
      _buildAccueilCard("Semences et plants", "semence.png", 13),
      _buildAccueilCard("Produits phytosanitaires", "physo.png", 12),
      _buildAccueilCard("Engrais et apports", "engrais.png", 11),
      _buildAccueilCard("Fruits et légumes", "fruit&legume.png", 10),
      _buildAccueilCard("Produits agricoles", "pro.png", 9),
      _buildAccueilCard("Compléments alimentaires", "compl.png", 5),
      _buildAccueilCard("Produits d'élévages", "elevage.png", 7),
      _buildAccueilCard("Magasins", "shop.png", 6),
      _buildAccueilCard("Locations", "loc.png", 4),
      _buildAccueilCard("Moyens de Transports", "transp.png", 3),
      _buildAccueilCard("Produits transformés", "transforme.png", 8),
      _buildAccueilCard("Météo", "met.png", 2),
      _buildAccueilCard("Conseils", "cons.png", 1)
    ];

    return cards;
  }

  Widget _buildAccueilCard(String titre, String imgLocation, int index) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          if (index == 13) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SemenceAndPlant()));
          } else if (index == 12) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProduitPhytosanitaire()));
          } else if (index == 11) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EngraisAndApport()));
          } else if (index == 10) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FruitAndLegumes()));
          } else if (index == 9) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProductsScreen()));
          } else if (index == 8) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProduitTransforme()));
          } else if (index == 7) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProduitElevage()));
          } else if (index == 6) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const StoreScreen()));
          } else if (index == 5) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ComplementAlimentaire()));
          } else if (index == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Location()));
          } else if (index == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Transport()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const WeatherScreen()));
          } else if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ConseilScreen()));
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          // width: 200, // Largeur fixe
          // height: 50, // Hauteur fixe
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
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "assets/images/$imgLocation",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    titre,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
