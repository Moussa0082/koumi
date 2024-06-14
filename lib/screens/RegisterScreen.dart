import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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
  String? iso;
  String? selectedCountry;
  RegisterScreen({super.key, this.iso, this.selectedCountry});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String nomActeur = "";
  String telephone = "";

  PhoneNumber locale =
      PhoneNumber(isoCode: Platform.localeName.split('_').last);

  String? typeValue;
  String? selectedCountry;
  // late TypeActeur monTypeActeur;
  // late Future _mesTypeActeur;
  Position? _currentPosition;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var detectedCountry = "";
  String? detectedC = "";
  String dialCode = "";

  String _errorMessage = "";

  String dropdownvalue = 'Item 1';

  final TextEditingController controller = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();

  String? initialCountry;
  String detectedCountryCode = '';
  PhoneNumber number = PhoneNumber();
  // List of items in our dropdown menu
  var items = [
    'Item 2',
  ];
 

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
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(
        phoneNumber, Platform.localeName.split('_').last);

    setState(() {
      this.number = number;
    });
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
    selectedCountry = widget.selectedCountry;
    // _mesTypeActeur  =
    // http.get(Uri.parse('https://koumi.ml/api-koumi/typeActeur/read'));
    // http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/typeActeur/read'));
    // getLocation();
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
                Center(
                    child: Image.asset(
                  'assets/images/logo.png',
                  height: 200,
                  width: 100,
                )),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 240, 178, 107),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "J'ai déjà un compte .",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text(
                            "Se connecter",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Inscription",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF2B6706)),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        // debut fullname
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Nom Complet *",
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
                          ),
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

                        const SizedBox(
                          height: 20,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Téléphone *",
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        IntlPhoneField(
                          initialCountryCode:
                              widget.iso, // Automatically detect user's country
                          invalidNumberMessage: "Numéro invalide",
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
                            processedNumberTel =
                                removePlus(phone.completeNumber.toString());
                            print(processedNumberTel);
                          },
                          onCountryChanged: (country) {
                            print('Country changed to: ' + country.name);
                          },
                        ),

//  const SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Numéro WhtasApp",
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
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
                          initialCountryCode:
                              widget.iso, // Automatically detect user's country
                          controller: whatsAppController,
                          invalidNumberMessage: "Numéro invalide",
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
                            processedNumber =
                                removePlus(phone.completeNumber.toString());
                            print(processedNumber);
                          },
                          onCountryChanged: (country) {
                            setState(() {
                              selectedCountry = country.name.toString();
                            });

                            print('Country changed to: ' + country.name);
                          },
                        ),

                        // fin  téléphone

                        //end select type acteur
                        const SizedBox(
                          height: 10,
                        ),

                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterNextScreen(
                                              nomActeur:
                                                  nomActeurController.text,
                                              whatsAppActeur:
                                                  processedNumberTel,
                                              telephone: processedNumberTel,
                                              pays: selectedCountry!,
                                            )));
                              }
                            },
                            child: Text(
                              " Suivant ",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFFF8A00), // Orange color code
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
