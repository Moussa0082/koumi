import 'package:flutter/material.dart';
import 'package:koumi_app/Admin/SpeculationPage.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Filiere.dart';
import 'package:koumi_app/service/CategorieService.dart';
import 'package:provider/provider.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/CategorieService.dart';
import 'package:koumi_app/Admin/UpdatesCategorie.dart';

class CategoriPage extends StatefulWidget {
  const CategoriPage({super.key});

  @override
  State<CategoriPage> createState() => _CategoriPageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _CategoriPageState extends State<CategoriPage> {
  Future<List<CategorieProduit>> getCatListe(String id) async {
    return await CategorieService().fetchCategorieByFiliere(id);
  }

  List<CategorieProduit> categorieList = [];
  late Future<List<CategorieProduit>> _liste;

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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<CategorieService>(
              builder: (context, categorieService, child) {
                return FutureBuilder(
                    future: categorieService.fetchCategorie(),
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
                        categorieList = snapshot.data!;

                        return Column(
                            children: categorieList
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
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SpeculationPage(
                                                                categorieProduit:
                                                                    e)));
                                              },
                                              child: ListTile(
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
                                            ),
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
                                                  _buildEtat(e.statutCategorie),
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
                                                            await CategorieService()
                                                                .activerCategorie(e
                                                                    .idCategorieProduit!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<CategorieService>(context, listen: false)
                                                                              .applyChange(),
                                                                          // setState(
                                                                          //     () {
                                                                          //   _liste =
                                                                          //       CategorieService().fetchCategorieByFiliere(filiere.idFiliere!);
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
                                                            await CategorieService()
                                                                .desactiverCategorie(e
                                                                    .idCategorieProduit!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<CategorieService>(context, listen: false)
                                                                              .applyChange(),
                                                                          // setState(
                                                                          //     () {
                                                                          //   _liste =
                                                                          //       CategorieService().fetchCategorieByFiliere(filiere.idFiliere!);
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
                                                                            BorderRadius.circular(16),
                                                                      ),
                                                                      content: UpdatesCategorie(
                                                                          categorieProduit:
                                                                              e)),
                                                            );

                                                            // setState(() {
                                                            //   _liste = CategorieService()
                                                            //       .fetchCategorieByFiliere(
                                                            //           filiere
                                                            //               .idFiliere!);
                                                            // });
                                                            if (updatedSousRegion !=
                                                                null) {
                                                              Provider.of<CategorieService>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .applyChange();
                                                              // setState(() {
                                                              //   _liste = CategorieService()
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
                                                            await CategorieService()
                                                                .deleteCategorie(e
                                                                    .idCategorieProduit!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<CategorieService>(context, listen: false)
                                                                              .applyChange(),
                                                                          // setState(
                                                                          //     () {
                                                                          //   _liste =
                                                                          //       CategorieService().fetchCategorieByFiliere(filiere.idFiliere!);
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
            ),
          ],
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
