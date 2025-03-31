  import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Utils/Provider/MeasurementsProvider.dart';

void showdelete(BuildContext context, WidgetRef ref, String number) {
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