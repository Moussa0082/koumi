import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:profile_photo/profile_photo.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            leading: ProfilePhoto(
              totalWidth: 50,
              cornerRadius: 50,
              color: Colors.black,
              image: const AssetImage('assets/images/profil.jpg'),
            ),
            title: const Text(
              "Ibrahim sy",
              style: TextStyle(
                  color: d_colorGreen,
                  fontSize: 22,
                  fontWeight: FontWeight.w800),
            ),
            subtitle: const Text(
              "Administrateur",
              style: TextStyle(
                  color: d_colorOr, fontSize: 18, fontWeight: FontWeight.w400),
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
          )),
    );
  }
}
