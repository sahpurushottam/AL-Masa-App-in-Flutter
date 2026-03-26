// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:ai_masa/myScreen/Mainpage.dart';
import 'package:ai_masa/splashScreen/OnboardingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ai_masa/global/Global.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // VersionCheck.checkForUpdate(context);
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (context.mounted) {
    //     VersionCheck.checkForUpdate(context);
    //   }
    // });
    starttimer();
  }

  starttimer() {
    Timer(Duration(seconds: 1), () async {
      String? token = await storage.read(key: 'distributor_access_token');
      //print(token);
      if (token != null) {
        app_auth_token = token;
        //print('App Auth Tokrn $app_auth_token');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        // No token found, navigate to LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 200,
                child: Image.asset('assets/img/logo.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
