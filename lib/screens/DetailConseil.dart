import 'package:flutter/material.dart';
import 'package:koumi_app/models/Conseil.dart';

class DetailConseil extends StatefulWidget {
  final Conseil conseil;
  const DetailConseil({super.key, required this.conseil});

  @override
  State<DetailConseil> createState() => _DetailConseilState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _DetailConseilState extends State<DetailConseil> {
  late Conseil conseils;

  @override
  void initState() {
    super.initState();
    conseils = widget.conseil;
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
        title: Text(
          'Détail conseil',
          style:
              const TextStyle(color: d_colorGreen, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: conseils.photoConseil != null &&
                      !conseils.photoConseil!.isEmpty
                  ? Image.network(
                      "http://10.0.2.2/${conseils.photoConseil!}",
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/default_image.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Titre conseil',
                style: const TextStyle(
                    color: d_colorGreen,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                conseils.titreConseil,
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
