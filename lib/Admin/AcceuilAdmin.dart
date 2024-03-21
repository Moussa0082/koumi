import 'package:flutter/material.dart';
import 'package:koumi_app/Admin/ActeurScreen.dart';
import 'package:koumi_app/Admin/AlerteScreen.dart';
import 'package:koumi_app/Admin/CategoriePage.dart';
import 'package:koumi_app/Admin/FiliereScreen.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/screens/CommandeScreen.dart';
import 'package:koumi_app/screens/ConseilScreen.dart';
import 'package:koumi_app/screens/IntrantScreen.dart';
import 'package:koumi_app/screens/Location.dart';
import 'package:koumi_app/screens/MagasinActeur.dart';
import 'package:koumi_app/screens/MagasinScreen.dart';
import 'package:koumi_app/screens/Meteo.dart';
import 'package:koumi_app/screens/Produit.dart';
import 'package:koumi_app/screens/Transport.dart';
import 'package:koumi_app/service/ParametreGenerauxService.dart';
import 'package:koumi_app/widgets/Carrousel.dart';
import 'package:koumi_app/widgets/CustomAppBar.dart';
import 'package:provider/provider.dart';

class AcceuilAdmin extends StatefulWidget {
  const AcceuilAdmin({super.key});

  @override
  State<AcceuilAdmin> createState() => _AcceuilAdminState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AcceuilAdminState extends State<AcceuilAdmin> {
  late Acteur acteur;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    //   WidgetsBinding.instance.addPostFrameCallback((_) {

    //  Snack.info(message:'Connecté en tant que : ${acteur.nomActeur!.toUpperCase()}') ;
    //   });
  }

  @override
  Widget build(BuildContext context) {
    final parametreProvider =
        Provider.of<ParametreGenerauxProvider>(context, listen: false);

    ParametreGenerauxService().fetchParametre().then((parametreList) {
      parametreProvider.setParametreList(parametreList);
    }).catchError((error) {
      // Gestion des erreurs
      print('Erreur lors du chargement des données : $error');
    });

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
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 5,
              childAspectRatio: 0.9,
              children: [
                _buildAccueilCard("Intrants", "intrant.png", 1),
                _buildAccueilCard("Conseils", "conseil.png", 2),
                _buildAccueilCard("Commandes", "commande.png", 3),
                _buildAccueilCard("Magasin", "magasin.png", 4),
                _buildAccueilCard("Meteo", "meteo.png", 5),
                _buildAccueilCard("Transports", "transport.png", 6),
                _buildAccueilCard("Locations", "location.png", 7),

                _buildAccueilCard("Alertes", "alerte.png", 8),
                _buildAccueilCard("Produits", "produit.png", 9),
                _buildAccueilCard("Filières", "filiere.png", 10),
                _buildAccueilCard("Catégorie", "cat.png", 11),
                _buildAccueilCard("Acteurs", "acteur.png", 12),
                // _buildAccueilCard("Statistique", "statistique_logo.png", 4)
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget _buildAccueilCard(String titre, String imgLocation, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
          onTap: () {
            if (index == 12) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ActeurScreen()));
            } else if (index == 11) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoriPage()));
            } else if (index == 10) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FiliereScreen()));
            } else if (index == 9) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  ProduitScreen()));
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
                  const SizedBox(height: 8),
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
