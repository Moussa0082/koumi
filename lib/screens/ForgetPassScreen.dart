import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/screens/CodeConfirmScreen.dart';
import 'package:koumi_app/service/ActeurService.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen>
    with AutomaticKeepAliveClientMixin<ForgetPassScreen> {
  // Override wantKeepAlive to return true
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = "";
  String whatsApp = "";

  String _errorMessage = "";

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email ne doit pas être vide";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Email non valide";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  // Fonction pour vérifier la connectivité réseau
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

// Fonction pour afficher un message d'erreur si la connexion Internet n'est pas disponible
  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur de connexion'),
          content: const Text(
              'Veuillez vérifier votre connexion Internet et réessayer.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _handleClick(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    await handleSendButton(context).then((_) {
      // Cacher l'indicateur de chargement lorsque votre fonction est terminée
      setState(() {
        isLoading = false;
      });
    });
  }

  // Fonction pour gérer le bouton Envoyer
  handleSendButton(BuildContext context) async {
    bool isConnected = await checkInternetConnectivity();
    if (!isConnected) {
      showNoInternetDialog(context);
      return;
    }

    // Si la connexion Internet est disponible, poursuivez avec l'envoi du code
    // Affichez la boîte de dialogue de chargement

    try {
      final emailActeur = emailController.text;
      final whatsAppActeur = whatsAppController.text;

      if (isVisible) {
        await ActeurService.sendOtpCodeEmail(emailActeur, context);
        debugPrint("Code envoyé par mail");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Succès'),
              content: const Text("Code envoyé par à email avec succès"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CodeConfirmScreen(
                                isVisible: isVisible,
                                emailActeur: emailController.text,
                                whatsAppActeur: whatsAppController.text)));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        await ActeurService.sendOtpCodeWhatsApp(whatsAppActeur, context);
        debugPrint("Code envoyé par whats app");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Succès'),
              content: const Text(
                  "Code envoyé par à votre numéro whtas app avec succès"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CodeConfirmScreen(
                                isVisible: isVisible,
                                emailActeur: emailController.text,
                                whatsAppActeur: whatsAppController.text)));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }

      // Fermez la boîte de dialogue de chargement après l'envoi du code
    } catch (e) {
      // En cas d'erreur, fermez également la boîte de dialogue de chargement
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: const Text("Une erreur s'est produite veuillez réessayer"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => CodeConfirmScreen(
                  //             isVisible: isVisible,
                  //             emailActeur: emailController.text,
                  //             whatsAppActeur: whatsAppController.text)));
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      // Gérez l'erreur ici
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
  bool isVisible = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isVisible = !isVisible;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    // Fonction de retour
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  iconSize: 30,
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              ),
              Center(child: Image.asset('assets/images/fg-pass.png')),
              // connexion
              const Text(
                " Mot de passe oublier  ",
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
                    // debut email ou whats app
                    // Row(
                    //   children:[
                    //     Text("Email"),

                    //   ]
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Bouton radio Email
                        Text(
                          'Email',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Radio(
                          value: true,
                          groupValue: isVisible,
                          onChanged: (bool? value) {
                            setState(() {
                              isVisible = value!;
                            });
                          },
                        ),
                        // Espace
                        SizedBox(width: 4),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('WhatsApp',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        // Bouton radio WhatsApp
                        Radio(
                          value: false,
                          groupValue: isVisible,
                          onChanged: (bool? value) {
                            setState(() {
                              isVisible = value!;
                            });
                          },
                        ),
                      ],
                    ),

                    //                Padding(
                    //   padding: const EdgeInsets.only(left:10.0),
                    //   child: Text( isVisible ? " Email *" : "Whats App *" , style: TextStyle(color:  (Colors.black), fontSize: 18),),
                    // ),

                    Padding(
                      padding: EdgeInsets.all(2),
                      child: Center(
                        child: Text(isVisible ? _errorMessage : ""),
                      ),
                    ),
                    Visibility(
                      visible: isVisible,
                      child: TextFormField(
                        controller: emailController,
                         decoration: InputDecoration(
                          hintText: "Entrez votre adresse email",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Veillez entrez votre adresse email";
                          } else if (_errorMessage == "Email non valide" &&
                              isVisible == false) {
                            return "Veillez entrez une adresse email valide";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          validateEmail(val);
                        },
                        onSaved: (val) => email = val!,
                      ),
                    ),
                    Visibility(
                      visible: !isVisible,
                      child: TextFormField(
                        controller: whatsAppController,
                         decoration: InputDecoration(
                          hintText: "Entrez votre numéro WhatsApp",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Veillez entrez votre numéro WhatsApp";
                          } else if (val.length < 8) {
                            return "Veillez entrez au moins 8 chiffres";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => whatsApp = val!,
                      ),
                    ),
                  ],
                ),
              ),

              //       TextButton(
              //   onPressed: ()  {

              //   setState(() {
              //     isVisible = !isVisible;
              //   });

              //   },
              //   child: Text(
              // isVisible ? "Envoyer le code par WhatsApp" : "Envoyer le code par email",
              // style: TextStyle(fontSize: 16),
              //   ),
              // ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleClick(context);
                    }
                  },
                  child: Text(
                    " Envoyer ",
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
            ]),
          ))),
    );
  }
}
