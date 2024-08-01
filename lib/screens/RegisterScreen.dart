import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:koumi_app/providers/CountryProvider.dart';
import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/screens/RegisterNextScreen.dart';
import 'package:koumi_app/widgets/DetectorPays.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String nomActeur = "";
  String telephone = "";

  PhoneNumber locale =
      PhoneNumber(isoCode: Platform.localeName.split('_').last);

  String? typeValue;
  String? selectedCountry = "";
  String? detectedCountryCode = "";
  // late TypeActeur monTypeActeur;
  // late Future _mesTypeActeur;
  Position? _currentPosition;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _errorMessage = "";

  String dropdownvalue = 'Item 1';

  final TextEditingController controller = TextEditingController();
  CountryProvider? countryProvider;

  String? initialCountry;
  // String detectedCountryCode = '';
  PhoneNumber number = PhoneNumber();
  // List of items in our dropdown menu
  var items = [
    'Item 2',
  ];

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(
        phoneNumber, Platform.localeName.split('_').last);

    setState(() {
      this.number = number;
    });
  }

  TextEditingController nomActeurController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController telephoneController = TextEditingController();
  TextEditingController typeActeurController = TextEditingController();

  String removePlus(String phoneNumber) {
    if (phoneNumber.startsWith('+')) {
      return phoneNumber.substring(1); // Remove the first character
    } else {
      return phoneNumber; // No change if "+" is not present
    }
  }

  bool isWhatsAppEditing = false;
  bool isPhoneEditing = false;
  String processedNumberWA = "";
  String processedNumberTel = "";
  String selectCode = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Accédez au fournisseur ici
    countryProvider = Provider.of<CountryProvider>(context, listen: false);
  }

  void updateCountryCode(String countryCode) {
    setState(() {
      detectedCountryCode = countryCode;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final paysProvider = Provider.of<DetectorPays>(context, listen: false);
    paysProvider.hasLocation
        ? detectedCountryCode =
            Provider.of<DetectorPays>(context, listen: false)
                .detectedCountryCode!
        : detectedCountryCode = "ML";
    paysProvider.hasLocation
        ? selectedCountry =
            Provider.of<DetectorPays>(context, listen: false).detectedCountry!
        : selectedCountry = "Mali";

    print("pays code : ${detectedCountryCode}, ${selectedCountry}");

    whatsAppController.addListener(() {
      if (isPhoneEditing) return;
      setState(() {
        processedNumberWA = removePlus(whatsAppController.text);
        phoneController.text = processedNumberWA;
      });
    });

    phoneController.addListener(() {
      if (isWhatsAppEditing) return;
      setState(() {
        processedNumberTel = removePlus(phoneController.text);
      });
    });

    // whatsAppController.addListener(() {
    //   if (isPhoneEditing) return;
    //   setState(() {
    //     // processedNumber = removePlus(whatsAppController.text);
    //     phoneController.text = whatsAppController.text;
    //   });
    // });

    // phoneController.addListener(() {
    //   if (isWhatsAppEditing) return;
    //   setState(() {
    //     processedNumberTel = phoneController.text;
    //     // processedNumberTel = removePlus(phoneController.text);
    //   });
    // });
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
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios))),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Center(
                    child: Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                  width: 150,
                )),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 248, 138, 11),
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
                        SizedBox(
                          height: 15,
                        ),
                        // fin  adresse fullname
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Numéro WhatsApp",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 4),
                        IntlPhoneField(
                          initialCountryCode: detectedCountryCode != null
                              ? detectedCountryCode
                              : "ML",
                          controller: whatsAppController,
                          disableLengthCheck: true,
                          invalidNumberMessage: "Numéro invalide",
                          searchText: "Chercher un pays",
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          languageCode: "fr",
                          onChanged: (phone) {
                            print(phone.completeNumber);
                            processedNumberWA =
                                removePlus(phone.completeNumber.toString());
                            print("wa selected  $processedNumberWA");
                          },
                          onCountryChanged: (country) {
                            setState(() {
                              selectedCountry = country.name.toString();
                              updateCountryCode(country.code.toString());
                              processedNumberWA =
                                  removePlus(whatsAppController.text);
                            });
                            print("wa change country $processedNumberWA");

                            // Obtenir le numéro actuel sans indicatif
                            String currentNumber = whatsAppController.text
                                .replaceAll(RegExp(r'^\+\d+\s'), '');

                            // Ajouter l'indicatif du nouveau pays au numéro actuel
                            String newCompleteNumber =
                                '+${country.dialCode}$currentNumber';

                            // Mettre à jour le controller avec le nouveau numéro complet
                            // whatsAppController.text = newCompleteNumber;

                            // Mettre à jour processedNumberWA avec le nouveau numéro complet sans le signe +
                            setState(() {
                              processedNumberWA = removePlus(newCompleteNumber);
                            });

                            print(
                                "wa updated with country change $processedNumberWA");

                            print('Country changed to: ' + country.name);
                          },
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Téléphone *",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 5),
                        IntlPhoneField(
                          initialCountryCode: detectedCountryCode != null
                              ? detectedCountryCode
                              : "ML",
                          controller: phoneController,
                          disableLengthCheck: true,
                          invalidNumberMessage: "Numéro invalide",
                          searchText: "Chercher un pays",
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          languageCode: "fr",
                          onChanged: (phone) {
                            print(phone.completeNumber);

                            processedNumberTel =
                                removePlus(phone.completeNumber.toString());
                            print("tel selected  $processedNumberTel");
                          },
                          onCountryChanged: (country) {
                            setState(() {
                              // selectedCountry = country.name.toString();
                              // updateCountryCode(country.code.toString());
                              processedNumberTel =
                                  removePlus(phoneController.text);
                            });
                            print("wa change country $processedNumberWA");

                            // Obtenir le numéro actuel sans indicatif
                            String currentNumber = phoneController.text
                                .replaceAll(RegExp(r'^\+\d+\s'), '');

                            // Ajouter l'indicatif du nouveau pays au numéro actuel
                            String newCompleteNumber =
                                '+${country.dialCode}$currentNumber';

                            // Mettre à jour le controller avec le nouveau numéro complet
                            // whatsAppController.text = newCompleteNumber;

                            // Mettre à jour processedNumberWA avec le nouveau numéro complet sans le signe +
                            setState(() {
                              processedNumberTel =
                                  removePlus(newCompleteNumber);
                            });

                            print(
                                "wa updated with country change $processedNumberTel");

                            print('Country changed to: ' + country.name);
                          },
                        ),

                        //end select type acteur
                        const SizedBox(
                          height: 10,
                        ),

                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                print("pays: $selectedCountry");
                                print(
                                    "tel :${processedNumberTel} , wa ${processedNumberWA}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterNextScreen(
                                              nomActeur:
                                                  nomActeurController.text,
                                              whatsAppActeur: processedNumberWA,
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
