import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
titleTextStyle: GoogleFonts.poppins(
  fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold
),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(child: Column(children: [
        
      ])),
    );
  }
}
