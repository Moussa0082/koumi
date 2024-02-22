import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/CategorieService.dart';
import 'package:provider/provider.dart';

class UpdatesCategorie extends StatefulWidget {
  final CategorieProduit categorieProduit;
  const UpdatesCategorie({super.key, required this.categorieProduit});

  @override
  State<UpdatesCategorie> createState() => _UpdatesCategorieState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _UpdatesCategorieState extends State<UpdatesCategorie> {
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late CategorieProduit cat;
late Acteur acteur;
  @override
  void initState() {
    super.initState();
        acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    cat = widget.categorieProduit;
    libelleController.text = cat.libelleCategorie;
    descriptionController.text = cat.descriptionCategorie;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text(
              "Modifier une catégorie",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 5),
          Form(
            key: formkey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez remplir les champs";
                      }
                      return null;
                    },
                    controller: libelleController,
                    decoration: InputDecoration(
                      hintText: "Nom de la filiere",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez remplir les champs";
                      }
                      return null;
                    },
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: "Description",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final String libelle = libelleController.text;
                          final String description = descriptionController.text;
                          if (formkey.currentState!.validate()) {
                            try {
                              await CategorieService()
                                  .updateCategorie(idCategorieProduit: cat.idCategorieProduit!, libelleCategorie: libelle, descriptionCategorie: description, personneModif: acteur.nomActeur)
                                  .then((value) => {
                                        Provider.of<CategorieService>(context,
                                                listen: false)
                                            .applyChange(),
                                        libelleController.clear(),
                                        descriptionController.clear(),
                                        Navigator.of(context).pop()
                                      });
                            } catch (e) {
                              final String errorMessage = e.toString();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    children: [
                                      Text("Une erreur s'est produite"),
                                    ],
                                  ),
                                  duration: Duration(seconds: 5),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                       
                        child: const Text(
                          "Modifier",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Ferme la boîte de dialogue
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Text(
                          "Annuler",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
