import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/api/firebase_api.dart';
import 'package:koumi_app/firebase_options.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/providers/CartProvider.dart';
import 'package:koumi_app/providers/ParametreGenerauxProvider.dart';
import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/screens/SplashScreen.dart';
import 'package:koumi_app/service/ActeurService.dart';
import 'package:koumi_app/service/AlerteService.dart';
import 'package:koumi_app/service/BottomNavigationService.dart';
import 'package:koumi_app/service/CampagneService.dart';
import 'package:koumi_app/service/CategorieService.dart';
import 'package:koumi_app/service/CommandeService.dart';
import 'package:koumi_app/service/ConseilService.dart';
import 'package:koumi_app/service/ContinentService.dart';
import 'package:koumi_app/service/FiliereService.dart';
import 'package:koumi_app/service/FormeService.dart';
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
import 'package:koumi_app/widgets/connection_verify.dart';
import 'package:koumi_app/widgets/notification_controller.dart';
import 'package:koumi_app/controller/dependency_injection.dart';
import 'package:provider/provider.dart';

// final navigatorKey = GlofbalKey<NavigatorState>();


void main() async {
    // WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // await FirebaseApi().initNotification();
  // await AwesomeNotifications().initial ize(
  //    'resource://@drawable/launcher_icon',
  //   [
  //   Not
  //       channelGroupKey: "basic_channel_group",
  //       channelKey: "basic_channel",
  //       channelName: "Basic Notification",
  //       channelDescription: "Basic notifications channel",
  //       defaultRingtoneType: DefaultRingtoneType.Notification,
  //     playSound: true,
  //     enableVibration: true,
  //     importance: NotificationImportance.High,
  //     ledColor: Colors.white,
  //     ledOnMs: 1000,
  //     ledOffMs: 500,
  //   ),

  // ], channelGroups: [
  //   NotificationChannelGroup(
  //       channelGroupKey: "basic_channel_group", channelGroupName: "Basic group")
  // ]);
  // bool isAllowedToSendNotif =
  //     await AwesomeNotifications().isNotificationAllowed();
  // if (isAllowedToSendNotif) {
  //   AwesomeNotifications().requestPermissionToSendNotifications();
  // }
  // await AwesomeNotifications().createNotification(
  //   content:NotificationContent(
  //     id: 1,
  //     channelKey: 'basic_channel',
  //     title: 'Notification programmée',
  //     body: 'Cette notification est déclenchée à une heure précise.',
  //       // icon: '@drawable/launcher_icon'
  //     ),
  //     schedule: NotificationCalendar(
  //       second: 10,
  //       allowWhileIdle: true
  //     )
  //   );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MagasinService()),
    ChangeNotifierProvider(create: (context) => CommandeService()),
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
    ChangeNotifierProvider(create: (context) => FormeService()),
    ChangeNotifierProvider(create: (context) => BottomNavigationService())
  ], child: MyApp()));
    // DependencyInjection.init();
  // Get.put(ConnectionVerify(), permanent: true);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //  late ConnectionVerify connectionVerify;
  @override
  void initState() {
    // AwesomeNotifications().setListeners(
    //     onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    //     onNotificationCreatedMethod:
    //         NotificationController.onNotificationCreateMethod,
    //     onDismissActionReceivedMethod:
    //         NotificationController.onDismissActionReceivedMethod,
    //     onNotificationDisplayedMethod:
    //         NotificationController.onNotificationDisplayMethod);
    //  connectionVerify = Get.put(ConnectionVerify(), permanent: true);
    super.initState();
  }

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
      //  home:  ItemScreen(),
      home: const SplashScreen(), 
    );
  }
}
