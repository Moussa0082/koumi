import 'package:flutter/material.dart';
import 'package:koumi_app/Admin/UpdatesSpeculation.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/SpeculationService.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:provider/provider.dart';

class SpeculationPage extends StatefulWidget {
  final CategorieProduit categorieProduit;
  const SpeculationPage({super.key, required this.categorieProduit});

  @override
  State<SpeculationPage> createState() => _SpeculationPageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _SpeculationPageState extends State<SpeculationPage> {
  late CategorieProduit cat;
  late Acteur acteur;
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Speculation> speculationList = [];
  List<Stock> stockList = [];
  late Future<List<Speculation>> _liste;
  late TextEditingController _searchController;

  Future<List<Speculation>> getCatListe(String id) async {
    return await SpeculationService().fetchSpeculationByCategorie(id);
  }

  @override
  void initState() {
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    cat = widget.categorieProduit;
    _liste = getCatListe(cat.idCategorieProduit!);
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Disposez le TextEditingController lorsque vous n'en avez plus besoin
    super.dispose();
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
          title: Column(
            children: [
              // Text(
              //   "Spéculation",
              //   style:
              //       TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(height: 10),
              Text(
                cat.libelleCategorie!.toUpperCase(),
                style: TextStyle(
                    color: d_colorGreen,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                _showDialog();
              },
              icon: const Icon(
                Icons.add,
                color: d_colorGreen,
                size: 25,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50], // Couleur d'arrière-plan
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search,
                          color: Colors.blueGrey[400]), // Couleur de l'icône
                      SizedBox(
                          width:
                              10), // Espacement entre l'icône et le champ de recherche
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Rechercher',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: Colors
                                    .blueGrey[400]), // Couleur du texte d'aide
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Consumer<SpeculationService>(
                builder: (context, speculationService, child) {
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
                            child: Center(
                                child: Text("Aucune spéculation trouvé")),
                          );
                        } else {
                          speculationList = snapshot.data!;
                          String searchText = "";
                          List<Speculation> filtereSearch =
                              speculationList.where((search) {
                            String libelle =
                                search.nomSpeculation!.toLowerCase();
                            searchText = _searchController.text.toLowerCase();
                            return libelle.contains(searchText);
                          }).toList();
                          return Column(
                              children: filtereSearch
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: Container(
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
                                                  leading: _getIconForFiliere(e
                                                      .categorieProduit!
                                                      .filiere!
                                                      .libelleFiliere!),
                                                  title: Text(
                                                      e.nomSpeculation!
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                  subtitle: Text(
                                                      e.descriptionSpeculation!
                                                          .trim(),
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ))),
                                              FutureBuilder(
                                                  future: StockService()
                                                      .fetchStockBySpeculation(
                                                          e.idSpeculation!),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                "Nombres de produit",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                )),
                                                            Text("0",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ))
                                                          ],
                                                        ),
                                                      );
                                                    }

                                                    if (!snapshot.hasData) {
                                                      return Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                "Nombres de produit:",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                )),
                                                            Text("0",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ))
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      stockList =
                                                          snapshot.data!;
                                                      return Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                "Nombres de produit",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                )),
                                                            Text(
                                                                stockList.length
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ))
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  }),
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
                                                        e.statutSpeculation!),
                                                    PopupMenuButton<String>(
                                                      padding: EdgeInsets.zero,
                                                      itemBuilder: (context) =>
                                                          <PopupMenuEntry<
                                                              String>>[
                                                        PopupMenuItem<String>(
                                                          child: ListTile(
                                                            leading:  e.statutSpeculation ==
                                                                        false
                                                                    ? Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Colors
                                                                            .green,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .disabled_visible,
                                                                        color: Colors
                                                                            .orange[400],
                                                                      ),
                                                            title:  Text(
                                                              e.statutSpeculation ==
                                                                      false
                                                                  ? "Activer"
                                                                  : "Desactiver",
                                                              style: TextStyle(
                                                                color: e.statutSpeculation ==
                                                                        false
                                                                    ? Colors
                                                                        .green
                                                                    : Colors.orange[
                                                                        400],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                               e.statutSpeculation ==
                                                                      false
                                                                  ?
                                                              await SpeculationService()
                                                                  .activerSpeculation(e
                                                                      .idSpeculation!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<SpeculationService>(context, listen: false).applyChange(),
                                                                            setState(() {
                                                                              _liste = getCatListe(cat.idCategorieProduit!);
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
                                                                          }) :  await SpeculationService()
                                                                      .desactiverSpeculation(e
                                                                          .idSpeculation!)
                                                                      .then(
                                                                          (value) =>
                                                                              {
                                                                                Provider.of<SpeculationService>(context, listen: false).applyChange(),
                                                                                setState(() {
                                                                                  _liste = getCatListe(cat.idCategorieProduit!);
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
                                                                            UpdatesSpeculation(
                                                                          speculation:
                                                                              e,
                                                                        )),
                                                              );

                                                              setState(() {
                                                                _liste =
                                                                    getCatListe(
                                                                        cat.idCategorieProduit!);
                                                              });
                                                              if (updatedSousRegion !=
                                                                  null) {
                                                                Provider.of<SpeculationService>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .applyChange();
                                                                // setState(() {
                                                                //   _liste = SpeculationService()
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
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              await SpeculationService()
                                                                  .deleteSpeculation(e
                                                                      .idSpeculation!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<SpeculationService>(context, listen: false).applyChange(),
                                                                            setState(() {
                                                                              _liste = getCatListe(cat.idCategorieProduit!);
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    "Ajouter une spéculation",
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
                            return "Veuillez remplir les champs";
                          }
                          return null;
                        },
                        controller: libelleController,
                        decoration: InputDecoration(
                          hintText: "Nom de la spéculation",
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
                            return "Veuillez remplir les champs";
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
                              await SpeculationService()
                                  .addSpeculation(
                                    nomSpeculation: libelle,
                                    descriptionSpeculation: description,
                                    categorieProduit: cat,
                                  )
                                  .then((value) => {
                                        Provider.of<SpeculationService>(context,
                                                listen: false)
                                            .applyChange(),
                                        setState(() {
                                          _liste = getCatListe(
                                              cat.idCategorieProduit!);
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
                          backgroundColor: Colors.green, // Orange color code
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: const Size(290, 45),
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
                      )
                    ],
                  ),
                )
              ],
            ),
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
