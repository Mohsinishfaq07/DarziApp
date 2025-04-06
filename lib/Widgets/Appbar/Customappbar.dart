import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar CustomAppbar(String title) {
  return AppBar(
    title: Text(title),
    backgroundColor: Colors.blue,
    centerTitle: true,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
}
