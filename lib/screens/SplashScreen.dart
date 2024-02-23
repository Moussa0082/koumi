
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:koumi_app/screens/LoginScreen.dart';
import 'package:koumi_app/screens/RegisterScreen.dart';
import 'package:koumi_app/widgets/AnimatedBackground.dart';

import 'package:koumi_app/widgets/BottomNavigationPage.dart';

import 'package:koumi_app/widgets/AnimatedBackground.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
const d_colorPage = Color.fromRGBO(255, 255, 255, 1);

class _SplashScreenState extends State<SplashScreen> {


   @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(
     const  Duration(seconds:5), 
      () =>
      Navigator.of(context).pushReplacement(
      MaterialPageRoute(

      builder: (_) =>  LoginScreen()      


      ),
      ),
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: d_colorPage,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
         const  AnimatedBackground(),
        const SizedBox(height:10),
          Center(child: Image.asset('assets/images/logo.png', height: 350, width: 250,)),
         CircularProgressIndicator(
          backgroundColor: (Color.fromARGB(255, 245, 212, 169)),
          color: (Colors.orange),
         ),
        ],
      ),
    );
  }
}