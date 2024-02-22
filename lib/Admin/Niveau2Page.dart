import 'package:flutter/material.dart';
import 'package:koumi_app/Admin/CodePays.dart';
import 'package:koumi_app/Admin/Niveau3Page.dart';
import 'package:koumi_app/Admin/UpdatesNiveau2.dart';
import 'package:koumi_app/models/Niveau1Pays.dart';
import 'package:koumi_app/models/Niveau2Pays.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/service/Niveau2Service.dart';
import 'package:provider/provider.dart';

class Niveau2Page extends StatefulWidget {
  final Niveau1Pays niveau1pays;
  const Niveau2Page({super.key, required this.niveau1pays});

  @override
  State<Niveau2Page> createState() => _Niveau2PageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _Niveau2PageState extends State<Niveau2Page> {
  late ParametreGeneraux para;
  List<Niveau2Pays> niveauList = [];
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late Future<List<Niveau2Pays>> _liste;
  List<ParametreGeneraux> paraList = [];
  late Niveau1Pays n1;

  Future<List<Niveau2Pays>> getNiveauListe() async {
    final response = await Niveau2Service()
        .fetchNiveau2ByNiveau1(widget.niveau1pays.idNiveau1Pays!);
    return response;
  }

  @override
  void initState() {
    super.initState();
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;
    para = paraList[0];
    _liste = getNiveauListe();
    _liste.toString();
    n1 = widget.niveau1pays;
    debugPrint("niveau :${n1.toString()}");
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
          "Niveau 2 : ${para.libelleNiveau2Pays}",
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
        child: Column(children: [
          Consumer<Niveau2Service>(builder: (context, niveau2Service, child) {
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
                      child: Center(child: Text("Aucun donné trouvé")),
                    );
                  } else {
                    niveauList = snapshot.data!;
                    return Column(
                        children: niveauList
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Niveau3Page(
                                                      niveau2pays: e,
                                                    )));
                                      },
                                      child: ListTile(
                                        leading: CodePays().getFlag(
                                            widget.niveau1pays.pays.nomPays),
                                        title: Text(e.nomN2.toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        subtitle: Text(e.descriptionN2,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic,
                                            )),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 15),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       Text(
                                    //           "Nombres de :${para.libelleNiveau2Pays}",
                                    //           style: const TextStyle(
                                    //             color: Colors.black87,
                                    //             fontSize: 17,
                                    //             fontWeight: FontWeight.w500,
                                    //             fontStyle: FontStyle.italic,
                                    //           )),
                                    //       const Text("10",
                                    //           style: TextStyle(
                                    //             color: Colors.black87,
                                    //             fontSize: 18,
                                    //             fontWeight: FontWeight.w800,
                                    //           ))
                                    //     ],
                                    //   ),
                                    // ),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildEtat(e.statutN2),
                                          PopupMenuButton<String>(
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context) =>
                                                <PopupMenuEntry<String>>[
                                              PopupMenuItem<String>(
                                                child: ListTile(
                                                  leading: const Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  ),
                                                  title: const Text(
                                                    "Activer",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    await Niveau2Service()
                                                        .activerNiveau2(
                                                            e.idNiveau2Pays!)
                                                        .then((value) => {
                                                              Provider.of<Niveau2Service>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .applyChange(),
                                                              setState(() {
                                                                _liste = Niveau2Service()
                                                                    .fetchNiveau2ByNiveau1(widget
                                                                        .niveau1pays
                                                                        .idNiveau1Pays!);
                                                              }),
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Row(
                                                                    children: [
                                                                      Text(
                                                                          "Activer avec succèss "),
                                                                    ],
                                                                  ),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                ),
                                                              )
                                                            })
                                                        .catchError(
                                                            (onError) => {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      content:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                              "Une erreur s'est produit"),
                                                                        ],
                                                                      ),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              5),
                                                                    ),
                                                                  ),
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                                });
                                                  },
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.disabled_visible,
                                                    color: Colors.orange[400],
                                                  ),
                                                  title: Text(
                                                    "Désactiver",
                                                    style: TextStyle(
                                                      color: Colors.orange[400],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    await Niveau2Service()
                                                        .desactiverNiveau2Pays(
                                                            e.idNiveau2Pays!)
                                                        .then((value) => {
                                                              Provider.of<Niveau2Service>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .applyChange(),
                                                              setState(() {
                                                                _liste = Niveau2Service()
                                                                    .fetchNiveau2ByNiveau1(widget
                                                                        .niveau1pays
                                                                        .idNiveau1Pays!);
                                                              }),
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                            })
                                                        .catchError(
                                                            (onError) => {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      content:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                              "Une erreur s'est produit"),
                                                                        ],
                                                                      ),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              5),
                                                                    ),
                                                                  ),
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                                });

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Row(
                                                          children: [
                                                            Text(
                                                                "Désactiver avec succèss "),
                                                          ],
                                                        ),
                                                        duration: Duration(
                                                            seconds: 2),
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
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                                  Colors.white,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                              ),
                                                              content:
                                                                  UpdatesNiveau2(
                                                                      niveau2pays:
                                                                          e)),
                                                    );

                                                    // Si les détails sont modifiés, appliquer les changements
                                                    if (updatedSousRegion !=
                                                        null) {
                                                      Provider.of<Niveau2Service>(
                                                              context,
                                                              listen: false)
                                                          .applyChange();
                                                      setState(() {
                                                        _liste =
                                                            updatedSousRegion;
                                                      });
                                                      // Mettre à jour la liste des sous-régions
                                                      setState(() {
                                                        setState(() {
                                                          _liste = Niveau2Service()
                                                              .fetchNiveau2ByNiveau1(widget
                                                                  .niveau1pays
                                                                  .idNiveau1Pays!);
                                                        });
                                                      });
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
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    await Niveau2Service()
                                                        .deleteNiveau2Pays(
                                                            e.idNiveau2Pays!)
                                                        .then((value) => {
                                                              Provider.of<Niveau2Service>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .applyChange(),
                                                              setState(() {
                                                                _liste = Niveau2Service()
                                                                    .fetchNiveau2ByNiveau1(widget
                                                                        .niveau1pays
                                                                        .idNiveau1Pays!);
                                                              }),
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                            })
                                                        .catchError(
                                                            (onError) => {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      content:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                              "Impossible de supprimer"),
                                                                        ],
                                                                      ),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              2),
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
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      height: 2,
                                      thickness: 1,
                                      indent: 50,
                                      endIndent: 0,
                                    )
                                  ],
                                ),
                              ),
                            )
                            .toList());
                  }
                });
          })
        ]),
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
                              final Niveau1Pays niveau1 = widget.niveau1pays;
                              if (formkey.currentState!.validate()) {
                                try {
                                  await Niveau2Service().addNiveau2Pays(
                                    nomN2: libelle,
                                    descriptionN2: description,
                                    niveau1pays: niveau1,
                                  );

                                  Provider.of<Niveau2Service>(context,
                                          listen: false)
                                      .applyChange();
                                  setState(() {
                                    _liste = Niveau2Service()
                                        .fetchNiveau2ByNiveau1(
                                            widget.niveau1pays.idNiveau1Pays!);
                                  });

                                  libelleController.clear();
                                  descriptionController.clear();
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  final String errorMessage = e.toString();
                                  print(errorMessage);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Une erreur s'est produite"),
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                                }
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
