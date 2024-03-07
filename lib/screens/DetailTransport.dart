import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/models/Vehicule.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailTransport extends StatefulWidget {
  final Vehicule vehicule;
  const DetailTransport({super.key, required this.vehicule});

  @override
  State<DetailTransport> createState() => _DetailTransportState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _DetailTransportState extends State<DetailTransport> {
  late Vehicule vehicules;
  late Acteur acteur;
  late List<TypeActeur> typeActeurData = [];
  late String type;

  @override
  void initState() {
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    typeActeurData = acteur.typeActeur;
    type = typeActeurData.map((data) => data.libelle).join(', ');
    vehicules = widget.vehicule;
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
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
        title: Text(
          'Transport',
          style:
              const TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: vehicules.photoVehicule != null
                  ? Image.network(
                      "http://10.0.2.2/${vehicules.photoVehicule!}",
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/camion.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
            ),
            SizedBox(height: 30),
            _buildItem('Nom du véhicule : ', vehicules.nomVehicule),
            _buildItem('Capacité : ', vehicules.capaciteVehicule),
            _buildItem('Prix / voyage: ', vehicules.prix.toString()),
            _buildItem('Localisation : ', vehicules.localisation),
            _buildItem('Statut: : ',
                '${vehicules.statutVehicule ? 'Disponible' : 'Non disponible'}'),
            _buildItem('Description : ', vehicules.description),
            type.toLowerCase() == 'admin' ||
                    type.toLowerCase() == 'transporteurs' ||
                    type.toLowerCase() == 'transporteur'
                ? Container()
                : _buildItem('Propriètaire : ', vehicules.acteur.nomActeur),
            ElevatedButton(
                onPressed: () {
                  final String numberPhone = vehicules.acteur.telephoneActeur;
                  if (numberPhone != null) {
                    _makePhoneCall(numberPhone);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Orange color code
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: const Size(290, 45),
                ),
                child: Text(
                  "Contacter",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final String whatsappNumber = vehicules.acteur.whatsAppActeur;
          _openWhatsApp(whatsappNumber);
        },
        child: const Icon(Icons.message),
      ),
    );
  }

  Future<void> _openWhatsApp(String whatsappNumber) async {
    final Uri url = Uri.parse("https://wa.me/$whatsappNumber");
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Impossible de lancer $url';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Widget _buildItem(String title, String value) {
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
}
