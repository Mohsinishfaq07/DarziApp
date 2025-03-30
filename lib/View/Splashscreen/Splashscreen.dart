import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/View/Home/HomeScreen.dart';
import 'package:tailor_app/View/Login/LoginScreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     final FirebaseAuth _auth = FirebaseAuth.instance;
        Future.delayed(Duration(seconds: 3), () {
      if(_auth.currentUser!=null){
  Get.offAll(Homescreen());
     }
     else{
  Get.offAll(LoginScreen());
     }

    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(Icons.accessibility, color: Colors.orange, size: 150),
            Gap(20),
            Text(
              "Tailor App",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: .5,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Gap(60),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
