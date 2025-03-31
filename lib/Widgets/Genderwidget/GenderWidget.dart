import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/View/Data/NewList/Newlist.dart';

final textStyle = GoogleFonts.poppins(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: Colors.white, // Changed to white for better visibility
);

Widget GenderWidget(String title, IconData icon, String imageUrl) {
  return InkWell(
    onTap: () {
      if(title.contains("Male")){
        Get.to(NewlistScreen(isFemale: false));
      }
      else{
        Get.to(NewlistScreen(isFemale:true));
      }
      // Handle tap
    },
    child: Center(
      child: Container(
        height: 200, // Increased height for better proportion
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(17), // Slightly smaller than container
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
            
              ),
            ),
            
            // Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.6, 1],
                ),
              ),
            ),
            
            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                
                Text(
                  title,
                  style: textStyle.copyWith(
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 6,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                const Gap(15),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
Widget CustomButton(GestureTapCallback ontap,String title){
  return  InkWell(
    onTap: ontap,
    child: Container(
    height: Get.height*0.1,
    width: Get.width*0.6,
    
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),  
    color: Colors.blue
    ),
    child:Center(
      child: Text(title,style: textStyle,),
    ),
     ),
  );
}
Widget CustomButton2(GestureTapCallback ontap,String title){
  return  InkWell(
    onTap: ontap,
    child: Container(
    height: Get.height*0.08,
    width: Get.width*0.5,
    
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),  
    color: Colors.blue
    ),
    child:Center(
      child: Text(title,style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.white
      ),),
    ),
     ),
  );
}