import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:koumi_app/models/Speculation.dart';
import 'package:koumi_app/service/SpeculationService.dart';
import 'package:koumi_app/widgets/LoadingOverlay.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:path/path.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koumi_app/models/Acteur.dart';



import 'package:koumi_app/models/Pays.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/screens/LoginSuccessScreen.dart';
import 'package:koumi_app/screens/RegisterEndScreen.dart';
import 'package:koumi_app/service/ActeurService.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';
import 'package:path_provider/path_provider.dart';

class RegisterEndScreen extends StatefulWidget {

    String nomActeur, email,telephone, adresse , maillon , localistaion, numeroWhatsApp , pays;
    File? image1;
   late List<TypeActeur>? typeActeur;
  //  late List<TypeActeur> idTypeActeur;

   RegisterEndScreen({
   super.key, required this.nomActeur, 
   this.image1,
   required this.email, required this.telephone, 
    this.typeActeur, required this.adresse, 
   required this.maillon, required this.numeroWhatsApp,
   required this.localistaion, required this.pays});

  @override
  State<RegisterEndScreen> createState() => _RegisterEndScreenState();
}

class _RegisterEndScreenState extends State<RegisterEndScreen> {

 bool isLoading = false;
   
 final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    
List<Speculation> _speculations = [];
  //  final MultiSelectController _controllerCategorie = MultiSelectController();

final MultiSelectController _controllerCategorie = MultiSelectController();
final MultiSelectController _controllerSpeculation = MultiSelectController();
    



// Définissez une fonction pour récupérer les spéculations en fonction des catégories sélectionnées
Future<void> fetchSpeculationsByCategories(List<String> idsCategorieProduit) async {
  try {
    // Utilisez la méthode getSpeculationsByCategories pour récupérer les spéculations
    
    List<Speculation> speculations = await SpeculationService().getSpeculationsByCategories(idsCategorieProduit);
    
    // Mettez à jour l'état des spéculations avec les données récupérées
    setState(() {
      _speculations = speculations;
    });
  } catch (e) {
    // Gérez les erreurs éventuelles
    print('Erreur lors de la récupération des spéculations : $e');
    // Affichez un message d'erreur à l'utilisateur ou gérez l'erreur selon votre logique
  }
}

// Définissez la fonction onOptionSelected pour gérer la sélection des options dans MultiSelectDropDown

   final MultiSelectController _controllerTypeActeur = MultiSelectController();

  String password = "";
  String confirmPassword = "";
  
  String filiere = "";
    String idsJson = "" ;
  bool _obscureText = true;
    List<String> libelleCategorie = [];
    List<String> libelleSpeculation = [];
    List<String> typeLibelle = [];
   List<String> selectedCategoryIds = [];

   List<String> idsCategorieProduit = [];
String idsCategorieProduitAsString = "";
  
  String? image2Src;
  File? image2;

   String url = "";


    

        Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

   Future<File?> getImage(ImageSource source) async {
  final image = await ImagePicker().pickImage(source: source);
  if (image == null) return null;

  return File(image.path);
}

Future<void> _pickImage(ImageSource source) async {
  final image = await getImage(source);
  if (image != null) {
    setState(() {
      this.image2 = image;
      image2Src = image.path;
    });
  }
}
 
