import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MagasinScreen extends StatefulWidget {
  const MagasinScreen({super.key});

  @override
  State<MagasinScreen> createState() => _MagasinScreenState();
}

class _MagasinScreenState extends State<MagasinScreen>  with TickerProviderStateMixin {

  TabController? _tabController;
  List<String> regions = [];
  List<String> regionIds = [];

  Map<String, List<Map<String, dynamic>>> magasinsParRegion = {};

List<Map<String, dynamic>> regionsData = [];
  List<String> niveau1Pays = [];
  List<String> magasins = [];
  int currentIndex = 0;

  //     Future<List<String>> fetchMagasinsByNiveau1Pays(String id) async {
  //   final response = await http.get(Uri.parse('http://10.0.2.2:9000/getAllMagasinByPays/$id'));
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     List<String> magasinsList = [];
  //     for (var item in data) {
  //       magasinsList.add(item['nomMagasin']);
  //     }
  //     return magasinsList;
  //   } else {
  //     throw Exception('Failed to load magasins by niveau1 pays');
  //   }
  // }


    
  
    

 
  //  void fetchRegions() async {
  //   try {
  //     final response = await http.get(Uri.parse('http://10.0.2.2:9000/niveau1Pays/read'));
  //     if (response.statusCode == 200) {
  //       List<dynamic> data = json.decode(response.body);
  //       setState(() {
  //       regions = (data as List<dynamic>).map((item) => item['nomN1'] as String).toList();

  //       });
  //       _tabController = TabController(length: regions.length, vsync: this);
  //       _tabController!.addListener(_handleTabChange);
  //       fetchMagasinsByRegion(regions[0]);
  //     } else {
  //       throw Exception('Failed to load regions');
  //     }
  //   } catch (e) {
  //     print('Error fetching regions: $e');
  //   }
  // }
  
    void fetchRegions() async {
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:9000/niveau1Pays/read'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        regionsData = data.cast<Map<String, dynamic>>();
        regions = regionsData.map((item) => item['nomN1'] as String).toList();
        regionIds = regionsData.map((item) => item['idNiveau1Pays'] as String).toList();
        // Initialiser la carte magasinsParRegion avec des listes vides pour chaque région
        magasinsParRegion = Map.fromIterable(regionIds, key: (id) => id, value: (_) => []);
      });
      _tabController = TabController(length: regions.length, vsync: this);
      _tabController!.addListener(_handleTabChange);
      fetchMagasinsByRegion(regionIds.isNotEmpty ? regionIds[_tabController!.index] : ''); // Utilisez l'ID de la première région
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
            'photo': item['photo'], // Modifier avec l'attribut réel de la photo
          }).toList();
        });
      } else {
        throw Exception('Failed to load magasins for region ${regionIds[_tabController!.index]}');
      }
    } catch (e) {
      print('Error fetching magasins for region : , ${e}');
    }
  }

  void _handleTabChange() {
fetchMagasinsByRegion(regionIds.isNotEmpty ? regionIds[_tabController!.index] : '');

  }

   @override 
void initState() {
  super.initState();
  _tabController = TabController(length: regions.length, vsync: this);
  _tabController!.addListener(_handleTabChange);
  fetchRegions();
   fetchMagasinsByRegion(regionIds.isNotEmpty ? regionIds[_tabController!.index] : '');
  //  debugPrint( "nombre : ${regionIds[_tabController!.index]}");
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
            tabs: regions.map((region) => Tab(text: region)).toList(),
          ),
        ),
        body: TabBarView(
          children: regionIds.map((region) {
            return buildGridView(region);
          }).toList(),
        ),
      ),
        ),
    );
  }



  //  card widget 
  Widget buildGridView(String id) {
     List<Map<String, dynamic>>? magasins = magasinsParRegion[id];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: magasins?.length ?? 0,
      itemBuilder: (context, index) {
        return  Card(
  child: Column(
    children: [
      Image.network(
        magasins?[index]['photo'] ?? 'assets/images/transport.png',
        width: double.infinity,
        height: 150, // Définissez la hauteur de l'image selon vos besoins
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          // Cette fonction est appelée en cas d'erreur lors du chargement de l'image
          return Image.asset(
            'assets/images/produit.png', // Chemin de l'image par défaut dans votre projet
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          );
        },
      ),
      SizedBox(height: 10), // Ajoutez un peu d'espace entre l'image et le texte
      Text(
        magasins?[index]['nomMagasin'] ?? 'Nom du magasin non disponible',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ), // Affichez le nom du magasin
    ],
  ),
);
      },
    );
  }
  // fin card widget 
}
