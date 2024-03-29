import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Niveau3Pays.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/models/TypeVoiture.dart';
import 'package:koumi_app/models/Vehicule.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/service/VehiculeService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailTransport extends StatefulWidget {
  final Vehicule vehicule;
  const DetailTransport({super.key, required this.vehicule});

  @override
  State<DetailTransport> createState() => _DetailTransportState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _DetailTransportState extends State<DetailTransport> {
  late Vehicule vehicules;
  late Acteur acteur = Acteur();
  late List<TypeActeur> typeActeurData = [];
  late String type;
  String? imageSrc;
  File? photo;
  late TypeVoiture typeVoiture;
  late Map<String, int> prixParDestinations;
  List<ParametreGeneraux> paraList = [];
  late ParametreGeneraux para = ParametreGeneraux();
  late ValueNotifier<bool> isDialOpenNotifier;
  TextEditingController _prixController = TextEditingController();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _nbKiloController = TextEditingController();
  TextEditingController _capaciteController = TextEditingController();
  TextEditingController _etatController = TextEditingController();
  TextEditingController _localiteController = TextEditingController();
  List<TextEditingController> _destinationControllers = [];
  List<TextEditingController> _prixControllers = [];
  List<TextEditingController> destinationControllers = [];
  List<TextEditingController> prixControllers = [];
  List<Widget> destinationPrixFields = [];
  bool _isEditing = false;
  bool _isLoading = false;
  bool active = false;
  String? typeValue;
  late Future _niveau3List;
  String? n3Value;
  String niveau3 = '';
  List<String> selectedDestinations = [];
  Map<String, int> newPrixParDestinations = {};
  List<String?> selectedDestinationsList = [];

  bool isExist = false;
  String? email = "";

  void verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('emailActeur');
    if (email != null) {
      // Si l'email de l'acteur est présent, exécute checkLoggedIn
      acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
      typeActeurData = acteur.typeActeur!;
      type = typeActeurData.map((data) => data.libelle).join(', ');
      setState(() {
        isExist = true;
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

  // Méthode pour ajouter une nouvelle destination et prix
  void addDestinationAndPrix() {
    // Créer un nouveau contrôleur pour chaque champ
    TextEditingController newDestinationController = TextEditingController();
    TextEditingController newPrixController = TextEditingController();

    setState(() {
      // Ajouter les nouveaux contrôleurs aux listes
      destinationControllers.add(newDestinationController);
      prixControllers.add(newPrixController);

      // Ajouter une valeur nulle à la liste des destinations sélectionnées
      selectedDestinationsList.add(null);
    });
  }

  void ajouterPrixDestination() {
    for (int i = 0; i < selectedDestinationsList.length; i++) {
      String destination = selectedDestinations[i];
      int prix = int.tryParse(prixControllers[i].text) ?? 0;

      // Ajouter la destination et le prix à la nouvelle map
      if (destination.isNotEmpty && prix > 0) {
        newPrixParDestinations.addAll({destination: prix});
      }
    }
  }

  void verifyParam() {
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;

    if (paraList.isNotEmpty) {
      para = paraList[0];
    } else {
      // Gérer le cas où la liste est null ou vide, par exemple :
      // Afficher un message d'erreur, initialiser 'para' à une valeur par défaut, etc.
    }
  }

  @override
  void initState() {
    verify();
    // paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
    //     .parametreList!;
    // para = paraList[0];
    verifyParam();
    // _niveau3List =
    //     http.get(Uri.parse('https://koumi.ml/api-koumi/nivveau3Pays/read'));
    _niveau3List =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/nivveau3Pays/read'));
    vehicules = widget.vehicule;
    typeVoiture = vehicules.typeVoiture;
    prixParDestinations = vehicules.prixParDestination;
    _nomController.text = vehicules.nomVehicule;
    _capaciteController.text = vehicules.capaciteVehicule;
    _etatController.text = vehicules.etatVehicule.toString();
    _localiteController.text = vehicules.localisation;
    _descriptionController.text = vehicules.description!;
    _nbKiloController.text = vehicules.nbKilometrage.toString();
    vehicules.prixParDestination.forEach((destination, prix) {
      TextEditingController destinationController =
          TextEditingController(text: destination);
      TextEditingController prixController =
          TextEditingController(text: prix.toString());

      _destinationControllers.add(destinationController);
      _prixControllers.add(prixController);
    });

    isDialOpenNotifier = ValueNotifier<bool>(false);
    super.initState();
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = path.basename(imagePath);
    final image = File('${directory.path}/$name');
    return image;
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await getImage(source);
    if (image != null) {
      setState(() {
        photo = image;
        imageSrc = image.path;
      });
    }
  }

  Future<File?> getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return null;

    return File(image.path);
  }

  Future<void> _showImageSourceDialog() async {
    final BuildContext context = this.context;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: AlertDialog(
            title: const Text('Choisir une source'),
            content: Wrap(
              alignment: WrapAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Fermer le dialogue
                    _pickImage(ImageSource.camera);
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.camera_alt, size: 40),
                      Text('Camera'),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Fermer le dialogue
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.image, size: 40),
                      Text('Galerie photo'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updateMethode() async {
    setState(() {
      // Afficher l'indicateur de chargement pendant l'opération
      _isLoading = true;
    });

    try {
      // Récupération des nouvelles valeurs des champs
      final String nom = _nomController.text;
      final String capacite = _capaciteController.text;
      final String etat = _etatController.text;
      final String localite = _localiteController.text;
      final String description = _descriptionController.text;
      final String nbKil = _nbKiloController.text;
      final int? nb = int.tryParse(nbKil);

      setState(() {
        // Parcourir les destinations et les prix modifiés simultanément
        for (int i = 0; i < _destinationControllers.length; i++) {
          String destination = _destinationControllers[i].text;
          int prix = int.tryParse(_prixControllers[i].text) ?? 0;

          // Ajouter la destination et le prix à la nouvelle map
          if (destination.isNotEmpty && prix > 0) {
            newPrixParDestinations[destination] = prix;
          }
        }

        // Parcourir pour ajouter les nouvelles destinations
        for (int i = 0; i < selectedDestinationsList.length; i++) {
          String destination = selectedDestinations[i];
          int prix = int.tryParse(prixControllers[i].text) ?? 0;

          // Ajouter la destination et le prix à la nouvelle map
          if (destination.isNotEmpty && prix > 0) {
            // Si la destination n'existe pas déjà dans la nouvelle map, l'ajouter
            if (!newPrixParDestinations.containsKey(destination)) {
              newPrixParDestinations[destination] = prix;
            } else {
              // Si la destination existe déjà, mettre à jour le prix
              newPrixParDestinations[destination] = prix;
              // Réinitialiser les contrôleurs de destination et de prix
            }
          }
        }
        // Réinitialiser les listes de destinations sélectionnées
        selectedDestinationsList.clear();
        selectedDestinations.clear();
      });

      if (photo != null) {
        await VehiculeService()
            .updateVehicule(
              idVehicule: vehicules.idVehicule,
              nomVehicule: nom,
              capaciteVehicule: capacite,
              prixParDestination: newPrixParDestinations,
              etatVehicule: etat,
              photoVehicule: photo,
              localisation: localite,
              description: description,
              nbKilometrage: nb.toString(),
              typeVoiture: typeVoiture,
              acteur: acteur,
            )
            .then((value) => {
                  setState(() {
                    vehicules = Vehicule(
                      idVehicule: vehicules.idVehicule,
                      nomVehicule: nom,
                      photoVehicule: vehicules.photoVehicule,
                      capaciteVehicule: capacite,
                      prixParDestination: newPrixParDestinations,
                      etatVehicule: etat,
                      codeVehicule: vehicules.codeVehicule,
                      description: vehicules.description,
                      nbKilometrage: nb,
                      localisation: localite,
                      typeVoiture: typeVoiture,
                      acteur: acteur,
                      statutVehicule: vehicules.statutVehicule,
                    );

                    _isLoading = false;
                  }),
                  Provider.of<VehiculeService>(context, listen: false)
                      .applyChange()
                })
            .catchError((onError) => {print(onError.toString())});
      } else {
        await VehiculeService()
            .updateVehicule(
              idVehicule: vehicules.idVehicule,
              nomVehicule: nom,
              capaciteVehicule: capacite,
              prixParDestination: newPrixParDestinations,
              etatVehicule: etat,
              localisation: localite,
              description: description,
              nbKilometrage: nb.toString(),
              typeVoiture: typeVoiture,
              acteur: acteur,
            )
            .then((value) => {
                  setState(() {
                    vehicules = Vehicule(
                      idVehicule: vehicules.idVehicule,
                      nomVehicule: nom,
                      capaciteVehicule: capacite,
                      prixParDestination: newPrixParDestinations,
                      etatVehicule: etat,
                      photoVehicule: vehicules.photoVehicule,
                      codeVehicule: vehicules.codeVehicule,
                      description: description,
                      nbKilometrage: nb,
                      localisation: localite,
                      typeVoiture: typeVoiture,
                      acteur: acteur,
                      statutVehicule: vehicules.statutVehicule,
                    );
                    _isLoading = false;
                  }),
                  Provider.of<VehiculeService>(context, listen: false)
                      .applyChange()
                })
            .catchError((onError) => {print(onError.toString())});
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleButtonPress() async {
    // Afficher l'indicateur de chargement
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          appBar: AppBar(
              centerTitle: true,
              toolbarHeight: 100,
              leading: _isEditing
                  ? IconButton(
                      onPressed: _showImageSourceDialog,
                      icon: const Icon(
                        Icons.camera_alt,
                        // size: 60,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon:
                          const Icon(Icons.arrow_back_ios, color: d_colorGreen),
                    ),
              title: Text(
                'Transport',
                style: const TextStyle(
                    color: d_colorGreen, fontWeight: FontWeight.bold),
              ),
              actions: acteur.nomActeur == vehicules.acteur.nomActeur
                  ? [
                      _isEditing
                          ? IconButton(
                              onPressed: () async {
                                setState(() {
                                  _isEditing = false;
                                  vehicules = widget.vehicule;
                                });
                                updateMethode();
                              },
                              icon: Icon(Icons.check),
                            )
                          : IconButton(
                              onPressed: () async {
                                setState(() {
                                  _isEditing = true;
                                  vehicules = widget.vehicule;
                                });
                              },
                              icon: Icon(Icons.edit),
                            ),
                      // PopupMenuButton<String>(
                      //   padding: EdgeInsets.zero,
                      //   itemBuilder: (context) => <PopupMenuEntry<String>>[
                      //     PopupMenuItem<String>(
                      //       child: ListTile(
                      //         leading: const Icon(
                      //           Icons.check,
                      //           color: Colors.green,
                      //         ),
                      //         title: const Text(
                      //           "Activer",
                      //           style: TextStyle(
                      //             color: Colors.green,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         onTap: () async {
                      //           await VehiculeService()
                      //               .activerVehicules(vehicules.idVehicule!)
                      //               .then((value) => {
                      //                     Provider.of<VehiculeService>(context,
                      //                             listen: false)
                      //                         .applyChange(),
                      //                     setState(() {
                      //                       vehicules = Vehicule(
                      //                         idVehicule: vehicules.idVehicule,
                      //                         nomVehicule:
                      //                             vehicules.nomVehicule,
                      //                         capaciteVehicule:
                      //                             vehicules.capaciteVehicule,
                      //                         prixParDestination:
                      //                             prixParDestinations,
                      //                         etatVehicule:
                      //                             vehicules.etatVehicule,
                      //                         localisation:
                      //                             vehicules.localisation,
                      //                         typeVoiture: typeVoiture,
                      //                         acteur: acteur,
                      //                         statutVehicule:
                      //                             vehicules.statutVehicule,
                      //                       );
                      //                     }),
                      //                     Navigator.of(context).pop(),
                      //                     ScaffoldMessenger.of(context)
                      //                         .showSnackBar(
                      //                       const SnackBar(
                      //                         content: Row(
                      //                           children: [
                      //                             Text("Activer avec succèss "),
                      //                           ],
                      //                         ),
                      //                         duration: Duration(seconds: 2),
                      //                       ),
                      //                     )
                      //                   })
                      //               .catchError((onError) => {
                      //                     ScaffoldMessenger.of(context)
                      //                         .showSnackBar(
                      //                       const SnackBar(
                      //                         content: Row(
                      //                           children: [
                      //                             Text(
                      //                                 "Une erreur s'est produit"),
                      //                           ],
                      //                         ),
                      //                         duration: Duration(seconds: 5),
                      //                       ),
                      //                     ),
                      //                     Navigator.of(context).pop(),
                      //                   });
                      //         },
                      //       ),
                      //     ),
                      //     PopupMenuItem<String>(
                      //       child: ListTile(
                      //         leading: Icon(
                      //           Icons.disabled_visible,
                      //           color: Colors.orange[400],
                      //         ),
                      //         title: Text(
                      //           "Désactiver",
                      //           style: TextStyle(
                      //             color: Colors.orange[400],
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         onTap: () async {
                      //           await VehiculeService()
                      //               .desactiverVehicules(vehicules.idVehicule!)
                      //               .then((value) => {
                      //                     Provider.of<VehiculeService>(context,
                      //                             listen: false)
                      //                         .applyChange(),
                      //                     // setState(() {
                      //                     //   futureListe = getListe(
                      //                     //       typeVoiture.idTypeVoiture);
                      //                     // }),
                      //                     Navigator.of(context).pop(),
                      //                   })
                      //               .catchError((onError) => {
                      //                     ScaffoldMessenger.of(context)
                      //                         .showSnackBar(
                      //                       const SnackBar(
                      //                         content: Row(
                      //                           children: [
                      //                             Text(
                      //                                 "Une erreur s'est produit"),
                      //                           ],
                      //                         ),
                      //                         duration: Duration(seconds: 5),
                      //                       ),
                      //                     ),
                      //                     Navigator.of(context).pop(),
                      //                   });

                      //           ScaffoldMessenger.of(context).showSnackBar(
                      //             const SnackBar(
                      //               content: Row(
                      //                 children: [
                      //                   Text("Désactiver avec succèss "),
                      //                 ],
                      //               ),
                      //               duration: Duration(seconds: 2),
                      //             ),
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //     PopupMenuItem<String>(
                      //       child: ListTile(
                      //         leading: const Icon(
                      //           Icons.delete,
                      //           color: Colors.red,
                      //         ),
                      //         title: const Text(
                      //           "Supprimer",
                      //           style: TextStyle(
                      //             color: Colors.red,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         onTap: () async {
                      //           await VehiculeService()
                      //               .deleteVehicule(vehicules.idVehicule!)
                      //               .then((value) => {
                      //                     Provider.of<VehiculeService>(context,
                      //                             listen: false)
                      //                         .applyChange(),
                      //                     // setState(() {
                      //                     //   futureListe = getListe(
                      //                     //       typeVoiture.idTypeVoiture);
                      //                     // }),
                      //                     Navigator.of(context).pop(),
                      //                   })
                      //               .catchError((onError) => {
                      //                     ScaffoldMessenger.of(context)
                      //                         .showSnackBar(
                      //                       const SnackBar(
                      //                         content: Row(
                      //                           children: [
                      //                             Text(
                      //                                 "Impossible de supprimer"),
                      //                           ],
                      //                         ),
                      //                         duration: Duration(seconds: 2),
                      //                       ),
                      //                     )
                      //                   });
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ]
                  : null),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                photo != null
                    ? Center(
                        child: Image.file(
                        photo!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ))
                    : Center(
                        child: vehicules.photoVehicule != null &&
                                !vehicules.photoVehicule!.isEmpty
                            ? Image.network(
                                "http://10.0.2.2/${vehicules.photoVehicule!}",
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/default_image.png",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                      ),
                SizedBox(height: 30),
                _isEditing ? _buildEditing() : _buildData(),
                !_isEditing ? _buildPanel() : Container(),
                !_isEditing
                    ? _buildDescription(
                        'Description : ', vehicules.description!)
                    : Container(),
              ],
            ),
          ),
          floatingActionButton: acteur.nomActeur != vehicules.acteur.nomActeur
              ? SpeedDial(
                  // animatedIcon: AnimatedIcons.close_menu,
                  backgroundColor: d_colorGreen,
                  foregroundColor: Colors.white,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.4,
                  spacing: 12,
                  icon: Icons.phone,

                  children: [
                    SpeedDialChild(
                      child: FaIcon(FontAwesomeIcons.whatsapp),
                      label: 'Par wathsApp',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      onTap: () {
                        final String whatsappNumber =
                            vehicules.acteur.whatsAppActeur!;
                        _makePhoneWa(whatsappNumber);
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.phone),
                      label: 'Par téléphone ',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      onTap: () {
                        final String numberPhone =
                            vehicules.acteur.telephoneActeur!;
                        _makePhoneCall(numberPhone);
                      },
                    )
                  ],
                  // État du Speed Dial (ouvert ou fermé)
                  openCloseDial: isDialOpenNotifier,
                  // Fonction appelée lorsque le bouton principal est pressé
                  onPress: () {
                    isDialOpenNotifier.value = !isDialOpenNotifier
                        .value; // Inverser la valeur du ValueNotifier
                  },
                )
              : Container()),
    );
  }

  // Future<void> _openWhatsApp(String whatsappNumber) async {
  //   final Uri url = Uri.parse("https://wa.me/$whatsappNumber");
  //   if (await launchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     print("Failed to launch $url");
  //   }
  // }

  Future<void> _makePhoneWa(String whatsappNumber) async {
    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: whatsappNumber,
    );
    print(Uri);
    await launchUrl(launchUri);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Widget _buildEditing() {
    return Column(
      children: [
        _buildEditableDetailItem('Nom du véhicule : ', _nomController),
        _buildEditableDetailItem('Capacité : ', _capaciteController),
        _buildEditableDetailItem('Localisation : ', _localiteController),
        _buildEditableDetailItem('Etat du véhicule : ', _etatController),
        _buildEditableDetailItem('Description : ', _descriptionController),
        _buildEditableDetailItem('Nombre kilometrage : ', _nbKiloController),
        _buildDestinationPriceFields(),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 22,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ajouter prix",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () {
                      // Appeler la méthode pour ajouter une destination et un prix
                      addDestinationAndPrix();
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: destinationPrixFields,
              ),
              Column(
                children: List.generate(
                  destinationControllers.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: FutureBuilder(
                            future: _niveau3List,
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return DropdownButtonFormField(
                                  items: [],
                                  onChanged: null,
                                  decoration: InputDecoration(
                                    labelText: 'Destination',
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              if (snapshot.hasData) {
                                dynamic responseData =
                                    json.decode(snapshot.data.body);
                                if (responseData is List) {
                                  final reponse = responseData;
                                  final niveau3List = reponse
                                      .map((e) => Niveau3Pays.fromMap(e))
                                      .where((con) => con.statutN3 == true)
                                      .toList();

                                  if (niveau3List.isEmpty) {
                                    return DropdownButtonFormField(
                                      items: [],
                                      onChanged: null,
                                      decoration: InputDecoration(
                                        labelText: 'Destination',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    );
                                  }

                                  return DropdownButtonFormField<String>(
                                    items: niveau3List
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.idNiveau3Pays,
                                            child: Text(e.nomN3),
                                          ),
                                        )
                                        .toList(),

                                    value: selectedDestinationsList[
                                        index], // Utilisez l'index pour accéder à la valeur sélectionnée correspondante dans selectedDestinationsList
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedDestinationsList[index] =
                                            newValue; // Mettre à jour avec l'ID de la destination
                                        String selectedDestinationName =
                                            niveau3List
                                                .firstWhere((element) =>
                                                    element.idNiveau3Pays ==
                                                    newValue)
                                                .nomN3;
                                        selectedDestinations.add(
                                            selectedDestinationName); // Ajouter le nom de la destination à la liste
                                        print(
                                            "niveau 3 : $selectedDestinationsList");
                                        print(
                                            "niveau 3 nom  : $selectedDestinations");
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Destination',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                } else {
                                  return DropdownButtonFormField(
                                    items: [],
                                    onChanged: null,
                                    decoration: InputDecoration(
                                      labelText: 'Destination',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                }
                              }
                              return DropdownButtonFormField(
                                items: [],
                                onChanged: null,
                                decoration: InputDecoration(
                                  labelText: 'Destination',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: prixControllers[index],
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: "Prix",
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildData() {
    return Column(
      children: [
        _buildItem('Nom du véhicule : ', vehicules.nomVehicule),
        _buildItem('Type de véhicule : ', vehicules.typeVoiture.nom!),
        vehicules.typeVoiture.nombreSieges != 0
            ? _buildItem('Nombre de siège : ',
                vehicules.typeVoiture.nombreSieges.toString())
            : Container(),
        _buildItem('Capacité : ', vehicules.capaciteVehicule),
        // _buildItem('Prix / voyage: ', vehicules.prix.toString()),
        _buildItem('Localisation : ', vehicules.localisation),
        _buildItem('Nombre de kilometrage : ',
            "${vehicules.nbKilometrage.toString()} Km"),
        _buildItem('Statut: : ',
            '${vehicules.statutVehicule ? 'Disponible' : 'Non disponible'}'),
        !isExist
            ? Container()
            : acteur.nomActeur != vehicules.acteur.nomActeur
                ? _buildItem('Propriètaire : ', vehicules.acteur.nomActeur!)
                : Container(),
        // _buildItem('Description : ', vehicules.description!),
      ],
    );
  }

  Widget _buildDestinationPriceFields() {
    List<Widget> fields = [];

    for (int i = 0; i < _destinationControllers.length; i++) {
      fields.add(
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _destinationControllers[i],
                decoration: InputDecoration(
                  hintText: 'Destination',
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _prixControllers[i],
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: 'Prix',
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: fields,
    );
  }

  Widget _buildEditableDetailItem(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 18),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black54,
                  ),
                  enabled: _isEditing,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDescription(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 18),
            ),
            Text(
              value,
              textAlign: TextAlign.justify,
              softWrap: true,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                // overflow: TextOverflow.ellipsis,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                overflow: TextOverflow.ellipsis,
                fontSize: 18),
          ),
          Text(
            value,
            textAlign: TextAlign.justify,
            softWrap: true,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              overflow: TextOverflow.ellipsis,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          active = !active;
        });
      },
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                "Voir les prix par destination",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 17,
                ),
              ),
            );
          },
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: List.generate(vehicules.prixParDestination.length,
                      (index) {
                    String destination =
                        vehicules.prixParDestination.keys.elementAt(index);
                    int prix =
                        vehicules.prixParDestination.values.elementAt(index);
                    return _buildItem(
                        destination, "${prix.toString()} ${para.monnaie}");
                  }),
                ),
              ),
            ],
          ),
          isExpanded: active,
          canTapOnHeader: true,
        )
      ],
    );
  }
}
