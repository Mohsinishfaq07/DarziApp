// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:tailor_app/Utils/Provider/DressProvider.dart';
// import 'package:tailor_app/Utils/Provider/MeasurementsProvider.dart';
// import 'package:tailor_app/Utils/models/DressModel.dart';  // Ensure correct import here
// import 'package:tailor_app/Utils/models/clientmodel.dart';
// import 'package:tailor_app/Utils/Snackbar/Snackbar.dart';
// import 'package:tailor_app/View/Home/HomeScreen.dart';
// import 'package:tailor_app/Widgets/Genderwidget/GenderWidget.dart';

// class NewDress extends ConsumerStatefulWidget {
//   const NewDress({super.key});

//   @override
//   ConsumerState<NewDress> createState() => _NewDressState();
// }

// class _NewDressState extends ConsumerState<NewDress> {
//   final _nameController = TextEditingController();
//   final _numberController = TextEditingController();
//   final _colorController = TextEditingController();
//   DateTime? _selectedDate;
//   Measurement? _selectedMeasurement;

//   /// ✅ **Show Bottom Sheet for Existing Measurements**
//   void _showMeasurementSelector(List<Measurement> measurements) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent, // Makes the bottom sheet background transparent for custom design
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Select Measurement",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blueAccent,
//                 ),
//               ),
//               const Divider(),
//               ...measurements.map(
//                 (measure) => ListTile(
//                   title: Text("${measure.name} - ${measure.number}"),
//                   subtitle: Text("Chest: ${measure.chest}, Waist: ${measure.waist}"),
//                   onTap: () {
//                     setState(() {
//                       _selectedMeasurement = measure;
//                       _nameController.text = measure.name;
//                       _numberController.text = measure.number;
//                     });
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.add),
//                 title: const Text("New Measurement", style: TextStyle(fontSize: 18)),
//                 onTap: () {
//               Get.to(Homescreen());
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   /// ✅ **Save Dress & Link Measurements**
//   Future<void> _saveDress() async {
//     if (_nameController.text.isEmpty || _numberController.text.isEmpty) {
//       showSnackBar("Error", "Name & Number required");
//       return;
//     }

//     final dressNotifier = ref.read(dressProvider.notifier);

//     final dress = DressModel(
//       name: _nameController.text,
//       number: _numberController.text,
//       dressColor: _colorController.text,
//       dressPic: '',  // Image removed
//       bookDate: _selectedDate ?? DateTime.now(),
//        mea: _selectedMeasurement!,
//         , isCompleted: null,
//     );

//     await dressNotifier.addOrUpdateDress(dress);
//     showSnackBar("Success", "Dress details saved!");
//   }

//   @override
//   Widget build(BuildContext context) {
//     final measurementStream = ref.watch(measurementProvider);

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme:IconThemeData(color: Colors.white),
//         title:  Text("New Dress",style: GoogleFonts.poppins(
//           color: Colors.white,fontSize: 20,
//           fontWeight: FontWeight.bold
//         ),),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// **📌 Name Input**
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8, offset: Offset(0, 4))],
//               ),
//               child: TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: "Client Name",
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   border: InputBorder.none,
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ),

//             /// **📌 Number Input**
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8, offset: Offset(0, 4))],
//               ),
//               child: TextField(
//                 controller: _numberController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   labelText: "Client Number",
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   border: InputBorder.none,
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ),

//             /// **📌 Dress Color Input**
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8, offset: Offset(0, 4))],
//               ),
//               child: TextField(
//                 controller: _colorController,
//                 decoration: InputDecoration(
//                   labelText: "Dress Color",
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   border: InputBorder.none,
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ),

//             /// **📆 Date Picker**
//             TextButton(
//               onPressed: () async {
//                 final pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime(2100),
//                 );
//                 if (pickedDate != null) {
//                   setState(() => _selectedDate = pickedDate);
//                 }
//               },
           
//               child: Text(
//                 _selectedDate == null
//                     ? "Select Booking Date"
//                     : "Date: ${_selectedDate!.toLocal()}",
//                 style: const TextStyle(fontSize: 15, color: Colors.blueAccent),
//               ),
//             ),

//             const SizedBox(height: 10),

//             /// **📏 Link with Existing Measurement**
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _selectedMeasurement == null
//                         ? "No Measurement Linked"
//                         : "${_selectedMeasurement!.name} - ${_selectedMeasurement!.number}",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   Gap(20),
//               CustomButton2(() {
//                            measurementStream.whenData((measurements) {
//                         _showMeasurementSelector(measurements);
//                       });
//               }, "Link Measurements"),
//                           const SizedBox(height: 20),
// CustomButton2(() {
//   _saveDress();
// }, "Save Dress"),
      
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
