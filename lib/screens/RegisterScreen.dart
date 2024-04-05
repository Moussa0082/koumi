import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:sim_data_plus/sim_data.dart';

// import 'package:koumi_app/models/TypeActeur.dart';
import 'package:http/http.dart' as http;

import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/screens/RegisterNextScreen.dart';
import 'package:shimmer/shimmer.dart';

class RegisterScreen extends StatefulWidget {

   
   RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  String nomActeur = "";
  String telephone = "";

  PhoneNumber locale = 
  PhoneNumber(
isoCode: Platform.localeName.split('_').last
  );
  

  String? typeValue;
  String selectedCountry = '';
  // late TypeActeur monTypeActeur;
  late Future _mesTypeActeur;
  Position? _currentPosition;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


    var detectedCountry = "";
    String? detectedC = "";
    String dialCode ="";

    String _errorMessage = "";

    String dropdownvalue = 'Item 1';    
  
   final TextEditingController controller = TextEditingController();
     TextEditingController whatsAppController = TextEditingController();

  String initialCountry = 'ML';
  String detectedCountryCode = '';
  PhoneNumber number = PhoneNumber();
  // List of items in our dropdown menu 
  var items = [     
    'Item 2', 
    
  ]; 
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
    debugPrint("Address ISO: $detectedC"  );
    address.value = 'Address : ${place.locality},${place.country},${place.isoCountryCode} ';
    detectedC = place.isoCountryCode;
            detectedCountryCode = place.isoCountryCode!;

    debugPrint("Address:   ${place.locality},${place.country},${place.isoCountryCode}"  );
  }

  //    void _detectInitialCountryCode() {
  //   // Obtenir la locale du périphérique
  //   String locale = Platform.localeName;

  //   // Extraire le code de pays de la locale
  //   String countryCode = locale.split('_').last;

  //   // Mettre à jour l'état avec le code de pays détecté
  //   setState(() {
  //     detectedCountry = countryCode;
  //     debugPrint("Iso : $detectedCountry");
  //   });
  // }
   
  

   void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, Platform.localeName.split('_').last);

    setState(() {
      this.number = number;
    });
  }


 // Fonction pour obtenir le pays à partir des coordonnées de latitude et de longitude
Future<String?> getCountryFromLatLng(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      return placemarks[0].country;
    } else {
      return null; // Aucun résultat trouvé
    }
  } catch (e) {
    print("Erreur lors de la récupération du pays à partir des coordonnées: $e");
    return null;
  }
}

Future<String?> getCurrentCountryFromLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    return getCountryFromLatLng(position.latitude, position.longitude);
  } catch (e) {
    print("Erreur lors de la récupération du pays actuel à partir de la géolocalisation: $e");
    return null;
  }
}

  TextEditingController nomActeurController = TextEditingController();
 
  TextEditingController telephoneController = TextEditingController();
  TextEditingController typeActeurController = TextEditingController();


  String removePlus(String phoneNumber) {
  if (phoneNumber.startsWith('+')) {
    return phoneNumber.substring(1); // Remove the first character
  } else {
    return phoneNumber; // No change if "+" is not present
  }
}

  String processedNumber = "";
  String processedNumberTel = "";

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mesTypeActeur  =
        // http.get(Uri.parse('https://koumi.ml/api-koumi/typeActeur/read'));
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/typeActeur/read'));
    // getLocation();
    getLocationNew();
  }

   @override
  void dispose() {
   controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
              Center(child: Image.asset('assets/images/logo.png', height: 200, width: 100,)),
               Container(
                 height: 40,
                 width:MediaQuery.of(context).size.width,
                 decoration: BoxDecoration(
                   color: Color.fromARGB(255, 240, 178, 107),
                 ),
                 child: Center(
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    const  Text("J'ai déjà un compte .",
                     style: TextStyle(color: Colors.white, fontSize: 18, 
                     fontWeight: FontWeight.bold),),
                     const SizedBox(width: 4,),
                     GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
                      },
                      child: const Text("Se connecter", 
                      style: TextStyle(color: Colors.blue, 
                      fontSize: 18, 
                      fontWeight: FontWeight.bold) ,
                       ),
                       ),
                    ],
                 ),
                 
                 ),
                 
               ),
               const SizedBox(height: 10,),
                 const Text("Inscription", style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold , color: Color(0xFFF2B6706)),),
               Form(
                key:_formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const SizedBox(height: 10,),
                // debut fullname 
                Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Nom Complet *", style: TextStyle(color:  (Colors.black), fontSize: 18),),
                ),
                TextFormField(
                    controller: nomActeurController,
                     decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        hintText: "Entrez votre prenom et nom",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veillez entrez votre prenom et nom";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => nomActeur = val!,
                  ),
                  // fin  adresse fullname
  
                      const SizedBox(height: 20,),
       
                     Padding(
  padding: const EdgeInsets.only(left:10.0),
  child: Text("Téléphone *", style: TextStyle(color: (Colors.black), fontSize: 18),),
     ),
                      const SizedBox(height: 5,),


  IntlPhoneField(
           initialCountryCode: "ML", // Automatically detect user's country
       invalidNumberMessage : "Numéro invalide",
    searchText: "Chercher un pays",
                   decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                  languageCode: "en",
                  onChanged: (phone) {
                    print(phone.completeNumber);
                    processedNumberTel = removePlus(phone.completeNumber.toString());
          print(processedNumberTel);
                  },
                  onCountryChanged: (country) {
                    print('Country changed to: ' + country.name);
                  },
                ),

