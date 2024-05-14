import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/Admin/AddMaterielByType.dart';
import 'package:koumi_app/Admin/DetailMateriel.dart';
import 'package:koumi_app/models/Materiel.dart';
import 'package:koumi_app/models/TypeMateriel.dart';
import 'package:koumi_app/service/MaterielService.dart';
import 'package:provider/provider.dart';

class ListeMaterielByType extends StatefulWidget {
  final TypeMateriel? typeMateriel;
  const ListeMaterielByType({super.key, this.typeMateriel});

  @override
  State<ListeMaterielByType> createState() => _ListeMaterielByTypeState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _ListeMaterielByTypeState extends State<ListeMaterielByType> {
  late TypeMateriel type = TypeMateriel();
  List<Materiel> materielListe = [];
  late Future<List<Materiel>> futureListe;
  bool isExist = false;

  Future<List<Materiel>> getListe(String id) async {
    final response = await MaterielService().fetchMaterielByType(id);
    return response;
  }

  void verifyTypeMateriel() {
    if (widget.typeMateriel != null) {
      type = widget.typeMateriel!;
      setState(() {
        isExist = true;
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

  @override
  void initState() {
    verifyTypeMateriel();
    // futureListe = getListe(type.idTypeMateriel!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 100,
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
                        Navigator.of(context).pop();
                        Get.to(AddMaterielByType(typeMateriel: type), transition: Transition.leftToRightWithFade);
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
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.8,
                                ),
                                itemCount: materielListe.length,
                                itemBuilder: (context, index) {
                                  var e = materielListe.elementAt(index);
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailMateriel(
                                                        materiel: e)));
                                      },
                                      child: Card(
                                          margin: EdgeInsets.all(8),
                                          // decoration: BoxDecoration(
                                          //   color: Color.fromARGB(
                                          //       250, 250, 250, 250),
                                          //   borderRadius:
                                          //       BorderRadius.circular(15),
                                          //   boxShadow: [
                                          //     BoxShadow(
                                          //       color: Colors.grey
                                          //           .withOpacity(0.3),
                                          //       offset: Offset(0, 2),
                                          //       blurRadius: 8,
                                          //       spreadRadius: 2,
                                          //     ),
                                          //   ],
                                          // ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: SizedBox(
                                                    height: 85,
                                                    child: e.photoMateriel ==
                                                            null ||
                                                            e.photoMateriel!
                                                                .isEmpty
                                                        ? Image.asset(
                                                            "assets/images/default_image.png",
                                                            fit: BoxFit.cover,
                                                            height: 72,
                                                          )
                                                        : 
                                                        CachedNetworkImage(
                   width: double.infinity,
                    height: 200,
                    
                                                  imageUrl:
                                                      "https://koumi.ml/api-koumi/Materiel/${e.idMateriel}/image",
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    'assets/images/default_image.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                                        
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                ListTile(
                                                  title: Text(
                                                    e.nom,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  subtitle: Text(
                                                    e.localisation,
                                                    style: TextStyle(
                                                      overflow: TextOverflow.ellipsis,
                                                      fontSize: 15,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                                
                                                 !isExist
                                                    ? Container()
                                                    : Container(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            _buildEtat(
                                                                e.statut!),
                                                            PopupMenuButton<
                                                                String>(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              itemBuilder: (context) =>
                                                                  <PopupMenuEntry<
                                                                      String>>[
                                                                PopupMenuItem<
                                                                    String>(
                                                                  child:
                                                                      ListTile(
                                                                    leading: e.statut ==
                                                                            false
                                                                        ? Icon(
                                                                            Icons.check,
                                                                            color:
                                                                                Colors.green,
                                                                          )
                                                                        : Icon(
                                                                            Icons
                                                                                .disabled_visible,
                                                                            color:
                                                                                Colors.orange[400]),
                                                                    title: Text(
                                                                      e.statut ==
                                                                              false
                                                                          ? "Activer"
                                                                          : "Desactiver",
                                                                      style:
                                                                          TextStyle(
                                                                        color: e.statut ==
                                                                                false
                                                                            ? Colors.green
                                                                            : Colors.orange[400],
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    onTap:
                                                                        () async {
                                                                      e.statut ==
                                                                              false
                                                                          ? await MaterielService()
                                                                              .activerMateriel(e.idMateriel!)
                                                                              .then((value) => {
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
                                                                              .catchError((onError) => {
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
                                                                                  })
                                                                          : await MaterielService()
                                                                              .desactiverMateriel(e.idMateriel!)
                                                                              .then((value) => {
                                                                                    Provider.of<MaterielService>(context, listen: false).applyChange(),
                                                                                    setState(() {
                                                                                      futureListe = getListe(type.idTypeMateriel!);
                                                                                    }),
                                                                                    Navigator.of(context).pop(),
                                                                                  })
                                                                              .catchError((onError) => {
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
                                                                              Text("Désactiver avec succèss "),
                                                                            ],
                                                                          ),
                                                                          duration:
                                                                              Duration(seconds: 2),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                PopupMenuItem<
                                                                    String>(
                                                                  child:
                                                                      ListTile(
                                                                    leading:
                                                                        const Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    title:
                                                                        const Text(
                                                                      "Supprimer",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    onTap:
                                                                        () async {
                                                                      await MaterielService()
                                                                          .deleteMateriel(e
                                                                              .idMateriel!)
                                                                          .then((value) =>
                                                                              {
                                                                                Provider.of<MaterielService>(context, listen: false).applyChange(),
                                                                                // setState(
                                                                                //     () {
                                                                                //   futureListe =
                                                                                //       getListe(type.idTypeMateriel!);
                                                                                // }),
                                                                                Navigator.of(context).pop(),
                                                                              })
                                                                          .catchError((onError) =>
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
                                              ])));
                                },
                              );
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                fontSize: 16),
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
