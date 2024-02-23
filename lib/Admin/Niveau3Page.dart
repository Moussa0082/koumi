import 'package:flutter/material.dart';
import 'package:koumi_app/Admin/CodePays.dart';
import 'package:koumi_app/models/Niveau2Pays.dart';
import 'package:koumi_app/models/Niveau3Pays.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/service/Niveau3Service.dart';
import 'package:provider/provider.dart';

class Niveau3Page extends StatefulWidget {
  // final Niveau2Pays niveau2pays;
  const Niveau3Page({super.key});

  @override
  State<Niveau3Page> createState() => _Niveau3PageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _Niveau3PageState extends State<Niveau3Page> {
  late ParametreGeneraux para;
  List<Niveau3Pays> niveauList = [];
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late Future<List<Niveau3Pays>> _liste;
  List<ParametreGeneraux> paraList = [];
  late Niveau2Pays n2;

  // Future<List<Niveau3Pays>> getNiveauListe() async {
  //   final response = await Niveau3Service()
  //       .fetchNiveau3ByNiveau2(widget.niveau2pays.idNiveau2Pays!);
  //   return response;
  // }

  @override
  void initState() {
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;
    para = paraList[0];
    // _liste = getNiveauListe();
    // _liste.toString();
    // n2 = widget.niveau2pays;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Niveau 3 : ${para.libelleNiveau3Pays}",
          style:
              const TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showDialog();
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: d_colorGreen,
              size: 25,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<Niveau3Service>(
              builder: (context, niveau3Service, child) {
                return FutureBuilder(
                    future: _liste,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: Text("Aucun catégorie trouvé")),
                        );
                      } else {
                        niveauList = snapshot.data!;

                        return Column(
                            children: niveauList
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      child: Container(
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              offset: const Offset(0, 2),
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            ListTile(
                                                leading: CodePays().getFlag(
                                                    e.niveau2Pays.niveau1Pays!.pays.nomPays
                                                        ),
                                                title:
                                                    Text(e.nomN3.toUpperCase(),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )),
                                                subtitle: Text(e.descriptionN3,
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ))),
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  _buildEtat(e.statutN3),
                                                  PopupMenuButton<String>(
                                                    padding: EdgeInsets.zero,
                                                    itemBuilder: (context) =>
                                                        <PopupMenuEntry<
                                                            String>>[
                                                      PopupMenuItem<String>(
                                                        child: ListTile(
                                                          leading: const Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                          title: const Text(
                                                            "Activer",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            await Niveau3Service()
                                                                .activerNiveau3(e
                                                                    .idNiveau3Pays!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<Niveau3Service>(context, listen: false)
                                                                              .applyChange(),
                                                                          // setState(
                                                                          //     () {
                                                                          //   _liste =
                                                                          //       Niveau3Service().fetchNiveau3ByNiveau2(widget.niveau2pays.idNiveau2Pays!);
                                                                          // }),
                                                                          Navigator.of(context)
                                                                              .pop(),
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                              content: Row(
                                                                                children: [
                                                                                  Text("Activer avec succèss "),
                                                                                ],
                                                                              ),
                                                                              duration: Duration(seconds: 2),
                                                                            ),
                                                                          )
                                                                        })
                                                                .catchError(
                                                                    (onError) =>
                                                                        {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                              content: Row(
                                                                                children: [
                                                                                  Text("Une erreur s'est produit"),
                                                                                ],
                                                                              ),
                                                                              duration: Duration(seconds: 5),
                                                                            ),
                                                                          ),
                                                                          Navigator.of(context)
                                                                              .pop(),
                                                                        });
                                                          },
                                                        ),
                                                      ),
                                                      PopupMenuItem<String>(
                                                        child: ListTile(
                                                          leading: Icon(
                                                            Icons
                                                                .disabled_visible,
                                                            color: Colors
                                                                .orange[400],
                                                          ),
                                                          title: Text(
                                                            "Désactiver",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .orange[400],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            await Niveau3Service()
                                                                .desactiverNiveau3Pays(e
                                                                    .idNiveau3Pays!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<Niveau3Service>(context, listen: false)
                                                                              .applyChange(),
                                                                         
                                                                          Navigator.of(context)
                                                                              .pop(),
                                                                        })
                                                                .catchError(
                                                                    (onError) =>
                                                                        {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                              content: Row(
                                                                                children: [
                                                                                  Text("Une erreur s'est produit"),
                                                                                ],
                                                                              ),
                                                                              duration: Duration(seconds: 5),
                                                                            ),
                                                                          ),
                                                                          Navigator.of(context)
                                                                              .pop(),
                                                                        });

                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Row(
                                                                  children: [
                                                                    Text(
                                                                        "Désactiver avec succèss "),
                                                                  ],
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      PopupMenuItem<String>(
                                                        child: ListTile(
                                                          leading: const Icon(
                                                            Icons.edit,
                                                            color: Colors.green,
                                                          ),
                                                          title: const Text(
                                                            "Modifier",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            // Ouvrir la boîte de dialogue de modification
                                                            var updatedSousRegion =
                                                                await showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  AlertDialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                ),
                                                                // content: UpdatesCategorie(
                                                                //     categorieProduit:
                                                                //         e)
                                                              ),
                                                            );

                                                           
                                                            if (updatedSousRegion !=
                                                                null) {
                                                              Provider.of<Niveau3Service>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .applyChange();
                                                              // setState(() {
                                                              //   _liste = Niveau3Service()
                                                              //       .fetchCategorieByFiliere(
                                                              //           filiere
                                                              //               .idFiliere!);
                                                              // });
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      PopupMenuItem<String>(
                                                        child: ListTile(
                                                          leading: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                          title: const Text(
                                                            "Supprimer",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            await Niveau3Service()
                                                                .deleteNiveau3Pays(e
                                                                    .idNiveau3Pays!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<Niveau3Service>(context, listen: false)
                                                                              .applyChange(),
                                                                          // setState(
                                                                          //     () {
                                                                          //   _liste =
                                                                          //       Niveau3Service().fetchNiveau3ByNiveau2(widget.niveau2pays.idNiveau2Pays!);
                                                                          // }),
                                                                          Navigator.of(context)
                                                                              .pop(),
                                                                        })
                                                                .catchError(
                                                                    (onError) =>
                                                                        {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                              content: Row(
                                                                                children: [
                                                                                  Text("Impossible de supprimer"),
                                                                                ],
                                                                              ),
                                                                              duration: Duration(seconds: 2),
                                                                            ),
                                                                          )
                                                                        });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList());
                      }
                    });
              },
            )
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "Ajouter un(e) ${para.libelleNiveau2Pays}",
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
                          hintText: "Nom du niveau 2",
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
                              final String description =
                                  descriptionController.text;
                              // final Niveau2Pays niveau2 = widget.niveau2pays;
                              if (formkey.currentState!.validate()) {
                                // try {
                                //   await Niveau3Service()
                                //       .addNiveau3Pays(
                                //           nomN3: libelle,
                                //           descriptionN3: description,
                                //           niveau2pays: niveau2)
                                //       .then((value) => {
                                //             Provider.of<Niveau3Service>(context,
                                //                     listen: false)
                                //                 .applyChange(),
                                //             setState(() {
                                //               _liste = Niveau3Service()
                                //                   .fetchNiveau3ByNiveau2(widget
                                //                       .niveau2pays
                                //                       .idNiveau2Pays!);
                                //             })
                                //           })
                                //       .catchError((onError) =>
                                //           {print(onError.message)});

                                //   libelleController.clear();
                                //   descriptionController.clear();
                                //   Navigator.of(context).pop();
                                // } catch (e) {
                                //   final String errorMessage = e.toString();
                                //   print(errorMessage);
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     const SnackBar(
                                //       content:
                                //           Text("Une erreur s'est produite"),
                                //       duration: Duration(seconds: 5),
                                //     ),
                                //   );
                                // }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Ajouter",
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
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
        ),
      ),
    );
  }

  Widget _buildEtat(bool isState) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isState ? Colors.green : Colors.red,
      ),
    );
  }
}
