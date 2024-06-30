import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:koumi_app/Admin/ActeurScreen.dart';
import 'package:koumi_app/Admin/AlerteScreen.dart';
import 'package:koumi_app/Admin/CategoriePage.dart';
import 'package:koumi_app/Admin/FiliereScreen.dart';
import 'package:koumi_app/Admin/ProfilA.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/CountryProvider.dart';
import 'package:koumi_app/screens/ComplementAlimentaire.dart';
import 'package:koumi_app/screens/ConseilScreen.dart';
import 'package:koumi_app/screens/EngraisAndApport.dart';
import 'package:koumi_app/screens/FruitsAndLegumes.dart';
import 'package:koumi_app/screens/IntrantScreen.dart';
import 'package:koumi_app/screens/Location.dart' as l;
import 'package:koumi_app/screens/MatereilAndEquipement.dart';
import 'package:koumi_app/screens/MesCommande.dart';
import 'package:koumi_app/screens/MyProduct.dart';
import 'package:koumi_app/screens/Panier.dart';
import 'package:koumi_app/screens/Products.dart';
import 'package:koumi_app/screens/ProduitElevage.dart';
import 'package:koumi_app/screens/ProduitPhytosanitaire.dart';
import 'package:koumi_app/screens/ProduitTransforme.dart';
import 'package:koumi_app/screens/SemenceAndPlant.dart';
import 'package:koumi_app/screens/Store.dart';
import 'package:koumi_app/screens/Transport.dart';
import 'package:koumi_app/screens/Weather.dart';
import 'package:koumi_app/widgets/Carrousel.dart';
import 'package:koumi_app/widgets/CustomAppBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcceuilAdmin extends StatefulWidget {
  const AcceuilAdmin({super.key});

  @override
  State<AcceuilAdmin> createState() => _AcceuilAdminState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AcceuilAdminState extends State<AcceuilAdmin> {
  late Acteur acteur = Acteur();

  String? email = "";
  bool isExist = false;

  String? detectedC;
  String? isoCountryCode;
  String? country;
  String? detectedCountryCode;
  String? detectedCountry;
  CountryProvider? countryProvider;
  late BuildContext _currentContext;

  void getLocationNew() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark placemark = placemarks.first;
      setState(() {
        detectedCountryCode = placemark.isoCountryCode!;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  var latitude = 'Getting Latitude..'.obs;
  var longitude = 'Getting Longitude..'.obs;
  var address = 'Getting Address..'.obs;
  late StreamSubscription<Position> streamSubscription;

  getLocation() async {
    bool serviceEnabled;

    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      latitude.value = 'Latitude : ${position.latitude}';
      longitude.value = 'Longitude : ${position.longitude}';
      getAddressFromLatLang(position);
    });
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    debugPrint("Address ISO: $detectedC");
    address.value =
        'Address : ${place.locality},${place.country},${place.isoCountryCode} ';
    if (mounted)
      setState(() {
        detectedC = place.isoCountryCode;
        detectedCountryCode = place.isoCountryCode!;
        detectedCountry = place.country!;
      });

    debugPrint(
        "Address: admin accueil  ${place.locality},${place.country},${place.isoCountryCode}");
  }

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
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    verify();
    getLocation();
    //  Snack.info(message:'Connecté en tant que : ${acteur.nomActeur!.toUpperCase()}') ;
    //   });
  }

  @override
  Widget build(BuildContext context) {
    // final parametreProvider =
    //     Provider.of<ParametreGenerauxProvider>(context, listen: false);

    // ParametreGenerauxService().fetchParametre().then((parametreList) {
    //   parametreProvider.setParametreList(parametreList);
    // }).catchError((error) {
    //   // Gestion des erreurs
    //   print('Erreur lors du chargement des données : $error');
    // });

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: const CustomAppBar(),
      body: ListView(
        children: [
          SizedBox(height: 200, child: Carrousels()),
          // SizedBox(
          //     height: 180, child: isExist ? Carrousel() : CarrouselOffLine()),

          // SizedBox(height: 100, child: isExist ? Carrousel(): CarrouselOffLine()),
          // const SizedBox(
          //   height: 10,
          // ),
          // SizedBox(height: 100, child: AlertAcceuil()),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
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
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  List<Widget> _buildCards() {
    List<Widget> cards = [
      _buildAccueilCard("Conseils", "cons.png", 2),
      _buildAccueilCard("Alertes", "alt.png", 8),
      // _buildAccueilCard("Semences et plants", "semence.png", 14),
      // _buildAccueilCard("Produits phytosanitaires", "physo.png", 15),
      // _buildAccueilCard("Engrais et apports", "engrais.png", 17),
      // _buildAccueilCard("Fruits et légumes", "fruit&legume.png", 16),
      // _buildAccueilCard("Compléments alimentaires", "compl.png", 18),
      // _buildAccueilCard("Produits d'élevages", "elevage.png", 19),
      // _buildAccueilCard("Matériels et équipements", "equi.png", 13),
      // _buildAccueilCard("Produits transformés", "transforme.png", 20),
      _buildAccueilCard("Commandes", "cm.png", 3),
      _buildAccueilCard("Magasins", "shop.png", 4),
      _buildAccueilCard("Intrants agricoles", "int.png", 1),
      _buildAccueilCard("Produits agricoles", "pro.png", 9),
      _buildAccueilCard("Materiels de Locations", "loc.png", 7),
      _buildAccueilCard("Moyens de Transports", "transp.png", 6),
      _buildAccueilCard("Filières", "fi.jpg", 10),
      _buildAccueilCard("Météo", "met.png", 5),
      _buildAccueilCard("Catégories", "c.jpg", 11),
      _buildAccueilCard("Acteurs", "ac.png", 12),
    ];

    return cards;
  }

  Widget _buildAccueilCard(String titre, String imgLocation, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
          onTap: () {
            if (index == 20) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProduitTransforme(detectedCountry: detectedCountry)));
            } else if (index == 19) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProduitElevage(detectedCountry: detectedCountry)));
            } else if (index == 18) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ComplementAlimentaire(
                          detectedCountry: detectedCountry)));
            } else if (index == 17) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EngraisAndApport(detectedCountry: detectedCountry)));
            } else if (index == 16) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FruitAndLegumes(detectedCountry: detectedCountry)));
            } else if (index == 15) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProduitPhytosanitaire(
                          detectedCountry: detectedCountry)));
            } else if (index == 14) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SemenceAndPlant(detectedCountry: detectedCountry)));
            } else if (index == 13) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MaterielAndEquipement()));
            } else if (index == 12) {
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
                    builder: (context) =>
                        ProductsScreen(detectedCountry: detectedCountry!),
                  ));
            } else if (index == 8) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  AlerteScreen(detectedCountry: detectedCountry!, detectedCountryCode: detectedCountryCode!,)));
            } else if (index == 7) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          l.Location(detectedCountry: detectedCountry!)));
            } else if (index == 6) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Transport(detectedCountry: detectedCountry!)));
            } else if (index == 5) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WeatherScreen()));
            } else if (index == 4) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  StoreScreen(detectedCountry: detectedCountry!,)));
            } else if (index == 3) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MesCommande()));
            } else if (index == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConseilScreen()));
            } else if (index == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          IntrantScreen(detectedCountry: detectedCountry!)));
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
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
                    width: 35,
                    height: 35,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      titre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
          )),
    );
  }

  Widget buildPageView() {
    return SizedBox(
      // height:MediaQuery.of(context).size.height,
      height: MediaQuery.of(context).size.height * 0.90,
      child: PageView(
        children: [
          const AcceuilAdmin(),
          MyProductScreen(),
          Panier(),
          const ProfilA()
        ],
      ),
    );
  }
}