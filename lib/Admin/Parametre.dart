import 'package:flutter/material.dart';
import 'package:koumi_app/Admin/ContinentPage.dart';
import 'package:koumi_app/Admin/PaysPage.dart';
import 'package:koumi_app/Admin/UnitePage.dart';
import 'package:koumi_app/Admin/Zone.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/service/ParametreGenerauxService.dart';
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

    // params = Provider.of<ParametreGProvider>(context, listen: false).param!;
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
          "Parametre Système",
          style: TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Consumer<ParametreGenerauxService>(
              builder: (context, paramService, child) {
            return FutureBuilder(
                future: paramService.fetchParametre(),
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
                      child: Text("Une erreur s'est produite"),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Aucun donnée trouvé"),
                    );
                  } else {
                    paramList = snapshot.data!;
                    params = paramList[0];
                    return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.02,
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: Container(
                          height: 110,
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
                            leading: params.logoSysteme!.isEmpty ||
                                    params.logoSysteme == null
                                ? SizedBox(
                                    width: 110,
                                    height: 150,
                                    child: Image.asset(
                                      "assets/images/type.png",
                                      scale: 1,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : SizedBox(
                                    width: 110,
                                    height: 150,
                                    child: Image.network(
                                      "http://10.0.2.2/${params.logoSysteme!}",
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
                              style: const TextStyle(
                                fontSize: 17,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ));
                  }
                });
          }),
          Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Container(
                height: 225,
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
                        "pays.png",
                        'Pays',
                         const Zone(),
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
                        "zone.png",
                        'Zone de production',
                        const Zone(),
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
                        'Unite de mésure',
                        const UnitePage(),
                        const Icon(
                          Icons.chevron_right_sharp,
                          size: 30,
                        )),
                  ],
                ),
              ))
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
  // Widget getList(Icon icon1, String text, Widget page, Icon icon2) {
  //   return ListTile(
  //     // isThreeLine: true,
  //     leading: icon1,
  //     title: TextButton(
  //       onPressed: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) =>
  //                   page),
  //                             );
  //       },
  //       child: Text(text),
  //     ),
  //     trailing: icon2,
  //   );
  // }
}
