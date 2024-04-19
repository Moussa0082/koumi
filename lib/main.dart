import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/Admin/NotificationPage.dart';
import 'package:koumi_app/api/firebase_api.dart';
import 'package:koumi_app/firebase_options.dart';
import 'package:koumi_app/models/CartItem.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/CartProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/screens/AddAndUpdateProductEndScreen.dart';
import 'package:koumi_app/screens/AddAndUpdateProductScreen.dart';
import 'package:koumi_app/screens/PinLoginScreen.dart';
import 'package:koumi_app/screens/SplashScreen.dart';
import 'package:koumi_app/screens/Weather.dart';
import 'package:koumi_app/service/ActeurService.dart';
import 'package:koumi_app/service/AlerteService.dart';
import 'package:koumi_app/service/BottomNavigationService.dart';
import 'package:koumi_app/service/CampagneService.dart';
import 'package:koumi_app/service/CategorieService.dart';
import 'package:koumi_app/service/ConseilService.dart';
import 'package:koumi_app/service/ContinentService.dart';
import 'package:koumi_app/service/FiliereService.dart';
import 'package:koumi_app/service/IntrantService.dart';
import 'package:koumi_app/service/MagasinService.dart';
import 'package:koumi_app/service/MaterielService.dart';
import 'package:koumi_app/service/MessageService.dart';
import 'package:koumi_app/service/Niveau1Service.dart';
import 'package:koumi_app/service/Niveau2Service.dart';
import 'package:koumi_app/service/Niveau3Service.dart';
import 'package:koumi_app/service/ParametreFicheService.dart';
import 'package:koumi_app/service/ParametreGenerauxService.dart';
import 'package:koumi_app/service/PaysService.dart';
import 'package:koumi_app/service/SousRegionService.dart';
import 'package:koumi_app/service/SpeculationService.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:koumi_app/service/SuperficieService.dart';
import 'package:koumi_app/service/TypeActeurService.dart';
import 'package:koumi_app/service/TypeMaterielService.dart';
import 'package:koumi_app/service/TypeVoitureService.dart';
import 'package:koumi_app/service/UniteService.dart';
import 'package:koumi_app/service/VehiculeService.dart';
import 'package:koumi_app/service/ZoneProductionService.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';
import 'package:provider/provider.dart';

// final navigatorKey = GlofbalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MagasinService()),
    ChangeNotifierProvider(create: (context) => CartProvider()),
    ChangeNotifierProvider(create: (context) => ActeurService()),
    ChangeNotifierProvider(create: (context) => TypeActeurService()),
    ChangeNotifierProvider(create: (context) => ActeurProvider()),
    ChangeNotifierProvider(create: (context) => StockService()),
    ChangeNotifierProvider(create: (context) => ParametreGenerauxService()),
    ChangeNotifierProvider(create: (context) => ParametreGenerauxProvider()),
    ChangeNotifierProvider(create: (context) => UniteService()),
    ChangeNotifierProvider(create: (context) => ParametreFicheService()),
    ChangeNotifierProvider(create: (context) => ZoneProductionService()),
    ChangeNotifierProvider(create: (context) => PaysService()),
    ChangeNotifierProvider(create: (context) => ConseilService()),
    ChangeNotifierProvider(create: (context) => TypeMaterielService()),
    ChangeNotifierProvider(create: (context) => SuperficieService()),
    ChangeNotifierProvider(create: (context) => AlertesService()),
    ChangeNotifierProvider(create: (context) => IntrantService()),
    ChangeNotifierProvider(create: (context) => TypeVoitureService()),
    ChangeNotifierProvider(create: (context) => CampagneService()),
    ChangeNotifierProvider(create: (context) => TypeVoitureService()),
    ChangeNotifierProvider(create: (context) => TypeMaterielService()),
    ChangeNotifierProvider(create: (context) => TypeVoitureService()),
    ChangeNotifierProvider(create: (context) => MessageService()),
    ChangeNotifierProvider(create: (context) => MaterielService()),
    ChangeNotifierProvider(create: (context) => VehiculeService()),
    ChangeNotifierProvider(create: (context) => ContinentService()),
    ChangeNotifierProvider(create: (context) => CategorieService()),
    ChangeNotifierProvider(create: (context) => SpeculationService()),
    ChangeNotifierProvider(create: (context) => SousRegionService()),
    ChangeNotifierProvider(create: (context) => Niveau1Service()),
    ChangeNotifierProvider(create: (context) => Niveau2Service()),
    ChangeNotifierProvider(create: (context) => FiliereService()),
    ChangeNotifierProvider(create: (context) => Niveau3Service()),
    ChangeNotifierProvider(create: (context) => BottomNavigationService())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade400),
        useMaterial3: true,
      ),
      // navigatorKey: navigatorKey,
      routes: {
        '/BottomNavigationPage': (context) => const BottomNavigationPage(),
        // '/notificationPage':(context) =>  NotificationPage(),
      },
      home: const SplashScreen(),
    );
  }
}
