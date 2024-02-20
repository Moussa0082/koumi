import 'package:flutter/material.dart';
import 'package:koumi_app/models/Continent.dart';
import 'package:koumi_app/models/SousRegion.dart';
import 'package:koumi_app/service/SousRegionService.dart';
import 'package:provider/provider.dart';

class updateSousRegions extends StatefulWidget {
  final SousRegion sousRegion;
  const updateSousRegions({super.key, required this.sousRegion});

  @override
  State<updateSousRegions> createState() => _updateSousRegionsState();
}

class _updateSousRegionsState extends State<updateSousRegions> {
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  late Continent continent;
  @override
  void initState() {
    libelleController.text = widget.sousRegion.nomSousRegion;
    continent = widget.sousRegion.continent;
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
              "Ajouter une sous region",
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
                      hintText: "Nom de sous région",
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
                      child: ElevatedButton(
                        onPressed: () async {
                          final String libelle = libelleController.text;
                          if (formkey.currentState!.validate()) {
                            try {
                              await SousRegionService()
                                  .updateSousRegion(
                                    idSousRegion: widget.sousRegion.idSousRegion!,
                                      nomSousRegion: libelle,
                                      continent: continent)
                                  .then((value) => {
                                        Provider.of<SousRegionService>(context,
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
                                      Text("Une erreur s'est produit"),
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
