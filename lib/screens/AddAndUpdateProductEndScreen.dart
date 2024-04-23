
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/Unite.dart';
import 'package:koumi_app/models/ZoneProduction.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/DetailProduits.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:koumi_app/widgets/SnackBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAndUpdateProductEndSreen extends StatefulWidget {
  
     bool? isEditable;
     late Stock? stock;
     String  nomProduit, origine, forme,prix , quantite;
     File? image;

   AddAndUpdateProductEndSreen({super.key, this.isEditable, this.stock, 
   required this.nomProduit, required this.forme , required this.origine, required this.prix, required this.quantite, this.image
   });

  @override
  State<AddAndUpdateProductEndSreen> createState() => _AddAndUpdateProductEndSreenState();
}

class _AddAndUpdateProductEndSreenState extends State<AddAndUpdateProductEndSreen> {

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
     Magasin magasin  = Magasin();
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
            id = acteur.idActeur;
    magasinListe =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByActeur/${id}'));
      setState(() {
        isExist = true;
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }


  

  void handleButtonPress() async{
    setState(() {
      isLoading = true;
    });
    if(widget.isEditable == false){

     await ajouterStock().then((_) {
      setState(() {
        isLoading = false;
      });
     });
    }else{
  await updateProduit().then((_) {
      setState(() {
        isLoading = false;
      });
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
   
    Future<void> ajouterStock() async{
    try {
      
    if(widget.image != null){
    await StockService().creerStock(nomProduit: widget.nomProduit,
     origineProduit: widget.origine, prix: widget.prix,
     formeProduit: widget.forme, quantiteStock: widget.quantite, photo: widget.image,
     typeProduit: _typeController.text, descriptionStock: _descriptionController.text, 
     zoneProduction: zoneProduction, speculation: speculation, unite: unite, 
      magasin: magasin, acteur: acteur);
    }else{
    await StockService().creerStock(nomProduit: widget.nomProduit,
         origineProduit: widget.origine, prix: widget.prix,
     formeProduit: widget.forme, quantiteStock: widget.quantite, 
     typeProduit: _typeController.text, descriptionStock: _descriptionController.text, 
     zoneProduction: zoneProduction, speculation: speculation, unite: unite, 
      magasin: magasin, acteur: acteur);
   }
    } catch (error) {
        // Handle any exceptions that might occur during the request
        final String errorMessage = error.toString();
        debugPrint("no " + errorMessage);
      } 

   }
   

   Future<void> updateProduit() async{

    try {
      
    if(widget.image != null){
    await StockService().updateStock(
      idStock: widget.stock!.idStock!, nomProduit: widget.nomProduit,
           origineProduit: widget.origine, prix: widget.prix,
     formeProduit: widget.forme, quantiteStock: widget.quantite, photo: widget.image!,
     typeProduit: _typeController.text, descriptionStock: _descriptionController.text, 
     zoneProduction: widget.stock!.zoneProduction!, speculation: widget.stock!.speculation!,
      unite: widget.stock!.unite!,
      magasin: widget.stock!.magasin!, acteur: acteur);
    }else{
    await StockService().updateStock(
      idStock: widget.stock!.idStock!, nomProduit: widget.nomProduit,
      origineProduit: widget.origine, prix: widget.prix,
     formeProduit: widget.forme, quantiteStock: widget.quantite, 
     typeProduit: _typeController.text, descriptionStock: _descriptionController.text, 
      zoneProduction: widget.stock!.zoneProduction!, speculation: widget.stock!.speculation!,
      unite: widget.stock!.unite!, 
      magasin: widget.stock!.magasin!, acteur: acteur);
   }
    } catch (error) {
        // Handle any exceptions that might occur during the request
        final String errorMessage = error.toString();
        debugPrint("no update" + errorMessage);
      } 


   } 

     @override
  void initState() {

    verify();
    magasinListe =
        // http.get(Uri.parse('https://koumi.ml/api-koumi/Magasin/getAllMagasinByActeur/${id}'));
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Magasin/getAllMagasinByActeur/${id}'));
    speculationListe =
        // http.get(Uri.parse('https://koumi.ml/api-koumi/Speculation/getAllSpeculation'));
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Speculation/getAllSpeculation'));
    uniteListe =
        // http.get(Uri.parse('https://koumi.ml/api-koumi/Unite/getAllUnite'));
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Unite/getAllUnite'));
    zoneListe =
        // http.get(Uri.parse('https://koumi.ml/api-koumi/ZoneProduction/getAllZone'));
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/ZoneProduction/getAllZone'));

          debugPrint("id : $id, type : ${widget.stock!.typeProduit!}, desc : ${widget.stock!.descriptionStock!}  acteur : $acteur");
        
         
    super.initState();
    if(widget.isEditable! == true){
     _typeController.text = widget.stock!.typeProduit!;
     _descriptionController.text = widget.stock!.descriptionStock!;
    }
    debugPrint("nom : ${widget.nomProduit}, bool : ${widget.isEditable} , forme: ${widget.forme}, origine : ${widget.origine}, qte : ${widget.quantite}, prix : ${widget.prix}");
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
            widget.isEditable == false
                ? "Ajouter produit"
                : "Modifier produit",
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
                            return Text("Une erreur s'est produite veuillez réessayer");
                              }
                              if (snapshot.hasData) {
                                dynamic responseData =
                                    json.decode(snapshot.data.body);
                                if (responseData is List) {
                                  final reponse = responseData;
                                  final speculationListe = reponse
                                      .map((e) => Speculation.fromMap(e))
                                      .where((con) => con.statutSpeculation == true)
                                      .toList();
                    
                                  if (speculationListe.isEmpty) {
                                    return DropdownButtonFormField(
                                      items: [],
                                      onChanged: null,
                                      decoration: InputDecoration(
                                        labelText: 'Aucune speculation trouvé',
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
                                  
                                    items: speculationListe
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.idSpeculation,
                                            child: Text(e.nomSpeculation!),
                                          ),
                                        )
                                        .toList(),
                                    value: speculation.idSpeculation,
                                    onChanged: (newValue) {
                                      setState(() {
                                        speculation.idSpeculation = newValue;
                                        if (newValue != null) {
                                          speculation.nomSpeculation = speculationListe
                                              .map((e) => e.nomSpeculation!)
                                              .first;
                                          print("speculation : ${speculation}");
                                        }
                                      });
                                    },
                                  
                                    decoration: InputDecoration(
                                      
                                      labelText: widget.stock!.speculation!.nomSpeculation == null ? 'Selectionner une spéculation' : widget.stock!.speculation!.nomSpeculation!,
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
                            return Text("Une erreur s'est produite veuillez réessayer plus tard");
                              }
                              if (snapshot.hasData) {
                                dynamic responseData =
                                    json.decode(snapshot.data.body);
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
                                    
                                    items: magasinListe
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.idMagasin,
                                            child: Text(e.nomMagasin!),
                                          ),
                                        )
                                        .toList(),
                                    value: magasin.idMagasin,
                                    onChanged: (newValue) {
                                      setState(() {
                                        magasin.idMagasin = newValue;
                                        if (newValue != null) {
                                          magasin.nomMagasin = magasinListe
                                              .map((e) => e.nomMagasin!)
                                              .first;
                                          print("magasin : ${magasin.nomMagasin}");
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: widget.stock!.magasin!.nomMagasin == null ? 'Selectionner un magasin' : widget.stock!.magasin!.nomMagasin,
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
                            return Text("Une erreur s'est produite veuillez réessayer plus tard");
                              }
                              if (snapshot.hasData) {
                                dynamic responseData =
                                    json.decode(snapshot.data.body);
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
                                   
                                    items: uniteListe
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.idUnite,
                                            child: Text(e.nomUnite!),
                                          ),
                                        )
                                        .toList(),
                                    value: unite.idUnite,
                                    onChanged: (newValue) {
                                      setState(() {
                                        unite.idUnite = newValue;
                                        if (newValue != null) {
                                          unite.nomUnite = uniteListe
                                              .map((e) => e.nomUnite!)
                                              .first;
                                          print("unité : ${unite.nomUnite}");
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: widget.stock!.unite!.nomUnite == null ? 'Selectionner une unité' : widget.stock!.unite!.nomUnite ,
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
                            return Text("Une erreur s'est produite veuillez réessayer plus tard");
                              }
                              if (snapshot.hasData) {
                                dynamic responseData =
                                    json.decode(snapshot.data.body);
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
                                        labelText: 'Aucune zone de production trouvé',
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
                              
                                    items: zoneListe
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.idZoneProduction,
                                            child: Text(e.nomZoneProduction!),
                                          ),
                                        )
                                        .toList(),
                                    value: zoneProduction.idZoneProduction,
                                    onChanged: (newValue) {
                                      setState(() {
                                        zoneProduction.idZoneProduction = newValue;
                                        if (newValue != null) {
                                          zoneProduction.nomZoneProduction = zoneListe
                                              .map((e) => e.nomZoneProduction!)
                                              .first;
                                          print("zone de production : ${speculation}");
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                     labelText: widget.stock!.zoneProduction!.nomZoneProduction == null ?'Selectionner une zone de production' : widget.stock!.zoneProduction!.nomZoneProduction,
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
                                      labelText:  'Aucune zone de production trouvé',
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
                                handleButtonPress();
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
  
}