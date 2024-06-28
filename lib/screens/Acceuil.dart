import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' ;
import 'package:get/get.dart';
import 'package:koumi_app/admin/AlerteScreen.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/CountryProvider.dart';
import 'package:koumi_app/screens/ConseilScreen.dart';
import 'package:koumi_app/screens/IntrantScreen.dart';
import 'package:koumi_app/screens/Location.dart' as l;
import 'package:koumi_app/screens/MesCommande.dart';
import 'package:koumi_app/screens/Products.dart';
import 'package:koumi_app/screens/Store.dart';
import 'package:koumi_app/screens/Transport.dart';
import 'package:koumi_app/screens/Weather.dart';
import 'package:koumi_app/widgets/Carrousel.dart';
import 'package:koumi_app/widgets/CustomAppBar.dart';

import 'package:koumi_app/widgets/Default_Acceuil.dart';
import 'package:koumi_app/widgets/connection_verify.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/AlertAcceuil.dart';

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

  String? detectedC = '';
  String? isoCountryCode = '';
  String? country = '';
  String? detectedCountryCode= '';
  String? detectedCountry = '';

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
        if(mounted)
        setState(() {
          
    detectedC = place.isoCountryCode;
    detectedCountryCode = place.isoCountryCode!;
    detectedCountry = place.country!;
        });

    debugPrint(
        "Address: data ${detectedCountry}  user accueil ${place.locality},${place.country},${place.isoCountryCode}");
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
    super.initState();
    verify();
    getLocation();

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
          // SizedBox(height: 180, child:  Carrousels()),
          
          // SizedBox(height: 180, child: isExist ? Carrousel(): Carrousels()),
          // const SizedBox(
          //   height: 10,
          // ),
                    
                    SizedBox(height: 180, child: isExist == true ? Carrousel() : CarrouselOffLine()),
                  

                    // SizedBox(height: 180, child: isExist ? Carrousel(): CarrouselOffLine()),
         
          // isExist ?
          // SizedBox(height: 100, child: AlertAcceuil()): Container(),
          const SizedBox(
            height: 10,
          ),
          DefautAcceuil(),
          // isExist ?
          // SizedBox(
          //   child: GridView.count(
          //     shrinkWrap: true,
          //           physics: const NeverScrollableScrollPhysics(),
          //           crossAxisCount: 2,
          //           mainAxisSpacing: 2,
          //           crossAxisSpacing: 5,
          //           childAspectRatio: 2,
          //     children: _buildCards(),
          //   ),
          // ) : DefautAcceuil(),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  // List<Widget> _buildCards() {
  //   List<Widget> cards = [
  //     _buildAccueilCard("Intrants", "int.png", 1),
  //     _buildAccueilCard("Commandes", "cm.png", 3),
  //     _buildAccueilCard("Magasins", "shop.png", 4),
  //     // _buildAccueilCard("Météo", "meteo.png", 5),
  //     _buildAccueilCard("Moyens de Transports", "transp.png", 6),
  //     _buildAccueilCard("Materiels de Locations", "loc.png", 7),
  //     _buildAccueilCard("Produits agricoles", "pro.png", 9),
  //   ];

  //   if (isExist) {
  //     cards.insert(1, _buildAccueilCard("Conseils", "cons.png", 2));
  //     // cards.insert(4, _buildAccueilCard("Transport", "transport.png", 6));
  //     cards.insert(4, _buildAccueilCard("Météo", "met.png", 5));
  //     cards.insert(7, _buildAccueilCard("Alertes", "alt.png", 8));
  //   }

  //   return cards;
  // }

  Widget _buildAccueilCard(String titre, String imgLocation, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
          onTap: () {
            if (index == 9) {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductsScreen(detectedCountry: detectedCountry!)));
             
            } else if (index == 8) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AlerteScreen()));
            } else if (index == 7) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  l.Location(detectedCountry: detectedCountry!)));
            } else if (index == 6) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  Transport(detectedCountry: detectedCountry!)));
            } else if (index == 5) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WeatherScreen()));
            } else if (index == 4) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  StoreScreen(detectedCountry: detectedCountry!)));
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
                      builder: (context) =>  IntrantScreen(detectedCountry: detectedCountry!)));
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
  // Widget _buildAccueilCard(String titre, String imgLocation, int index) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //     child: InkWell(
  //         onTap: () {
  //           if (index == 9) {
  //               Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => ProductsScreen(detectedCountry: detectedCountry)));
             
  //           } else if (index == 8) {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => const AlerteScreen()));
  //           } else if (index == 7) {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) =>  l.Location(detectedCountry: detectedCountry)));
  //           } else if (index == 6) {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) =>  Transport(detectedCountry: detectedCountry)));
  //           } else if (index == 5) {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => const WeatherScreen()));
  //           } else if (index == 4) {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => const StoreScreen()));
  //           } else if (index == 3) {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => const MesCommande()));
  //           } else if (index == 2) {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => const ConseilScreen()));
  //           } else if (index == 1) {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) =>  IntrantScreen(detectedCountry: detectedCountry,)));
  //           }
  //         },
  //          borderRadius: BorderRadius.circular(10),
  //         child: Container(
  //           // width: 200, // Largeur fixe
  //           // height: 50, // Hauteur fixe
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //             color: Colors.white,
  //             boxShadow: const [
  //               BoxShadow(
  //                 blurRadius: 5.0,
  //                 color: Color.fromRGBO(0, 0, 0, 0.25), // Opacité de 10%
  //               ),
  //             ],
  //           ),
  //           child: Row(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(10.0),
  //                 child: Image.asset(
  //                   "assets/images/$imgLocation",
  //                   width: 50,
  //                   height: 50,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(10.0),
  //                   child: Text(
  //                     titre,
  //                     maxLines: 2,
  //                     textAlign: TextAlign.center,
  //                     style: const TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )
  //         ),
  //   );
  // }

   
}
