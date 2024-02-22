import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:koumi_app/models/Acteur.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:provider/provider.dart';

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
  late Acteur acteur;

  @override
  void initState() {
    acteur = Provider.of<ActeurProvider>(context, listen: false).acteur!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Consumer<ActeurProvider>(
          builder: (context, acteurProvider, child) {
            final ac = acteurProvider.acteur;
            // debugPrint("appBar ${ac.toString()}");
            if (ac == null) {
              return const CircularProgressIndicator();
            }

            // List<TypeActeur> typeActeurData = ac.typeActeur;
            // List<String> typeActeurList =
            //     typeActeurData.map((data) => data.libelle).toList();
            // String type = typeActeurList.toString();

            List<TypeActeur> typeActeurData = ac.typeActeur;
            String type = typeActeurData.map((data) => data.libelle).join(', ');
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
                      image: NetworkImage("http:10.0.2.2/${ac.logoActeur}"),
                    ),
              title: Text(
                ac.nomActeur.toUpperCase(),
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
                position: badges.BadgePosition.topEnd(top: -2, end: -2),
                badgeContent: const Text(
                  "3",
                  style: TextStyle(color: Colors.white),
                ),
                child: const Icon(
                  Icons.notifications_none_outlined,
                  size: 40,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
