import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Utils/Service/AuthService.dart';
import 'package:tailor_app/View/Data/Dress/Saveddress.dart';
import 'package:tailor_app/View/Data/SavedMeasures/SavedScreen.dart';
import 'package:tailor_app/Widgets/Genderwidget/GenderWidget.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
 final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {
              _auth.logout(context);
            }, icon: Icon(Icons.logout,color: Colors.white,size: 30,)),
          )
        ],
        title: Text("New Entry"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Choose a Gender : ",style: textstyle,),
          Gap(50),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          GenderWidget("Male",Icons.person,"assets/men.webp"),
          Gap(20),
            GenderWidget("Female",Icons.person_2,"assets/female.jpg"),
            ],
          ),

          Gap(40),
          CustomButton(() {
            Get.to(SavedScreen());    
          },"Saved Entries"),
          Gap(10),
   CustomButton(() {
            Get.to(SavedDress());    
          },"Dresses"),

        ],
      ),
    );
  }
  
final textstyle=GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    );
}

 

