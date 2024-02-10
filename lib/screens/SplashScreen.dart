
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:koumi_app/screens/RegisterScreen.dart';
import 'package:koumi_app/widgets/AnimatedBackground.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


   @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Timer(
    //  const  Duration(seconds:2), 
    //   () =>
    //   Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //   builder: (_) => const RegisterScreen()      
    //   ),
    //   ),
    //  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
        //  const  AnimatedBackground(),
        const SizedBox(height:30, ),
          Center(child: Image.asset('assets/images/logo.png', height: 350, width: 250,))
        ],
      ),
    );
  }
}