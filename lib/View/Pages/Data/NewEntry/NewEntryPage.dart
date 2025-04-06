// New Entry Page Widget
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Widgets/Genderwidget/GenderWidget.dart';

class NewEntryPage extends StatelessWidget {
  const NewEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("New Entry"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Choose a Gender : ",
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Gap(50),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GenderWidget("Male", Icons.person, "assets/men.webp"),
              Gap(20),
              GenderWidget("Female", Icons.person_2, "assets/female.webp"),
            ],
          ),
          Gap(40),
          // CustomButton(() {
          //   Get.to(SavedScreen());
          // }, "Saved Entries"),
          // Gap(10),
          // CustomButton(() {
          //   Get.to(SavedDress());
          // }, "Dresses"),
        ],
      ),
    );
  }
}
