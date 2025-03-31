import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Utils/Provider/MeasurementsProvider.dart';
import 'package:tailor_app/View/Data/SavedMeasures/Details.dart';
import 'package:tailor_app/View/Home/HomeScreen.dart';
import 'package:tailor_app/Widgets/DeleteDialoge/Delete.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final measurementList = ref.watch(measurementProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(Homescreen());
        },
        child: Icon(Icons.add, color: Colors.orange),
      ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by name or phone number",
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: measurementList.when(
              data: (measurements) {
                // Filter measurements based on search query
                final filteredMeasurements = searchQuery.isEmpty
                    ? measurements
                    : measurements.where((measurement) {
                        return measurement.name.toLowerCase().contains(searchQuery) ||
                            measurement.number.toLowerCase().contains(searchQuery);
                      }).toList();

                if (measurements.isEmpty) {
                  return Center(
                    child: Text(
                      "No saved data",
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  );
                }

                if (filteredMeasurements.isEmpty) {
                  return Center(
                    child: Text(
                      "No results found",
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredMeasurements.length,
                  itemBuilder: (context, index) {
                    final measurement = filteredMeasurements[index];

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
                                showdelete(context, ref, measurement.number);
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
          ),
        ],
      ),
    );
  }


}