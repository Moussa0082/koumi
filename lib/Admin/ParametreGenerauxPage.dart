import 'package:flutter/material.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/service/ParametreGenerauxService.dart';
import 'package:provider/provider.dart';

class ParametreGenerauxPage extends StatefulWidget {
  const ParametreGenerauxPage({Key? key}) : super(key: key);

  @override
  State<ParametreGenerauxPage> createState() => _ParametreGenerauxPageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _ParametreGenerauxPageState extends State<ParametreGenerauxPage> {
  List<ParametreGeneraux> paramList = [];
  TextEditingController sigleStructureController = TextEditingController();
  TextEditingController nomStructureController = TextEditingController();
  TextEditingController sigleSystemeController = TextEditingController();
  TextEditingController nomSystemeController = TextEditingController();
  TextEditingController descriptionSystemeController = TextEditingController();
  TextEditingController sloganSystemeController = TextEditingController();
  TextEditingController adresseStructureController = TextEditingController();
  TextEditingController emailStructureController = TextEditingController();
  TextEditingController telephoneStructureController = TextEditingController();
  TextEditingController whattsAppStructureController = TextEditingController();
  TextEditingController libelleNiveau1PaysController = TextEditingController();
  TextEditingController libelleNiveau2PaysController = TextEditingController();
  TextEditingController libelleNiveau3PaysController = TextEditingController();
  TextEditingController localiteStructureController = TextEditingController();
  bool isEditing = false;
  late ParametreGeneraux param;

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing; // Inverse l'état d'édition
    });
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
          icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen),
        ),
        title: const Text(
          "Parametre généraux",
          style: TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isEditing
                ? IconButton(
                    onPressed: () async {
                      setState(() {
                        isEditing = false; 
                      });
                      await ParametreGenerauxService()
                          .updateParametre(
                              idParametreGeneraux: param.idParametreGeneraux!,
                              sigleStructure: param.sigleStructure,
                              nomStructure: param.nomStructure,
                              sigleSysteme: param.sigleSysteme,
                              nomSysteme: param.nomSysteme,
                              descriptionSysteme: param.descriptionSysteme,
                              sloganSysteme: param.sloganSysteme,
                              adresseStructure: param.adresseStructure,
                              emailStructure: param.emailStructure,
                              telephoneStructure: param.telephoneStructure,
                              whattsAppStructure: param.whattsAppStructure,
                              libelleNiveau1Pays: param.libelleNiveau1Pays,
                              libelleNiveau2Pays: param.libelleNiveau2Pays,
                              libelleNiveau3Pays: param.libelleNiveau3Pays,
                              localiteStructure: param.localiteStructure)
                          .then((value) => 
                          {
                            print("Modifier avec succèss"),
                            Provider.of<ParametreGenerauxService>(context,
                                        listen: false)
                                    .applyChange(),
                            })
                          .catchError((onError) => {print(onError.toString())});
                    },
                    icon: const Icon(Icons.save),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true; // Activer le mode édition
                      });
                    },
                    icon: const Icon(Icons.edit),
                  ),
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
                      param = paramList[0];

                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                            child: Container(
                              height: isEditing ? 250 : 200,
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
                                  ListTile(
                                    leading: param.logoSysteme!.isEmpty ||
                                            param.logoSysteme == null
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
                                              "http://10.0.2.2/${param.logoSysteme!}",
                                              scale: 1,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                    title: isEditing
                                        ? TextFormField(
                                            initialValue: param.nomSysteme,
                                            // controller:sigleStructureController,
                                            onChanged: (value) {
                                              param.nomSysteme = value;
                                            })
                                        : Text(
                                            param.nomSysteme,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    subtitle: isEditing
                                        ? TextFormField(
                                            initialValue: param.sloganSysteme,
                                            onChanged: (value) {
                                              param.sloganSysteme = value;
                                            },
                                          )
                                        : Text(
                                            param.sloganSysteme,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Divider(
                                      height: 2,
                                      color: d_colorGreen,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  isEditing
                                      ? TextFormField(
                                          initialValue:
                                              param.descriptionSysteme,
                                          onChanged: (value) {
                                            param.descriptionSysteme = value;
                                          },
                                          // controller:
                                          //     descriptionSystemeController,
                                        )
                                      : Text(
                                          param.descriptionSysteme,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height * 0.01,
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.05),
                              child: Container(
                                height: isEditing ? 150 : 110,
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
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Expanded(
                                          child: Text("Nom structure",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                              )),
                                        ),
                                        isEditing
                                            ? Expanded(
                                                child: TextFormField(
                                                  initialValue:
                                                      param.nomStructure,
                                                  onChanged: (value) {
                                                    param.nomStructure = value;
                                                  },
                                                  // controller:
                                                  //     nomStructureController
                                                ),
                                              )
                                            : Text(param.nomStructure,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ))
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Divider(
                                      height: 2,
                                      color: d_colorGreen,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Expanded(
                                          child: Text("Sigle Structure",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                              )),
                                        ),
                                        isEditing
                                            ? Expanded(
                                                child: TextFormField(
                                                  initialValue:
                                                      param.sigleStructure,
                                                  onChanged: (value) {
                                                    param.sigleStructure =
                                                        value;
                                                  },
                                                  // controller:
                                                  //     sigleStructureController,
                                                ),
                                              )
                                            : Text(param.sigleStructure,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ))
                                      ],
                                    ),
                                  )
                                ]),
                              )),
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Autre information"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Container(
                              height: isEditing ? 560 : 400,
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Expanded(
                                          child: Text("Adresse",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                              )),
                                        ),
                                        isEditing
                                            ? Expanded(
                                                child: TextFormField(
                                                  initialValue:
                                                      param.adresseStructure,
                                                  onChanged: (value) {
                                                    param.adresseStructure =
                                                        value;
                                                  },
                                                  // controller:
                                                  //     adresseStructureController,
                                                ),
                                              )
                                            : Text(param.adresseStructure,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ))
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Divider(
                                      height: 1,
                                      color: d_colorGreen,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Expanded(
                                          child: Text("Téléphone",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                              )),
                                        ),
                                        isEditing
                                            ? Expanded(
                                                child: TextFormField(
                                                  initialValue:
                                                      param.telephoneStructure,
                                                  onChanged: (value) {
                                                    param.telephoneStructure =
                                                        value;
                                                  },
                                                  // controller:
                                                  //     telephoneStructureController,
                                                ),
                                              )
                                            : Text(param.telephoneStructure,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ))
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Divider(
                                      height: 1,
                                      color: d_colorGreen,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Expanded(
                                          child: Text("WathsApp",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                              )),
                                        ),
                                        isEditing
                                            ? Expanded(
                                                child: TextFormField(
                                                  initialValue:
                                                      param.whattsAppStructure,
                                                  onChanged: (value) {
                                                    param.whattsAppStructure =
                                                        value;
                                                  },
                                                  // controller:
                                                  //     whattsAppStructureController,
                                                ),
                                              )
                                            : Text(param.whattsAppStructure,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ))
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Divider(
                                      height: 1,
                                      color: d_colorGreen,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Expanded(
                                          child: Text("Localité",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                              )),
                                        ),
                                        isEditing
                                            ? Expanded(
                                                child: TextFormField(
                                                  initialValue:
                                                      param.localiteStructure,
                                                  onChanged: (value) {
                                                    param.localiteStructure =
                                                        value;
                                                  },
                                                  // controller:
                                                  //     localiteStructureController,
                                                ),
                                              )
                                            : Text(param.localiteStructure,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ))
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Divider(
                                      height: 1,
                                      color: d_colorGreen,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Expanded(
                                          child: Text("Niveau 1",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                              )),
                                        ),
                                        isEditing
                                            ? Expanded(
                                                child: TextFormField(
                                                  initialValue:
                                                      param.libelleNiveau1Pays,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      param.libelleNiveau1Pays =
                                                          value;
                                                    });
                                                  },
                                                  // controller:
                                                  //     libelleNiveau1PaysController
                                                ),
                                              )
                                            : Text(param.libelleNiveau1Pays,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ))
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Divider(
                                      height: 1,
                                      color: d_colorGreen,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Expanded(
                                          child: Text("Niveau 2",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                              )),
                                        ),
                                        isEditing
                                            ? Expanded(
                                                child: TextFormField(
                                                  initialValue:
                                                      param.libelleNiveau2Pays,
                                                  onChanged: (value) {
                                                    param.libelleNiveau2Pays =
                                                        value;
                                                  },
                                                  // controller:
                                                  //     libelleNiveau2PaysController
                                                ),
                                              )
                                            : Text(param.libelleNiveau2Pays,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ))
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Divider(
                                      height: 1,
                                      color: d_colorGreen,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Expanded(
                                          child: Text("Niveau 3",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                              )),
                                        ),
                                        isEditing
                                            ? Expanded(
                                                child: TextFormField(
                                                  initialValue:
                                                      param.libelleNiveau1Pays,
                                                  onChanged: (value) {
                                                    param.libelleNiveau3Pays =
                                                        value;
                                                  },
                                                  // controller:
                                                  //     libelleNiveau3PaysController
                                                ),
                                              )
                                            : Text(param.libelleNiveau3Pays,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfil(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                overflow: TextOverflow.ellipsis),
          ),
          Text(
            value,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
