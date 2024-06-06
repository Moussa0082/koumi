import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Materiel.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/screens/DetailProduits.dart';
import 'package:koumi_app/service/MaterielService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
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

  
    bool isLoadingLibelle = true;
    String? monnaie;


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

     Future<String> getMonnaieByActor(String id) async {
    final response = await http.get(Uri.parse('$apiOnlineUrl/acteur/monnaie/$id'));

    if (response.statusCode == 200) {
      print("libelle : ${response.body}");
      return response.body;  // Return the body directly since it's a plain string
    } else {
      throw Exception('Failed to load monnaie');
    }
}

Future<void> fetchPaysDataByActor() async {
    try {
     
      String monnaies = await getMonnaieByActor(acteur.idActeur!);

      setState(() { 
        monnaie = monnaies;
        isLoadingLibelle = false;
      });
    } catch (e) {
      setState(() {
        isLoadingLibelle = false;
        });
      print('Error: $e');
    }
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
      final String nom = _nomController.text;
      final String description = _descriptionController.text;
      final String etat = _etatController.text;
      final String localisation = _localiteController.text;
      final int prixParHeures = int.tryParse(_prixController.text) ?? 0;

      if (photo != null) {
        await MaterielService()
            .updateMateriel(
                idMateriel: materiels.idMateriel!,
                prixParHeure: prixParHeures,
                nom: nom,
                description: description,
                localisation: localisation,
                etatMateriel: etat,
                photoMateriel: photo,
                acteur: acteur,
                typeMateriel: materiels.typeMateriel)
            .then((value) => {
                  Provider.of<MaterielService>(context, listen: false)
                      .applyChange(),
                  setState(() {
                    materiels = Materiel(
                        prixParHeure: prixParHeures,
                        nom: nom,
                        description: description,
                        localisation: localisation,
                        statut: materiels.statut,
                        acteur: acteur,
                        dateAjout: materiels.dateAjout,
                        etatMateriel: etat,
                        typeMateriel: materiels.typeMateriel);
                    _isLoading = false;
                  })
                })
            .catchError((onError) => {print(onError.toString())});
      } else {
        await MaterielService()
            .updateMateriel(
                idMateriel: materiels.idMateriel!,
                prixParHeure: prixParHeures,
                nom: nom,
                description: description,
                localisation: localisation,
                etatMateriel: etat,
                acteur: acteur,
                typeMateriel: materiels.typeMateriel)
            .then((value) => {
                  Provider.of<MaterielService>(context, listen: false)
                      .applyChange(),
                  setState(() {
                    materiels = Materiel(
                        prixParHeure: prixParHeures,
                        nom: nom,
                        description: description,
                        localisation: localisation,
                        statut: materiels.statut,
                        acteur: acteur,
                        dateAjout: materiels.dateAjout,
                        etatMateriel: etat,
                        typeMateriel: materiels.typeMateriel);
                    _isLoading = false;
                  })
                })
            .catchError((onError) => {print(onError.toString())});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Text(
                "Une erreur est survenu lors de la modification",
                style: TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    verify();

    _niveau3List =
        http.get(Uri.parse('$apiOnlineUrl/nivveau3Pays/read'));
    materiels = widget.materiel;
    _nomController.text = materiels.nom;
    _descriptionController.text = materiels.description;
    _etatController.text = materiels.etatMateriel;
    _localiteController.text = materiels.localisation;
    _prixController.text = materiels.prixParHeure.toString();
    isDialOpenNotifier = ValueNotifier<bool>(false);
    fetchPaysDataByActor();
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
                        _showImageSourceDialog();
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
              actions: acteur.idActeur == materiels.acteur.idActeur
                  ? [
                      _isEditing
                          ? IconButton(
                              onPressed: () async {
                                setState(() {
                                  _isEditing = false;
                                });
                                updateMethode();
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
                    ? Image.file(
                    photo!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                                          )
                    : materiels.photoMateriel != null &&
                            materiels.photoMateriel!.isNotEmpty
                        ? 
                        CachedNetworkImage(
                   width: double.infinity,
                    height: 200,
                    
                                                  imageUrl:
                                                      'https://koumi.ml/api-koumi/Materiel/${materiels.idMateriel}/image',
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    'assets/images/default_image.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                       
                        : Image.asset(
                            "assets/images/default_image.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                SizedBox(height: 30),
                _isEditing ? _buildEditingData() : _buildData(),
              ],
            ),
          ),
          floatingActionButton: acteur.idActeur != materiels.acteur.idActeur
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
        // !isExist ? _buildItem('Prix par heure : ',
        //     "${materiels.prixParHeure.toString()} ${para.monnaie}"):
        _buildItem('Prix par heure : ',
            "${materiels.prixParHeure.toString()} ${monnaie}"),
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
             Padding(
                      padding: EdgeInsets.all(8),
                      child: ReadMoreText(
                        colorClickableText: Colors.orange,
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: "Lire plus",
                        trimExpandedText: "Lire moins",
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                        value
                      ),
                    ),
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
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              // softWrap: true,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget _buildItem(String title, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.all(10.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           title,
  //           style: const TextStyle(
  //               color: Colors.black87,
  //               fontWeight: FontWeight.w500,
  //               fontStyle: FontStyle.italic,
  //               overflow: TextOverflow.ellipsis,
  //               fontSize: 18),
  //         ),
  //         Text(
  //           value,
  //           textAlign: TextAlign.justify,
  //           softWrap: true,
  //           style: const TextStyle(
  //             color: Colors.black,
  //             fontWeight: FontWeight.w800,
  //             overflow: TextOverflow.ellipsis,
  //             fontSize: 16,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
