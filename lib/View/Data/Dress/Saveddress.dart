import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Utils/Provider/DressProvider.dart';
import 'package:tailor_app/Utils/Snackbar/Snackbar.dart';
import 'package:tailor_app/View/Data/Dress/NewDress.dart';
import 'package:tailor_app/View/Data/Dress/DressDetail.dart';

class SavedDress extends ConsumerWidget {
  const SavedDress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dressList = ref.watch(dressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Saved Dresses",
          style: GoogleFonts.poppins(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: dressList.when(
        data: (dresses) {
          if (dresses.isEmpty) {
            return Center(
              child: Text(
                "No saved dresses",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: dresses.length,
            itemBuilder: (context, index) {
              final dress = dresses[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: dress.isCompleted ? Colors.grey.shade50 : Colors.white,
                child: ListTile(
                  onTap: () => Get.to(DressDetail(dress: dress)),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, 
                    vertical: 12
                  ),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: dress.isCompleted 
                            ? Colors.grey.shade300 
                            : Colors.blue.shade100,
                        child: Text(
                          dress.name[0].toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold, 
                            color: dress.isCompleted ? Colors.grey : Colors.blue,
                            decoration: dress.isCompleted 
                                ? TextDecoration.lineThrough 
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      if (dress.isCompleted)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check, 
                              size: 12, 
                              color: Colors.white
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    dress.name,
                    style: GoogleFonts.poppins(
                      fontSize: 18, 
                      fontWeight: FontWeight.w600,
                      decoration: dress.isCompleted 
                          ? TextDecoration.lineThrough 
                          : TextDecoration.none,
                      color: dress.isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    "Color: ${dress.dressColor} | 📅 ${dress.bookDate.toLocal().toString().split(" ")[0]}",
                    style: GoogleFonts.poppins(
                      fontSize: 14, 
                      color: dress.isCompleted ? Colors.grey : Colors.grey.shade700,
                      decoration: dress.isCompleted 
                          ? TextDecoration.lineThrough 
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: dress.isCompleted,
                        onChanged: (bool? newValue) {
                          ref.read(dressProvider.notifier)
                              .toggleCompletion(dress.number, newValue ?? false);
                              if(newValue==true){
showSnackBar("Dress Status", "Dress Completed");
                              }
                              else{
                                showSnackBar("Dress Status", "Dress Incomplete");
                              }
                        },
                        activeColor: Colors.green,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit, 
                          color: dress.isCompleted ? Colors.grey : Colors.blue
                        ),
                        onPressed: () {
                             Get.to(DressDetail(dress: dress));
                              },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete, 
                          color: dress.isCompleted ? Colors.grey : Colors.red
                        ),
                        onPressed: dress.isCompleted 
                            ? null 
                            : () => _showDeleteConfirmation(context, ref, dress.number),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            "Error loading dresses",
            style: GoogleFonts.poppins(
              fontSize: 18, 
              fontWeight: FontWeight.w500, 
              color: Colors.red
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(const NewDress()),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, String number) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Dress"),
        content: const Text("Are you sure you want to delete this dress?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancel")
          ),
          TextButton(
            onPressed: () {
              ref.read(dressProvider.notifier).removeDress(number);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}