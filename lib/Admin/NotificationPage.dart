import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/Admin/NotificationDetail.dart';
import 'package:koumi_app/models/MessageWa.dart';
import 'package:koumi_app/service/MessageService.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _NotificationPageState extends State<NotificationPage> {
  late TextEditingController _searchController;
  List<MessageWa> messageList = [];
  late Future<List<MessageWa>> _liste;

  Future<List<MessageWa>> getMessage() async {
    final response = await MessageService().fetchMessage();
    return response;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _liste = getMessage();
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Disposez le TextEditingController lorsque vous n'en avez plus besoin
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingDraggableWidget(
      mainScreenWidget: Scaffold(
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 100,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
            title: Text(
              "Notifications",
              style:
                  TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
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
              Consumer(builder: (context, messageService, child) {
                return FutureBuilder(
                    future: _liste,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        );
                      }

                      if (!snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Image.asset('assets/images/notif.jpg'),
                          ),
                        );
                      } else {
                        messageList = snapshot.data!;
                        String searchText = "";
                        List<MessageWa> filtereSearch =
                            messageList.where((search) {
                          String libelle = search.text.toLowerCase();
                          searchText = _searchController.text.toLowerCase();
                          return libelle.contains(searchText);
                        }).toList();
                        return Column(
                            children: filtereSearch
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
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
                                                Icons
                                                    .notifications_active_rounded,
                                                color: d_colorGreen,
                                                size: 40,
                                              ),
                                              title: Text(e.text,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                              subtitle: Text(e.dateAjout!,
                                                  style: const TextStyle(
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
                                                        // await Niveau2Service()
                                                        //     .deleteNiveau2Pays(e
                                                        //         .idNiveau2Pays!)
                                                        //     .then(
                                                        //         (value) => {
                                                        //               Provider.of<Niveau2Service>(context, listen: false)
                                                        //                   .applyChange(),
                                                        //               setState(
                                                        //                   () {
                                                        //                 _liste =
                                                        //                     Niveau2Service().fetchNiveau2ByNiveau1(widget.niveau1pays.idNiveau1Pays!);
                                                        //               }),
                                                        //               Navigator.of(context)
                                                        //                   .pop(),
                                                        //             })
                                                        //     .catchError(
                                                        //         (onError) =>
                                                        //             {
                                                        //               ScaffoldMessenger.of(context)
                                                        //                   .showSnackBar(
                                                        //                 const SnackBar(
                                                        //                   content: Row(
                                                        //                     children: [
                                                        //                       Text("Impossible de supprimer"),
                                                        //                     ],
                                                        //                   ),
                                                        //                   duration: Duration(seconds: 2),
                                                        //                 ),
                                                        //               )
                                                        //             });
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
              })
            ]),
          )), // Replace YourMainScreenWidget() with your actual main screen widget
      floatingWidget: FloatingActionButton(
        backgroundColor: d_colorGreen,
        onPressed: () {
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                child: ListTile(
                  // leading: const Icon(
                  //   Icons.delete,
                  //   color: Colors.red,
                  // ),
                  title: const Text(
                    "Envoyer un message à tous le monde",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {},
                ),
              ),
            ],
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingWidgetHeight: 60,
      floatingWidgetWidth: 60,
      dx: 330,
      dy: 700,
    );
  }
}
