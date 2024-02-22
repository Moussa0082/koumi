import 'package:flutter/material.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/LoginSuccessScreen.dart';
import 'package:koumi_app/providers/ParametreGProvider.dart';
import 'package:koumi_app/screens/SplashScreen.dart';
import 'package:koumi_app/service/ActeurService.dart';
import 'package:koumi_app/service/BottomNavigationService.dart';
import 'package:koumi_app/service/ParametreGenerauxService.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:koumi_app/service/TypeActeurService.dart';
import 'package:koumi_app/service/UniteService.dart';
import 'package:koumi_app/service/ZoneProductionService.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';
import 'package:provider/provider.dart';
 

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ActeurService()),
    ChangeNotifierProvider(create: (context) => TypeActeurService()),
    ChangeNotifierProvider(create: (context) => ActeurProvider()),
    ChangeNotifierProvider(create: (context) => StockService()),
    ChangeNotifierProvider(create: (context) => ParametreGenerauxService()),
    ChangeNotifierProvider(create: (context) => ParametreGProvider()),
    ChangeNotifierProvider(create: (context) => UniteService()),
    ChangeNotifierProvider(create: (context) => ZoneProductionService()),
    ChangeNotifierProvider(create: (context) => BottomNavigationService())
  ], child: const MyApp()));
}

// @override
//   void initState() {
//     super.initState();
//     checkUserSession(); // Appel de la fonction pour vérifier la session utilisateur
//   }

  // Future<void> checkUserSession() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? email = prefs.getString('emailActeur');
  //   String? password = prefs.getString('password');

  //   if (email != null && password != null) {
  //     // S'il existe des informations d'identification utilisateur dans les SharedPreferences, connectez automatiquement l'utilisateur
  //     // Utilisez votre méthode de connexion appropriée ici
  //     // Par exemple :
  //     // loginUser(email, password);
  //   } else {
  //     // Si aucune information d'identification utilisateur n'est trouvée, redirigez l'utilisateur vers l'écran de connexion
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  //   }
  // }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      routes: {
        '/BottomNavigationPage': (context) => const BottomNavigationPage()
      },
      home: const SplashScreen(),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:koumi_app/models/TypeActeur.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/LoginSuccessScreen.dart';
import 'package:koumi_app/providers/ParametreGProvider.dart';
import 'package:koumi_app/screens/SplashScreen.dart';
import 'package:koumi_app/service/ActeurService.dart';
import 'package:koumi_app/service/BottomNavigationService.dart';
import 'package:koumi_app/service/ParametreGenerauxService.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:koumi_app/service/TypeActeurService.dart';
import 'package:koumi_app/service/UniteService.dart';
import 'package:koumi_app/service/ZoneProductionService.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que les widgets Flutter sont initialisés

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // String? email = prefs.getString('emailActeur');
  // String? password = prefs.getString('password');

  runApp(MyApp(
    // email: email,
    // password: password,
  ));
}

class MyApp extends StatelessWidget {
  final String? email;
  final String? password;

  const MyApp({Key? key, this.email, this.password}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ActeurService()),
        ChangeNotifierProvider(create: (context) => TypeActeurService()),
        ChangeNotifierProvider(create: (context) => ActeurProvider()),
        ChangeNotifierProvider(create: (context) => StockService()),
        ChangeNotifierProvider(create: (context) => ParametreGenerauxService()),
        ChangeNotifierProvider(create: (context) => ParametreGProvider()),
        ChangeNotifierProvider(create: (context) => UniteService()),
        ChangeNotifierProvider(create: (context) => ZoneProductionService()),
        ChangeNotifierProvider(create: (context) => BottomNavigationService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        routes: {
          '/BottomNavigationPage': (context) => const BottomNavigationPage()
        },
        home:  const SplashScreen() ,
        // home: email != null && password != null ? const SplashScreen() : const BottomNavigationPage(),
      ),
    );
  }
}

*/