
 import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/CategorieProduit.dart';
import 'package:koumi_app/models/Commande.dart';
import 'package:koumi_app/models/ParametreGeneraux.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/service/BottomNavigationService.dart';
import 'package:koumi_app/service/CommandeService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MesCommande extends StatefulWidget {
  const MesCommande({super.key});

  @override
  State<MesCommande> createState() => _MesCommandeState();
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _MesCommandeState extends State<MesCommande> {

    late Acteur acteur = Acteur();
  late List<TypeActeur> typeActeurData = [];
  // List<ParametreGeneraux> paraList = [];
  // late ParametreGeneraux para = ParametreGeneraux();
  late String type;
  late TextEditingController _searchController;
  List<Stock>  stockListe = [];
  CategorieProduit? selectedCat;
   List<Commande> _liste = [];
  String? typeValue;
  bool isExist = false;
  bool isProprietaire = false;
  String? email = "";



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
        //     if (_liste.any((commande) => commande.acteur?.idActeur == acteur.idActeur)) {
          
        // getAllCommandeByActeur(acteur.idActeur!).then((value) => {
        //   _liste = value
        // });
        // }else{
        //   setState(() {
        //     isProprietaire = true;
        //   });
        // fetchCommandeByActeurProprietaire(acteur.idActeur!).then((value) => {
        //   _liste = value
        // });
        // }
        fetchAllCommandes(acteur.idActeur!).then((combinedList) {
          setState(() {
            _liste = combinedList;
          });
        });
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

   Future<List<Commande>> fetchAllCommandes(String idActeur) async {
    final commandesActeur = await getAllCommandeByActeur(idActeur);
    final commandesProprietaire = await fetchCommandeByActeurProprietaire(idActeur);
    return [...commandesActeur, ...commandesProprietaire];
  }


 Future<List<Commande>> getAllCommandeByActeur(String idActeur) async {
    final response = await CommandeService().fetchCommandeByActeur(idActeur);
    return response;
  }
 Future<List<Commande>> fetchCommandeByActeurProprietaire(String acteurProprietaire)async {
    final response = await CommandeService().fetchCommandeByActeurProprietaire(acteurProprietaire);
    return response;
  }

 
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController();
    verify();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes commandes"),
      actions: [
  // Container(
  //   width: 30,
  //   height: 30,
  //   decoration: BoxDecoration(
  //     color: Colors.green, // Background color of the circle
  //     shape: BoxShape.circle, // Shape of the container
  //   ),
  //   child: Center(
  //     child: IconButton(
  //       onPressed: () {
  //         // Your onPressed function
  //       },
  //       icon: Icon(Icons.add),
  //       color: Colors.white, // Icon color
  //       iconSize: 16, // Adjust the icon size as needed
  //     ),
  //   ),
  // ),
  IconButton(
    onPressed: () {
      // Your onPressed function
    },
    icon: Icon(Icons.refresh),
    color: Colors.black, // Icon color
    iconSize: 25,
  ),
],

      ),
      body:
       !isExist
            ? Center(
                child: Container(
                  padding: EdgeInsets.all(
                      20), // Ajouter un padding pour l'espace autour du contenu

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/lock.png",
                          width: 100,
                          height:
                              100), // Ajuster la taille de l'image selon vos besoins
                      SizedBox(
                          height:
                              20), // Ajouter un espace entre l'image et le texte
                      Text(
                        "Vous devez vous connecter pour voir vos commandes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                          height:
                              20), // Ajouter un espace entre le texte et le bouton
                      ElevatedButton(
                        onPressed: () {
                          Future.microtask(() {
                            Provider.of<BottomNavigationService>(context,
                                    listen: false)
                                .changeIndex(0);
                          });
                          Get.to(LoginScreen(),
                              duration: Duration(
                                  seconds:
                                      1), //duration of transitions, default 1 sec
                              transition: Transition.leftToRight);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          elevation: MaterialStateProperty.all<double>(
                              0), // Supprimer l'élévation du bouton
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.grey.withOpacity(
                                  0.2)), // Couleur de l'overlay du bouton lorsqu'il est pressé
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color:
                                      d_colorGreen), // Bordure autour du bouton
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "Se connecter",
                            style: TextStyle(fontSize: 16, color: d_colorGreen),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            :
       RefreshIndicator(
        onRefresh: () async{
       setState(() {
            fetchAllCommandes(acteur.idActeur!).then((value) => {
          _liste = value
        });
       });
        },
         child: SingleChildScrollView(
          child: Column(
            children: [
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
                          color: Colors.blueGrey[400],
                          size: 28), // Utiliser une icône de recherche plus grande
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Rechercher',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.blueGrey[400]),
                          ),
                        ),
                      ),
                      // Ajouter un bouton de réinitialisation pour effacer le texte de recherche
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),    
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(left:20.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Liste des commandes :",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold))),
              ),  
             Padding(
               padding: const EdgeInsets.all(15.0),
               child: Table(
          border: TableBorder.all(color: Colors.black38),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Header row
            TableRow(
              decoration: BoxDecoration(color: Colors.redAccent),
              children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Code",
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Date",
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Statut",
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
         
            // Data rows
            ..._liste.map((commande) =>  TableRow(
              children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(commande.codeCommande!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(commande.dateCommande!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        if(acteur.idActeur == commande.acteur?.idActeur){
                          print("acteur qui a commande");
                        }
                        else {
                          print("acteur proprietaire");
                        }
                      },
                      onLongPress: () {
                        if(acteur.idActeur == commande.acteur?.idActeur){
                          print("acteur qui a commande");
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Annuler la commande'),
                              content: const Text('Êtes-vous sûr de vouloir annuler la commande ?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Non'),
                                ),
                                TextButton(
                                  onPressed: () async{
                                    Navigator.pop(context);
                                    // Call the callback function for cancellation
                                    
                                               commande.statutCommande! ==
                                                              true
                                                          ? await CommandeService()
                                                              .disableCommane(
                                                                  commande.idCommande!)
                                                              .then((value) => {
                                                                    // Mettre à jour la liste des magasins après le changement d'état
                                                                    Provider.of<CommandeService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .applyChange(),
                                                                    setState(() {
            fetchAllCommandes(acteur.idActeur!).then((value) => {
          _liste = value
            });
          }),
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                  })
                                                              .catchError(
                                                                  (onError) => {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          const SnackBar(
                                                                            content:
                                                                                Row(
                                                                              children: [
                                                                                Text("Une erreur s'est produit"),
                                                                              ],
                                                                            ),
                                                                            duration:
                                                                                Duration(seconds: 5),
                                                                          ),
                                                                        ),
                                                                        Navigator.of(context)
                                                                            .pop(),
                                                                      }): null;
                                  },
                                  child: const Text('Oui'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Center(
                        child: Container(
                          width: 80,
                          color: commande.statutCommande == false ? Colors.red : Colors.green,
                          child: Center(
                            child: Text(
                              commande.statutCommande == false ? "En attende" : "Validée",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),))
            ],
          ),)
               
             ],)
             )
             ],)
             ),
       ));
  }
  
}