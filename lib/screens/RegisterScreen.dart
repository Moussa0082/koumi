import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:koumi_app/models/TypeActeur.dart';
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

  String? typeValue;
  String selectedCountry = '';
  // late TypeActeur monTypeActeur;
  late Future _mesTypeActeur;
  Position? _currentPosition;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


    String? detectedCountry = "";
    String dialCode ="";

    String _errorMessage = "";

    String dropdownvalue = 'Item 1';    
  
   final TextEditingController controller = TextEditingController();
     TextEditingController whatsAppController = TextEditingController();

  String initialCountry = 'ML';
  PhoneNumber number = PhoneNumber(isoCode: 'ML');
  // List of items in our dropdown menu 
  var items = [     
    'Item 2', 
    
  ]; 

   void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

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
     controller: telephoneController,
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
       
   IntlPhoneField(
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
                 telephone: processedNumber , pays: selectedCountry,) ));
              
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
