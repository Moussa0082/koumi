import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/Admin/NotificationPage.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/MessageWa.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/service/BottomNavigationService.dart';
import 'package:koumi_app/service/MessageService.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(150.0);
}

const d_colorGreen = Color.fromRGBO(43, 103, 6, 1);
const d_colorOr = Color.fromRGBO(255, 138, 0, 1);

class _CustomAppBarState extends State<CustomAppBar> {
  late Acteur acteur = Acteur();
  List<MessageWa> messageList = [];
  String? email = "";
  bool isExist = false;
  void verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('emailActeur');
    if (email != null) {
      // Si l'email de l'acteur est présent, exécute checkLoggedIn
      acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
      setState(() {
        isExist = true;
      });
    } else {
      setState(() {
        isExist = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Vérifiez si acteur est non nul avant de l'attribuer à la variable locale
    // if (Provider.of<ActeurProvider>(context, listen: false).acteur != null) {
    verify();

    // }
    // debugPrint("Acteur : ${acteur.nomActeur}");
  }

  @override
  Widget build(BuildContext context) {
    return !isExist
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Koumi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold, // Ajout d'un style de police en gras
                    color: Colors.black, // Ajout d'une couleur de texte
                  ),
                ),
                IconButton(
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
                  icon: Icon(
                    Icons.login,
                    color: d_colorGreen, // Ajout d'une couleur à l'icône
                    size: 30, // Ajout d'une taille à l'icône
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Consumer<ActeurProvider>(
                builder: (context, acteurProvider, child) {
                  final ac = acteurProvider.acteur;
                  if (ac == null) {
                    return SizedBox();
                  }

                  List<TypeActeur> typeActeurData = ac.typeActeur!;
                  String type =
                      typeActeurData.map((data) => data.libelle).join(', ');
                  return ListTile(
                    leading: ac.logoActeur == null || ac.logoActeur!.isEmpty
                        ? ProfilePhoto(
                            totalWidth: 50,
                            cornerRadius: 50,
                            color: Colors.black,
                            image: const AssetImage('assets/images/profil.jpg'),
                          )
                        : ProfilePhoto(
                            totalWidth: 50,
                            cornerRadius: 50,
                            color: Colors.black,
                            image:
                                NetworkImage("http:10.0.2.2/${ac.logoActeur}"),
                          ),
                    title: Text(
                      ac.nomActeur!.toUpperCase(),
                      style: const TextStyle(
                          color: d_colorGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      type,
                      style: const TextStyle(
                          color: d_colorOr,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    trailing: badges.Badge(
                      position: badges.BadgePosition.topEnd(top: -8, end: -1),
                      badgeContent:
                          Consumer(builder: (context, messageService, child) {
                        return FutureBuilder(
                            future: MessageService()
                                .fetchMessageByActeur(ac.idActeur!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("0",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ));
                              }

                              if (!snapshot.hasData) {
                                return Text("0",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ));
                              } else {
                                messageList = snapshot.data!;
                                return Text(
                                  messageList.length.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                );
                              }
                            });
                      }),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationPage()));
                        },
                        child: Icon(
                          Icons.notifications_none_outlined,
                          size: 40,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
// Text(
//                   "3",
//                   style: TextStyle(color: Colors.white),
//                 )