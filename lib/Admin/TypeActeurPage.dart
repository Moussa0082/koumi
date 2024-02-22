import 'package:flutter/material.dart';
import 'package:koumi_app/Admin/UpdateTypeActeur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/service/TypeActeurService.dart';
import 'package:provider/provider.dart';

class TypeActeurPage extends StatefulWidget {
  const TypeActeurPage({super.key});

  @override
  State<TypeActeurPage> createState() => _TypeActeurPageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _TypeActeurPageState extends State<TypeActeurPage> {
  List<TypeActeur> typeList = [];
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
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
            title: const Text(
              "Type acteur",
              style:
                  TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
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
                  ))
            ]),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //     alignment: Alignment.topRight,
              //     child: TextButton(
              //         onPressed: () {
              //           _showDialog();
              //         },
              //         child: const Text("+ Ajouter un type d'acteur",
              //             style:
              //                 TextStyle(fontSize: 16, color: d_colorGreen)))),
              Consumer<TypeActeurService>(
                builder: (context, typeService, child) {
                  return FutureBuilder(
                      future: typeService.fetchTypeActeur(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            color: Colors.orange,
                          );
                        }

                        if (snapshot.hasError) {
                          return const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Une erreur s'est produite"),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Aucun type trouvé"),
                          );
                        } else {
                          typeList = snapshot.data!;
                          return Column(
                              children: typeList
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: Container(
                                          height: 150,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                offset: const Offset(0, 2),
                                                blurRadius: 5,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                  leading: _getIconForType(
                                                      e.libelle),
                                                  title: Text(
                                                      e.libelle.toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                  subtitle: Text(
                                                      e.descriptionTypeActeur,
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ))),
                                              Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    _buildEtat(
                                                        e.statutTypeActeur),
                                                    PopupMenuButton<String>(
                                                      padding: EdgeInsets.zero,
                                                      itemBuilder: (context) =>
                                                          <PopupMenuEntry<
                                                              String>>[
                                                        PopupMenuItem<String>(
                                                          child: ListTile(
                                                            leading: const Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            title: const Text(
                                                              "Activer",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              await TypeActeurService()
                                                                  .activerTypeActeur(e
                                                                      .idTypeActeur!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<TypeActeurService>(context, listen: false).applyChange(),
                                                                            Navigator.of(context).pop(),
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(
                                                                                content: Row(
                                                                                  children: [
                                                                                    Text("Type acteur activer avec succèss "),
                                                                                  ],
                                                                                ),
                                                                                duration: Duration(seconds: 2),
                                                                              ),
                                                                            )
                                                                          })
                                                                  .catchError(
                                                                      (onError) =>
                                                                          {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(
                                                                                content: Row(
                                                                                  children: [
                                                                                    Text("Une erreur s'est produit : $onError"),
                                                                                  ],
                                                                                ),
                                                                                duration: const Duration(seconds: 5),
                                                                              ),
                                                                            ),
                                                                            Navigator.of(context).pop(),
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
                                                                        .orange[
                                                                    400],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              await TypeActeurService()
                                                                  .desactiverTypeActeur(e
                                                                      .idTypeActeur!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<TypeActeurService>(context, listen: false).applyChange(),
                                                                            Navigator.of(context).pop(),
                                                                          })
                                                                  .catchError(
                                                                      (onError) =>
                                                                          {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(
                                                                                content: Row(
                                                                                  children: [
                                                                                    Text("Une erreur s'est produit : $onError"),
                                                                                  ],
                                                                                ),
                                                                                duration: const Duration(seconds: 5),
                                                                              ),
                                                                            ),
                                                                            Navigator.of(context).pop(),
                                                                          });

                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Row(
                                                                    children: [
                                                                      Text(
                                                                          "Type acteur desactiver avec succèss "),
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
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            title: const Text(
                                                              "Modifier",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      AlertDialog(
                                                                          backgroundColor: Colors
                                                                              .white,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                          ),
                                                                          content:
                                                                              UpdateTypeActeur(typeActeur: e)));
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              // setState(() {
                                                              //   setState(() {
                                                              //     listFuture =
                                                              //         DepenseService()
                                                              //             .fetchParametre();
                                                              //   });
                                                              // });
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
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              await TypeActeurService()
                                                                  .deleteTypeActeur(e
                                                                      .idTypeActeur!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<TypeActeurService>(context, listen: false).applyChange(),
                                                                            Navigator.of(context).pop(),
                                                                          })
                                                                  .catchError(
                                                                      (onError) =>
                                                                          {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(
                                                                                content: Row(
                                                                                  children: [
                                                                                    Text("Ce type d'acteur est déjà associer à un acteur"),
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
              ),
            ],
          ),
        ));
  }

  Widget _getIconForType(String libelle) {
    switch (libelle.toLowerCase()) {
      case 'producteur':
      case 'producteurs':
        return Image.asset(
          "assets/images/prod.png",
          width: 100,
          height: 100,
        );
      case 'fournisseur':
      case 'fournisseurs':
        return Image.asset(
          "assets/images/fournisseur.png",
          width: 100,
          height: 100,
        );
      case 'commercant':
      case 'commerçant':
        return Image.asset(
          "assets/images/type.png",
          width: 100,
          height: 100,
        );
      case 'transporteur':
      case 'transporteurs':
        return Image.asset(
          "assets/images/trans.png",
          width: 100,
          height: 100,
        );
      default:
        return Image.asset(
          "assets/images/type.png",
          width: 100,
          height: 100,
        );
    }
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
              Row(
                children: [
                  Image.asset(
                    "assets/images/type.png",
                    width: 80,
                    height: 100,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "Ajouter un type d'acteur",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
              // const SizedBox(height: 10),
              Form(
                key: formkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Libellé',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
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
                          hintText: "Libellé",
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
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
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final String libelle = libelleController.text;
                              final String desc = descriptionController.text;
                              if (formkey.currentState!.validate()) {
                                try {
                                  await TypeActeurService()
                                      .addTypeActeur(
                                          libelle: libelle,
                                          descriptionTypeActeur: desc)
                                      .then((value) => {
                                            Provider.of<TypeActeurService>(
                                                    context,
                                                    listen: false)
                                                .applyChange(),
                                            libelleController.clear(),
                                            descriptionController.clear(),
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