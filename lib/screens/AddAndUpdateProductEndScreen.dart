import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/Admin/Zone.dart';
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Monnaie.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/Unite.dart';
import 'package:koumi_app/models/ZoneProduction.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddMagasinScreen.dart';
import 'package:koumi_app/screens/DetailProduits.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAndUpdateProductEndSreen extends StatefulWidget {
  bool? isEditable;
  late Stock? stock;
  String? nomProduit, origine, forme, prix, quantite;
  File? image;
  Monnaie? monnaies;

  AddAndUpdateProductEndSreen(
      {super.key,
      this.isEditable,
      this.stock,
      this.nomProduit,
      this.forme,
      this.origine,
      this.prix,
      this.quantite,
      this.image,
      this.monnaies});

  @override
  State<AddAndUpdateProductEndSreen> createState() =>
      _AddAndUpdateProductEndSreenState();
}

class _AddAndUpdateProductEndSreenState
    extends State<AddAndUpdateProductEndSreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController uniteController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController magasinController = TextEditingController();
  TextEditingController zoneController = TextEditingController();
  TextEditingController speculationController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  File? photos;
  String? specValue;
  Speculation speculation = Speculation();
  late Future speculationListe;
  String? uniteValue;
  Unite unite = Unite(); // Initialisez l'objet unite
  late Future uniteListe;
  String? magasinValue;
  late Magasin magasin = Magasin();
  late Future magasinListe;
  String? zoneValue;
  ZoneProduction zoneProduction = ZoneProduction();
  late Future zoneListe;
  late Acteur acteur = Acteur();
  String? id = "";
  String? email = "";
  bool isExist = false;

  void verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('emailActeur');
    if (email != null) {
      // Si l'email de l'acteur est présent, exécute checkLoggedIn
      acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
      setState(() {
      id = acteur.idActeur;
      zoneListe = http.get(
          Uri.parse('$apiOnlineUrl/ZoneProduction/getAllZonesByActeurs/${id}'));
      magasinListe = http
          .get(Uri.parse('$apiOnlineUrl/Magasin/getAllMagasinByActeur/${id}'));
        isExist = true;
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

  void handleButtonPress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    if (widget.isEditable == false) {
      await ajouterStock().then((_) {
        _typeController.clear();
        _descriptionController.clear();
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } else {
      await updateProduit().then((_) {
        _typeController.clear();
        _descriptionController.clear();

        Navigator.of(context).pop();
      });
      _typeController.clear();
      _descriptionController.clear();
    }
  }

  // Fonction pour traiter les données du QR code scanné
  Future<void> processScannedQRCode(Stock scannedData) async {
    // Ici, vous pouvez décoder les données du QR code et effectuer les actions nécessaires
    // Par exemple, naviguer vers la page de détail du produit avec les données du produit
    // Veuillez remplacer DetailProduits avec le nom de votre widget de détail du produit
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailProduits(stock: scannedData),
      ),
    );
  }

  Future<void> ajouterStock() async {
    try {
      if (widget.image != null) {
        await StockService().creerStock(
            nomProduit: widget.nomProduit!,
            origineProduit: widget.origine!,
            prix: widget.prix!,
            formeProduit: widget.forme!,
            quantiteStock: widget.quantite!,
            photo: widget.image,
            typeProduit: _typeController.text,
            descriptionStock: _descriptionController.text,
            zoneProduction: zoneProduction,
            speculation: speculation,
            unite: unite,
            magasin: magasin,
            acteur: acteur,
            monnaie: widget.monnaies!);
      } else {
        await StockService().creerStock(
            nomProduit: widget.nomProduit!,
            origineProduit: widget.origine!,
            prix: widget.prix!,
            formeProduit: widget.forme!,
            quantiteStock: widget.quantite!,
            typeProduit: _typeController.text,
            descriptionStock: _descriptionController.text,
            zoneProduction: zoneProduction,
            speculation: speculation,
            unite: unite,
            magasin: magasin,
            acteur: acteur,
            monnaie: widget.monnaies!);
      }
    } catch (error) {
      // Handle any exceptions that might occur during the request
      final String errorMessage = error.toString();
      debugPrint("no " + errorMessage);
    }
  }

  Future<void> updateProduit() async {
    try {
      if (widget.image != null) {
        await StockService().updateStock(
            idStock: widget.stock!.idStock!,
            nomProduit: widget.nomProduit!,
            origineProduit: widget.origine!,
            prix: widget.prix!,
            formeProduit: widget.forme!,
            quantiteStock: widget.quantite!,
            photo: widget.image,
            typeProduit: _typeController.text,
            descriptionStock: _descriptionController.text,
            zoneProduction: zoneProduction,
            speculation: speculation,
            unite: unite,
            magasin: magasin,
            acteur: acteur,
            monnaie: widget.monnaies!);
      } else {
        await StockService().updateStock(
            idStock: widget.stock!.idStock!,
            nomProduit: widget.nomProduit!,
            origineProduit: widget.origine!,
            prix: widget.prix!,
            formeProduit: widget.forme!,
            quantiteStock: widget.quantite!,
            typeProduit: _typeController.text,
            descriptionStock: _descriptionController.text,
            zoneProduction: zoneProduction,
            speculation: speculation,
            unite: unite,
            magasin: magasin,
            acteur: acteur,
            monnaie: widget.monnaies!);
      }
    } catch (error) {
      // Handle any exceptions that might occur during the request
      final String errorMessage = error.toString();
      debugPrint("no update " + errorMessage);
    }
  }

  @override
  void initState() {
    verify();
    magasinListe = http
        .get(Uri.parse('$apiOnlineUrl/Magasin/getAllMagasinByActeur/${id}'));
    speculationListe =
        http.get(Uri.parse('$apiOnlineUrl/Speculation/getAllSpeculation'));
    uniteListe = http.get(Uri.parse('$apiOnlineUrl/Unite/getAllUnite'));
    zoneListe = http.get(
        Uri.parse('$apiOnlineUrl/ZoneProduction/getAllZonesByActeurs/${id}'));

    debugPrint(
        "nom : ${widget.nomProduit}, bool : ${widget.isEditable} ,image : ${widget.image.toString()} , forme: ${widget.forme}, origine : ${widget.origine}, qte : ${widget.quantite}, prix : ${widget.prix}");

    if (widget.isEditable! == true) {
      _typeController.text = widget.stock!.typeProduit!;
      _descriptionController.text = widget.stock!.descriptionStock!;
      debugPrint("id : $id,  forme : ${widget.forme}");
      magasin = widget.stock!.magasin!;
      speculation = widget.stock!.speculation!;
      unite = widget.stock!.unite!;
      zoneProduction = widget.stock!.zoneProduction!;
      // debugPrint("spec : ${widget.speculation}, magasin : ${widget.magasin}, zone : ${widget.zoneProduction}   , unite : ${widget.unite}");
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 100,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
          title: Text(
            widget.isEditable == false ? "Ajouter produit" : "Modifier produit",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Type Produit *",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez saisir le type du produit";
                            }
                            return null;
                          },
                          controller: _typeController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Type produit",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Description Produit *",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez saisir la description du produit";
                            }
                            return null;
                          },
                          controller: _descriptionController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Description produit",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Speculation *",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )),
                        ),
                        FutureBuilder(
                          future: speculationListe,
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return DropdownButtonFormField(
                                items: [],
                                onChanged: null,
                                decoration: InputDecoration(
                                  labelText: 'En cours de chargement',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return DropdownButtonFormField(
                                items: [],
                                onChanged: null,
                                decoration: InputDecoration(
                                  labelText: 'Probleme de connexion',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              dynamic jsonString =
                                  utf8.decode(snapshot.data.bodyBytes);
                              dynamic responseData = json.decode(jsonString);
                              if (responseData is List) {
                                final reponse = responseData;
                                final speculationListe = reponse
                                    .map((e) => Speculation.fromMap(e))
                                    .where(
                                        (con) => con.statutSpeculation == true)
                                    .toList();

                                if (speculationListe.isEmpty) {
                                  return DropdownButtonFormField(
                                    items: [],
                                    onChanged: null,
                                    decoration: InputDecoration(
                                      labelText: 'Aucune spéculation trouvé',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                }
                                return DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Veuillez sélectionner une spéculation";
                                    }
                                    return null;
                                  },
                                  items: speculationListe
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.idSpeculation,
                                          child: Text(
                                            e.nomSpeculation!,
                                            style: TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  value: speculation.idSpeculation,
                                  onChanged: (newValue) {
                                    setState(() {
                                      speculation.idSpeculation = newValue;
                                      if (newValue != null) {
                                        speculation =
                                            speculationListe.firstWhere(
                                          (spec) =>
                                              spec.idSpeculation == newValue,
                                        );
                                        print("speculation : ${speculation}");
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: widget.isEditable == false
                                        ? 'Selectionner une spéculation'
                                        : widget.stock!.speculation!
                                            .nomSpeculation!,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
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
                                    labelText: 'Aucune spéculation trouvé',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
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
                                labelText: 'Aucune spéculation trouvé',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Magasin *",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )),
                        ),
                        FutureBuilder(
                          future: magasinListe,
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return DropdownButtonFormField(
                                items: [],
                                onChanged: null,
                                decoration: InputDecoration(
                                  labelText: 'En cours de chargement ...',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return DropdownButtonFormField(
                                items: [],
                                onChanged: null,
                                decoration: InputDecoration(
                                  labelText: 'Probleme de connexion',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              dynamic jsonString =
                                  utf8.decode(snapshot.data.bodyBytes);
                              dynamic responseData = json.decode(jsonString);
                              if (responseData is List) {
                                final reponse = responseData;
                                final magasinListe = reponse
                                    .map((e) => Magasin.fromMap(e))
                                    .where((con) => con.statutMagasin == true)
                                    .toList();

                                if (magasinListe.isEmpty) {
                                  return DropdownButtonFormField(
                                    items: [],
                                    onChanged: null,
                                    decoration: InputDecoration(
                                      labelText: 'Aucune magasin trouvé',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                }

                                return DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  validator: _validateMagasin,
                                  items: magasinListe
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.idMagasin,
                                          child: Text(
                                            e.nomMagasin!,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  value: magasin.idMagasin,
                                  onChanged: (newValue) {
                                    setState(() {
                                      magasin.idMagasin = newValue;
                                      if (newValue != null) {
                                        magasin = magasinListe.firstWhere(
                                          (magasin) =>
                                              magasin.idMagasin == newValue,
                                        );
                                        magasinValue = newValue;
                                        print(
                                            "magasin : ${magasin.nomMagasin}");
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                    labelText: widget.isEditable == false
                                        ? 'Selectionner un magasin'
                                        : widget.stock!.magasin!.nomMagasin,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
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
                                    labelText: 'Aucune magasin trouvé',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
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
                                labelText: 'Aucune magasin trouvé',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Unité *",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )),
                        ),
                        FutureBuilder(
                          future: uniteListe,
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return DropdownButtonFormField(
                                items: [],
                                onChanged: null,
                                decoration: InputDecoration(
                                  labelText: 'En cours de chargement',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return DropdownButtonFormField(
                                items: [],
                                onChanged: null,
                                decoration: InputDecoration(
                                  labelText: 'Probleme de connexion',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              dynamic jsonString =
                                  utf8.decode(snapshot.data.bodyBytes);
                              dynamic responseData = json.decode(jsonString);
                              if (responseData is List) {
                                final reponse = responseData;
                                final uniteListe = reponse
                                    .map((e) => Unite.fromMap(e))
                                    .where((con) => con.statutUnite == true)
                                    .toList();

                                if (uniteListe.isEmpty) {
                                  return DropdownButtonFormField(
                                    items: [],
                                    onChanged: null,
                                    decoration: InputDecoration(
                                      labelText: 'Aucune unité trouvé',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                }

                                return DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Veuillez sélectionner une unité";
                                    }
                                    return null;
                                  },
                                  items: uniteListe
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.idUnite,
                                          child: Text(
                                            e.nomUnite!,
                                            style: TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  value: unite.idUnite,
                                  onChanged: (newValue) {
                                    setState(() {
                                      unite.idUnite = newValue;
                                      if (newValue != null) {
                                        unite = uniteListe.firstWhere(
                                          (unite) => unite.idUnite == newValue,
                                        );
                                        print("unité : ${unite.nomUnite}");
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: widget.isEditable == false
                                        ? 'Selectionner une unité'
                                        : widget.stock!.unite!.nomUnite,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
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
                                    labelText: 'Aucune unité trouvé',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
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
                                labelText: 'Aucune unité trouvé',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Zone de production *",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )),
                        ),
                        FutureBuilder(
                          future: zoneListe,
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return DropdownButtonFormField(
                                items: [],
                                onChanged: null,
                                decoration: InputDecoration(
                                  labelText: 'En cours de chargement ...',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return DropdownButtonFormField(
                                items: [],
                                onChanged: null,
                                decoration: InputDecoration(
                                  labelText: 'Probleme de connexion',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              dynamic jsonString =
                                  utf8.decode(snapshot.data.bodyBytes);
                              dynamic responseData = json.decode(jsonString);
                              if (responseData is List) {
                                final reponse = responseData;
                                final zoneListe = reponse
                                    .map((e) => ZoneProduction.fromMap(e))
                                    .where((con) => con.statutZone == true)
                                    .toList();

                                if (zoneListe.isEmpty) {
                                  return DropdownButtonFormField(
                                    items: [],
                                    onChanged: null,
                                    decoration: InputDecoration(
                                      labelText:
                                          'Aucune zone de production trouvé',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                }

                                return DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  validator: _validateZone,
                                  items: zoneListe
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.idZoneProduction,
                                          child: Text(
                                            e.nomZoneProduction!,
                                            style: TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  value: zoneProduction.idZoneProduction,
                                  onChanged: (newValue) {
                                    setState(() {
                                      zoneProduction.idZoneProduction =
                                          newValue;
                                      if (newValue != null) {
                                        zoneProduction = zoneListe.firstWhere(
                                          (zone) =>
                                              zone.idZoneProduction == newValue,
                                        );
                                        zoneValue = newValue;
                                        print(
                                            "zone de production : ${zoneProduction}");
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: widget.isEditable == false
                                        ? 'Selectionner une zone de production'
                                        : widget.stock!.zoneProduction!
                                            .nomZoneProduction,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
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
                                    labelText:
                                        'Aucune zone de production trouvé',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
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
                                labelText: 'Aucune zone de production trouvé',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              // Handle button press action here
                              if (_formKey.currentState!.validate()) {
                                if (magasinValue == null && zoneValue == null) {
                                  _showMessageDialog();
                                } else if (magasinValue == null) {
                                  _showMagasinDialog();
                                } else if (zoneValue == null) {
                                  _showZoneDialog();
                                } else {
                                  handleButtonPress();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFFF8A00), // Orange color code
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              minimumSize: const Size(250, 40),
                            ),
                            child: Text(
                              widget.isEditable == false
                                  ? " Ajouter "
                                  : " Modifier ",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateMagasin(String? value) {
    if (value == null || value.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showMagasinDialog());
      return 'Veuillez sélectionner un magasin';
    }
    return null;
  }

  void _showMagasinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Aucun magasin sélectionner')),
          content: const Text("Veuillez au préalable créer un magasin"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Get.back();
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMagasinScreen(
                        isEditable: false,
                      ),
                    ));
              },
              child: const Text('Créer un magasin'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  void _showMessageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Center(child: Text('Aucun magasin et zone  sélectionner')),
          content: const Text(
              "Veuillez au préalable créer un magasin et une zone de production(Profil)"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  String? _validateZone(String? value) {
    if (value == null || value.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showMagasinDialog());
      return 'Veuillez sélectionner une zone de production';
    }
    return null;
  }

  void _showZoneDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Aucun zone sélectionner')),
          content: const Text("Veuillez au préalable ajouter une zone"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Get.back();
                Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Zone()));
              },
              child: const Text('Ajouter une zone'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }
}
