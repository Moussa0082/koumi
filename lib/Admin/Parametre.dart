import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/Admin/ContinentPage.dart';
import 'package:koumi_app/Admin/Niveau1Page.dart';
import 'package:koumi_app/Admin/Niveau2Page.dart';
import 'package:koumi_app/Admin/Niveau3Page.dart';
import 'package:koumi_app/Admin/PaysPage.dart';
import 'package:koumi_app/Admin/ProfilA.dart';
import 'package:koumi_app/Admin/SousRegionPage.dart';
import 'package:koumi_app/Admin/UnitePage.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/screens/TypeVehicule.dart';
import 'package:provider/provider.dart';

class Parametre extends StatefulWidget {
  const Parametre({super.key});

  @override
  State<Parametre> createState() => _ParametreState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _ParametreState extends State<Parametre> {
  late ParametreGeneraux params;
  List<ParametreGeneraux> paramList = [];

  @override
  void initState() {
    super.initState();

    paramList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;
    params = paramList[0];
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
              // Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
        title: const Text(
          "Paramètre Système",
          style: TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
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
                child: ListTile(
                  leading:
                      params.logoSysteme == null || params.logoSysteme!.isEmpty
                          ? SizedBox(
                              width: 110,
                              height: 150,
                              child: Image.asset(
                                "assets/images/logo.png",
                                scale: 1,
                                fit: BoxFit.fill,
                              ),
                            )
                          : SizedBox(
                              width: 110,
                              height: 150,
                              child: Image.network(
                                "http://10.0.2.2/api-koumi/${params.logoSysteme!}",
                                scale: 1,
                                fit: BoxFit.fill,
                              ),
                            ),
                  title: Text(
                    params.nomSysteme,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    params.sloganSysteme,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 17,
                      // overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
          Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
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
                    getList(
                        "continent.png",
                        'Continent',
                        const ContinentPage(),
                        const Icon(
                          Icons.chevron_right_sharp,
                          size: 30,
                        )),
                    const Divider(
                      color: Colors.grey,
                      height: 4,
                      thickness: 1,
                      indent: 50,
                      endIndent: 0,
                    ),
                    getList(
                        "sous.png",
                        'Sous région',
                        const SousRegionPage(),
                        const Icon(
                          Icons.chevron_right_sharp,
                          size: 30,
                        )),
                    const Divider(
                      color: Colors.grey,
                      height: 4,
                      thickness: 1,
                      indent: 50,
                      endIndent: 0,
                    ),
                    getList(
                        "pays.png",
                        'Pays',
                        const PaysPage(),
                        const Icon(
                          Icons.chevron_right_sharp,
                          size: 30,
                        )),
                    const Divider(
                      color: Colors.grey,
                      height: 4,
                      thickness: 1,
                      indent: 50,
                      endIndent: 0,
                    ),
                    getList(
                        "region.png",
                        params.libelleNiveau1Pays,
                        const Niveau1Page(),
                        const Icon(
                          Icons.chevron_right_sharp,
                          size: 30,
                        )),
                    const Divider(
                      color: Colors.grey,
                      height: 4,
                      thickness: 1,
                      indent: 50,
                      endIndent: 0,
                    ),
                    getList(
                        "region.png",
                        params.libelleNiveau2Pays,
                        const Niveau2Page(),
                        const Icon(
                          Icons.chevron_right_sharp,
                          size: 30,
                        )),
                    const Divider(
                      color: Colors.grey,
                      height: 4,
                      thickness: 1,
                      indent: 50,
                      endIndent: 0,
                    ),
                    getList(
                        "region.png",
                        params.libelleNiveau3Pays,
                        const Niveau3Page(),
                        const Icon(
                          Icons.chevron_right_sharp,
                          size: 30,
                        )),
                    const Divider(
                      color: Colors.grey,
                      height: 4,
                      thickness: 1,
                      indent: 50,
                      endIndent: 0,
                    ),
                    getList(
                        "unite.png",
                        'Unite de mesure',
                        const UnitePage(),
                        const Icon(
                          Icons.chevron_right_sharp,
                          size: 30,
                        )),
                    const Divider(
                      color: Colors.grey,
                      height: 4,
                      thickness: 1,
                      indent: 50,
                      endIndent: 0,
                    ),
                    getList(
                        "car.png",
                        'Type de véhicule',
                        const TypeVehicule(),
                        const Icon(
                          Icons.chevron_right_sharp,
                          size: 30,
                        )),
                  ],
                ),
              )),
          // Padding(
          //     padding: EdgeInsets.symmetric(
          //       vertical: MediaQuery.of(context).size.height * 0.02,
          //       horizontal: MediaQuery.of(context).size.width * 0.05,
          //     ),
          //     child: Container(
          //       width: MediaQuery.of(context).size.width * 0.9,
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(15),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.grey.withOpacity(0.2),
          //             offset: const Offset(0, 2),
          //             blurRadius: 5,
          //             spreadRadius: 2,
          //           ),
          //         ],
          //       ),
          //       child: Column(
          //         children: [
          //           getList(
          //               "settings.png",
          //               'Paramètre fiche donnée',
          //               const ParametreFichePage(),
          //               const Icon(
          //                 Icons.chevron_right_sharp,
          //                 size: 30,
          //               )),
          //           const Divider(
          //             color: Colors.grey,
          //             height: 4,
          //             thickness: 1,
          //             indent: 50,
          //             endIndent: 0,
          //           ),
          //           getList(
          //              "settings.png",
          //               'Paramètre regroupée',
          //               const ParametreRegroupePage(),
          //               const Icon(
          //                 Icons.chevron_right_sharp,
          //                 size: 30,
          //               )),
          //           const Divider(
          //             color: Colors.grey,
          //             height: 4,
          //             thickness: 1,
          //             indent: 50,
          //             endIndent: 0,
          //           ),
          //           getList(
          //               "settings.png",
          //               'Renvoie donnée',
          //               const ParametreRenvoiePage(),
          //               const Icon(
          //                 Icons.chevron_right_sharp,
          //                 size: 30,
          //               )),
          //         ],
          //       ),
          //     ))
        ]),
      ),
    );
  }

  Widget getList(String imgLocation, String text, Widget page, Icon icon2) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.07,
                  child: Image.asset(
                    "assets/images/$imgLocation",
                    fit: BoxFit
                        .cover, // You can adjust the BoxFit based on your needs
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            icon2
          ],
        ),
      ),
    );
  }
}
