import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Filiere.dart';
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
  late Filiere filiere;

  @override
  void initState() {
    super.initState();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    cat = widget.categorieProduit;
    libelleController.text = cat.libelleCategorie;
    descriptionController.text = cat.descriptionCategorie!;
    filiere = cat.filiere!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                "Modification",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 24,
                ),
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
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez remplir ce champ";
                      }
                      return null;
                    },
                    controller: libelleController,
                    decoration: InputDecoration(
                      labelText: "Nom du categorie",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez remplir ce champ";
                      }
                      return null;
                    },
                    controller: descriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final String libelle = libelleController.text;
                      final String description = descriptionController.text;
                      if (formkey.currentState!.validate()) {
                        try {
                          await CategorieService()
                              .updateCategorie(
                                  idCategorieProduit: cat.idCategorieProduit!,
                                  libelleCategorie: libelle,
                                  descriptionCategorie: description,
                                  personneModif: acteur.nomActeur,
                                  filiere: filiere)
                              .then((value) => {
                                    Provider.of<CategorieService>(context,
                                            listen: false)
                                        .applyChange(),
                                    libelleController.clear(),
                                    descriptionController.clear(),
                                    Navigator.of(context).pop(),
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Row(
                                          children: [
                                            Text(
                                                "Catégorie modifier avec success"),
                                          ],
                                        ),
                                        duration: Duration(seconds: 5),
                                      ),
                                    )
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
                      backgroundColor: Colors.green, // Orange color code
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(290, 45),
                    ),
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Modifier",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
