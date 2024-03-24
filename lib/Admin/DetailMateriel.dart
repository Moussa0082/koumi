import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Materiel.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMateriel extends StatefulWidget {
  final Materiel materiel;
  const DetailMateriel({super.key, required this.materiel});

  @override
  State<DetailMateriel> createState() => _DetailMaterielState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _DetailMaterielState extends State<DetailMateriel> {
  TextEditingController _nomController = TextEditingController();
  TextEditingController _localiteController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _etatController = TextEditingController();
  TextEditingController _prixController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  List<ParametreGeneraux> paraList = [];
  late ParametreGeneraux para = ParametreGeneraux();
  late ValueNotifier<bool> isDialOpenNotifier;
  String? imageSrc;
  File? photo;
  late Acteur acteur = Acteur();
  late List<TypeActeur> typeActeurData = [];
  late String type;
  bool _isLoading = false;
  bool active = false;
  late Future _niveau3List;
  String? n3Value;
  String niveau3 = '';
  late Materiel materiels;
  bool _isEditing = false;

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
    verifyParam();
    _niveau3List =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/nivveau3Pays/read'));
    materiels = widget.materiel;
    _nomController.text = materiels.nom;
    _descriptionController.text = materiels.description;
    _etatController.text = materiels.etatMateriel;
    _localiteController.text = materiels.localisation;
    _prixController.text = materiels.prixParHeure.toString();
    isDialOpenNotifier = ValueNotifier<bool>(false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              toolbarHeight: 100,
              leading: _isEditing
                  ? IconButton(
                      onPressed: () {
                        // _showImageSourceDialog
                      },
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
                'Détail matériel',
                style: const TextStyle(
                    color: d_colorGreen, fontWeight: FontWeight.bold),
              ),
              actions: acteur.nomActeur == materiels.acteur.nomActeur
                  ? [
                      _isEditing
                          ? IconButton(
                              onPressed: () async {
                                setState(() {
                                  _isEditing = false;
                                });
                                // updateMethode();
                              },
                              icon: Icon(Icons.check),
                            )
                          : IconButton(
                              onPressed: () async {
                                setState(() {
                                  _isEditing = true;
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
                photo != null
                    ? Center(
                        child: Image.file(
                        photo!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ))
                    : Center(
                        child: materiels.photoMateriel != null &&
                                materiels.photoMateriel!.isNotEmpty
                            ? Image.network(
                                "http://10.0.2.2/${materiels.photoMateriel}",
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
                _isEditing ? _buildEditingData() : _buildData(),
              ],
            ),
          ),
          floatingActionButton: acteur.nomActeur != materiels.acteur.nomActeur
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
                            materiels.acteur.whatsAppActeur!;
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
                            materiels.acteur.telephoneActeur!;
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

  Widget _buildData() {
    return Column(
      children: [
        _buildItem('Nom du matériel: ', materiels.nom),
        _buildItem('Type matériel: ', materiels.typeMateriel.nom!),
        _buildItem('Localité : ', materiels.localisation),
        _buildItem('Etat du matériel : ', materiels.etatMateriel),
        _buildItem('Prix par heure : ', materiels.prixParHeure.toString()),
        _buildItem('Date d\'ajout : ', materiels.dateAjout!),
        _buildDescription('Description : ', materiels.description)
      ],
    );
  }

  Widget _buildEditingData() {
    return Column(
      children: [
        _buildEditableDetailItem('Nom du matériel: ', _nomController),
        _buildEditableDetailItem('Localité : ', _localiteController),
        _buildEditableDetailItem('Etat du matériel : ', _etatController),
        _buildEditableDetailItem('Prix par heure : ', _prixController),
        _buildEditableDetailItem('Description : ', _descriptionController)
      ],
    );
  }

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
}
