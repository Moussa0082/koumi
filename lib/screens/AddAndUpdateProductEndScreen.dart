
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/models/Speculation.dart';
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
     TextEditingController nomProduitController = TextEditingController();
      String nomProduit = "";
      File? photos;
      String? specValue;
  String speculation = '';

    late Future speculationListe;

    @override
  void initState() {
    speculationListe =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/Speculation/getAllSpeculation'));
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
                  child: Column(
                    children: [
                      // Nom magasin
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Nom Produit *",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                      ),
                      TextFormField(
                        controller: nomProduitController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: "Entrez le nom du produit",
                        ),
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Veillez entrez le nom du produit";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => nomProduit = val!,
                      ),
                      // fin  nom magasin
                      const SizedBox(height: 10),

                    
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
                                        print("niveau 3 : ${speculation}");
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

                      const SizedBox(
                        height: 10,
                      ),

                      // (photos == null)
                      //     ? IconButton(
                      //         onPressed: _showImageSourceDialog,
                      //         icon: Icon(Icons.camera_alt_sharp),
                      //         iconSize: 50,
                      //       )
                      //     : Image.file(
                      //         photos!,
                      //         height: 100,
                      //         width: 200,
                      //         fit: BoxFit.cover,
                      //       ),
                      // Text("Choisir une image"),

                      const SizedBox(
                        height: 10,
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
                  )),
            ),
          ),
        ),
      ),
    );
  }
  
}