import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MagasinScreen extends StatefulWidget {
  const MagasinScreen({super.key});

  @override
  State<MagasinScreen> createState() => _MagasinScreenState();
}
class _MagasinScreenState extends State<MagasinScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  List<String> regions = [];
  List<String> idNiveau1Pays = [];
   String selectedRegionId = ''; // Ajoutez une variable pour stocker l'ID de la région sélectionnée

  Map<String, List<Map<String, dynamic>>> magasinsParRegion = {};

  List<Map<String, dynamic>> regionsData = [];
  List<String> magasins = [];
  int currentIndex = 0;

  Set<String> loadedRegions = {}; // Ensemble pour garder une trace des régions pour lesquelles les magasins ont déjà été chargés

  void fetchRegions() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9000/niveau1Pays/read'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          regionsData = data.cast<Map<String, dynamic>>();
          regions = regionsData.map((item) => item['nomN1'] as String).toList();
          idNiveau1Pays = regionsData.map((item) => item['idNiveau1Pays'] as String).toList();
        });
        _tabController = TabController(length: regions.length, vsync: this);
        _tabController!.addListener(_handleTabChange);
        // Fetch les magasins pour la première région
        fetchMagasinsByRegion(idNiveau1Pays.isNotEmpty ? idNiveau1Pays[_tabController!.index] : '');
      } else {
        throw Exception('Failed to load regions');
      }
    } catch (e) {
      print('Error fetching regions: $e');
    }
  }

  void fetchMagasinsByRegion(String id) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9000/Magasin/getAllMagasinByPays/${id}'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          magasinsParRegion[id] = data.map((item) => {
            'nomMagasin': item['nomMagasin'],
            'photo': item['photo'],
          }).toList();
        });
        // Si les magasins pour cette région n'ont pas déjà été chargés, ajoutez l'ID de la région à loadedRegions
        if (!loadedRegions.contains(id)) {
          loadedRegions.add(id);
        }
      } else {
        throw Exception('Failed to load magasins for region $id');
      }
    } catch (e) {
      print('Error fetching magasins for region $id: $e');
    }
  }

 void _handleTabChange() {
  if (_tabController != null && _tabController!.index >= 0 && _tabController!.index < idNiveau1Pays.length) {
    String selectedRegionId = idNiveau1Pays[_tabController!.index];
    fetchMagasinsByRegion(selectedRegionId);
  }
}

  @override
  void initState() {
    super.initState();
     if (idNiveau1Pays.isNotEmpty) {
      selectedRegionId = idNiveau1Pays[_tabController!.index];
    }
    fetchRegions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: regions.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('My App'),
            bottom: TabBar(
              controller: _tabController, // Ajoutez le contrôleur TabBar
              tabs: regions.map((region) => Tab(text: region)).toList(),
            ),
          ),
          body: TabBarView(
            controller: _tabController, // Ajoutez le contrôleur TabBarView
            children: idNiveau1Pays.map((region) {
              return buildGridView(region);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildGridView(String id) {
    List<Map<String, dynamic>>? magasins = magasinsParRegion[id];
   if (magasinsParRegion[id] == null) {
    // Si les données ne sont pas encore chargées, affichez le CircularProgressIndicator
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: (Color.fromARGB(255, 245, 212, 169)),
          color: (Colors.orange),
      ),
    );
  } else {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: magasins?.length ?? 0,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              Image.network(
                magasins?[index]['photo'] ?? 'assets/images/transport.png',
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/images/produit.png',
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  );
                },
              ),
              SizedBox(height: 10),
              Text(
                magasins?[index]['nomMagasin'] ?? 'Pas de nom definis',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
  }
}
