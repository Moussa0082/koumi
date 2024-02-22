import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Unite.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/UniteService.dart';
import 'package:provider/provider.dart';

class UpdateUnite extends StatefulWidget {
  final Unite unite;
  const UpdateUnite({super.key, required this.unite});

  @override
  State<UpdateUnite> createState() => _UpdateUniteState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _UpdateUniteState extends State<UpdateUnite> {
  List<Unite> uniteList = [];
  late Acteur acteur;
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();

  @override
  void initState() {
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;

    libelleController.text = widget.unite.nomUnite;
    super.initState();
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
              "Mofifier unite ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
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
                      hintText: "Nom unité",
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final String libelle = libelleController.text;
                          if (formkey.currentState!.validate()) {
                            try {
                              await UniteService()
                                  .updateUnite(
                                      idUnite: widget.unite.idUnite!,
                                      nomUnite: libelle,
                                      acteur: acteur,
                                      personneModif: acteur.nomActeur)
                                  .then((value) => {
                                        Provider.of<UniteService>(context,
                                                listen: false)
                                            .applyChange(),
                                        libelleController.clear(),
                                        Navigator.of(context).pop()
                                      });
                            } catch (e) {
                              final String errorMessage = e.toString();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Text(
                                          "Une erreur s'est produit : $errorMessage"),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Modifer",
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
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Ferme la boîte de dialogue
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        label: const Text(
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
