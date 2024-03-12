import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/models/Vehicule.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
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
  late Acteur acteur;
  late List<TypeActeur> typeActeurData = [];
  late String type;
  String? imageSrc;
  File? photo;
    late Map<String, int> prixParDestinations;

  late ValueNotifier<bool> isDialOpenNotifier;
  TextEditingController _prixController = TextEditingController();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _capaciteController = TextEditingController();
  TextEditingController _etatController = TextEditingController();
  TextEditingController _localiteController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;
  bool active = false;

  @override
  void initState() {
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    typeActeurData = acteur.typeActeur;
    type = typeActeurData.map((data) => data.libelle).join(', ');
prixParDestinations = {};
    vehicules = widget.vehicule;

    _nomController.text = vehicules.nomVehicule;
    // _prixController.text = vehicules.prix.toString();
    _capaciteController.text = vehicules.capaciteVehicule;
    _etatController.text = vehicules.etatVehicule.toString();
    _localiteController.text = vehicules.localisation;

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
      final String prix = _prixController.text;
      final String etat = _etatController.text;
      final String localite = _localiteController.text;

      // Appel de la méthode de mise à jour du service
      // await VehiculeService().updateVehicule(
      //   idVehicule: vehicules.idVehicule!,
      //   nomVehicule: nom,
      //   capaciteVehicule: capacite,
      //   prix: prix,
      //   etatVehicule: etat,
      //   localisation: localite,
      //   description: description,
      //   acteur: acteur,
      // );

      // Mise à jour des données locales
      setState(() {
        final int? prixParsed = int.tryParse(prix);
        final int prixValue = prixParsed ?? 0;
        // vehicules = Vehicule(
        //   idVehicule: vehicules.idVehicule,
        //   nomVehicule: nom,
        //   capaciteVehicule: capacite,
        //   description: description,
        //   prix: prixValue,
        //   etatVehicule: etat,
        //   localisation: localite,
        //   acteur: acteur, statutVehicule: vehicules.statutVehicule,
        // );
        // Désactiver l'indicateur de chargement après la mise à jour
        _isLoading = false;
      });
    } catch (e) {
      // Gérer les erreurs potentielles ici
      print(e.toString());
      setState(() {
        _isLoading =
            false; // Assurez-vous de désactiver l'indicateur de chargement en cas d'erreur
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
                  ? Container()
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
                    ]
                  : null),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: vehicules.photoVehicule != null
                      ? Image.network(
                          "http://10.0.2.2/${vehicules.photoVehicule!}",
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/images/camion.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                ),
                SizedBox(height: 30),
                _isEditing ? _buildEditing() : _buildData(),
                _buildDescription(
                    'Description : ', vehicules.typeVoiture.description!),
                _buildPanel()
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
                            vehicules.acteur.whatsAppActeur;
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
                            vehicules.acteur.telephoneActeur;
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
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 22,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Destination et prix",
              style: TextStyle(color: (Colors.black), fontSize: 18),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    hintText: "Destination",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _prixController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: "Prix",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    String destination = _destinationController.text;
                    int prix = int.tryParse(_prixController.text) ?? 0;

                    if (destination.isNotEmpty && prix > 0) {
                      // Ajouter la destination et le prix à la liste prixParDestinations
                      prixParDestinations.addAll({destination: prix});

                      print(prixParDestinations.toString());

                      _destinationController.clear();
                      _prixController.clear();
                    }
                  });
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
        _buildEditableDetailItem('Localisation : ', _localiteController),
        _buildEditableDetailItem('Etat du véhicule : ', _etatController),
      ],
    );
  }

  Widget _buildData() {
    return Column(
      children: [
        _buildItem('Nom du véhicule : ', vehicules.nomVehicule),
        _buildItem('Type de véhicule : ', vehicules.typeVoiture.nom),
        vehicules.typeVoiture.nombreSieges != 0
            ? _buildItem('Nombre de siège : ',
                vehicules.typeVoiture.nombreSieges.toString())
            : Container(),
        _buildItem('Capacité : ', vehicules.capaciteVehicule),
        // _buildItem('Prix / voyage: ', vehicules.prix.toString()),
        _buildItem('Localisation : ', vehicules.localisation),
        _buildItem('Statut: : ',
            '${vehicules.statutVehicule ? 'Disponible' : 'Non disponible'}'),
        acteur.nomActeur != vehicules.acteur.nomActeur
            ? _buildItem('Propriètaire : ', vehicules.acteur.nomActeur)
            : Container(),
        // _buildItem('Description : ', vehicules.typeVoiture.description!),
      ],
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

          // Divider(),
        ],
      ),
    );
  }

  Widget _buildDescription(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
                    return _buildItem(destination, "${prix.toString()} FCFA");
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
