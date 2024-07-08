import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/ActeurService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:provider/provider.dart';

class EditProfil extends StatefulWidget {
  Acteur? acteurs;
  EditProfil({super.key, this.acteurs});

  @override
  State<EditProfil> createState() => _EditProfilState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);
const d_colorPage = Color.fromRGBO(255, 255, 255, 1);

class _EditProfilState extends State<EditProfil> {
  TextEditingController nomActeurController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController localisationController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  MultiSelectController _controllerTypeActeur = MultiSelectController();
  MultiSelectController _controllerSpeculation = MultiSelectController();
  List<TypeActeur> typeActeur = [];
    // ActeurProvider acteurProvider =
    //     Provider.of<ActeurProvider>(context, listen: false);

  bool isEditing = false;
  bool _isLoading = false;
  late Acteur acteur;
  String? imageSrc;
  File? photo;
  late List<TypeActeur> typeActeurData = [];
  late String type;
  List<TypeActeur> selectedTypes = [];
  List<Speculation> selectedSpec = [];
  List<String> typeLibelle = [];
  List<String> libelleSpeculation = [];
  List<Speculation> listeSpeculations = [];

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

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing; // Inverse l'état d'édition
    });
  }

  @override
  void initState() {
    super.initState();
    acteur = widget.acteurs!;
    nomActeurController.text = acteur.nomActeur!;
    whatsAppController.text = acteur.whatsAppActeur!;
    telephoneController.text = acteur.telephoneActeur!;
    localisationController.text = acteur.localiteActeur!;
    adresseController.text = acteur.adresseActeur!;
    passwordController.text = acteur.password!;
    confirmPasswordController.text = acteur.password!;
    if (acteur.emailActeur != null) {
      emailController.text = acteur.emailActeur!;
    }

    if(acteur.speculations != null){
    selectedSpec = acteur.speculations!;
    }

    typeActeur = acteur.typeActeur!;
    typeLibelle = typeActeur.map((e) => e.libelle!).toList();
    selectedTypes = typeActeur;
    
    print("type acteur : ${typeActeur.toString()}");
    print("speculation : ${selectedSpec.toString()}");
    print("type libelle : ${typeLibelle}");
    // _controllerTypeActeur.onOptionSelected()
    // setSelectedOptions(options) {
    //   typeActeur.map((type) {
    //     return ValueItem<TypeActeur>(
    //       label: type.libelle!,
    //       value: type,
    //     );
    //   }).toList();
    // }

    // ;
  }

  Future<List<ValueItem<TypeActeur>>> _fetchAndCombineOptions() async {
    // Fetch the data from the network
    final response = await NetworkConfig(
      url: 'http://10.0.2.2:9000/api-koumi/typeActeur/read',
      method: RequestMethod.get,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    List<TypeActeur> fetchedTypes = (response as List<dynamic>)
        .where((data) => (data['libelle']).trim().toLowerCase() != 'admin')
        .map((e) {
      return TypeActeur(
        idTypeActeur: e['idTypeActeur'] as String,
        libelle: e['libelle'] as String,
        statutTypeActeur: e['statutTypeActeur'] as bool,
      );
    }).toList();

    // Combine fetched options with initially selected ones
    List<TypeActeur> combinedTypes =
        {...fetchedTypes, ...selectedTypes}.toList();

    // Create ValueItems for the combined list
    final List<ValueItem<TypeActeur>> valueItems =
        combinedTypes.map((typeActeur) {
      return ValueItem<TypeActeur>(
        label: typeActeur.libelle!,
        value: typeActeur,
      );
    }).toList();

    return valueItems;
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
          leading: isEditing
              ? IconButton(
                  onPressed: () {
                    toggleEditing();
                  },
                  icon: const Icon(Icons.close_sharp, color: d_colorGreen),
                )
              : IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen),
                ),
          title: const Text(
            "Editer Profil",
            style: TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
          // actions: [
          //   isEditing
          //       ? IconButton(
          //           onPressed: () async {
          //             setState(() {
          //               isEditing = false;
          //             });
          //           },
          //           icon: const Icon(Icons.save),
          //         )
          //       : IconButton(
          //           onPressed: () {
          //             setState(() {
          //               isEditing = true; // Activer le mode édition
          //             });
          //           },
          //           icon: const Icon(Icons.edit),
          //         ),
          // ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  photo != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.file(
                              photo!,
                              height: 100,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ))
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: acteur.logoActeur == null ||
                                  acteur.logoActeur!.isEmpty
                              ? ProfilePhoto(
                                  totalWidth: 100,
                                  cornerRadius: 100,
                                  color: Colors.black,
                                  image: const AssetImage(
                                      'assets/images/profil.jpg'),
                                )
                              : ProfilePhoto(
                                  totalWidth: 100,
                                  cornerRadius: 100,
                                  color: Colors.black,
                                  image: NetworkImage(
                                      "https://koumi.ml/api-koumi/acteur/${acteur.idActeur}/image"),
                                ),
                        ),
                  TextButton(
                      onPressed: () {
                        _showImageSourceDialog();
                      },
                      // onHover : true,
                      child: Text(
                        "Changer le logo",
                        style: TextStyle(
                            fontSize: 18,
                            color: d_colorOr,
                            fontWeight: FontWeight.w900),
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: nomActeurController,
                  decoration: InputDecoration(
                    labelText: "Nom complet",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    // hintText: "Entrez votre prenom et nom",
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
                  // onSaved: (val) => nomActeur = val!,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MultiSelectDropDown.network(
                  networkConfig: NetworkConfig(
                    url: 'http://10.0.2.2:9000/api-koumi/typeActeur/read',
                    method: RequestMethod.get,
                    headers: {
                      'Content-Type': 'application/json',
                    },
                  ),

                  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                  responseParser: (response) {
                    typeActeur = (response as List<dynamic>)
                        .where((data) =>
                            (data['libelle']).trim().toLowerCase() != 'admin')
                        .map((e) {
                      return TypeActeur(
                        idTypeActeur: e['idTypeActeur'] as String,
                        libelle: e['libelle'] as String,
                        statutTypeActeur: e['statutTypeActeur'] as bool,
                      );
                    }).toList();

                    // Filtrer les types avec un libellé différent de "admin" et dont le statutTypeActeur est true
                    final filteredTypes = typeActeur
                        .where((typeActeur) =>
                            typeActeur.libelle != "admin" ||
                            typeActeur.libelle != "Admin" &&
                                typeActeur.statutTypeActeur == true)
                        .toList();

                    // Créer des ValueItems pour les types filtrés
                    final List<ValueItem<TypeActeur>> valueItems =
                        filteredTypes.map((typeActeur) {
                      return ValueItem<TypeActeur>(
                        label: typeActeur.libelle!,
                        value: typeActeur,
                      );
                    }).toList();

                    return Future<List<ValueItem<TypeActeur>>>.value(
                        valueItems);
                  },

                  controller: _controllerTypeActeur,

                  dropdownHeight: 320,
                  hint: 'Sélectionner un type d\'acteur',

                  fieldBackgroundColor: Color.fromARGB(255, 219, 219, 219),
                  searchEnabled: false,
                  searchLabel: "Search",
                  onOptionSelected: (options) {
                    if (mounted) {
                      setState(() {
                        typeLibelle.clear();
                        typeLibelle
                            .addAll(options.map((data) => data.label).toList());
                        selectedTypes = options
                            .map<TypeActeur>((item) => item.value!)
                            .toList();
                        print("Types sélectionnés : $selectedTypes");

                        print("Libellé sélectionné ${typeLibelle.toString()}");
                      });
                    }
                  },
                  responseErrorBuilder: ((context, body) {
                    return const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Aucun type disponible'),
                    );
                  }),
                  // Exemple de personnalisation des styles
                ),
              ),
              SizedBox(
                height: 10,
              ),
              acteur.emailActeur != null
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          // hintText: "Entrez votre prenom et nom",
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
                        // onSaved: (val) => nomActeur = val!,
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: whatsAppController,
                  decoration: InputDecoration(
                    labelText: "Numéro wathsApp",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    // hintText: "Entrez votre prenom et nom",
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
                  // onSaved: (val) => nomActeur = val!,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: telephoneController,
                  decoration: InputDecoration(
                    labelText: "Numéro",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    // hintText: "Entrez votre prenom et nom",
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
                  // onSaved: (val) => nomActeur = val!,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: localisationController,
                  decoration: InputDecoration(
                    labelText: "Localité",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    // hintText: "Entrez votre prenom et nom",
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
                  // onSaved: (val) => nomActeur = val!,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: adresseController,
                  decoration: InputDecoration(
                    labelText: "Adresse",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    // hintText: "Entrez votre prenom et nom",
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
                  // onSaved: (val) => nomActeur = val!,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MultiSelectDropDown.network(
                  networkConfig: NetworkConfig(
                    // Endpoint pour récupérer les spéculations en fonction des catégories sélectionnées
                    // url:url , //e40ijxd5k0n0yrzj5f80,
                    // url:
                    //     '$apiOnlineUrl/Speculation/getAllSpeculation', //e40ijxd5k0n0yrzj5f80,
                    url:
                        'http://10.0.2.2:9000/api-koumi/Speculation/getAllSpeculation', //e40ijxd5k0n0yrzj5f80,
                    method: RequestMethod.get,
                    headers: {'Content-Type': 'application/json'},
                  ),
                  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                  responseParser: (response) {
                    // List<dynamic> decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

                    listeSpeculations = (response as List<dynamic>).map((e) {
                      return Speculation(
                        idSpeculation: e['idSpeculation'] as String,
                        nomSpeculation: e['nomSpeculation'] as String,
                        statutSpeculation: e['statutSpeculation'] as bool,
                        // Assurez-vous de correspondre aux clés JSON avec les noms de propriétés de votre classe TypeActeur
                        // Ajoutez d'autres champs si nécessaire
                      );
                    }).toList();

                    // Filtrer les types avec un libellé différent de "admin" et dont le statutTypeActeur est true
                    final filteredTypes = listeSpeculations
                        .where((speculation) =>
                            speculation.statutSpeculation == true)
                        .toList();

                    // Créer des ValueItems pour les types filtrés
                    final List<ValueItem<Speculation>> valueItems =
                        filteredTypes.map((speculation) {
                      return ValueItem<Speculation>(
                        label: speculation.nomSpeculation!,
                        value: speculation,
                      );
                    }).toList();

                    return Future<List<ValueItem<Speculation>>>.value(
                        valueItems);
                  },

                  controller: _controllerSpeculation,
                  hint: 'Sélectionner une spéculation',
                  dropdownHeight: 320,
                  fieldBackgroundColor: Color.fromARGB(255, 219, 219, 219),
                  onOptionSelected: (options) {
                    setState(() {
                      selectedSpec = options
                          .map<Speculation>((item) => item.value!)
                          .toList();
                      print("Types sélectionnés : $selectedSpec");
                      libelleSpeculation.clear();
                      libelleSpeculation
                          .addAll(options.map((data) => data.label).toList());
                      print(
                          "Spéculation sélectionnée ${libelleSpeculation.toString()}");
                    });
                    // Fermer automatiquement le dialogue
                    // FocusScope.of(context).unfocus();
                  },
                  responseErrorBuilder: ((context, body) {
                    return const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Aucune spéculation disponible'),
                    );
                  }),
                  // Exemple de personnalisation des styles
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final nomActeur = nomActeurController.text;
                  final emailActeur = emailController.text;
                  final adresse = adresseController.text;
                  final localisation = localisationController.text;
                  final typeActeur = selectedTypes;
                  final password = acteur.password!;
                  final wathsApp = whatsAppController.text;
                  final numero = telephoneController.text;
                  print("type acteur : ${typeActeur.toString()}");
                  print("speculation : ${selectedSpec.toString()}");
                  var newActeur;
                  try {
                    setState(() {
                      _isLoading = true;
                    });

                     if (photo != null) {
                      newActeur = await ActeurService()
                          .updateActeur(
                              idActeur: acteur.idActeur!,
                              nomActeur: nomActeur,
                              logoActeur: photo,
                              adresseActeur: adresse,
                              telephoneActeur: numero,
                              whatsAppActeur: wathsApp,
                              localiteActeur: localisation,
                              emailActeur: emailActeur,
                              niveau3PaysActeur: acteur.niveau3PaysActeur!,
                              typeActeur: typeActeur,
                              // password: password
                              )
                          .then((value) => {
                                setState(() {
                                  _isLoading = false;
                                }),
                                Provider.of<ActeurProvider>(context,
                                        listen: false)
                                    .setActeur(newActeur),
                                Provider.of<ActeurService>(context,
                                        listen: false)
                                    .applyChange(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Text(
                                          "Profil modifié avec success",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 5),
                                  ),
                                )
                              })
                          .catchError((onError) => {
                                setState(() {
                                  _isLoading = false;
                                }),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Text(
                                          "Une erreur s'est produite",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 5),
                                  ),
                                ),
                                print("catch 1 ${onError.toString()}"),
                              });
                    } else if (photo != null && selectedSpec.isEmpty) {
                      newActeur = await ActeurService()
                          .updateActeur(
                              idActeur: acteur.idActeur!,
                              nomActeur: nomActeur,
                              logoActeur: photo,
                              adresseActeur: adresse,
                              telephoneActeur: numero,
                              whatsAppActeur: wathsApp,
                              localiteActeur: localisation,
                              emailActeur: emailActeur,
                              niveau3PaysActeur: acteur.niveau3PaysActeur!,
                              typeActeur: typeActeur,
                              // password: password
                              )
                          .then((value) => {
                                setState(() {
                                  _isLoading = false;
                                }),
                                Provider.of<ActeurProvider>(context,
                                        listen: false)
                                    .setActeur(newActeur),
                                Provider.of<ActeurService>(context,
                                        listen: false)
                                    .applyChange(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Text(
                                          "Profil modifié avec success",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 5),
                                  ),
                                )
                              })
                          .catchError((onError) => {
                                setState(() {
                                  _isLoading = false;
                                }),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Text(
                                          "Une erreur s'est produite",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 5),
                                  ),
                                ),
                                print("catch 2 ${onError.toString()}"),
                              });
                    } else if (photo != null && selectedSpec.isNotEmpty) {
                    newActeur =  await ActeurService()
                          .updateActeur(
                              idActeur: acteur.idActeur!,
                              nomActeur: nomActeur,
                              logoActeur: photo,
                              adresseActeur: adresse,
                              telephoneActeur: numero,
                              whatsAppActeur: wathsApp,
                              localiteActeur: localisation,
                              emailActeur: emailActeur,
                              niveau3PaysActeur: acteur.niveau3PaysActeur!,
                              typeActeur: typeActeur,
                                // password: password,
                              speculations: selectedSpec)
                          .then((value) => {
                                setState(() {
                                  _isLoading = false;
                                }),
                                
                                Provider.of<ActeurProvider>(context, listen: false)
                                .setActeur(newActeur),

                                Provider.of<ActeurService>(context, listen: false)
                                .applyChange(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Text(
                                          "Profil modifié avec success",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 5),
                                  ),
                                )
                              })
                          .catchError((onError) => {
                             setState(() {
                                  _isLoading = false;
                                }),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Text(
                                          "Une erreur s'est produite",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 5),
                                  ),
                                ),
                            print("catch 3 ${onError.toString()}"),
                            }
                            
                            );
                    } else  if (selectedSpec.isNotEmpty) {
                    newActeur =  await ActeurService()
                          .updateActeur(
                              idActeur: acteur.idActeur!,
                              nomActeur: nomActeur,
                              // logoActeur: photo,
                              adresseActeur: adresse,
                              telephoneActeur: numero,
                              whatsAppActeur: wathsApp,
                              localiteActeur: localisation,
                              emailActeur: emailActeur,
                              niveau3PaysActeur: acteur.niveau3PaysActeur!,
                              typeActeur: typeActeur,
                              speculations: selectedSpec,
                                // password: password
                                )
                          .then((value) => {
                                setState(() {
                                  _isLoading = false;
                                }),
                                
                                Provider.of<ActeurProvider>(context, listen: false)
                                .setActeur(newActeur),

                                Provider.of<ActeurService>(context, listen: false)
                                .applyChange(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Text(
                                          "Profil modifié avec success",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 5),
                                  ),
                                )
                              })
                          .catchError((onError) => {
                             setState(() {
                                  _isLoading = false;
                                }),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Text(
                                          "Une erreur s'est produite",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 5),
                                  ),
                                ),
                            print("catch 4 ${onError.toString()}"),
                            }
                            
                            );
                    } 
                    else {
                      newActeur = await ActeurService()
                          .updateActeur(
                              idActeur: acteur.idActeur!,
                              nomActeur: nomActeur,
                              adresseActeur: adresse,
                              telephoneActeur: numero,
                              whatsAppActeur: wathsApp,
                              localiteActeur: localisation,
                              emailActeur: emailActeur,
                              typeActeur: typeActeur,

                              niveau3PaysActeur: acteur.niveau3PaysActeur!,
                              // password: password
                              )
                          .then((value) => {
                                setState(() {
                                  _isLoading = false;
                                }),
                                Provider.of<ActeurProvider>(context,
                                        listen: false)
                                    .setActeur(newActeur),
                                Provider.of<ActeurService>(context,
                                        listen: false)
                                    .applyChange(),
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Text(
                                          "Profil modifié avec success",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 5),
                                  ),
                                )
                              })
                          .catchError((onError) => {
                                print("catch 5 error ${onError.toString()}"),
                                setState(() {
                                  _isLoading = false;
                                }),
                                  ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Text(
                                          "Une erreur s'est produite",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 5),
                                  ),
                                )
                              });
                    }
                  } catch (e) {
                    print("catch try ${e.toString()}");
                    setState(() {
                      _isLoading = false;
                    });

                  }
                },
                child: Text(
                  "Modifier",
                  style: TextStyle(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
