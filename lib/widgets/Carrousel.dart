import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:koumi_app/constants.dart';
import 'dart:convert';
import 'dart:async';

import 'package:koumi_app/models/Alertes.dart';
import 'package:koumi_app/widgets/carousel_loading.dart';
import 'package:shimmer/shimmer.dart';


List imageList = [
  {"id": 1, "image_path": 'assets/images/koumi1.png'},
  {"id": 2, "image_path": 'assets/images/koumi2.jpg'},
];

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class Carrousels extends StatelessWidget {
  Carrousels({super.key});

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InkWell(
            onTap: () {
              print(currentIndex);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                // height: 200,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 228, 225, 225),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: CarouselSlider(
                  items: imageList
                      .map((item) => Image.asset(
                            item['image_path'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ))
                      .toList(),
                  carouselController: carouselController,
                  options: CarouselOptions(
                    scrollPhysics: const BouncingScrollPhysics(),
                    autoPlay: true,
                    aspectRatio: 2,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      currentIndex = index;
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => carouselController.animateToPage(entry.key),
                  child: Container(
                    width: currentIndex == entry.key ? 17 : 7,
                    height: 7.0,
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          currentIndex == entry.key ? d_colorOr : d_colorGreen,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class Carrousel extends StatefulWidget {
   Carrousel({super.key});

  @override
  _CarrouselState createState() => _CarrouselState();
}

class _CarrouselState extends State<Carrousel> {
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  List<Alertes> alertesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAlertes().then((alerts) {
      setState(() {
        alertesList = alerts;
        isLoading = false;
      });
    });
  }

  Future<List<Alertes>> fetchAlertes() async {
    const String baseUrl = '$apiOnlineUrl/alertes';
int page = 0;
  int size = 3;
  try {
    final response = await http.get(Uri.parse('$baseUrl/getAllAlertesWithPagination?page=$page&size=$size'));

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
      String contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('application/json')) {
        String jsonString = utf8.decode(response.bodyBytes);
        Map<String, dynamic> body = jsonDecode(jsonString);
        List<dynamic> alertes = body['content'];
        return alertes.map((e) => Alertes.fromMap(e)).toList();
      } else {
        print('La réponse n\'est pas au format JSON : $contentType');
        print('Contenu de la réponse : ${response.body}');
      }
    } else {
      print('Échec du chargement des alertes avec le code d\'état : ${response.statusCode}');
      print('Contenu de la réponse : ${response.body}');
    }
  } catch (e) {
    print('Erreur lors de la requête : $e');
  }
  return [];
}

  List<Widget> getImageSliders() {
    return alertesList.isEmpty
        ? imageList.map((item) => buildImageSlider(item['image_path'], '')).toList()
        : alertesList.map((alert) => buildImageSlider
        ("https://koumi.ml/api-koumi/alertes/${alert.idAlerte}/image",
         alert.titreAlerte!)).toList();
  }

  Widget buildImageSlider(String imagePath, String text) {
    return Stack(
      children: [
        // Image.asset(
        //                                               'assets/images/default_image.png',
        //                                               fit: BoxFit.cover,
        //                                             ),
        Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.white, width: 4.0), // Bordure noire de 4.0 de largeur
          borderRadius: BorderRadius.circular(12.0), // Bordure arrondie
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0), // Bordure arrondie pour les coins des images
          child: CachedNetworkImage(
            imageUrl: imagePath,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/default_image.png',
              fit: BoxFit.cover,
            ),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
        Positioned(
          bottom: 20,
          left: 20,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black54,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 17, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: buildShimmerImageSlider())
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width ,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 228, 225, 225),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: CarouselSlider(
                      items: getImageSliders(),
                      carouselController: carouselController,
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        aspectRatio: 2,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: (alertesList.isEmpty ? imageList : alertesList).asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => carouselController.animateToPage(entry.key),
                        child: Container(
                          width: currentIndex == entry.key ? 17 : 7,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: currentIndex == entry.key ? d_colorOr : d_colorGreen,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

// Shimmer 
Widget buildShimmerImageSlider() {
  return Stack(
    children: [
      // Placeholder pour l'image
      Shimmer.fromColors(
       highlightColor: kBackgroundColor,
        baseColor: Colors.grey[300]!, // Utilisez une couleur grise plus claire
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
             width: MediaQuery.of(context).size.width ,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 228, 225, 225),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
            height: 200, // Ajustez la hauteur en fonction de vos besoins
          ),
        ),
      ),
      // Placeholder pour le texte
      
    ],
  );
}

}

// List defaultImageList = [
//   {"id": 1, "image_path": 'assets/images/koumi1.png'},
//   {"id": 2, "image_path": 'assets/images/koumi2.jpg'},
// ];