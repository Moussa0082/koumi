
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/models/DetailCommande.Dart';
import 'package:koumi_app/service/CommandeService.dart';
import 'package:koumi_app/widgets/CartListItem.dart';

class DetailCommandeScreen extends StatefulWidget {
 String? idCommande;
 bool? isProprietaire;
   DetailCommandeScreen({super.key,  this.idCommande, this.isProprietaire});

  @override
  State<DetailCommandeScreen> createState() => _DetailCommandeScreenState();
}

class _DetailCommandeScreenState extends State<DetailCommandeScreen> { 
  
   late Future<List<DetailCommande>> futureDetails;
   List<DetailCommande> details = [];


   @override
  void initState() {
    super.initState();
    futureDetails = CommandeService().fetchDetailsByCommandeId(widget.idCommande!);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DetailCommande"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Text("Produit commandés" , style: TextStyle(fontSize: 25),),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: const Divider(height: 2, )),
            ),
              FutureBuilder<List<DetailCommande>>(
        future: futureDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return SingleChildScrollView(
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                          'assets/images/notif.jpg'),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Une erreur s\'est  produit veuiller réessayer plus tard',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return SingleChildScrollView(
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                          'assets/images/notif.jpg'),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Aucun detail trouvé',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
          } else {
              details = snapshot.data!;
            
                
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                DetailCommande detail = snapshot.data![index];
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 0.5,
                        blurRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (detail.isStock == true && detail.stock != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: detail.stock!.photo != null
                              ? CachedNetworkImage(
                                  imageUrl: "https://koumi.ml/api-koumi/Stock/${detail.stock!.idStock!}/image",
                                  fit: BoxFit.cover,
                                  width: 67,
                                  height: 100,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Image.asset("assets/images/default_image.png", width: 67, height: 100),
                                )
                              : Image.asset("assets/images/default_image.png", width: 67, height: 100),
                        )
                      else if (detail.intrant != null)
                      // else if (detail.isStock == false && detail.intrant != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: detail.intrant!.photoIntrant != null
                              ? CachedNetworkImage(
                                  imageUrl: "https://koumi.ml/api-koumi/intrant/${detail.intrant!.idIntrant}/image",
                                  fit: BoxFit.cover,
                                  width: 67,
                                  height: 100,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Image.asset("assets/images/default_image.png", width: 67, height: 100),
                                )
                              : Image.asset("assets/images/default_image.png", width: 67, height: 100),
                        ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detail.nomProduit!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  "${detail.isStock == true ? detail.stock!.prix : detail.intrant!.prixIntrant} F",
                                  // "${detail.isStock == true ? detail.stock!.prix : detail.intrant!.prixIntrant} F",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Expanded(child: Container()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
           
      
      );
  }
        })
    

          ],
        ),
      ),
    );
  }
}