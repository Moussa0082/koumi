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
  String selectedCountry = "";
  String detectedCountryCode = "";
  // late TypeActeur monTypeActeur;
  // late Future _mesTypeActeur;
  Position? _currentPosition;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // var detectedCountry = "";
  // String? detectedC = "";
  // String dialCode = "";

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
  String processedNumber = "";
  String processedNumberTel = "";
  // String selectedCountryCode = 'ML';
  // void detectNum(String num){
  //   if(processedNumberTel.isEmpty){
  //     setState(() {
  //     processedNumberTel = num;
  //   });
  //   }
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Accédez au fournisseur ici
    countryProvider = Provider.of<CountryProvider>(context, listen: false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    detectedCountryCode =
        Provider.of<DetectorPays>(context, listen: false).detectedCountryCode!;
    selectedCountry =
        Provider.of<DetectorPays>(context, listen: false).detectedCountry!;

    whatsAppController.addListener(() {
      if (isPhoneEditing) return;
      setState(() {
        processedNumber = removePlus(whatsAppController.text);
        phoneController.text = processedNumber;
      });
    });

    phoneController.addListener(() {
      if (isWhatsAppEditing) return;
      setState(() {
        processedNumberTel = removePlus(phoneController.text);
      });
    });

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

                        IntlPhoneField(
                          initialCountryCode: detectedCountryCode,
                          controller: whatsAppController,
                          invalidNumberMessage: "Numéro invalide",
                          searchText: "Chercher un pays",
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
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
                        const SizedBox(
                          height: 10,
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
                          controller: phoneController,
                          initialCountryCode:
                              detectedCountryCode, // Automatically detect user's country
                          invalidNumberMessage: "Numéro invalide",
                          searchText: "Chercher un pays",
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
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

                        //end select type acteur
                        const SizedBox(
                          height: 10,
                        ),

                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                print("pays: $selectedCountry");
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
                                              pays: selectedCountry,
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
