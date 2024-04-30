import 'package:flutter/material.dart';
import 'package:koumi_app/screens/Acceuil.dart';
import 'package:koumi_app/screens/Panier.dart';
import 'package:koumi_app/screens/Product.dart';
import 'package:koumi_app/screens/Produit.dart';
import 'package:koumi_app/screens/Profil.dart';
import 'package:koumi_app/service/BottomNavigationService.dart';
import 'package:provider/provider.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

const d_color = Color.fromRGBO(254, 243, 231, 1);
const d_colorPage = Color.fromRGBO(255, 255, 255, 1);
const d_colorOr = Color.fromRGBO(254, 243, 231, 1);

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int activePageIndex = 0;
  Future<bool> _onBackPressed() async {
    // Essayez de revenir en arrière dans la pile de navigation actuelle
    final NavigatorState? navigator =
        _navigatorKeys[activePageIndex].currentState;
    if (navigator != null && navigator.canPop()) {
      // S'il y a une page précédente, pop la page
      navigator.pop();
      return false; // Indiquez que l'événement de retour a été géré
    }
    return true; // Indiquez que l'application peut se fermer
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  List pages = <Widget>[
    const Accueil(),
    ProductScreen(),
    Panier(),
    const Profil()
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
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      Provider.of<BottomNavigationService>(context, listen: false)
          .changeIndex(0);
    });
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

      '/': (context) => pages[index],
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

  // Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
  //   return {
  //     '/': (context) {
  //       return [const Accueil(), ProduitScreen(), Panier(), const Profil()]
  //           .elementAt(index);
  //     },
  //   };
  // }

  // Widget _buildOffstageNavigator(int index) {
  //   var routeBuilders = _routeBuilders(context, index);

  //   return Offstage(
  //     offstage: activePageIndex != index,
  //     child: Navigator(
  //       key: _navigatorKeys[index],
  //       onGenerateRoute: (routeSettings) {
  //         return MaterialPageRoute(
  //           builder: (context) => routeBuilders[routeSettings.name]!(context),
  //         );
  //       },
  //     ),
  //   );
  // }
}
