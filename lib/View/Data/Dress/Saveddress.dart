// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tailor_app/Utils/Provider/DressProvider.dart';
// import 'package:tailor_app/View/Data/Dress/NewDress.dart';
// import 'package:tailor_app/View/Data/Dress/DressDetail.dart';
// import 'package:tailor_app/Utils/models/DressModel.dart';

// class SavedDress extends ConsumerWidget {
//   const SavedDress({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final dressList = ref.watch(dressProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Saved Dresses",
//           style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: Colors.blue,
//         centerTitle: true,
//       ),
//       body: dressList.when(
//         data: (dresses) {
//           if (dresses.isEmpty) {
//             return Center(
//               child: Text(
//                 "No saved dresses",
//                 style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//             );
//           }
//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: dresses.length,
//             itemBuilder: (context, index) {
//               final dress = dresses[index];

//               return Card(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 elevation: 3,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 child: ListTile(
//                   onTap: () {
//                     Get.to(DressDetail(dress: dress));
//                   },
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.blue.shade100,
//                     child: Text(
//                       dress.name[0].toUpperCase(),
//                       style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
//                     ),
//                   ),
//                   title: Text(
//                     dress.name,
//                     style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                   subtitle: Text(
//                     "Color: ${dress.dressColor} | 📅 ${dress.bookDate.toLocal().toString().split(" ")[0]}",
//                     style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700),
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       /// ✅ **Checkbox for Completion**
// // Checkbox(
// //   value: dress.is, // ✅ Correct field
// //   onChanged: (bool? newValue) {
// //     ref.read(dressProvider.notifier).toggleCompletionStatus(dress.number, newValue ?? false);
// //   },
// //   activeColor: Colors.green,
// // ),

//                       IconButton(
//                         icon: Icon(Icons.edit, color: Colors.blue),
//                         onPressed: () {
//                           // Add edit logic if required
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.delete, color: Colors.red),
//                         onPressed: () {
//                           _showDeleteConfirmation(context, ref, dress.number);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(
//           child: Text(
//             "Error loading dresses",
//             style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.red),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const NewDress()),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   /// ✅ **Delete Confirmation Dialog**
//   void _showDeleteConfirmation(BuildContext context, WidgetRef ref, String number) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Delete Dress"),
//         content: Text("Are you sure you want to delete this dress?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//           TextButton(
//             onPressed: () {
//               ref.read(dressProvider.notifier).removeDress(number);
//               Navigator.pop(context);
//             },
//             child: Text("Delete", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }
