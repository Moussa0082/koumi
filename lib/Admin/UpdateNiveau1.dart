import 'package:flutter/material.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/service/Niveau1Service.dart';
import 'package:provider/provider.dart';

class UpdatesNiveau1 extends StatefulWidget {
  final Niveau1Pays niveau1pays;
  const UpdatesNiveau1({super.key, required this.niveau1pays});

  @override
  State<UpdatesNiveau1> createState() => _UpdatesNiveau1State();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _UpdatesNiveau1State extends State<UpdatesNiveau1> {
    late ParametreGeneraux para;
    final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
    late Future<List<Niveau1Pays>> _liste;
     List<ParametreGeneraux> paraList = [];
     late Niveau1Pays niveau;

   Future<List<Niveau1Pays>> geNiveauListe() async {
    final response =
        await Niveau1Service().fetchNiveau1ByPays(widget.niveau1pays.pays.idPays!);
    return response;
  }

  @override
  void initState() {
    super.initState();
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;
    para = paraList[0];
    niveau = widget.niveau1pays;
    libelleController.text = niveau.nomN1;
    descriptionController.text = niveau.descriptionN1;
    setState(() {
      _liste = geNiveauListe();
    });
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
              "Ajouter un(e) ${para.libelleNiveau1Pays}",
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
                              await Niveau1Service()
                                  .updateNiveau1Pays(idNiveau1Pays:niveau.idNiveau1Pays! , nomN1: libelle, descriptionN1: description, pays: niveau.pays)
                                  .then((value) => {
                                        Provider.of<Niveau1Service>(context,
                                                listen: false)
                                            .applyChange(),
                                        Provider.of<Niveau1Service>(context,
                                                listen: false)
                                            .applyChange(),
                                        setState(() {
                                          _liste = Niveau1Service()
                                              .fetchNiveau1ByPays(
                                                  niveau.pays.idPays!);
                                        }),
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
