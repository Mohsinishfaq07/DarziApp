import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/View/Pages/Data/Add%20Measurements/AddMeasurements.dart';
import 'package:tailor_app/View/Pages/Data/NewEntry/NewEntryPage.dart';

Widget GenderWidget(String title, IconData icon, String imageUrl) {
  return InkWell(
    onTap: () {
      if (title.contains("Male")) {
        Get.to(AddMeasurementScreen(isFemale: false));
      } else {
        Get.to(AddMeasurementScreen(isFemale: true));
      }
    },
    child: Center(
      child: Container(
        height: 220, // Increased height for better proportion
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(imageUrl, fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  stops: const [0.6, 1],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: textStyle.copyWith(
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 8,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget CustomButton(GestureTapCallback ontap, String title) {
  return InkWell(
    onTap: ontap,
    child: Container(
      height: Get.height * 0.12,
      width: Get.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

Widget CustomButton2(GestureTapCallback ontap, String title) {
  return InkWell(
    onTap: ontap,
    child: Container(
      height: Get.height * 0.08,
      width: Get.width * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue,
      ),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
