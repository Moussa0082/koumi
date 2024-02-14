import 'package:flutter/material.dart';
import 'package:koumi_app/Admin/AcceuilAdmin.dart';
import 'package:koumi_app/Admin/PanierA.dart';
import 'package:koumi_app/Admin/ProduitA.dart';
import 'package:koumi_app/Admin/ProfilA.dart';
import 'package:koumi_app/service/BottomNavigationService.dart';
import 'package:provider/provider.dart';

class BottomNavBarAdmin extends StatefulWidget {
  const BottomNavBarAdmin({super.key});

  @override
  State<BottomNavBarAdmin> createState() => _BottomNavBarAdminState();
}

const d_color = Color.fromRGBO(254, 243, 231, 1);
const d_colorPage = Color.fromRGBO(255, 255, 255, 1);
const d_colorOr = Color.fromRGBO(254, 243, 231, 1);

class _BottomNavBarAdminState extends State<BottomNavBarAdmin> {
  int activePageIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  List pages = <Widget>[
    const AcceuilAdmin(),
    const ProduitA(),
    const PanierA(),
    const ProfilA()
  ];

  void _changeActivePageValue(int index) {
    setState(() {
      activePageIndex = index;
    });
  }

  void _onItemTap(int index) {
    Provider.of<BottomNavigationService>(context, listen: false)
        .changeIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async {
    final isFirstRouteInCurrentTab =
        !await _navigatorKeys[activePageIndex].currentState!.maybePop();
    return isFirstRouteInCurrentTab;
  },

      child: Scaffold(
        backgroundColor: d_colorPage,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
        ),
        body: Consumer<BottomNavigationService>(
          builder: (context, bottomService, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _changeActivePageValue(bottomService.pageIndex);
            });
            return Stack(
              children: [
                _buildOffstageNavigator(0),
                _buildOffstageNavigator(1),
                _buildOffstageNavigator(2),
                _buildOffstageNavigator(3)
              ],
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 5.0,
          items: const [
            BottomNavigationBarItem(
              backgroundColor: d_color,
              icon: Icon(Icons.home_filled),
              label: "Accueil",
            ),
            BottomNavigationBarItem(
              backgroundColor: d_color,
              icon: Icon(Icons.agriculture),
              label: "Produit",
            ),
            BottomNavigationBarItem(
              backgroundColor: d_color,
              icon: Icon(Icons.shopping_cart),
              label: "Panier",
            ),
            BottomNavigationBarItem(
              backgroundColor: d_color,
              icon: Icon(Icons.person_pin),
              label: "Profil",
            ),
          ],
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.green[800],
          iconSize: 30,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(color: Colors.black),
          currentIndex: activePageIndex,
          onTap: _onItemTap,
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          const AcceuilAdmin(),
          const ProduitA(),
          const PanierA(),
          const ProfilA()
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: activePageIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name]!(context),
          );
        },
      ),
    );
  }
}
