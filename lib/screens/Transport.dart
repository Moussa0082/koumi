import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/models/Vehicule.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/DetailTransport.dart';
import 'package:koumi_app/screens/PageTransporteur.dart';
import 'package:koumi_app/screens/VehiculesActeur.dart';
import 'package:koumi_app/service/VehiculeService.dart';
import 'package:provider/provider.dart';

class Transport extends StatefulWidget {
  const Transport({super.key});

  @override
  State<Transport> createState() => _TransportState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _TransportState extends State<Transport> {
  late Acteur acteur;
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late TextEditingController _searchController;
  List<Vehicule> vehiculeListe = [];
  @override
  void initState() {
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    typeActeurData = acteur.typeActeur;
    type = typeActeurData.map((data) => data.libelle).join(', ');
    _searchController = TextEditingController();

    super.initState();
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
          title: Text(
            'Véhicule de transport',
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
          actions: [
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              itemBuilder: (context) {
                print("Type: $type");
                return type.toLowerCase() == 'admin' ||
                        type.toLowerCase() == 'transporteurs' ||
                        type.toLowerCase() == 'transporteur'
                    ? <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          child: ListTile(
                            leading: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.green,
                            ),
                            title: const Text(
                              "Mes véhicule",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VehiculeActeur()));
                            },
                          ),
                        ),
                      ]
                    : <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          child: ListTile(
                            leading: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.green,
                            ),
                            title: const Text(
                              "Voir les transporteurs",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PageTransporteur()));
                            },
                          ),
                        ),
                      ];
              },
            )
          ]),
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
          Consumer<VehiculeService>(builder: (context, vehiculeService, child) {
            return FutureBuilder(
                future: vehiculeService.fetchVehicule(),
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
                      child: Center(child: Text("Aucun donné trouvé")),
                    );
                  } else {
                    vehiculeListe = snapshot.data!;
                    String searchText = "";
                    List<Vehicule> filtereSearch =
                        vehiculeListe.where((search) {
                      String libelle = search.nomVehicule.toLowerCase();
                      searchText = _searchController.text.toLowerCase();
                      return libelle.contains(searchText);
                    }).toList();
                    return Wrap(
                      // spacing: 10, // Espacement horizontal entre les conteneurs
                      // runSpacing:
                      //     10, // Espacement vertical entre les lignes de conteneurs
                      children: filtereSearch
                          .where((element) => element.statutVehicule == true)
                          .map((e) => Padding(
                                padding: EdgeInsets.all(10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailTransport(
                                                      vehicule: e)));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
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
                                                BorderRadius.circular(8.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: e.photoVehicule == null
                                                  ? Image.asset(
                                                      "assets/images/camion.png",
                                                      fit: BoxFit.cover,
                                                      height: 90,
                                                    )
                                                  : Image.network(
                                                      "http://10.0.2.2/${e.photoVehicule}",
                                                      fit: BoxFit.cover,
                                                      height: 90,
                                                      errorBuilder:
                                                          (BuildContext context,
                                                              Object exception,
                                                              StackTrace?
                                                                  stackTrace) {
                                                        return Image.asset(
                                                          'assets/images/camion.png',
                                                          fit: BoxFit.cover,
                                                          height: 90,
                                                        );
                                                      },
                                                    ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Text(
                                              e.nomVehicule,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: d_colorGreen),
                                            ),
                                          ),
                                          _buildItem("Statut:",
                                              '${e.statutVehicule! ? 'Disponible' : 'Non disponible'}'),
                                          _buildItem(
                                              "Localité :", e.localisation),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  }
                });
          })
        ]),
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
