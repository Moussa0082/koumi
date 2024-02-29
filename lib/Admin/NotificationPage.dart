import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:koumi_app/Admin/NotificationDetail.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/MessageWa.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/ActeurService.dart';
import 'package:koumi_app/service/MessageService.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _NotificationPageState extends State<NotificationPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late TextEditingController _searchController;
  List<MessageWa> messageList = [];
  List<String> typeLibelle = [];
  late Future<List<MessageWa>> _liste;
  late Acteur acteur;
  late ValueNotifier<bool> isDialOpenNotifier;
  final MultiSelectController _controller = MultiSelectController();

  Future<List<MessageWa>> getMessage(String id) async {
    final response = await MessageService().fetchMessageByActeur(id);
    return response;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    _liste = getMessage(acteur.idActeur!);
    isDialOpenNotifier =
        ValueNotifier<bool>(false); // Initialiser le ValueNotifier
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Disposez le TextEditingController lorsque vous n'en avez plus besoin
    isDialOpenNotifier.dispose(); // Disposez le ValueNotifier
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios, color: d_colorGreen)),
        title: Text(
          "Notifications",
          style: TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                child: ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: Text(
                    "Vider la liste",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    await MessageService()
                        .deleteAllMessages()
                        .then((value) => {
                              Provider.of<MessageService>(context,
                                      listen: false)
                                  .applyChange(),
                              setState(() {
                                _liste = getMessage(acteur.idActeur!);
                              }),
                              Navigator.of(context).pop(),
                            })
                        .catchError((onError) => {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
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
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(10.0),
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
          SizedBox(height: 10),
          Consumer(builder: (context, messageService, child) {
            return FutureBuilder(
                future: _liste,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset('assets/images/notif.jpg'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Aucune notification ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  overflow: TextOverflow.ellipsis,
                                ))
                          ],
                        ),
                      ),
                    );
                  } else {
                    messageList = snapshot.data!;
                    String searchText = "";
                    List<MessageWa> filtereSearch = messageList.where((search) {
                      String libelle = search.text.toLowerCase();
                      searchText = _searchController.text.toLowerCase();
                      return libelle.contains(searchText);
                    }).toList();
                    return Column(
                        children: filtereSearch
                            .map((e) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationDetail(
                                                      messageWa: e)));
                                    },
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(
                                            Icons.notifications_active_rounded,
                                            color: d_colorGreen,
                                            size: 40,
                                          ),
                                          title: Text(e.text,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                          subtitle: Text(e.dateAjout!,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                              )),
                                          trailing: PopupMenuButton<String>(
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context) =>
                                                <PopupMenuEntry<String>>[
                                              PopupMenuItem<String>(
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  title: Text(
                                                    "Supprimer",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    await MessageService()
                                                        .deleteMessage(
                                                            e.idMessage,
                                                            acteur.idActeur!)
                                                        .then((value) => {
                                                              Provider.of<MessageService>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .applyChange(),
                                                              setState(() {
                                                                _liste = getMessage(
                                                                    acteur
                                                                        .idActeur!);
                                                              }),
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                            })
                                                        .catchError(
                                                            (onError) => {
                                                                  print(onError
                                                                      .toString()),
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                              "Impossible de supprimer"),
                                                                        ],
                                                                      ),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              2),
                                                                    ),
                                                                  )
                                                                });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          indent: 70,
                                          height: 1,
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                            .toList());
                  }
                });
          }),
        ]),
      ),
      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.close_menu,
        backgroundColor: d_colorGreen,
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        spacing: 12,
        icon: Icons.add,

        // closeDialOnPop: true,
        children: [
          SpeedDialChild(
            child: Icon(Icons.message),
            label: 'Envoyé message aux acteurs',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            onTap: () {
              _showMessage();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.email),
            label: 'Envoyé email aux acteurs',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            onTap: () {
              _showEmail();
            },
          ),
        ],
        // État du Speed Dial (ouvert ou fermé)
        openCloseDial: isDialOpenNotifier,
        // Fonction appelée lorsque le bouton principal est pressé
        onPress: () {
          isDialOpenNotifier.value =
              !isDialOpenNotifier.value; // Inverser la valeur du ValueNotifier
        },
      ),
    );
  }

  void _showMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text(
                  "Envoyer un message WhatsApp",
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: MultiSelectDropDown.network(
                        networkConfig: NetworkConfig(
                          url: 'https://koumi.ml/api-koumi/typeActeur/read',
                          method: RequestMethod.get,
                          headers: {
                            'Content-Type': 'application/json',
                          },
                        ),
                        chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                        responseParser: (response) {
                          final list = (response as List<dynamic>)
                              .where((data) =>
                                  (data as Map<String, dynamic>)['libelle']
                                      .trim()
                                      .toLowerCase() !=
                                  'admin')
                              .map((e) {
                            final item = e as Map<String, dynamic>;
                            return ValueItem(
                              label: item['libelle'] as String,
                              value: item['idTypeActeur'],
                            );
                          }).toList();
                          return Future.value(list);
                        },
                        controller: _controller,
                        onOptionSelected: (options) {
                          setState(() {
                            typeLibelle.clear();
                            typeLibelle.addAll(options
                                .where((data) =>
                                    data.label.trim().toLowerCase() != 'admin')
                                .map((data) => data.label)
                                .toList());
                            print("type sélectionné ${typeLibelle.toString()}");
                          });
                        },
                        responseErrorBuilder: ((context, body) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Error fetching the data'),
                          );
                        }),
                        // Exemple de personnalisation des styles
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez remplir ce champ";
                          }
                          return null;
                        },
                        controller: descriptionController,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: "message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final String message = descriptionController.text;
                          List<String> type = typeLibelle;
                          if (formkey.currentState!.validate()) {
                            try {
                              await ActeurService()
                                  .sendMessageToActeurByTypeActeur(
                                      message, type)
                                  .then((value) => {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Message envoyé avec success"),
                                            duration: Duration(seconds: 3),
                                          ),
                                        ),
                                        Navigator.of(context).pop()
                                      })
                                  .catchError(
                                      (onError) => {print(onError.toString())});
                            } catch (e) {
                              final String errorMessage = e.toString();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage.isNotEmpty
                                      ? errorMessage
                                      : "Une erreur s'est produite"),
                                  duration: Duration(seconds: 5),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
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
                          "Envoyer",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmail() {
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
                    "Envoyer un message wathsapp",
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
                          labelText: "Nom de la speculation",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // FutureBuilder(
                      //   future: _categorieList,
                      //   builder: (_, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return CircularProgressIndicator();
                      //     }
                      //     if (snapshot.hasError) {
                      //       return Text("${snapshot.error}");
                      //     }
                      //     if (snapshot.hasData) {
                      //       final reponse =
                      //           json.decode((snapshot.data.body)) as List;
                      //       final catList = reponse
                      //           .map((e) => CategorieProduit.fromMap(e))
                      //           .where((con) => con.statutCategorie == true)
                      //           .toList();

                      //       if (catList.isEmpty) {
                      //         return Text(
                      //           'Aucun donné disponible',
                      //           style:
                      //               TextStyle(overflow: TextOverflow.ellipsis),
                      //         );
                      //       }

                      //       return DropdownButtonFormField<String>(
                      //         items: catList
                      //             .map(
                      //               (e) => DropdownMenuItem(
                      //                 value: e.idCategorieProduit,
                      //                 child: Text(e.libelleCategorie),
                      //               ),
                      //             )
                      //             .toList(),
                      //         value: catValue,
                      //         onChanged: (newValue) {
                      //           setState(() {
                      //             catValue = newValue;
                      //             if (newValue != null) {
                      //               categorieProduit = categorieList.firstWhere(
                      //                   (element) =>
                      //                       element.idCategorieProduit ==
                      //                       newValue);

                      //               // typeSelected = true;
                      //             }
                      //           });
                      //         },
                      //         decoration: InputDecoration(
                      //           labelText: 'Sélectionner une categorie',
                      //           border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(8),
                      //           ),
                      //         ),
                      //       );
                      //     }
                      //     return Text(
                      //       'Aucune donnée disponible',
                      //       style: TextStyle(overflow: TextOverflow.ellipsis),
                      //     );
                      //   },
                      // ),
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
                          if (formkey.currentState!.validate()) {
                            try {} catch (e) {
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
                          "Envoyer email",
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
}