//  const SizedBox(height: 5,),
                    Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Text("Numéro WhtasApp", style: TextStyle(color: (Colors.black), fontSize: 18),),
              ),
                const SizedBox(height: 4,),
//         Container(
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: <Widget>[
//       InternationalPhoneNumberInput(
//          initialValue: PhoneNumber(
//                       isoCode: Platform.localeName.split('_').last,
//                     ),
//         formatInput: true,
//         hintText: "Numéro de téléphone",
//         maxLength: 20,
//         errorMessage: "Numéro invalide",
//         onInputChanged: (PhoneNumber number) {
//            processedNumber = removePlus(number.phoneNumber!);
//     // selectedCountry = phone.countryCode;
//     // print('Country changed to: $selectedCountry');
//           print(processedNumber);
//         },
  
//         onInputValidated: (bool value) {
//           print(value);
//         },
//         selectorConfig: SelectorConfig(
//           selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//           useBottomSheetSafeArea: true,
//         ),
//         ignoreBlank: false,
//         autoValidateMode: AutovalidateMode.disabled,
//         selectorTextStyle: TextStyle(color: Colors.black),
//         keyboardType: TextInputType.phone,
//         inputDecoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(20)),
//           ),
//         ),
//         onSaved: (PhoneNumber number) {
//           print('On Saved: $number');
//         },
//         textFieldController: controller,
//       ),
//     ],
//   ),
// ),
   IntlPhoneField(
  initialCountryCode: "ML", // Automatically detect user's country
    controller: whatsAppController,
    invalidNumberMessage : "Numéro invalide",
    searchText: "Chercher un pays",
                   decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                  languageCode: "en",
                  onChanged: (phone) {
                    print(phone.completeNumber);
                    processedNumber = removePlus(phone.completeNumber.toString());
          print(processedNumber);
                  },
                  onCountryChanged: (country) {
                    selectedCountry = country.name.toString();
                    print('Country changed to: ' + country.name);
                  },
                ),

                  // fin  téléphone            


                //end select type acteur 
     const  SizedBox(height: 10,),

                  Center(
                    child: ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                 
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  
                RegisterNextScreen(nomActeur: nomActeurController.text,
                whatsAppActeur: processedNumberTel,
                 telephone: processedNumberTel, pays: selectedCountry,) ));
              
                }
               },
              child:  Text(
                " Suivant ",
                style:  TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A00), // Orange color code
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: Size(250, 40),
              ),
            ),
       ),

              ],
               )),
            
              ],
            ),
            
          ),
        ),
      ),
    );
  }


   

}
