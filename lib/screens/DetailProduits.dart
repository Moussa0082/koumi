import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/CartProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/screens/AddAndUpdateProductScreen.dart';
import 'package:koumi_app/widgets/SnackBar.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';


class DetailProduits extends StatefulWidget {
  late Stock stock;
  DetailProduits({super.key, required this.stock});

  @override
  State<DetailProduits> createState() => _DetailProduitsState();
}

const double defaultPadding = 16.0;
const double defaultPadding_min = 5.0;
const double defaultBorderRadius = 12.0;

class _DetailProduitsState extends State<DetailProduits>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<Offset> _animation;

  late Acteur acteur = Acteur();
  late List<TypeActeur> typeActeurData = [];
  late String type;
  late ValueNotifier<bool> isDialOpenNotifier;
    late Stock stock;

  bool isExist = false;
  String? email = "";
  List<ParametreGeneraux> paraList = [];
  late ParametreGeneraux para = ParametreGeneraux();

 void verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('emailActeur');
    if (email != null) {
      // Si l'email de l'acteur est présent, exécute checkLoggedIn
      acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
      typeActeurData = acteur.typeActeur!;
      type = typeActeurData.map((data) => data.libelle).join(', ');
      setState(() {
        isExist = true;
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

  void verifyParam() {
    paraList = Provider.of<ParametreGenerauxProvider>(context, listen: false)
        .parametreList!;

    if (paraList.isNotEmpty) {
      para = paraList[0];
    } else {
      // Gérer le cas où la liste est null ou vide, par exemple :
      // Afficher un message d'erreur, initialiser 'para' à une valeur par défaut, etc.
    }
  }

  @override
  void initState() {
    super.initState();
    verify();
    verifyParam();
    stock = widget.stock;
    // Initialiser le ValueNotifier
    isDialOpenNotifier = ValueNotifier<bool>(false);
  }



  @override
  Widget build(BuildContext context) {
    const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios, color: d_colorGreen)),
          centerTitle: true,
          title: const Text("Détail Produit"),
          actions: acteur.idActeur != widget.stock.acteur!.idActeur
              ? null
              : [
                  isExist == false
                      ? SizedBox()
                      : IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddAndUpdateProductScreen(
                                          isEditable: true,
                                          stock: widget.stock,
                                        )));
                          },
                          icon: Icon(
                            Icons.edit,
                          ),
                        )
                        //  PopupMenuButton<String>(
                        //                               padding: EdgeInsets.zero,
                        //                               itemBuilder: (context) =>
                        //                                   <PopupMenuEntry<
                        //                                       String>>[
                        //                                 PopupMenuItem<String>(
                        //                                     child: ListTile(
                        //                                   leading: stockListe[
                        //                                                   index]
                        //                                               .statutSotck ==
                        //                                           false
                        //                                       ? Icon(
                        //                                           Icons.check,
                        //                                           color: Colors
                        //                                               .green,
                        //                                         )
                        //                                       : Icon(
                        //                                           Icons
                        //                                               .disabled_visible,
                        //                                           color: Colors
                        //                                                   .orange[
                        //                                               400]),
                        //                                   title: Text(
                        //                                     stockListe[index]
                        //                                                 .statutSotck ==
                        //                                             false
                        //                                         ? "Activer"
                        //                                         : "Desactiver",
                        //                                     style: TextStyle(
                        //                                       color: stockListe[
                        //                                                       index]
                        //                                                   .statutSotck ==
                        //                                               false
                        //                                           ? Colors.green
                        //                                           : Colors.red,
                        //                                       fontWeight:
                        //                                           FontWeight
                        //                                               .bold,
                        //                                     ),
                        //                                   ),
                        //                                   onTap: () async {
                        //                                     // Changement d'état du magasin ici
                        //                                     stockListe[index]
                        //                                                 .statutSotck ==
                        //                                             false
                        //                                         ? await StockService()
                        //                                             .activerStock(
                        //                                                 stockListe[index]
                        //                                                     .idStock!)
                        //                                             .then(
                        //                                                 (value) =>
                        //                                                     {
                        //                                                       // Mettre à jour la liste des magasins après le changement d'état
                        //                                                       Provider.of<StockService>(context, listen: false).applyChange(),
                        //                                                       setState(() {
                        //                                                         stockListeFuture = StockService().fetchStock();
                        //                                                       }),
                        //                                                       Navigator.of(context).pop(),
                        //                                                     })
                        //                                             .catchError(
                        //                                                 (onError) =>
                        //                                                     {
                        //                                                       ScaffoldMessenger.of(context).showSnackBar(
                        //                                                         const SnackBar(
                        //                                                           content: Row(
                        //                                                             children: [
                        //                                                               Text("Une erreur s'est produit"),
                        //                                                             ],
                        //                                                           ),
                        //                                                           duration: Duration(seconds: 5),
                        //                                                         ),
                        //                                                       ),
                        //                                                       Navigator.of(context).pop(),
                        //                                                     })
                        //                                         : await StockService()
                        //                                             .desactiverStock(
                        //                                                 stockListe[index]
                        //                                                     .idStock!)
                        //                                             .then(
                        //                                                 (value) =>
                        //                                                     {
                        //                                                       Provider.of<StockService>(context, listen: false).applyChange(),
                        //                                                       setState(() {
                        //                                                         stockListeFuture = StockService().fetchStock();
                        //                                                       }),
                        //                                                       Navigator.of(context).pop(),
                        //                                                     });

                        //                                     ScaffoldMessenger
                        //                                             .of(context)
                        //                                         .showSnackBar(
                        //                                       SnackBar(
                        //                                         content: Row(
                        //                                           children: [
                        //                                             Text(stockListe[index].statutSotck ==
                        //                                                     false
                        //                                                 ? "Activer avec succèss "
                        //                                                 : "Desactiver avec succèss"),
                        //                                           ],
                        //                                         ),
                        //                                         duration:
                        //                                             Duration(
                        //                                                 seconds:
                        //                                                     2),
                        //                                       ),
                        //                                     );
                        //                                   },
                        //                                 )),
                        //                               ],
                        //                             ),
                ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
            children: [
              widget.stock.photo == null || widget.stock.photo!.isEmpty
                  ? Image.asset(
                      "assets/images/default_image.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    )
                  : CachedNetworkImage(
                      imageUrl:
                          'https://koumi.ml/api-koumi/Stock/${widget.stock.idStock}/image',
                      width: double.infinity,
                      height: 200,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/default_image.png',
                        fit: BoxFit.cover,
                      ),
                    ),
              const SizedBox(height: defaultPadding * 0.300),
              Container(
                padding: const EdgeInsets.fromLTRB(defaultPadding,
                    defaultPadding * 2, defaultPadding, defaultPadding),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(defaultBorderRadius * 3),
                    topRight: Radius.circular(defaultBorderRadius * 3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                      ),
                      child: Center(
                        child: Text(
                          widget.stock.nomProduit!.toUpperCase(),
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Forme : ",
                          style: TextStyle(
                              fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                        Text(
                            widget.stock
                                .formeProduit!, // Use optional chaining and ??
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Quantité : ",
                            style: TextStyle(
                                fontSize: 20, fontStyle: FontStyle.italic)),
                        Text(widget.stock.quantiteStock!.toInt().toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Unité Produit : ",
                            style: TextStyle(
                                fontSize: 20, fontStyle: FontStyle.italic)),
                        Text(
                          widget.stock.unite!.nomUnite!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                      ),
                      child: Center(
                        child: Text(
                          "Description",
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: defaultPadding),
                      child: ReadMoreText(
                        colorClickableText: Colors.orange,
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: "Lire plus",
                        trimExpandedText: "Lire moins",
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                        widget.stock.descriptionStock == null
                            ? "A Henley shirt is a collarless pullover shirt, by a round neckline and a placket about 3 to 5 inches (8 to 13 cm) long and usually having 2–5 buttons."
                            : widget.stock.descriptionStock!,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                      ),
                      child: Center(
                        child: Text(
                          "Autres information",
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.stock.prix!.toInt()} (${para.monnaie})', // Convertir en entier
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 0,
                            maxRating: 5,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 30,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Speculation : ",
                            style: TextStyle(
                                fontSize: 20, fontStyle: FontStyle.italic)),
                        Text(
                          widget.stock.speculation!.nomSpeculation!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Type Produit : ",
                            style: TextStyle(
                                fontSize: 20, fontStyle: FontStyle.italic)),
                        Text(
                          widget.stock.typeProduit!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Code Qr: ",
                              style: TextStyle(
                                  fontSize: 20, fontStyle: FontStyle.italic)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return DetailScreen(); // écran de détail avec l'image agrandie
                              }));
                            },
                            child: Image.asset("assets/images/qr.png"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    isExist == true
                        ? widget.stock.acteur!.idActeur == acteur.idActeur
                            ? SizedBox()
                            : Center(
                                child: SizedBox(
                                  width: 200,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // _addToCart(widget.stock);
                                      if (widget.stock.acteur!.idActeur ==
                                          acteur.idActeur) {
                                        Snack.error(
                                            titre: "Alerte",
                                            message:
                                                "Désolé!, Vous ne pouvez pas commander un produit qui vous appartient");
                                      } else {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .addToCart(widget.stock, 1, "");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.orange,
                                        shape: const StadiumBorder()),
                                    child: Text(
                                      "Ajouter au panier",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                        : SizedBox(),
                                          const SizedBox(height: 10),
                  ],
                ),
              )
            ],
          ),
        ),

    //     floatingActionButton: 
    //     widget.stock.acteur!.idActeur != acteur.idActeur ?
    // SpeedDial(
    //   backgroundColor: d_colorGreen,
    //   foregroundColor: Colors.white,
    //   overlayColor: Colors.black,
    //   overlayOpacity: 0.4,
    //   spacing: 12,
    //   icon: Icons.phone,
    //   children: [
    //     SpeedDialChild(
    //       child: FaIcon(FontAwesomeIcons.whatsapp),
    //       label: 'Par WhatsApp',
    //       labelStyle: TextStyle(
    //         color: Colors.black,
    //         fontSize: 15,
    //         fontWeight: FontWeight.w500,
    //       ),
    //       onTap: () {
    //         final String whatsappNumber = widget.stock.acteur!.whatsAppActeur!;
    //         _makePhoneWa(whatsappNumber);
    //       },
    //     ),
    //     SpeedDialChild(
    //       child: Icon(Icons.phone),
    //       label: 'Par téléphone',
    //       labelStyle: TextStyle(
    //         color: Colors.black,
    //         fontSize: 15,
    //         fontWeight: FontWeight.w500,
    //       ),
    //       onTap: () {
    //         final String numberPhone = widget.stock.acteur!.telephoneActeur!;
    //         _makePhoneCall(numberPhone);
    //       },
    //     )
    //   ],
    //   // État du Speed Dial (ouvert ou fermé)
    //   openCloseDial: isDialOpenNotifier,
    //   // Fonction appelée lorsque le bouton principal est pressé
    //   onPress: () {
    //     isDialOpenNotifier.value = !isDialOpenNotifier.value;
    //   },
    // )
    // :
    // Container()
      floatingActionButton: acteur.idActeur != stock.acteur!.idActeur
                ? SpeedDial(
                    // animatedIcon: AnimatedIcons.close_menu,

                    backgroundColor: d_colorGreen,
                    foregroundColor: Colors.white,
                    overlayColor: Colors.black,
                    overlayOpacity: 0.7,
                    spacing: 12,
                    icon: Icons.phone,

                    children: [
                      SpeedDialChild(
                        child: FaIcon(FontAwesomeIcons.whatsapp),
                        label: 'Par wathsApp',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        onTap: () {
                          final String whatsappNumber =
                              stock.acteur!.whatsAppActeur!;
                          _makePhoneWa(whatsappNumber);
                        },
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.phone),
                        label: 'Par téléphone ',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        onTap: () {
                          final String numberPhone =
                              stock.acteur!.telephoneActeur!;
                          _makePhoneCall(numberPhone);
                        },
                      )
                    ],
                    // État du Speed Dial (ouvert ou fermé)
                    openCloseDial: isDialOpenNotifier,
                    // Fonction appelée lorsque le bouton principal est pressé
                    onPress: () {
                      isDialOpenNotifier.value = !isDialOpenNotifier
                          .value; // Inverser la valeur du ValueNotifier
                    },
                  )
                : Container() 
    //// Si l'utilisateur est connecté et que le stock lui appartient, ne pas afficher le bouton de téléphone
);
  }


   Future<void> _makePhoneWa(String whatsappNumber) async {
    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: whatsappNumber,
    );
    print(Uri);
    await launchUrl(launchUri);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }


}



class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10) {
            Navigator.pop(context); // Ferme l'écran si glissé vers le bas
          }
        },
        child: Center(
          child: ListView(
            children: [
              Hero(
                tag:
                    "qrImage", // Référence au même tag utilisé dans l'écran précédent
                child: Image.asset("assets/images/qr.png"), // Image agrandie
              ),
              // Autres éléments de l'écran de détail ici...
            ],
          ),
        ),
      ),
      // Ferme l'écran si glissé vers la gauche ou la droite
      resizeToAvoidBottomInset: false,
    );
  }
}