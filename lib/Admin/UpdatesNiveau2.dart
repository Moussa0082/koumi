import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/Niveau2Pays.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/service/Niveau2Service.dart';
import 'package:provider/provider.dart';

class UpdatesNiveau2 extends StatefulWidget {
  final Niveau2Pays niveau2pays;
  const UpdatesNiveau2({super.key, required this.niveau2pays});

  @override
  State<UpdatesNiveau2> createState() => _UpdatesNiveau2State();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _UpdatesNiveau2State extends State<UpdatesNiveau2> {
  late ParametreGeneraux para;
  List<Niveau2Pays> niveauList = [];
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late Future<List<Niveau2Pays>> _liste;
  List<ParametreGeneraux> paraList = [];
  late Niveau2Pays niveau;
  late Acteur acteur;
  @override
  void initState() {
    super.initState();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;
    para = paraList[0];
    niveau = widget.niveau2pays;
    libelleController.text = niveau.nomN2;
    descriptionController.text = niveau.descriptionN2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              "Modifier un(e) ${para.libelleNiveau2Pays}",
              style: const TextStyle(
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
                      hintText: "Nom du niveau 1",
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
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final String libelle = libelleController.text;
                          final String description = descriptionController.text;
                          if (formkey.currentState!.validate()) {
                            try {
                              await Niveau2Service()
                                  .updateNiveau2Pays(
                                      idNiveau2Pays: niveau.idNiveau2Pays!,
                                      nomN2: libelle,
                                      descriptionN2: description,
                                      personeModif: acteur.nomActeur,
                                      niveau1pays: niveau.niveau1Pays!)
                                  .then((value) => {
                                        Provider.of<Niveau2Service>(context,
                                                listen: false)
                                            .applyChange(),
                                        Provider.of<Niveau2Service>(context,
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
                                      Text("Une erreur s'est produit"),
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
