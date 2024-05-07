import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Intrant.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/CartProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/service/IntrantService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:koumi_app/widgets/SnackBar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailIntrant extends StatefulWidget {
  final Intrant intrant;
  const DetailIntrant({super.key, required this.intrant});

  @override
  State<DetailIntrant> createState() => _DetailIntrantState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _DetailIntrantState extends State<DetailIntrant> {
  TextEditingController _nomController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _quantiteController = TextEditingController();
  TextEditingController _prixController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _uniteController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;
  late Acteur acteur = Acteur();
  late List<TypeActeur> typeActeurData = [];
  late String type;
  String? imageSrc;
  File? photo;
  List<ParametreGeneraux> paraList = [];
  late ParametreGeneraux para = ParametreGeneraux();
  late ValueNotifier<bool> isDialOpenNotifier;
  late Intrant intrants;
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
    super.initState();
    verify();
    // paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
    //     .parametreList!;
    // para = paraList[0];
    verifyParam();
    intrants = widget.intrant;
    _nomController.text = intrants.nomIntrant!;
    _descriptionController.text = intrants.descriptionIntrant!;
    _quantiteController.text = intrants.quantiteIntrant.toString();
    _prixController.text = intrants.prixIntrant.toString();
    _dateController.text = intrants.dateExpiration!;
    _uniteController.text = intrants.unite!;
    isDialOpenNotifier = ValueNotifier<bool>(false);
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
      final double quantite = double.tryParse(_quantiteController.text) ?? 0.0;
      final int prix = int.tryParse(_prixController.text) ?? 0;
      final String date = _dateController.text;
      final String unite = _uniteController.text;

      if (photo != null) {
        await IntrantService()
            .updateIntrant(
                idIntrant: intrants.idIntrant!,
                nomIntrant: nom,
                quantiteIntrant: quantite,
                descriptionIntrant: description,
                prixIntrant: prix,
                dateExpiration: date,
                photoIntrant: photo,
                unite: unite,
                acteur: acteur)
            .then((value) => {
                  Provider.of<IntrantService>(context, listen: false)
                      .applyChange(),
                  setState(() {
                    intrants = Intrant(
                        nomIntrant: nom,
                        quantiteIntrant: quantite,
                        prixIntrant: prix,
                        descriptionIntrant: description,
                        statutIntrant: intrants.statutIntrant,
                        dateAjout: intrants.dateAjout,
                        dateExpiration: date,
                        categorieProduit: intrants.categorieProduit,
                        forme: intrants.forme,
                        unite: unite,
                        acteur: acteur);
                    _isLoading = false;
                  }),
                })
            .catchError((onError) => {
                  print(onError.toString()),
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
                  )
                });
      } else {
        await IntrantService()
            .updateIntrant(
                idIntrant: intrants.idIntrant!,
                nomIntrant: nom,
                quantiteIntrant: quantite,
                descriptionIntrant: description,
                prixIntrant: prix,
                dateExpiration: date,
                unite: unite,
                acteur: acteur)
            .then((value) => {
                  Provider.of<IntrantService>(context, listen: false)
                      .applyChange(),
                  setState(() {
                    intrants = Intrant(
                        nomIntrant: nom,
                        quantiteIntrant: quantite,
                        prixIntrant: prix,
                        descriptionIntrant: description,
                        statutIntrant: intrants.statutIntrant,
                        dateAjout: intrants.dateAjout,
                        dateExpiration: date,
                        categorieProduit: intrants.categorieProduit,
                        forme: intrants.forme,
                        unite: unite,
                        photoIntrant: intrants.photoIntrant,
                        acteur: acteur);
                    _isLoading = false;
                  }),
                })
            .catchError((onError) => {
                  print(onError.toString()),
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Text(
                            "Erreur lors de la modification",
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      duration: Duration(seconds: 5),
                    ),
                  )
                });
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Text(
                "Erreur lors de la modification",
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
                        icon: const Icon(Icons.arrow_back_ios,
                            color: d_colorGreen),
                      ),
                title: Text(
                  'Détail intrant',
                  style: const TextStyle(
                      color: d_colorGreen, fontWeight: FontWeight.bold),
                ),
                actions: acteur.idActeur == intrants.acteur!.idActeur
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
                          child: intrants.photoIntrant != null &&
                                  !intrants.photoIntrant!.isEmpty
                              ?
                              //  Image.network(
                              //     "https://koumi.ml/api-koumi/intrant/${intrants.idIntrant}/image",
                              //     width: double.infinity,
                              //     height: 200,
                              //     fit: BoxFit.cover,
                              //     errorBuilder: (BuildContext context,
                              //         Object exception,
                              //         StackTrace? stackTrace) {
                              //       return Image.asset(
                              //         'assets/images/default_image.png',
                              //         fit: BoxFit.cover,
                              //       );
                              //     },
                              //   )

       CachedNetworkImage(
                                                  imageUrl:
                                                  "https://koumi.ml/api-koumi/intrant/${intrants.idIntrant}/image",
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

                              // ? Image.network(
                              //     "http://10.0.2.2/${intrants.photoIntrant!}",
                              //     width: double.infinity,
                              //     height: 200,
                              //     fit: BoxFit.cover,
                              //   )
                              : Image.asset(
                                  "assets/images/default_image.png",
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                        ),
                  SizedBox(height: 30),
                  !_isEditing ? viewData() : _buildEditing(),
                  SizedBox(height: 10),
                  isExist == true
                      ? widget.intrant.acteur!.idActeur == acteur.idActeur
                          ? SizedBox()
                          : Center(
                              child: SizedBox(
                                width: 200,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // _addToCart(widget.stock);
                                    if (widget.intrant.acteur!.idActeur ==
                                        acteur.idActeur) {
                                      Snack.error(
                                          titre: "Alerte",
                                          message:
                                              "Désolé!, Vous ne pouvez pas commander un intrant qui vous appartient");
                                    } else {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .addToCartInt(widget.intrant, 1, "");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.orange,
                                      shape: const StadiumBorder()),
                                  child: Text(
                                    "Ajouter au panier",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                      : SizedBox(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            floatingActionButton: acteur.idActeur != intrants.acteur!.idActeur
                ? SpeedDial(
                    // animatedIcon: AnimatedIcons.close_menu,

                    backgroundColor: d_colorGreen,
                    foregroundColor: Colors.white,
                    overlayColor: Colors.black,
                    overlayOpacity: 0.7,
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
                              intrants.acteur!.whatsAppActeur!;
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
                              intrants.acteur!.telephoneActeur!;
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
                : Container()));
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

  Widget viewData() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.orangeAccent,
            ),
            child: Center(
              child: Text(
                intrants.nomIntrant!.toUpperCase(),
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        _buildData(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.orangeAccent,
            ),
            child: Center(
              child: Text(
                'Description',
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        _buildDescription(intrants.descriptionIntrant!),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.orangeAccent,
            ),
            child: Center(
              child: Text(
                'Autre information',
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        // _buildItem('Spéculation ', intrants.speculation!.nomSpeculation!),
        _buildItem('Catégorie  ', intrants.categorieProduit!.libelleCategorie!),
        _buildItem(
            'Filière  ', intrants.categorieProduit!.filiere!.libelleFiliere!),
        _buildItem('Date d\'ajout ', '${intrants.dateAjout}' ?? 'N/A'),
        acteur.idActeur != intrants.acteur!.idActeur
            ? _buildFournissuer()
            : Container(),
        // isExist == true
        //     ? widget.intrant.acteur!.idActeur == acteur.idActeur
        //         ? SizedBox()
        //         : Center(
        //             child: acteur.idActeur != intrants.acteur!.idActeur!
        //                 ? Center(
        //                     child: SizedBox(
        //                       width: 200,
        //                       height: 60,
        //                       child: ElevatedButton(
        //                         onPressed: () {
        //                           // _addToCart(widget.stock);
        //                           if (acteur.idActeur ==
        //                               intrants.acteur!.idActeur) {
        //                             Snack.error(
        //                                 titre: "Alerte",
        //                                 message:
        //                                     "Désolé!, Vous ne pouvez pas commander un produit qui vous appartient");
        //                           } else {
        //                             Provider.of<CartProvider>(context,
        //                                     listen: false)
        //                                 .addToCartInt(widget.intrant, 1, "");
        //                           }
        //                         },
        //                         style: ElevatedButton.styleFrom(
        //                             foregroundColor: Colors.orange,
        //                             shape: const StadiumBorder()),
        //                         child: Text(
        //                           "Ajouter au panier",
        //                           style: TextStyle(
        //                               fontSize: 16,
        //                               fontWeight: FontWeight.bold),
        //                         ),
        //                       ),
        //                     ),
        //                   )
        //                 : Container(),
        //           )
        //     : Container(),
      ],
    );
  }

  _buildEditing() {
    return Column(children: [
      _buildEditableDetailItem('Nom intrant ', _nomController),
      _buildEditableDetailItem('Description', _descriptionController),
      _buildEditableDetailItem('Date péremption ', _dateController),
      _buildEditableDetailItem('Quantité ', _quantiteController),
      _buildEditableDetailItem('Prix intrant ', _prixController),
    ]);
  }

  _buildData() {
    return Column(
      children: [
        _buildItem('Nom intrant ', intrants.nomIntrant!),
        _buildItem('Quantité ', intrants.quantiteIntrant.toString()),
        _buildItem('Date péremption ', intrants.dateExpiration!),
        para.monnaie != null
            ? _buildItem(
                'Prix ', '${intrants.prixIntrant.toString()} ${para.monnaie}')
            : _buildItem('Prix ', '${intrants.prixIntrant.toString()} FCFA'),
        _buildItem('Unité ', '${intrants.unite}'),
        _buildItem('Forme ', '${intrants.forme!.libelleForme}'),
        _buildItem('Statut ',
            '${intrants.statutIntrant! ? 'Disponible' : 'Non disponible'}'),
      ],
    );
  }

  _buildFournissuer() {
    return Column(
      children: [
        _buildItem('Nom du fournisseur ', intrants.acteur!.nomActeur!),
        _buildItem('Contact ', intrants.acteur!.telephoneActeur!),
      ],
    );
  }

  Widget _buildDescription(String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          value,
          textAlign: TextAlign.justify,
          softWrap: true,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            // overflow: TextOverflow.ellipsis,
            fontSize: 16,
          ),
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

  Widget _buildEditableDetailItem(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
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
                  maxLines: null,
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
}