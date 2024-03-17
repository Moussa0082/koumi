import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeVoiture.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/NextAddVehicule.dart';
import 'package:koumi_app/service/VehiculeService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddVehiculeTransport extends StatefulWidget {
  final TypeVoiture? typeVoitures;

  const AddVehiculeTransport({
    Key? key,
    this.typeVoitures, // Paramètre avec une valeur par défaut
  }) : super(key: key);

  @override
  State<AddVehiculeTransport> createState() => _AddVehiculeTransportState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AddVehiculeTransportState extends State<AddVehiculeTransport> {
  TextEditingController _nomController = TextEditingController();
  TextEditingController _localiteController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _nbKilometrageController = TextEditingController();
  TextEditingController _capaciteController = TextEditingController();

  String? typeValue;
  late Future _typeList;
  late TypeVoiture typeVoiture;
  late TypeVoiture type;
  File? photo;
  late Acteur acteur;
  bool _isLoading = false;
  final formkey = GlobalKey<FormState>();

  void _handleButtonPress() async {
    // Afficher l'indicateur de chargement
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    type = widget.typeVoitures!;
    _typeList =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/TypeVoiture/read'));
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
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
          title: Text(
            'Ajout de véhicule transport',
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                // height: 150,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: photo != null
                        ? Image.file(
                            photo!,
                            fit: BoxFit.fitWidth,
                            height: 150,
                            width: 300,
                          )
                        : Container()),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Nom du véhicule",
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez remplir les champs";
                            }
                            return null;
                          },
                          controller: _nomController,
                          decoration: InputDecoration(
                            hintText: "nom",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Description",
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez remplir les champs";
                            }
                            return null;
                          },
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            hintText: "Description",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Nombre de kilométrage",
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez remplir les champs";
                            }
                            return null;
                          },
                          controller: _nbKilometrageController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: "Nombre de kilometrage",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      type == null
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 22,
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Type de véhicule",
                                  style: TextStyle(
                                      color: (Colors.black), fontSize: 18),
                                ),
                              ),
                            )
                          : Container(),
                      type == null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: FutureBuilder(
                                future: _typeList,
                                builder: (_, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return DropdownButtonFormField(
                                      items: [],
                                      onChanged: null,
                                      decoration: InputDecoration(
                                        labelText:
                                            'Aucun type de véhicule trouvé',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                      final vehiculeList = reponse
                                          .map((e) => TypeVoiture.fromMap(e))
                                          .where(
                                              (con) => con.statutType == true)
                                          .toList();

                                      if (vehiculeList.isEmpty) {
                                        return DropdownButtonFormField(
                                          items: [],
                                          onChanged: null,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Aucun type de véhicule trouvé',
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        );
                                      }

                                      return DropdownButtonFormField<String>(
                                        items: vehiculeList
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e.idTypeVoiture,
                                                child: Text(e.nom),
                                              ),
                                            )
                                            .toList(),
                                        value: typeValue,
                                        onChanged: (newValue) {
                                          setState(() {
                                            typeValue = newValue;
                                            if (newValue != null) {
                                              typeVoiture =
                                                  vehiculeList.firstWhere(
                                                (element) =>
                                                    element.idTypeVoiture ==
                                                    newValue,
                                              );
                                            }
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText:
                                              'Sélectionner un type de véhicule',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 20),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return DropdownButtonFormField(
                                        items: [],
                                        onChanged: null,
                                        decoration: InputDecoration(
                                          labelText:
                                              'Aucun type de véhicule trouvé',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 20),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  return DropdownButtonFormField(
                                    items: [],
                                    onChanged: null,
                                    decoration: InputDecoration(
                                      labelText:
                                          'Aucun type de véhicule trouvé',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Localité",
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez remplir les champs";
                            }
                            return null;
                          },
                          controller: _localiteController,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "Ex : Bamako, segou",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Capacité de la véhicule",
                            style:
                                TextStyle(color: (Colors.black), fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez remplir les champs";
                            }
                            return null;
                          },
                          controller: _capaciteController,
                          decoration: InputDecoration(
                            hintText: "capacité",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NextAddVehicule(
                                        typeVoiture: type,
                                        nomV: _nomController.text,
                                        localite: _localiteController.text,
                                        description:
                                            _descriptionController.text,
                                        nbKilo: _nbKilometrageController.text,
                                        capacite: _capaciteController.text)));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange, // Orange color code
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: const Size(290, 45),
                          ),
                          child: Text(
                            "Suivant",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
