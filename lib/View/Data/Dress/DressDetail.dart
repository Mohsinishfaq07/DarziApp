// import 'package:flutter/material.dart';
// import 'package:tailor_app/Utils/models/DressModel.dart';
// import 'package:tailor_app/View/Data/SavedMeasures/Details.dart';

// class DressDetail extends StatelessWidget {
//   final DressModel dress;

//   const DressDetail({super.key, required this.dress});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("${dress.name}'s Dress Details")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Display Dress Color
//             Text("Color: ${dress.dressColor}", style: const TextStyle(fontSize: 18)),

//             // Display Booking Date
//             Text("Date: ${dress.bookDate.toLocal()}", style: const TextStyle(fontSize: 18)),

//             const SizedBox(height: 20),

//             // Button to view measurements, assuming they are always available
//             ElevatedButton(
//               onPressed: () {
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //     builder: (context) => DetailScreen(measurement: dress.measurements),
//                 //   ),
//                 // );
//               },
//               child: const Text("View Measurements"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
