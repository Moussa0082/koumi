import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/Admin/ParametreGenerauxPage.dart';
import 'package:koumi_app/Admin/Zone.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/models/TypeVoiture.dart';
import 'package:koumi_app/models/ZoneProduction.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/screens/Surface.dart';
import 'package:koumi_app/screens/VehiculesActeur.dart';
import 'package:koumi_app/service/ZoneProductionService.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);
const d_colorPage = Color.fromRGBO(255, 255, 255, 1);

class _ProfilState extends State<Profil> {
  late Acteur acteur;
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late List<ZoneProduction> zoneList = [];
  late List<TypeVoiture> typeList = [];

  @override
  void initState() {
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    typeActeurData = acteur.typeActeur!;
    type = typeActeurData.map((data) => data.libelle).join(', ');
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
              onPressed: () {},
              icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
          title: const Text(
            "Mon Profil",
            style: TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Column(
                  children: [
                    Consumer<ActeurProvider>(
                      builder: (context, acteurProvider, child) {
                        final ac = acteurProvider.acteur;
                        // debugPrint("appBar ${ac.toString()}");
                        if (ac == null) {
                          return const CircularProgressIndicator();
                        }

                        List<TypeActeur> typeActeurData = ac.typeActeur!;
                        String type = typeActeurData
                            .map((data) => data.libelle)
                            .join(', ');
                        return Column(
                          children: [
                            ListTile(
                                leading: ac.logoActeur == null ||
                                        ac.logoActeur!.isEmpty
                                    ? ProfilePhoto(
                                        totalWidth: 50,
                                        cornerRadius: 50,
                                        color: Colors.black,
                                        image: const AssetImage(
                                            'assets/images/profil.jpg'),
                                      )
                                    : ProfilePhoto(
                                        totalWidth: 50,
                                        cornerRadius: 50,
                                        color: Colors.black,
                                        image: NetworkImage(
                                            "http:10.0.2.2/${ac.logoActeur}"),
                                      ),
                                title: Text(
                                  ac.nomActeur!.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800),
                                ),
                                subtitle: Text(
                                  type,
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    offset: const Offset(0, 2),
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildProfile('Email', ac.emailActeur!),
                                    _buildProfile(
                                        'Téléphone', ac.telephoneActeur!),
                                    _buildProfile(
                                        'WhatsApp', ac.whatsAppActeur ?? ''),
                                    _buildProfile('Adresse', ac.adresseActeur!),
                                    _buildProfile(
                                        'Localité', ac.localiteActeur!),
                                    _buildProfile(
                                        'Pays', ac.niveau3PaysActeur!),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                        child: Row(children: [
                          const Icon(Icons.align_horizontal_left_outlined,
                              color: d_colorGreen, size: 25),
                          const SizedBox(
                            width: 15,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ParametreGenerauxPage()));
                              },
                              child: type.toLowerCase() == 'admin'
                                  ? Text(
                                      "Parametre Généraux",
                                      style: TextStyle(
                                          fontSize: 17, color: d_colorGreen),
                                    )
                                  : Text(
                                      "Information sur la structure",
                                      style: TextStyle(
                                          fontSize: 17, color: d_colorGreen),
                                    ))
                        ]),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset("assets/images/settings.png",
                            width: 50, height: 50),
                      )
                    ],
                  ),
                ),
              ),
              type.toLowerCase() == 'producteur'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 15),
                              child: Column(
                                children: [
                                  Row(children: [
                                    const Icon(
                                        Icons.align_horizontal_left_outlined,
                                        color: d_colorGreen,
                                        size: 25),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Zone()));
                                        },
                                        child: Text(
                                          "Mes zones de production",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: d_colorGreen),
                                        ))
                                  ]),
                                  Consumer<ZoneProductionService>(
                                      builder: (context, zoneService, child) {
                                    return FutureBuilder(
                                        future: zoneService.fetchZoneByActeur(
                                            acteur.idActeur!),
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
                                                  child: Text(
                                                      "Aucun zone trouvé")),
                                            );
                                          } else {
                                            zoneList = snapshot.data!;
                                            return Wrap(
                                                spacing: 10,
                                                children: zoneList
                                                    .map(
                                                      (e) => Text(
                                                          "${e.nomZoneProduction} ,",
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis)),
                                                    )
                                                    .toList());
                                          }
                                        });
                                  })
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Image.asset("assets/images/zone.png",
                                  width: 50, height: 50),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
              type.toLowerCase() == 'producteur'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 15),
                              child: Column(
                                children: [
                                  Row(children: [
                                    const Icon(
                                        Icons.align_horizontal_left_outlined,
                                        color: d_colorGreen,
                                        size: 25),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Surface()));
                                        },
                                        child: Text(
                                          "Surface cultiver",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: d_colorGreen),
                                        ))
                                  ]),
                                  // Consumer<ZoneProductionService>(
                                  //     builder: (context, zoneService, child) {
                                  //   return FutureBuilder(
                                  //       future: zoneService.fetchZoneByActeur(
                                  //           acteur.idActeur!),
                                  //       builder: (context, snapshot) {
                                  //         if (snapshot.connectionState ==
                                  //             ConnectionState.waiting) {
                                  //           return const Center(
                                  //             child: CircularProgressIndicator(
                                  //               color: Colors.orange,
                                  //             ),
                                  //           );
                                  //         }

                                  //         if (!snapshot.hasData) {
                                  //           return const Padding(
                                  //             padding: EdgeInsets.all(10),
                                  //             child: Center(
                                  //                 child: Text(
                                  //                     "Aucun zone trouvé")),
                                  //           );
                                  //         } else {
                                  //           zoneList = snapshot.data!;
                                  //           return Column(
                                  //               children: zoneList
                                  //                   .map(
                                  //                       (ZoneProduction zone) =>
                                  //                           Column(children: [
                                  //                             Align(
                                  //                               alignment:
                                  //                                   Alignment
                                  //                                       .topLeft,
                                  //                               child: Text(zone.nomZoneProduction,
                                  //                                   style: const TextStyle(
                                  //                                       color: Colors
                                  //                                           .black87,
                                  //                                       fontSize:
                                  //                                           17,
                                  //                                       fontWeight:
                                  //                                           FontWeight
                                  //                                               .w500,
                                  //                                       fontStyle:
                                  //                                           FontStyle
                                  //                                               .italic,
                                  //                                       overflow:
                                  //                                           TextOverflow.ellipsis)),
                                  //                             )
                                  //                           ]))
                                  //                   .toList());
                                  //         }
                                  //       });
                                  // })
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Image.asset("assets/images/zone.png",
                                  width: 50, height: 50),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
              _buildType(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: ElevatedButton.icon(
                    onPressed: () async {
                      final acteurProvider =
                          Provider.of<ActeurProvider>(context, listen: false);

                      // Déconnexion avec le provider
                      await acteurProvider.logout();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();
                      //                   Navigator.pushReplacement(
                      // context,
                      // MaterialPageRoute(builder: (context) => LoginScreen()),
                      //                        );
                     Get.off(LoginScreen(),
                          duration: Duration(
                              seconds:
                                  1), //duration of transitions, default 1 sec
                          transition: Transition.leftToRight);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 10, // Orange color code
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(290, 45),
                    ),
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.green,
                    ),
                    label: Text(
                      "Déconnexion",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
              )
            ],
          ),
        ));
  }

  Widget _buildProfile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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

  Widget _buildType() {
    return type.toLowerCase() == 'transporteur'
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    child: Column(
                      children: [
                        Row(children: [
                          const Icon(Icons.align_horizontal_left_outlined,
                              color: d_colorGreen, size: 25),
                          const SizedBox(
                            width: 15,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const VehiculeActeur()));
                              },
                              child: Text(
                                "Mes véhicule",
                                style: TextStyle(
                                    fontSize: 17, color: d_colorGreen),
                              ))
                        ]),
                        // Consumer<TypeVoitureService>(
                        //     builder: (context, typeService, child) {
                        //   return FutureBuilder(
                        //       future: typeService
                        //           .fetchTypeVoitureByActeur(acteur.idActeur!),
                        //       builder: (context, snapshot) {
                        //         if (snapshot.connectionState ==
                        //             ConnectionState.waiting) {
                        //           return const Center(
                        //             child: CircularProgressIndicator(
                        //               color: Colors.orange,
                        //             ),
                        //           );
                        //         }

                        //         if (!snapshot.hasData) {
                        //           return const Padding(
                        //             padding: EdgeInsets.all(10),
                        //             child: Center(
                        //                 child: Text(
                        //                     "Aucun type de véhicule trouvé")),
                        //           );
                        //         } else {
                        //           typeList = snapshot.data!;
                        //           return Wrap(
                        //               spacing: 10,
                        //               children: typeList
                        //                   .map(
                        //                     (e) => Text("${e.nom} ,",
                        //                         style: const TextStyle(
                        //                             color: Colors.black87,
                        //                             fontSize: 16,
                        //                             fontWeight: FontWeight.w500,
                        //                             fontStyle: FontStyle.italic,
                        //                             overflow:
                        //                                 TextOverflow.ellipsis)),
                        //                   )
                        //                   .toList());
                        //         }
                        //       });
                        // })
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset("assets/images/car.png",
                        width: 50, height: 50),
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
