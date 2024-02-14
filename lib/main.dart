import 'package:flutter/material.dart';
import 'package:koumi_app/providers/ActeurProvider.dart';
import 'package:koumi_app/screens/SplashScreen.dart';
import 'package:koumi_app/service/BottomNavigationService.dart';
import 'package:koumi_app/service/StockService.dart';
import 'package:koumi_app/service/TypeActeurService.dart';
import 'package:koumi_app/service/ZoneProductionService.dart';
import 'package:koumi_app/widgets/BottomNavigationPage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ActeurService()),
    ChangeNotifierProvider(create: (context) => ActeurProvider()),
    ChangeNotifierProvider(create: (context) => StockService()),
    ChangeNotifierProvider(create: (context) => ZoneProductionService()),
    ChangeNotifierProvider(create: (context) => BottomNavigationService())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/BottomNavigationPage': (context) => const BottomNavigationPage()
      },
      home: const SplashScreen(),
    );
  }
}
