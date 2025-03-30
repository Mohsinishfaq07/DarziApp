import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Utils/Provider/MeasurementsProvider.dart';
import 'package:tailor_app/View/Data/NewList/Newlist.dart';
import 'package:tailor_app/View/Data/SavedMeasures/Details.dart';
import 'package:tailor_app/View/Home/HomeScreen.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurementList = ref.watch(measurementProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Get.to(Homescreen());
      },child: Icon(Icons.add,color: Colors.orange,),),
      appBar: AppBar(
        title: Text(
          "Saved Measurements",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: measurementList.when(
        data: (measurements) {
          if (measurements.isEmpty) {
            return Center(
              child: Text(
                "No saved data",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: measurements.length,
            itemBuilder: (context, index) {
              final measurement = measurements[index];

              return Card(
                
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  
                  onTap: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(measurement: measurement),
                            ),
                          );
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      measurement.name[0].toUpperCase(),
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                  title: Text(
                    measurement.name,
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "📞 ${measurement.number}",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(measurement: measurement),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmation(context, ref, measurement.number);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error loading data")),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, String number) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Measurement", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to delete this measurement?", style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey.shade700)),
          ),
          TextButton(
            onPressed: () {
              ref.read(measurementRepositoryProvider).deleteMeasurement(number);
              Navigator.pop(context);
            },
            child: Text("Delete", style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
