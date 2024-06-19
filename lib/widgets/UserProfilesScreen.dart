import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/widgets/BottomNavBarAdmin.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilesScreen extends StatefulWidget {
  @override
  _UserProfilesScreenState createState() => _UserProfilesScreenState();
}

class _UserProfilesScreenState extends State<UserProfilesScreen> {
  List<Map<String, String>> users = [];
    // String enteredPin = '';
  bool isLoading= false;
  
   late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? userList = prefs.getStringList('users');
    if (userList != null) {
      setState(() {
        users = userList.map((user) {
          List<String> userData = user.split('|');
          return {'nomActeur': userData[0], 'codeActeur': userData[1]};
        }).toList();
      });
    }
  }

  void _loginUser(String codeActeur) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('codeActeur', codeActeur);
    // Appeler la méthode de connexion après avoir enregistré le codeActeur
    await loginUser();
  }


  Future<void> loginUser() async {
    const String baseUrl = '$apiOnlineUrl/acteur/codeAndNomActeurLogin';
    const String defaultProfileImage = 'assets/images/profil.jpg';

    ActeurProvider acteurProvider =
        Provider.of<ActeurProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();

    String? codeActeur = prefs.getString('codeActeur');
    String? nomActeur = prefs.getString('nomActeur');

    if (codeActeur == null || codeActeur.isEmpty || nomActeur == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Erreur')),
            content: const Text(
              "Une erreur s'est produite veuillez réessayer plus tard",
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final Uri apiUrl = Uri.parse('$baseUrl?codeActeur=$codeActeur&nomActeur=$nomActeur');

    try {
      final response = await http.get(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));

        final password = responseBody['password'];
        final emailActeur = responseBody['emailActeur'];
        prefs.setString('emailActeur', emailActeur);
        prefs.setString('password', password);
        final nomActeur = responseBody['nomActeur'];
        final idActeur = responseBody['idActeur'];
        final adresseActeur = responseBody['adresseActeur'];
        final telephoneActeur = responseBody['telephoneActeur'];
        final whatsAppActeur = responseBody['whatsAppActeur'];
        final niveau3PaysActeur = responseBody['niveau3PaysActeur'];
        final localiteActeur = responseBody['localiteActeur'];

        prefs.setString('nomActeur', nomActeur);
        prefs.setString('idActeur', idActeur);
        prefs.setString('adresseActeur', adresseActeur);
        prefs.setString('telephoneActeur', telephoneActeur);
        prefs.setString('whatsAppActeur', whatsAppActeur);
        prefs.setString('niveau3PaysActeur', niveau3PaysActeur);
        prefs.setString('localiteActeur', localiteActeur);

        List<dynamic> typeActeurData = responseBody['typeActeur'];
        List<TypeActeur> typeActeurList =
            typeActeurData.map((data) => TypeActeur.fromMap(data)).toList();
        List<String> userTypeLabels =
            typeActeurList.map((typeActeur) => typeActeur.libelle!).toList();
        prefs.setStringList('userType', userTypeLabels);

        Acteur acteur = Acteur(
          idActeur: responseBody['idActeur'],
          nomActeur: responseBody['nomActeur'],
          adresseActeur: responseBody['adresseActeur'],
          telephoneActeur: responseBody['telephoneActeur'],
          whatsAppActeur: responseBody['whatsAppActeur'],
          dateAjout: responseBody['dateAjout'],
          localiteActeur: responseBody['localiteActeur'],
          emailActeur: emailActeur,
          statutActeur: responseBody['statutActeur'],
          typeActeur: typeActeurList,
          password: password,
        );

        acteurProvider.setActeur(acteur);

        final List<String> type =
            acteur.typeActeur!.map((e) => e.libelle!).toList();
        if (type.contains('admin') || type.contains('Admin')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBarAdmin()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigationPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text("Code pin incorrecte")),
            duration: Duration(seconds: 2),
          ),
        );
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final errorMessage = responseBody['message'];
        print(errorMessage);
      }
    } catch (e) {
      debugPrint(e.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Erreur')),
            content: const Text(
              "Une erreur s'est produite veuillez vérifier votre connexion internet",
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choisissez un profil')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profil.jpg'),
              ),
              title: Text(users[index]['nomActeur']!),
              onTap: () {
                _loginUser(users[index]['codeActeur']!);
              },
            ),
          );
        },
      ),
    );
  }
}