   Future<void> _showImageSourceDialog() async {
  final BuildContext context = this.context;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 150,
        child: AlertDialog(
          title: Text("Photo d'identité"),
          content: Wrap(
            alignment: WrapAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Fermer le dialogue
                  _pickImage(ImageSource.camera);
                },
                child: Column(
                  children: [
                    Icon(Icons.camera_alt, size: 40),
                    Text('Camera'),
                  ],
                ),
              ),
              const SizedBox(width:40),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Fermer le dialogue
                  _pickImage(ImageSource.gallery);
                },
                child: Column(
                  children: [
                    Icon(Icons.image, size: 40),
                    Text('Galerie photo'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  TextEditingController filiereController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

                       // Fonction pour afficher la boîte de dialogue de chargement
    void _handleButtonPress(BuildContext context) async {
    // Afficher l'indicateur de chargement
    setState(() {
      isLoading = true;
    });
      await registerUser(context).then((_) {
        // Cacher l'indicateur de chargement lorsque votre fonction est terminée
        setState(() {
          isLoading = false;
        });
      });
     
  }

   registerUser(BuildContext context) async {
   final nomActeur = widget.nomActeur;
        final emailActeur = widget.email;
        final adresse = widget.adresse;
        final telephone = widget.telephone;
        final whatsAppActeur = widget.numeroWhatsApp;
        final maillon = widget.maillon;
        final localisation = widget.localistaion;
        final  typeActeur = widget.typeActeur;
        final pays = widget.pays;
        final filiere = filiereController.text;
        final password = passwordController.text;
        final confirmPassword = confirmPasswordController.text;
        
                    if (password != confirmPassword) {
      
        // Gérez le cas où l'email ou le mot de passe est vide.
         const String errorMessage = "Les mot de passe ne correspondent pas ";
          // Gérez le cas où l'email ou le mot de passe est vide.
          showDialog(
            context:  context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Center(child: Text('Erreur', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                content:const  Text(errorMessage),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:const  Text('OK'),
                  ),
                ],
              );
            },
          );
        return;
      }
        // Utilize your backend service to send the request
        ActeurService acteurService = ActeurService();
         // Si widget.typeActeur est bien une liste de TypeActeur
      try {
      
            // String type = typeActeurList.toString();
        if(widget.image1 != null && image2 != null){
      
      await acteurService.creerActeur(
      logoActeur: widget.image1 as File,
      photoSiegeActeur: image2 as File,
      nomActeur: nomActeur,
      adresseActeur: adresse,
      telephoneActeur: telephone,
      whatsAppActeur: whatsAppActeur,
      niveau3PaysActeur: widget.pays,
      localiteActeur: localisation,
      emailActeur: emailActeur,
      filiereActeur: filiere,
      typeActeur: widget.typeActeur, // Convertir les IDs en chaînes de caractères
      password: password,
      maillonActeur: maillon,
        );
         showDialog(
            context:  context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Center(child: Text('Succès')),
                content:const  Text("Inscription réussi avec succès"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
       Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginSuccessScreen()),
        );                  },
                    child:const  Text('OK'),
                  ),
                ],
              );
            },
          );
        }else{
      await acteurService.creerActeur(
      nomActeur: nomActeur,
      adresseActeur: adresse,
      telephoneActeur: telephone,
      whatsAppActeur: whatsAppActeur,
      niveau3PaysActeur: widget.pays,
      localiteActeur: localisation,
      emailActeur: emailActeur,
      filiereActeur: filiere,
      typeActeur: typeActeur,
      password: password,
      maillonActeur: maillon,
        );
         showDialog(
            context:  context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Center(child: Text('Succès')),
                content:const  Text("Inscription réussi avec succès"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
       Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginSuccessScreen()),
        );                  },
                    child:const  Text('OK'),
                    
                  ),
                ],
              );
            },
          );
        }
       
        // print("Demande envoyée avec succès: ${updatedDemande.toString()}");
        debugPrint("yes ");
        // Navigate to the next page if necessary
      } catch (error) {
        // Handle any exceptions that might occur during the request
        final String errorMessage = error.toString();
        debugPrint("no " + errorMessage);
         showDialog(
        context: context,
        builder: (context) => AlertDialog(
      title: Text("Erreur lors de l'inscription"),
      content: Text(errorMessage),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
        ),
      );
        // print("Erreur: $error");
      } 
   }


    @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    debugPrint("Adresse : " + widget.adresse + " Maillon : " + widget.maillon + " Type : ${widget.typeActeur}"+
    " Localisation :  " + widget.localistaion + " Whats app : " + widget.numeroWhatsApp + "Email :" + widget.email
  
    );
    
  }


  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading:isLoading,
      child: Scaffold(
         backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                    SizedBox(height: 15,),
                Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   IconButton(
                 onPressed: () {
                   // Fonction de retour
                   Navigator.pop(context);
                 },
                 icon: Icon(
                   Icons.arrow_back,
                   color: Colors.black,
                   size: 30,
                 ),
                 iconSize: 30,
                 splashRadius: 20,
                 padding: EdgeInsets.zero,
                 constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                              ),
                 ],
                ),
                         Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Container(
        height:100,
        width: 200, // Spécifiez une largeur fixe pour le conteneur
        child: (image2 == null) ?
          Center(child: Image.asset('assets/images/logo-pr.png')) :
          SizedBox(
            height: 50,
            child: Image.file(
              image2!,
              height:100,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
      ),
        ],
      ),
             const SizedBox(height: 5,),
              GestureDetector(
                onTap: (){
                  _showImageSourceDialog();
                },
                child: Text("Choisir la photo du siège", style: TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold,
                        
                  ),
                  ),
              ),
               Form(
                 key:_formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const SizedBox(height: 10,),
   
 const SizedBox(height: 5,),
   Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Type Acteur", style: TextStyle(color: (Colors.black), fontSize: 18),),
                ),
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: MultiSelectDropDown.network(
    networkConfig: NetworkConfig(
      url: 'http://10.0.2.2:9000/api-koumi/typeActeur/read',
      method: RequestMethod.get,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
    chipConfig: const ChipConfig(wrapType: WrapType.wrap),
    responseParser: (response) {
      final list = (response as List<dynamic>)
          .where((data) =>
              (data as Map<String, dynamic>)['libelle']
                  .trim()
                  .toLowerCase() !=
              'admin')
          .map((e) {
        final item = e as Map<String, dynamic>;
        return ValueItem(
          label: item['libelle'] as String,
          value: item['idTypeActeur'],
        );
      }).toList();
      return Future.value(list);
    },
    controller: _controllerTypeActeur,
    hint: 'Sélectionner un type d\'acteur',
    fieldBackgroundColor: Color.fromARGB(255, 219, 219, 219),
    onOptionSelected: (options) {
      setState(() {
        typeLibelle.clear();
        typeLibelle.addAll(options
            .map((data) => data.label)
            .toList());
        print("Libellé sélectionné ${typeLibelle.toString()}");
      });
      // Fermer automatiquement le dialogue
      FocusScope.of(context).unfocus();
    },
    responseErrorBuilder: ((context, body) {
      return const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text('Aucun type disponible'),
      );
    }),
    // Exemple de personnalisation des styles
  ),
),

  const SizedBox(height: 5,),
      Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Categorie", style: TextStyle(color: (Colors.black), fontSize: 18),),
                ),
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: MultiSelectDropDown.network(
    networkConfig: NetworkConfig(
      url: 'http://10.0.2.2:9000/api-koumi/Categorie/allCategorie',
      method: RequestMethod.get,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
    chipConfig: const ChipConfig(wrapType: WrapType.wrap),
    responseParser: (response) {
      final list = (response as List<dynamic>)
          
          .map((e) {
        final item = e as Map<String, dynamic>;
        return ValueItem(
          label: item['libelleCategorie'] as String,
          value: item['idCategorieProduit'],
        );
      }).toList();
      return Future.value(list);
    },
    controller: _controllerCategorie,
    hint: 'Sélectionner une categorie produit',
    fieldBackgroundColor: Color.fromARGB(255, 219, 219, 219),
    onOptionSelected: (options) async{
      setState(() {
        libelleCategorie.clear();
        libelleCategorie.addAll(options
            .map((data) => data.label)
            .toList());
        idsCategorieProduit = _controllerCategorie.selectedOptions.map((item) => item.value.toString()).toList();
      //  idsCategorieProduitAsString = idsCategorieProduit.isEmpty ? idsCategorieProduit.join(',') : "e40ijxd5k0n0yrzj5f80";
           idsJson = idsCategorieProduit.join(',');
            //  url = "e40ijxd5k0n0yrzj5f80";
             url = 'http://10.0.2.2:9000/api-koumi/Speculation/by-categories/${idsJson}';


        print("categorie sélectionné ${libelleCategorie.toString()+ " speculationJson  "+ url }");
      });
      
  // print("id s "+ idsJson);
      // Fermer automatiquement le dialogue
      FocusScope.of(context).unfocus();
    },
    responseErrorBuilder: ((context, body) {
      return const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text('Aucun type disponible'),
      );
    }),
    // Exemple de personnalisation des styles
  ),
),

                
                     // Deuxième widget MultiSelectDropDown pour sélectionner les spéculations
        Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          "Spéculation",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
   Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: MultiSelectDropDown.network(
    networkConfig: NetworkConfig(
      // Endpoint pour récupérer les spéculations en fonction des catégories sélectionnées
      url:url , //e40ijxd5k0n0yrzj5f80,
      // url: 'http://10.0.2.2:9000/api-koumi/Speculation/by-categories/${idsCategorieProduit.join(',')}', //e40ijxd5k0n0yrzj5f80,
      method: RequestMethod.get,
      headers: {'Content-Type': 'application/json'},
    ),
    chipConfig: const ChipConfig(wrapType: WrapType.wrap),
    responseParser: (response) {
      final list = (response as List<dynamic>)
                .where((data) =>
              (data as Map<String, dynamic>)['statutSpeculation']== true)
          .map((e) {
            final item = e as Map<String, dynamic>;
            debugPrint("data " + item['nomSpeculation']);
            return ValueItem(
              label: item['nomSpeculation'] as String,
              value: item['idSpeculation'],
            );
          })
          .toList();
      return Future.value(list);
    },
    controller: _controllerSpeculation,
    hint: 'Sélectionner une spéculation',
    fieldBackgroundColor: Color.fromARGB(255, 219, 219, 219),
    onOptionSelected: (options) {
      setState(() {
        libelleSpeculation.clear();
        libelleSpeculation.addAll(options.map((data) => data.label).toList());
        print("Spéculation sélectionnée ${libelleSpeculation.toString()}");
      });
      // Fermer automatiquement le dialogue
      FocusScope.of(context).unfocus();
    },
    responseErrorBuilder: ((context, body) {
      return const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text('Aucune spéculation disponible'),
      );
    }),
    // Exemple de personnalisation des styles
  ),
),

                  // fin  filiere
                   const SizedBox(height: 10,),
                  // debut mot de passe
                   Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Mot de passe", style: TextStyle(color: (Colors.black), fontSize: 18),),
                ),
                // debut  mot de pass
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        // labelText: "Nouveau mot de passe",
                        hintText: "Entrez votre nouveau mot de passe",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText =
                                  !_obscureText; // Inverser l'état du texte masqué
                            });
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons
                                    .visibility, // Choisir l'icône basée sur l'état du texte masqué
                            color: Colors.grey,
                          ),
                        ),
                       
                        ),
                    keyboardType: TextInputType.text,
                    obscureText: _obscureText,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veillez entrez votre  mot de passe ";
                      }
                      if (val.length < 4) {
                        return 'Le mot de passe doit contenir au moins 4 caractères';
                      } 
                      else if (val.length > 4) {
                        return 'Le mot de passe ne doit pas 4 caractères';
                      } 
                       else {
                        return null;
                      }
                    },
                    onSaved: (val) => password = val!,
                  ),
                  // fin mot de pass 
          
                // confirm password 
                 const SizedBox(height: 10,),
                  // debut mot de passe
                   Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text("Confirm mot de passe", style: TextStyle(color: (Colors.black), fontSize: 18),),
                ),
                // debut  mot de pass
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Entrez votre confirmer votre mot de passe",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText =
                                  !_obscureText; // Inverser l'état du texte masqué
                            });
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons
                                    .visibility, // Choisir l'icône basée sur l'état du texte masqué
                            color: Colors.grey,
                          ),
                        ),
                        
                        ),
                    keyboardType: TextInputType.text,
                    obscureText: _obscureText,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veillez entrez votre  mot de passe à nouveau";
                      }
                      if (val.length < 4) {
                        return 'Le mot de passe doit contenir au moins 4 caractères';
                      } 
                      else if (val.length > 4) {
                        return 'Le mot de passe ne doit pas 4 caractères';
                      } 
                      else {
                        return null;
                      }
                    },
                    onSaved: (val) => password = val!,
                  ),
                  // fin mot de pass
      
                // fin confirm password 
      
                const SizedBox(height: 10,),
                  Center(
                    child: ElevatedButton(
      
              onPressed: 
              
        //       isLoading
        // ? null // Désactiver le bouton lorsque le chargement est en cours
        // :
         () async {
          // setState(() {
          //   isLoading = true; // Afficher le CircularProgressIndicator
          // });
          if(_formKey.currentState!.validate()){
      
       _handleButtonPress(context);
         }
                // Handle button press action here
              },
              child: Text(
                " Enregister ",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A00), // Orange color code
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: Size(250, 40),
              ),
            ),
                 ),
          
              ],
               )),
            
              ],
            ),
            
          ),
        ),
      ),
    );
  }
}