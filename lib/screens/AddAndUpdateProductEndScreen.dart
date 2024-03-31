
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Magasin.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/Unite.dart';
import 'package:koumi_app/models/ZoneProduction.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';

class AddAndUpdateProductEndSreen extends StatefulWidget {
  
     bool? isEditable;

   AddAndUpdateProductEndSreen({super.key, this.isEditable});

  @override
  State<AddAndUpdateProductEndSreen> createState() => _AddAndUpdateProductEndSreenState();
}

class _AddAndUpdateProductEndSreenState extends State<AddAndUpdateProductEndSreen> {

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   bool isLoading = false;
     TextEditingController uniteController = TextEditingController();
     TextEditingController magasinController = TextEditingController();
     TextEditingController zoneController = TextEditingController();
     TextEditingController speculationController = TextEditingController();
     TextEditingController _typeController = TextEditingController();
      File? photos;
      String? specValue;
     String speculation = '';
    late Future speculationListe;
      String? uniteValue;
     String unite = '';
    late Future uniteListe;
      String? magasinValue;
     String magasin = '';
    late Future magasinListe;
      String? zoneValue;
     String zoneProduction = '';
    late Future zoneListe;

    @override
  void initState() {
    speculationListe =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Speculation/getAllSpeculation'));
    uniteListe =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Unite/getAllUnite'));
    magasinListe =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Magasin/getAllMagagin'));
    zoneListe =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/ZoneProduction/getAllZone'));
        
    super.initState();
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
            widget.isEditable! == false
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
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
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
                                    labelText: 'Aucun localité trouvé',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
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
                                    value: specValue,
                                    onChanged: (newValue) {
                                      setState(() {
                                        specValue = newValue;
                                        if (newValue != null) {
                                          speculation = speculationListe
                                              .map((e) => e.nomSpeculation!)
                                              .first;
                                          print("speculation : ${speculation}");
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Selectionner une spéculation',
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
                                    labelText: 'Aucun magasin trouvé',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
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
                                    value: specValue,
                                    onChanged: (newValue) {
                                      setState(() {
                                        specValue = newValue;
                                        if (newValue != null) {
                                          magasin = magasinListe
                                              .map((e) => e.nomMagasin!)
                                              .first;
                                          print("magasin : ${speculation}");
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Selectionner un magasin',
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
                                    labelText: 'Aucune unité trouvé',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
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
                                    value: specValue,
                                    onChanged: (newValue) {
                                      setState(() {
                                        specValue = newValue;
                                        if (newValue != null) {
                                          unite = uniteListe
                                              .map((e) => e.nomUnite!)
                                              .first;
                                          print("unité : ${speculation}");
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Selectionner une unité',
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
                                    labelText: 'Aucune zone de production trouvé',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
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
                                    value: specValue,
                                    onChanged: (newValue) {
                                      setState(() {
                                        specValue = newValue;
                                        if (newValue != null) {
                                          zoneProduction = zoneListe
                                              .map((e) => e.nomZoneProduction!)
                                              .first;
                                          print("zone de production : ${speculation}");
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Selectionner une zone de production',
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
                                      labelText: 'Aucune zone de production trouvé',
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
                                // _handleButtonPress();
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
                              widget.isEditable! == false
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