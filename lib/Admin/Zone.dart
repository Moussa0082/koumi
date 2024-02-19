import 'package:flutter/material.dart';
import 'package:koumi_app/Admin/AddZone.dart';
import 'package:koumi_app/Admin/UpdateZone.dart';
import 'package:koumi_app/models/ZoneProduction.dart';
import 'package:koumi_app/service/ZoneProductionService.dart';
import 'package:provider/provider.dart';

class Zone extends StatefulWidget {
  const Zone({super.key});

  @override
  State<Zone> createState() => _ZoneState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _ZoneState extends State<Zone> {
  late List<ZoneProduction> zoneList = [];
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
          "Zone de production",
          style: TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddZone()));
              },
              icon: const Icon(
                Icons.add_circle,
                color: d_colorGreen,
                size: 25,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Consumer<ZoneProductionService>(
              builder: (context, zoneService, child) {
            return FutureBuilder(
                future: zoneService.fetchZone(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(child: Text("Une erreur s'est produite")),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(child: Text("Aucun zone trouvé")),
                    );
                  } else {
                    zoneList = snapshot.data!;
                    return Column(
                        children: zoneList
                            .map((ZoneProduction zone) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Card(
                                    elevation: 5,
                                    shadowColor: Colors.black,
                                    color: Colors.white,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height: 305,
                                      child: Column(children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: zone.photoZone == null ||
                                                  zone.photoZone!.isEmpty
                                              ? Image.asset(
                                                  "assets/images/zoneProd.jpg",
                                                  fit: BoxFit.fitWidth,
                                                  height: 150,
                                                  width: double.infinity,
                                                )
                                              : Image.network(
                                                  "http://10.0.2.2/${zone.photoZone!}",
                                                  fit: BoxFit.fitWidth,
                                                  height: 150,
                                                  width: double.infinity,
                                                ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Zone de production",
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                              Text(zone.nomZoneProduction,
                                                  style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      overflow: TextOverflow
                                                          .ellipsis))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Date d'ajout",
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                              Text(
                                                zone.dateAjout!,
                                                style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.italic,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _buildEtat(zone.statutZone),
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
                                                          await ZoneProductionService()
                                                              .activerZone(zone
                                                                  .idZoneProduction!)
                                                              .then((value) => {
                                                                    Provider.of<ZoneProductionService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .applyChange(),
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        content:
                                                                            Row(
                                                                          children: [
                                                                            Text("Activer avec succèss "),
                                                                          ],
                                                                        ),
                                                                        duration:
                                                                            Duration(seconds: 2),
                                                                      ),
                                                                    )
                                                                  })
                                                              .catchError(
                                                                  (onError) => {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Row(
                                                                              children: [
                                                                                Text("Une erreur s'est produit : $onError"),
                                                                              ],
                                                                            ),
                                                                            duration:
                                                                                const Duration(seconds: 5),
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
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          await ZoneProductionService()
                                                              .desactiverZone(zone
                                                                  .idZoneProduction!)
                                                              .then((value) => {
                                                                    Provider.of<ZoneProductionService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .applyChange(),
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                  })
                                                              .catchError(
                                                                  (onError) => {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Row(
                                                                              children: [
                                                                                Text("Une erreur s'est produit : $onError"),
                                                                              ],
                                                                            ),
                                                                            duration:
                                                                                const Duration(seconds: 5),
                                                                          ),
                                                                        ),
                                                                        Navigator.of(context)
                                                                            .pop(),
                                                                      });

                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Row(
                                                                children: [
                                                                  Text(
                                                                      " Desactiver avec succèss "),
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
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      UpdateZone(
                                                                          zone:
                                                                              zone)));
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
                                                          await ZoneProductionService()
                                                              .deleteZone(zone
                                                                  .idZoneProduction!)
                                                              .then((value) => {
                                                                    Provider.of<ZoneProductionService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .applyChange(),
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                  })
                                                              .catchError(
                                                                  (onError) => {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          const SnackBar(
                                                                            content:
                                                                                Row(
                                                                              children: [
                                                                                Text("Ce type d'acteur est déjà associer à un acteur"),
                                                                              ],
                                                                            ),
                                                                            duration:
                                                                                Duration(seconds: 2),
                                                                          ),
                                                                        )
                                                                      });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ))
                                      ]),
                                    ),
                                  ),
                                ))
                            .toList());
                  }
                });
          })
        ]),
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
