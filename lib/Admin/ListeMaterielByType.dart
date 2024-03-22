import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/Admin/AddMaterielByType.dart';
import 'package:koumi_app/models/Materiel.dart';
import 'package:koumi_app/models/TypeMateriel.dart';
import 'package:koumi_app/service/MaterielService.dart';
import 'package:provider/provider.dart';

class ListeMaterielByType extends StatefulWidget {
  final TypeMateriel typeMateriel;
  const ListeMaterielByType({super.key, required this.typeMateriel});

  @override
  State<ListeMaterielByType> createState() => _ListeMaterielByTypeState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _ListeMaterielByTypeState extends State<ListeMaterielByType> {
  late TypeMateriel type;
  List<Materiel> materielListe = [];
  late Future<List<Materiel>> futureListe;

  Future<List<Materiel>> getListe(String id) async {
    final response = await MaterielService().fetchMaterielByType(id);
    return response;
  }

  @override
  void initState() {
    type = widget.typeMateriel;
    futureListe = getListe(type.idTypeMateriel!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 100,
          // leading: IconButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
          title: Text(
            type.nom!.toUpperCase(),
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
          actions: [
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              itemBuilder: (context) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    child: ListTile(
                      leading: const Icon(
                        Icons.add,
                        color: Colors.green,
                      ),
                      title: const Text(
                        "Ajouter matériel ",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        Get.to(AddMaterielByType(typeMateriel: type));
                      },
                    ),
                  ),
                ];
              },
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<MaterielService>(
              builder: (context, materielService, child) {
                return FutureBuilder(
                    future: materielService
                        .fetchMaterielByType(type.idTypeMateriel!),
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
                          child: Center(child: Text("Aucun matériel trouvé")),
                        );
                      } else {
                        materielListe = snapshot.data!;
                        return materielListe.isEmpty
                            ? Padding(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                    child: Text("Aucun matériel trouvé")),
                              )
                            : Wrap(
                                children: materielListe
                                    .map((e) => Padding(
                                        padding: EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  offset: const Offset(0, 2),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: e.photoMateriel ==
                                                            null
                                                        ? Image.asset(
                                                            "assets/images/camion.png",
                                                            fit: BoxFit.cover,
                                                            height: 90,
                                                          )
                                                        : Image.network(
                                                            "http://10.0.2.2/${e.photoMateriel}",
                                                            fit: BoxFit.cover,
                                                            height: 90,
                                                            errorBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                              return Image
                                                                  .asset(
                                                                'assets/images/camion.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                                height: 90,
                                                              );
                                                            },
                                                          ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Text(
                                                    e.nom,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: d_colorGreen),
                                                  ),
                                                ),
                                                _buildItem("Statut:",
                                                    '${e.statut ? 'Disponible' : 'Non disponible'}'),
                                                _buildItem("Localité :",
                                                    e.localisation),
                                                SizedBox(height: 10),
                                                Container(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      _buildEtat(e.statut),
                                                      PopupMenuButton<String>(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        itemBuilder:
                                                            (context) =>
                                                                <PopupMenuEntry<
                                                                    String>>[
                                                          PopupMenuItem<String>(
                                                            child: ListTile(
                                                              leading:
                                                                  const Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              title: const Text(
                                                                "Activer",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              onTap: () async {
                                                                await MaterielService()
                                                                    .activerMateriel(type
                                                                        .idTypeMateriel!)
                                                                    .then(
                                                                        (value) =>
                                                                            {
                                                                              Provider.of<MaterielService>(context, listen: false).applyChange(),
                                                                              setState(() {
                                                                                futureListe = getListe(type.idTypeMateriel!);
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
                                                                        .orange[
                                                                    400],
                                                              ),
                                                              title: Text(
                                                                "Désactiver",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .orange[
                                                                      400],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              onTap: () async {
                                                                await MaterielService()
                                                                    .desactiverMateriel(type
                                                                        .idTypeMateriel!)
                                                                    .then(
                                                                        (value) =>
                                                                            {
                                                                              Provider.of<MaterielService>(context, listen: false).applyChange(),
                                                                              setState(() {
                                                                                futureListe = getListe(type.idTypeMateriel!);
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

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content:
                                                                        Row(
                                                                      children: [
                                                                        Text(
                                                                            "Désactiver avec succèss "),
                                                                      ],
                                                                    ),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            2),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          PopupMenuItem<String>(
                                                            child: ListTile(
                                                              leading:
                                                                  const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              title: const Text(
                                                                "Supprimer",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              onTap: () async {
                                                                await MaterielService()
                                                                    .deleteMateriel(type
                                                                        .idTypeMateriel!)
                                                                    .then(
                                                                        (value) =>
                                                                            {
                                                                              Provider.of<MaterielService>(context, listen: false).applyChange(),
                                                                              // setState(
                                                                              //     () {
                                                                              //   futureListe =
                                                                              //       getListe(type.idTypeMateriel!);
                                                                              // }),
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
                                        )))
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

  Widget _buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                overflow: TextOverflow.ellipsis,
                fontSize: 18),
          ),
          Text(
            value,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis,
                fontSize: 16),
          )
        ],
      ),
    );
  }
}
