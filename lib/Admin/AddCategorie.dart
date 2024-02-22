import 'package:flutter/material.dart';
import 'package:koumi_app/Admin/UpdatesCategorie.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Filiere.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/CategorieService.dart';
import 'package:provider/provider.dart';

class AddCategorie extends StatefulWidget {
  final Filiere filiere;
  const AddCategorie({super.key, required this.filiere});

  @override
  State<AddCategorie> createState() => _AddCategorieState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _AddCategorieState extends State<AddCategorie> {
  late Acteur acteur;
  late Filiere filiere;
  List<CategorieProduit> categorieList = [];
  late Future<List<CategorieProduit>> _liste;
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<List<CategorieProduit>> getCatListe(String id) async {
    return await CategorieService().fetchCategorieByFiliere(id);
  }

  @override
  void initState() {
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    filiere = widget.filiere;
    _liste = getCatListe(filiere.idFiliere!);
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
          title: const Text(
            "Catégorie produit",
            style: TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
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
              Consumer<CategorieService>(
                builder: (context, categorieService, child) {
                  return FutureBuilder(
                      future: _liste,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.all(10),
                            child:
                                Center(child: Text("Aucun catégorie trouvé")),
                          );
                        } else {
                          categorieList = snapshot.data!;

                          return Column(
                              children: categorieList
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: Container(
                                          height: 120,
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
                                                  leading: _getIconForFiliere(
                                                      e.filiere.libelleFiliere),
                                                  title: Text(
                                                      e.libelleCategorie
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                  subtitle: Text(
                                                      e.descriptionCategorie,
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ))),
                                              // const Padding(
                                              //   padding: EdgeInsets.symmetric(
                                              //       horizontal: 15),
                                              //   child: Row(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment
                                              //             .spaceBetween,
                                              //     children: [
                                              //       Text("Nombres pays :",
                                              //           style: TextStyle(
                                              //             color: Colors.black87,
                                              //             fontSize: 17,
                                              //             fontWeight:
                                              //                 FontWeight.w500,
                                              //             fontStyle:
                                              //                 FontStyle.italic,
                                              //           )),
                                              //       Text("10",
                                              //           style: TextStyle(
                                              //             color: Colors.black87,
                                              //             fontSize: 18,
                                              //             fontWeight:
                                              //                 FontWeight.w800,
                                              //           ))
                                              //     ],
                                              //   ),
                                              // ),
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
                                                        e.statutCategorie),
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
                                                              await CategorieService()
                                                                  .activerCategorie(e
                                                                      .idCategorieProduit!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<CategorieService>(context, listen: false).applyChange(),
                                                                            setState(() {
                                                                              _liste = CategorieService().fetchCategorieByFiliere(filiere.idFiliere!);
                                                                            }),
                                                                            Navigator.of(context).pop(),
                                                                            ScaffoldMessenger.of(context).showSnackBar(
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
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(
                                                                                content: Row(
                                                                                  children: [
                                                                                    Text("Une erreur s'est produit"),
                                                                                  ],
                                                                                ),
                                                                                duration: Duration(seconds: 5),
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
                                                              await CategorieService()
                                                                  .desactiverCategorie(e
                                                                      .idCategorieProduit!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<CategorieService>(context, listen: false).applyChange(),
                                                                            setState(() {
                                                                              _liste = CategorieService().fetchCategorieByFiliere(filiere.idFiliere!);
                                                                            }),
                                                                            Navigator.of(context).pop(),
                                                                          })
                                                                  .catchError(
                                                                      (onError) =>
                                                                          {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(
                                                                                content: Row(
                                                                                  children: [
                                                                                    Text("Une erreur s'est produit"),
                                                                                  ],
                                                                                ),
                                                                                duration: Duration(seconds: 5),
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
                                                            onTap: () async {
                                                              // Ouvrir la boîte de dialogue de modification
                                                              var updatedSousRegion =
                                                                  await showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(16),
                                                                        ),
                                                                        content:
                                                                            UpdatesCategorie(categorieProduit: e)),
                                                              );

                                                              setState(() {
                                                                _liste = CategorieService()
                                                                    .fetchCategorieByFiliere(
                                                                        filiere
                                                                            .idFiliere!);
                                                              });
                                                              if (updatedSousRegion !=
                                                                  null) {
                                                                Provider.of<CategorieService>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .applyChange();
                                                                setState(() {
                                                                  _liste = CategorieService()
                                                                      .fetchCategorieByFiliere(
                                                                          filiere
                                                                              .idFiliere!);
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
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              await CategorieService()
                                                                  .deleteCategorie(e
                                                                      .idCategorieProduit!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<CategorieService>(context, listen: false).applyChange(),
                                                                            setState(() {
                                                                              _liste = CategorieService().fetchCategorieByFiliere(filiere.idFiliere!);
                                                                            }),
                                                                            Navigator.of(context).pop(),
                                                                          })
                                                                  .catchError(
                                                                      (onError) =>
                                                                          {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
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
              ),
            ],
          ),
        ));
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
              const Center(
                child: Text(
                  "Ajouter une catégorie",
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
                          hintText: "Nom de la catégorie",
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
                              if (formkey.currentState!.validate()) {
                                try {
                                  await CategorieService()
                                      .addCategorie(
                                          libelleCategorie: libelle,
                                          descriptionCategorie: description,
                                          filiere: filiere,
                                          acteur: acteur)
                                      .then((value) => {
                                            Provider.of<CategorieService>(
                                                    context,
                                                    listen: false)
                                                .applyChange(),
                                            setState(() {
                                              _liste = CategorieService()
                                                  .fetchCategorieByFiliere(
                                                      filiere.idFiliere!);
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

  Widget _getIconForFiliere(String libelle) {
    switch (libelle.toLowerCase()) {
      case 'céréale':
      case 'céréales':
      case 'cereale':
      case 'cereales':
        return Image.asset(
          "assets/images/cereale.png",
          width: 80,
          height: 80,
        );
      case 'fruits':
      case 'fruit':
        return Image.asset(
          "assets/images/fruits.png",
          width: 80,
          height: 80,
        );
      case 'bétails':
      case 'bétail':
      case 'betails':
      case 'betail':
        return Image.asset(
          "assets/images/betail.png",
          width: 80,
          height: 80,
        );
      case 'légumes':
      case 'légume':
      case 'legumes':
      case 'legume':
        return Image.asset(
          "assets/images/legumes.png",
          width: 80,
          height: 80,
        );
      default:
        return Image.asset(
          "assets/images/default.png",
          width: 80,
          height: 80,
        );
    }
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
