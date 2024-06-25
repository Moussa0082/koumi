import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/models/TypeVoiture.dart';
import 'package:koumi_app/models/Vehicule.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/AddVehiculeTransport.dart';
import 'package:koumi_app/screens/DetailTransport.dart';
import 'package:koumi_app/service/VehiculeService.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';


class ListeVehiculeByType extends StatefulWidget {
  final TypeVoiture typeVoitures;
  String? detectedCountry;
   ListeVehiculeByType({super.key, required this.typeVoitures, this.detectedCountry});

  @override
  State<ListeVehiculeByType> createState() => _ListeVehiculeByTypeState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _ListeVehiculeByTypeState extends State<ListeVehiculeByType> {
  late Acteur acteur;
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late TextEditingController _searchController;
  List<Vehicule> vehiculeListe = [];
  late TypeVoiture typeVoiture;
  late Future<List<Vehicule>> futureListe;
         ScrollController scrollableController = ScrollController();
   int page = 0;
   bool isLoading = false;
   int size = 8;
   bool hasMore = true;

  Future<List<Vehicule>> getListe(String id) async {
    final response = await VehiculeService().fetchVehiculeByTypeVoitureWithPagination(id, widget.detectedCountry != null ? widget.detectedCountry! : "Mali");
    return response;
  }

  void _scrollListener() {
  
    if( scrollableController.position.pixels >=
          scrollableController.position.maxScrollExtent - 200 &&
      hasMore &&
      !isLoading){
      // Incrementez la page et récupérez les stocks généraux
      debugPrint("yes - fetch vehicule by type voiture");
      setState(() {
          // Rafraîchir les données ici
        page++;
        });
      fetchVehiculeByTypeVoitureWithPagination(typeVoiture.idTypeVoiture!, widget.detectedCountry != null ? widget.detectedCountry! : "Mali").then((value) {
        setState(() {
          // Rafraîchir les données ici
        });
      });
    // }
  // } 
  // else {
  }
    debugPrint("no");

}

 
 
 

     Future<List<Vehicule>> fetchVehiculeByTypeVoitureWithPagination(String idTypeVoiture, String niveau3PaysActeur, {bool refresh = false }) async {
    if (isLoading) return [];
      setState(() {
      isLoading = true;
      });
      
    if (refresh) {
       setState(() {
        vehiculeListe.clear();
        page = 0;
        hasMore = true;
       });
    }

    try {
      final response = await http.get(Uri.parse('$apiOnlineUrl/vehicule/getVehiculesByPaysAndTypeVoitureWithPagination?idTypeVoiture=$idTypeVoiture&niveau3PaysActeur=$niveau3PaysActeur&page=$page&size=$size'));

      if (response.statusCode == 200) {
        // debugPrint("url: $response");
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> body = jsonData['content'];

        if (body.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
           setState(() {
            List<Vehicule> newVehicule = body.map((e) => Vehicule.fromMap(e)).toList();
          vehiculeListe.addAll(newVehicule);
          // page++;
           });
          
        }

        debugPrint("response body vehicle by type vehicule with pagination $page par défilement soit ${vehiculeListe.length}");
       return vehiculeListe;
      } else {
        print('Échec de la requête avec le code d\'état: ${response.statusCode} |  ${response.body}');
        return [];
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de la récupération des vehicules: $e');
    } finally {
         setState(() {
        isLoading = false;
         });
    }
    return vehiculeListe;
  }



  @override
  void initState() {
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    typeActeurData = acteur.typeActeur!;
    type = typeActeurData.map((data) => data.libelle).join(', ');
    _searchController = TextEditingController();
    typeVoiture = widget.typeVoitures;
    futureListe = getListe(typeVoiture.idTypeVoiture!);
     WidgetsBinding.instance.addPostFrameCallback((_){
    //write or call your logic
    //code will run when widget rendering complete
  scrollableController.addListener(_scrollListener);
  });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    scrollableController.dispose();
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
                // Get.to(TypeVehicule());
              },
              icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
          title: Text(
            typeVoiture.nom!.toUpperCase(),
            style: const TextStyle(
                color: d_colorGreen, fontWeight: FontWeight.bold),
          ),
          actions: [
            // IconButton(
            //     onPressed: () {
            //       setState(() {
            //         futureListe = getListe(typeVoiture.idTypeVoiture!);
            //       });
            //     },
            //     icon: Icon(
            //       Icons.refresh,
            //       // color: Colors.green,
            //     )),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  child: ListTile(
                    leading: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    title: const Text(
                      "Ajouter un vehicule",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddVehiculeTransport(
                                    typeVoitures: typeVoiture,
                                  )));
                    },
                  ),
                ),
              ],
            )
          ]),
      body: Container(
        child: 
           NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              
             return  <Widget>
              [
                SliverToBoxAdapter(
                  child: Column(
                    children:[
        
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
                    ]
                  )
                ),
            
            ];
            
            
          },
            body:   RefreshIndicator(
                 onRefresh:() async{
                   setState(() {
                        page =0;
                       // Rafraîchir les données ici
                  futureListe = VehiculeService().fetchVehiculeByTypeVoitureWithPagination(typeVoiture.idTypeVoiture!, widget.detectedCountry != null ? widget.detectedCountry! : "Mali");
                     });
                 },
                 child: SingleChildScrollView(
                  controller: scrollableController,
                   child: Consumer<VehiculeService>(builder: (context, vehiculeService, child) {
                     return FutureBuilder(
                         // future: vehiculeService
                         //     .fetchVehiculeByTypeVehicule(typeVoiture.idTypeVoiture!),
                         future: futureListe,
                         builder: (context, snapshot) {
                           if (snapshot.connectionState == ConnectionState.waiting) {
                             return _buildShimmerEffect();
                           }
                   
                           if (!snapshot.hasData) {
                             return SingleChildScrollView(
                                  child: Padding(
                   padding: EdgeInsets.all(10),
                   child: Center(
                     child: Column(
                       children: [
                         Image.asset('assets/images/notif.jpg'),
                         SizedBox(
                           height: 10,
                         ),
                         Text(
                           'Aucune vehiucle trouvé' ,
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             overflow: TextOverflow.ellipsis,
                           ),
                         ),
                       ],
                     ),
                   ),
                                  ),
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
                             return GridView.builder(
                               shrinkWrap: true,
                               physics: NeverScrollableScrollPhysics(),
                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                 crossAxisCount: 2,
                                 mainAxisSpacing: 10,
                                 crossAxisSpacing: 10,
                                 childAspectRatio: 0.8,
                               ),
                               itemCount: filtereSearch.length+1,
                               itemBuilder: (context, index) {
                                 if(index < filtereSearch.length){
                                 var e = filtereSearch
                                     .where((element) => element.statutVehicule == true)
                                     .elementAt(index);
                                 return GestureDetector(
                                   onTap: () {
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                             builder: (context) =>
                                                 DetailTransport(vehicule: e)));
                                   },
                                   child: Card(
                                     margin: EdgeInsets.all(8),
                                     
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.stretch,
                                       children: [
                                         ClipRRect(
                                           borderRadius: BorderRadius.circular(8.0),
                                           child: SizedBox(
                                             height: 72,
                                             child: e.photoVehicule == null ||
                                                     e.photoVehicule!.isEmpty
                                                 ? Image.asset(
                                                     "assets/images/default_image.png",
                                                     fit: BoxFit.cover,
                                                   )
                                                 : CachedNetworkImage(
                                                     imageUrl:
                                                         "https://koumi.ml/api-koumi/vehicule/${e.idVehicule}/image",
                                                     fit: BoxFit.cover,
                                                     placeholder: (context, url) =>
                                                         const Center(
                                                             child:
                                                                 CircularProgressIndicator()),
                                                     errorWidget:
                                                         (context, url, error) =>
                                                             Image.asset(
                                                       'assets/images/default_image.png',
                                                       fit: BoxFit.cover,
                                                     ),
                                                   ),
                                           ),
                                         ),
                                         // SizedBox(height: 8),
                                         ListTile(
                                           title: Text(
                                             e.nomVehicule,
                                             style: TextStyle(
                                               fontSize: 16,
                                               fontWeight: FontWeight.bold,
                                               color: Colors.black87,
                                             ),
                                             maxLines: 2,
                                             overflow: TextOverflow.ellipsis,
                                           ),
                                           subtitle: Text(
                                             e.localisation,
                                             style: TextStyle(
                                               fontSize: 15,
                                               color: Colors.black87,
                                             ),
                                           ),
                                         ),
                                         Container(
                                           alignment: Alignment.bottomRight,
                                           padding: const EdgeInsets.symmetric(
                                               horizontal: 10),
                                           child: Row(
                                             mainAxisAlignment:
                                                 MainAxisAlignment.spaceBetween,
                                             children: [
                                               _buildEtat(e.statutVehicule),
                                               PopupMenuButton<String>(
                                                 padding: EdgeInsets.zero,
                                                 itemBuilder: (context) =>
                                                     <PopupMenuEntry<String>>[
                                                   PopupMenuItem<String>(
                                                     child: ListTile(
                                                       leading: e.statutVehicule == false
                                                           ? Icon(
                                                               Icons.check,
                                                               color: Colors.green,
                                                             )
                                                           : Icon(
                                                               Icons.disabled_visible,
                                                               color: Colors.orange[400],
                                                             ),
                                                       title: Text(
                                                         e.statutVehicule == false
                                                             ? "Activer"
                                                             : "Desactiver",
                                                         style: TextStyle(
                                                           color:
                                                               e.statutVehicule == false
                                                                   ? Colors.green
                                                                   : Colors.orange[400],
                                                           fontWeight: FontWeight.bold,
                                                         ),
                                                       ),
                                                       onTap: () async {
                                                         e.statutVehicule == false
                                                             ? await VehiculeService()
                                                                 .activerVehicules(
                                                                     e.idVehicule)
                                                                 .then((value) => {
                                                                       Provider.of<VehiculeService>(
                                                                               context,
                                                                               listen:
                                                                                   false)
                                                                           .applyChange(),
                                                                       setState(() {
                                                                         futureListe = getListe(
                                                                             typeVoiture
                                                                                 .idTypeVoiture!);
                                                                       }),
                                                                       Navigator.of(
                                                                               context)
                                                                           .pop(),
                                                                       ScaffoldMessenger
                                                                               .of(context)
                                                                           .showSnackBar(
                                                                         const SnackBar(
                                                                           content: Row(
                                                                             children: [
                                                                               Text(
                                                                                   "Activer avec succèss "),
                                                                             ],
                                                                           ),
                                                                           duration:
                                                                               Duration(
                                                                                   seconds:
                                                                                       2),
                                                                         ),
                                                                       )
                                                                     })
                                                                 .catchError(
                                                                     (onError) => {
                                                                           ScaffoldMessenger.of(
                                                                                   context)
                                                                               .showSnackBar(
                                                                             const SnackBar(
                                                                               content:
                                                                                   Row(
                                                                                 children: [
                                                                                   Text(
                                                                                       "Une erreur s'est produit"),
                                                                                 ],
                                                                               ),
                                                                               duration: Duration(
                                                                                   seconds:
                                                                                       5),
                                                                             ),
                                                                           ),
                                                                           Navigator.of(
                                                                                   context)
                                                                               .pop(),
                                                                         })
                                                             : await VehiculeService()
                                                                 .desactiverVehicules(
                                                                     e.idVehicule)
                                                                 .then((value) => {
                                                                       Provider.of<VehiculeService>(
                                                                               context,
                                                                               listen:
                                                                                   false)
                                                                           .applyChange(),
                                                                       setState(() {
                                                                         futureListe = getListe(
                                                                             typeVoiture
                                                                                 .idTypeVoiture!);
                                                                       }),
                                                                       Navigator.of(
                                                                               context)
                                                                           .pop(),
                                                                     })
                                                                 .catchError(
                                                                     (onError) => {
                                                                           ScaffoldMessenger.of(
                                                                                   context)
                                                                               .showSnackBar(
                                                                             const SnackBar(
                                                                               content:
                                                                                   Row(
                                                                                 children: [
                                                                                   Text(
                                                                                       "Une erreur s'est produit"),
                                                                                 ],
                                                                               ),
                                                                               duration: Duration(
                                                                                   seconds:
                                                                                       5),
                                                                             ),
                                                                           ),
                                                                           Navigator.of(
                                                                                   context)
                                                                               .pop(),
                                                                         });
                   
                                                         ScaffoldMessenger.of(context)
                                                             .showSnackBar(
                                                           const SnackBar(
                                                             content: Row(
                                                               children: [
                                                                 Text(
                                                                     "Désactiver avec succèss "),
                                                               ],
                                                             ),
                                                             duration:
                                                                 Duration(seconds: 2),
                                                           ),
                                                         );
                                                       },
                                                     ),
                                                   ),
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
                                                           fontWeight: FontWeight.bold,
                                                         ),
                                                       ),
                                                       onTap: () async {
                                                         await VehiculeService()
                                                             .deleteVehicule(
                                                                 e.idVehicule)
                                                             .then((value) => {
                                                                   Provider.of<VehiculeService>(
                                                                           context,
                                                                           listen: false)
                                                                       .applyChange(),
                                                                   setState(() {
                                                                     futureListe = getListe(
                                                                         typeVoiture
                                                                             .idTypeVoiture!);
                                                                   }),
                                                                   Navigator.of(context)
                                                                       .pop(),
                                                                 })
                                                             .catchError((onError) => {
                                                                   ScaffoldMessenger.of(
                                                                           context)
                                                                       .showSnackBar(
                                                                     const SnackBar(
                                                                       content: Row(
                                                                         children: [
                                                                           Text(
                                                                               "Impossible de supprimer"),
                                                                         ],
                                                                       ),
                                                                       duration:
                                                                           Duration(
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
                                             ],
                                           ),
                                         )
                                       ],
                                     ),
                                   ),
                                 );
                                  }else{
                                       return isLoading == true ? 
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                                  child: Center(
                                                    child:
                                                    const Center(
                                                                        child: CircularProgressIndicator(
                                         color: Colors.orange,
                                                                        ),
                                                                      )
                                                  ),
                                                ) : Container();
                             }
                               },
                             );
                           }
                         });
                   }),
                 ),
               )
             ),
           ),
         );
  }


   Widget _buildShimmerEffect(){
  return   Center(
        child: GridView.builder(
            shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
          itemCount: 6, // Number of shimmer items to display
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 85,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 16,
                        color: Colors.grey,
                      ),
                    ),
                    subtitle: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 15,
                        color: Colors.grey,
                        margin: EdgeInsets.only(top: 4),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 15,
                        color: Colors.grey,
                        margin: EdgeInsets.only(top: 4),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
 }

  Widget _buildEtat(bool isState) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isState ? Colors.green : Colors.red,
      ),
    );
  }

  Widget _buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
