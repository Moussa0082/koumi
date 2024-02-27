import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:profile_photo/profile_photo.dart';

class DetailsActeur extends StatefulWidget {
  final Acteur acteur;
  const DetailsActeur({super.key, required this.acteur});

  @override
  State<DetailsActeur> createState() => _DetailsActeurState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _DetailsActeurState extends State<DetailsActeur> {
  late Acteur acteurs;

  @override
  void initState() {
    super.initState();
    acteurs = widget.acteur;
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
          "Détails",
          style: TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: acteurs.logoActeur == null || acteurs.logoActeur!.isEmpty
                    ? ProfilePhoto(
                        totalWidth: 185,
                        cornerRadius: 185,
                        color: Colors.black,
                        image: const AssetImage('assets/images/profil.jpg'),
                      )
                    : ProfilePhoto(
                        totalWidth: 185,
                        cornerRadius: 185,
                        color: Colors.black,
                        image: NetworkImage(
                            "http://10.0.2.2/${acteurs.logoActeur}"),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
