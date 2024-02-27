import 'package:flutter/material.dart';
import 'package:koumi_app/Admin/CodePays.dart';
import 'package:koumi_app/Admin/Niveau1Page.dart';
import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/service/PaysService.dart';
import 'package:provider/provider.dart';

class PaysList extends StatefulWidget {
  const PaysList({super.key});

  @override
  State<PaysList> createState() => _PaysListState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _PaysListState extends State<PaysList> {
  List<Pays> paysList = [];

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
              Icons.add_circle_outline,
              color: d_colorGreen,
              size: 25,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<PaysService>(builder: (context, paysService, child) {
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
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading:
                                            CodePays().getFlag(e.nomPays),
                                        title: Text(e.nomPays.toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        subtitle: Text(e.descriptionPays,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic,
                                            )),
                                      ),
                                      const Divider(
                                        color: Colors.grey,
                                        height: 2,
                                        thickness: 1,
                                        indent: 55,
                                        endIndent: 0,
                                      )
                                    ],
                                  ),
                                ),
                              )
                              .toList());
                    }
                  });
            })
          ],
        ),
      ),
    );
  }

  void _showDialog() {}
}
