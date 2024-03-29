import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:koumi_app/Admin/AcceuilAdmin.dart';
import 'package:koumi_app/Admin/ProduitA.dart';
import 'package:koumi_app/Admin/ProfilA.dart';
import 'package:koumi_app/screens/Panier.dart';
import 'package:koumi_app/screens/Produit.dart';
import 'package:koumi_app/screens/Transport.dart';
import 'package:koumi_app/service/BottomNavigationService.dart';
import 'package:provider/provider.dart';

class BottomNavBarAdmin extends StatefulWidget {
  const BottomNavBarAdmin({super.key});

  @override
  State<BottomNavBarAdmin> createState() => _BottomNavBarAdminState();
  static final GlobalKey<_BottomNavBarAdminState> navBarKey =
      GlobalKey<_BottomNavBarAdminState>();


}

const d_color = Color.fromRGBO(254, 243, 231, 1);
const d_colorPage = Color.fromRGBO(255, 255, 255, 1);
const d_colorOr = Color.fromRGBO(254, 243, 231, 1);

class _BottomNavBarAdminState extends State<BottomNavBarAdmin> {
  int activePageIndex = 0;

   PageController _pageController = PageController();
  int selectedPage = 0;
  // void _onBackPressed(bool isBackPressed) async {
  //   if (!isBackPressed) {
  //     // Essayez de revenir en arrière dans la pile de navigation actuelle
  //     final NavigatorState? navigator =
  //         _navigatorKeys[activePageIndex].currentState;
  //     if (navigator != null && navigator.canPop()) {
  //       // S'il y a une page précédente, pop la page
  //       navigator.pop();
  //     }
  //   }
  // }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  List pages = <Widget>[
    const AcceuilAdmin(),
    ProfilA(),
    Panier(),
    const ProfilA()
  ];

  void _changeActivePageValue(int index) {
    setState(() {
      activePageIndex = index;
    });
  }


  void resetIndex(int index) {
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
        _pageController = PageController(initialPage: activePageIndex);

    Future.microtask(() {
      Provider.of<BottomNavigationService>(context, listen: false)
          .changeIndex(0);
    });
   
  }
  @override
  void dispose() {
    super.dispose();

   _pageController.dispose();
      
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          const AcceuilAdmin(),
          ProfilA(),
          Panier(),
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


  Widget buildPageView(){
    return SizedBox(
      // height:MediaQuery.of(context).size.height,
      height:MediaQuery.of(context).size.height * 0.90,
      child: PageView(
        children: [
          const AcceuilAdmin(),
            const ProduitA(),
             Panier(),
            const ProfilA()
        ],
      ),
    );
  }
}
