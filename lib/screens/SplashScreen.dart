import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/CountryProvider.dart';
import 'package:koumi_app/providers/PaysProvider.dart';
import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/screens/RegisterScreen.dart';
import 'package:koumi_app/widgets/AnimatedBackground.dart';
import 'package:koumi_app/widgets/BottomNavBarAdmin.dart';

import 'package:koumi_app/widgets/BottomNavigationPage.dart';

import 'package:koumi_app/widgets/AnimatedBackground.dart';
import 'package:koumi_app/widgets/connection_verify.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
 
  @override 
  State<SplashScreen> createState() => _SplashScreenState();
}

const d_colorPage = Color.fromRGBO(255, 255, 255, 1);

class _SplashScreenState extends State<SplashScreen> {
  late Acteur acteur;
  late ConnectionVerify connectionVerify;
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

 @override
void didChangeDependencies() {
  super.didChangeDependencies();
  // Save the context when it changes
  _currentContext = context;
}

  Future<void> getAddressFromLatLang(Position position) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  Placemark place = placemarks[0];
  
  // var countryProvider = Provider.of<CountryProvider>(_currentContext, listen: false);
   isoCountryCode = place.isoCountryCode!;
   country = place.country!;
  
   if(isoCountryCode != null || country != null){
   debugPrint("iso : $isoCountryCode et country $country");
   }else{
       debugPrint("data null");
   }

  // Check if the widget is still mounted
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (mounted) 

        prefs.setString('countryCode', country!);
        prefs.setString('countryName', isoCountryCode!);
  // await countryProvider?.setCountryInfo(isoCountryCode!, country!);

  // Check again before calling setState
  if (mounted)
  
  setState(() {
    detectedC = place.isoCountryCode;
    detectedCountryCode = place.isoCountryCode!;
    detectedCountry = place.country!;
  });

  debugPrint("Address: splashScreen ${place.locality}, ${place.country}, ${place.isoCountryCode}");
}


  // Future<void> getAddressFromLatLang(Position position) async {
  //   List<Placemark> placemark =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark place = placemark[0];
  //   debugPrint("Address ISO: $detectedC");
  //   address.value =
  //       'Address : ${place.locality},${place.country},${place.isoCountryCode} ';
    //     setState(() {
          
    // detectedC = place.isoCountryCode;
    // detectedCountryCode = place.isoCountryCode!;
    // detectedCountry = place.country!;
    //     });

  //   debugPrint(
  //       "Address:   ${place.locality},${place.country},${place.isoCountryCode}");
  // }
  
  @override
  void initState() {
    super.initState();
    // clearCart();
    streamSubscription = const Stream<Position>.empty().listen((_) {});
    getLocation();
    // Vérifie d'abord si l'email de l'acteur est présent dans SharedPreferences
      // connectionVerify = Get.put(ConnectionVerify(), permanent: true);
    checkEmailInSharedPreferences();
    // checkInternetConnection();
  }

  void checkEmailInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailActeur = prefs.getString('emailActeur');
    if (emailActeur != null) {
      checkLoggedIn();
    } else {
      Timer(
        const Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) =>  BottomNavigationPage(iso: detectedC,)),
        ),
      );
      // Si l'email de l'acteur n'est pas présent, redirige directement vers l'écran de connexion
    }
  }

  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
    // Récupérer le codeActeur depuis SharedPreferences
    String? codeActeur = prefs.getString('codeActeur');
    String? emailActeur = prefs.getString('emailActeur');

    if (emailActeur == null || emailActeur.isEmpty) {
      // Nettoyer toutes les données de SharedPreferences
      // await prefs.clear();
      debugPrint("Email shared : $emailActeur");
    } else {
      debugPrint("Email shared isExist : $emailActeur");
    }

// Vérifier si le codeActeur est présent dans SharedPreferences
    if (codeActeur == null || codeActeur.isEmpty) {
      // Gérer le cas où le codeActeur est manquant
      // Sauvegarder le codeActeur avant de nettoyer les SharedPreferences
      String savedCodeActeur = "VF212";
      // String savedCodeActeur = codeActeur;

      // Nettoyer toutes les données de SharedPreferences
      await prefs.clear();

      // Réenregistrer le codeActeur dans SharedPreferences
      prefs.setString('codeActeur', savedCodeActeur);
    } else {
      // Sauvegarder le codeActeur avant de nettoyer les SharedPreferences
      String savedCodeActeur = "VF212";

      // // Nettoyer toutes les données de SharedPreferences
      await prefs.clear();

      // // Réenregistrer le codeActeur dans SharedPreferences
      prefs.setString('codeActeur', savedCodeActeur);
    }
  }




  void checkLoggedIn() async {
    // Initialise les données de l'utilisateur à partir de SharedPreferences
    await Provider.of<ActeurProvider>(context, listen: false)
        .initializeActeurFromSharedPreferences();

    // // Récupère l'objet Acteur
    // acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;

    if (Provider.of<ActeurProvider>(context, listen: false).acteur != null) {
      acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
      // La suite de votre logique ici...
    } else {
      Timer(
        const Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) =>  BottomNavigationPage()),
        ),
      );
    }

    // Vérifie si l'utilisateur est déjà connecté
    if (acteur != null) {
      // Vérifie si l'utilisateur est un administrateur
      if (acteur.typeActeur!
          .any((type) => type.libelle == 'admin' || type.libelle == 'Admin')) {
        Timer(
          const Duration(seconds: 5),
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const BottomNavBarAdmin()),
          ),
        );
      } else {
        Timer(
          const Duration(seconds: 5),
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) =>  BottomNavigationPage(iso: detectedC,)),
          ),
        );
      }
    }
    //  else {
    //   // Redirige vers l'écran de connexion si l'utilisateur n'est pas connecté
    //   Timer(
    //     const Duration(seconds: 5),
    //     () => Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (_) => const LoginScreen()),
    //     ),
    //   );
    // }
  }

   @override
  void dispose() {
  // streamSubscription.cancel();
  if (streamSubscription != null) {
      streamSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: d_colorPage,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AnimatedBackground(),
          const SizedBox(height: 10),
          Center(
              child: Image.asset(
            'assets/images/logo.png',
            height: 350,
            width: 250,
          )),
          CircularProgressIndicator(
            backgroundColor: (Color.fromARGB(255, 245, 212, 169)),
            color: (Colors.orange),
          ),
        ],
      ),
    );
  }
}
