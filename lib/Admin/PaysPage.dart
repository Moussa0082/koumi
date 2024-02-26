import 'dart:convert';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koumi_app/Admin/UpdatesPays.dart';
import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/models/SousRegion.dart';
import 'package:koumi_app/service/PaysService.dart';
import 'package:provider/provider.dart';

class PaysPage extends StatefulWidget {
  // final SousRegion sousRegions;
  const PaysPage({super.key});

  @override
  State<PaysPage> createState() => _PaysPageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _PaysPageState extends State<PaysPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late SousRegion sousRegion;
  List<Pays> paysList = [];
  late Future<List<Pays>> _liste;
  bool isLoading = false;
  String? sousValue;
  late Future _sousRegionList;
  late TextEditingController _searchController;

  @override
  void initState() {
        super.initState();

    _sousRegionList =
        http.get(Uri.parse('http://10.0.2.2:9000/api-koumi/sousRegion/read'));
         _searchController = TextEditingController();
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
        title: const Text(
          "Pays",
          style: TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showDialog();
            },
            icon: const Icon(
              Icons.add,
              color: d_colorGreen,
              size: 30,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<PaysService>(
              builder: (context, paysService, child) {
                return FutureBuilder(
                    future: paysService.fetchPays(),
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
                          child: Center(child: Text("Aucun pays trouvé")),
                        );
                      } else {
                        paysList = snapshot.data!;

                        return Column(
                            children: paysList
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      child: Container(
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
                                            ListTile(
                                                leading: getFlag(e.nomPays),
                                                title: Text(
                                                    e.nomPays.toUpperCase(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                                subtitle:
                                                    Text(e.descriptionPays,
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
                                              alignment: Alignment.bottomRight,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  _buildEtat(e.statutPays),
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
                                                            await PaysService()
                                                                .activerPays(
                                                                    e.idPays!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<PaysService>(context, listen: false)
                                                                              .applyChange(),
                                                                          setState(
                                                                              () {
                                                                            _liste =
                                                                                PaysService().fetchPaysBySousRegion(sousRegion.idSousRegion!);
                                                                          }),
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
                                                            await PaysService()
                                                                .desactiverPays(
                                                                    e.idPays!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<PaysService>(context, listen: false)
                                                                              .applyChange(),
                                                                          // setState(() {
                                                                          //   _liste = PaysService().fetchPaysBySousRegion(sousRegion.idSousRegion!);
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
                                                                      content: UpdatesPays(
                                                                          pays:
                                                                              e)),
                                                            );

                                                            // Si les détails sont modifiés, appliquer les changements
                                                            if (updatedSousRegion !=
                                                                null) {
                                                              Provider.of<PaysService>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .applyChange();
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
                                                            await PaysService()
                                                                .deletePays(
                                                                    e.idPays!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<PaysService>(context, listen: false)
                                                                              .applyChange(),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(
                    "Ajouter un pays",
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
                SizedBox(height: 16),
                Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez remplir ce champ";
                          }
                          return null;
                        },
                        controller: libelleController,
                        decoration: InputDecoration(
                          labelText: "Nom du pays",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      FutureBuilder(
                        future: _sousRegionList,
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          if (snapshot.hasData) {
                            final reponse =
                                json.decode((snapshot.data.body)) as List;
                            final sousList = reponse
                                .map((e) => SousRegion.fromMap(e))
                                .where((con) => con.statutSousRegion == true)
                                .toList();
            
                            if (sousList.isEmpty) {
                              return Text(
                                'Aucun sous region disponible',
                                style: TextStyle(overflow: TextOverflow.ellipsis),
                              );
                            }
            
                            return DropdownButtonFormField<String>(
                              items: sousList
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.idSousRegion,
                                      child: Text(e.nomSousRegion),
                                    ),
                                  )
                                  .toList(),
                              value: sousValue,
                              onChanged: (newValue) {
                                setState(() {
                                  sousValue = newValue;
                                  if (newValue != null) {
                                    sousRegion = sousList.firstWhere((element) =>
                                        element.idSousRegion == newValue);
                                    debugPrint(
                                        "con select ${sousRegion.idSousRegion.toString()}");
                                    // typeSelected = true;
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Sélectionner un sous région',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }
                          return Text(
                            'Aucune donnée disponible',
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez remplir ce champ";
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
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final String libelle = libelleController.text;
                          final String description = descriptionController.text;
                          if (formkey.currentState!.validate()) {
                            try {
                              await PaysService()
                                  .addPays(
                                      nomPays: libelle,
                                      descriptionPays: description,
                                      sousRegion: sousRegion)
                                  .then((value) => {
                                        Provider.of<PaysService>(context,
                                                listen: false)
                                            .applyChange(),
                                        Provider.of<PaysService>(context,
                                                listen: false)
                                            .applyChange(),
                                        libelleController.clear(),
                                        descriptionController.clear(),
                                        setState(() {
                                          sousRegion == null;
                                        }),
                                        Navigator.of(context).pop()
                                      });
                            } catch (e) {
                              final String errorMessage = e.toString();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    children: [
                                      Text("Une erreur s'est produit"),
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
                ),
              ],
            ),
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

  Map<String, String> countries = {
    "afghanistan": "AF",
    "albanie": "AL",
    "algérie": "DZ",
    "andorre": "AD",
    "angola": "AO",
    "antigua-et-barbuda": "AG",
    "argentine": "AR",
    "arménie": "AM",
    "australie": "AU",
    "autriche": "AT",
    "azerbaïdjan": "AZ",
    "bahamas": "BS",
    "bahreïn": "BH",
    "bangladesh": "BD",
    "barbade": "BB",
    "biélorussie": "BY",
    "belgique": "BE",
    "belize": "BZ",
    "bénin": "BJ",
    "bhoutan": "BT",
    "bolivie": "BO",
    "bosnie-herzégovine": "BA",
    "botswana": "BW",
    "brésil": "BR",
    "brunei": "BN",
    "bulgarie": "BG",
    "burkina faso": "BF",
    "burundi": "BI",
    "cambodge": "KH",
    "cameroun": "CM",
    "canada": "CA",
    "cap-vert": "CV",
    "république centrafricaine": "CF",
    "tchad": "TD",
    "chili": "CL",
    "chine": "CN",
    "colombie": "CO",
    "comores": "KM",
    "congo (brazzaville)": "CG",
    "congo (kinshasa)": "CD",
    "costa rica": "CR",
    "côte d'ivoire": "CI",
    "croatie": "HR",
    "cuba": "CU",
    "chypre": "CY",
    "république tchèque": "CZ",
    "danemark": "DK",
    "djibouti": "DJ",
    "dominique": "DM",
    "république dominicaine": "DO",
    "équateur": "EC",
    "égypte": "EG",
    "el salvador": "SV",
    "guinée équatoriale": "GQ",
    "érythrée": "ER",
    "estonie": "EE",
    "éthiopie": "ET",
    "fidji": "FJ",
    "finlande": "FI",
    "france": "FR",
    "gabon": "GA",
    "gambie": "GM",
    "géorgie": "GE",
    "allemagne": "DE",
    "ghana": "GH",
    "grèce": "GR",
    "grenade": "GD",
    "guatemala": "GT",
    "guinée": "GN",
    "guinée-bissau": "GW",
    "guyana": "GY",
    "haïti": "HT",
    "honduras": "HN",
    "hongrie": "HU",
    "islande": "IS",
    "inde": "IN",
    "indonésie": "ID",
    "iran": "IR",
    "irak": "IQ",
    "irlande": "IE",
    "israël": "IL",
    "italie": "IT",
    "jamaïque": "JM",
    "japon": "JP",
    "jordanie": "JO",
    "kazakhstan": "KZ",
    "kenya": "KE",
    "kiribati": "KI",
    "corée du nord": "KP",
    "corée du sud": "KR",
    "koweït": "KW",
    "kirghizistan": "KG",
    "laos": "LA",
    "lettonie": "LV",
    "liban": "LB",
    "lesotho": "LS",
    "libéria": "LR",
    "libye": "LY",
    "liechtenstein": "LI",
    "lituanie": "LT",
    "luxembourg": "LU",
    "macédoine": "MK",
    "madagascar": "MG",
    "malawi": "MW",
    "malaisie": "MY",
    "maldives": "MV",
    "mali": "ML",
    "malte": "MT",
    "îles marshall": "MH",
    "mauritanie": "MR",
    "maurice": "MU",
    "mexique": "MX",
    "micronésie": "FM",
    "moldavie": "MD",
    "monaco": "MC",
    "mongolie": "MN",
    "monténégro": "ME",
    "maroc": "MA",
    "mozambique": "MZ",
    "birmanie": "MM",
    "namibie": "NA",
    "nauru": "NR",
    "népal": "NP",
    "pays-bas": "NL",
    "nouvelle-zélande": "NZ",
    "nicaragua": "NI",
    "niger": "NE",
    "nigeria": "NG",
    "niué": "NU",
    "norvège": "NO",
    "oman": "OM",
    "pakistan": "PK",
    "palaos": "PW",
    "palestine": "PS",
    "panama": "PA",
    "papouasie-nouvelle-guinée": "PG",
    "paraguay": "PY",
    "pérou": "PE",
    "philippines": "PH",
    "pologne": "PL",
    "portugal": "PT",
    "qatar": "QA",
    "roumanie": "RO",
    "russie": "RU",
    "rwanda": "RW",
    "saint-kitts-et-nevis": "KN",
    "sainte-lucie": "LC",
    "saint-vincent-et-les-grenadines": "VC",
    "samoa": "WS",
    "saint-marin": "SM",
    "sao tomé-et-principe": "ST",
    "arabie saoudite": "SA",
    "sénégal": "SN",
    "serbie": "RS",
    "seychelles": "SC",
    "sierra leone": "SL",
    "singapour": "SG",
    "slovaquie": "SK",
    "slovénie": "SI",
    "salomon": "SB",
    "somalie": "SO",
    "afrique du sud": "ZA",
    "soudan du sud": "SS",
    "espagne": "ES",
    "sri lanka": "LK",
    "soudan": "SD",
    "suriname": "SR",
    "swaziland": "SZ",
    "suède": "SE",
    "suisse": "CH",
    "syrie": "SY",
    "tadjikistan": "TJ",
    "tanzanie": "TZ",
    "thaïlande": "TH",
    "timor oriental": "TL",
    "togo": "TG",
    "tonga": "TO",
    "trinité-et-tobago": "TT",
    "tunisie": "TN",
    "turquie": "TR",
    "turkménistan": "TM",
    "tuvalu": "TV",
    "ouganda": "UG",
    "ukraine": "UA",
    "émirats arabes unis": "AE",
    "royaume-uni": "GB",
    "états-unis": "US",
    "uruguay": "UY",
    "ouzbékistan": "UZ",
    "vanuatu": "VU",
    "vatican": "VA",
    "vénézuéla": "VE",
    "vietnam": "VN",
    "yémen": "YE",
    "zambie": "ZM",
    "zimbabwe": "ZW",
  };

  Widget getFlag(String pays) {
    String code = '';
    String p = pays.toLowerCase();
    countries.forEach((key, value) {
      if (p == key) {
        // setState(() {

        // });
        code = value;
      }
    });
    return code.isEmpty
        ? Image.asset(
            "assets/images/sous.png",
            width: 50,
            height: 50,
          )
        : CountryFlag.fromCountryCode(
            code,
            height: 48,
            width: 62,
            borderRadius: 8,
          );
  }
}
