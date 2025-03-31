import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tailor_app/Utils/Provider/MeasurementsProvider.dart';
import 'package:tailor_app/Utils/models/measurmentmodel.dart';

class NewlistScreen extends ConsumerStatefulWidget {
  final bool isFemale;
  const NewlistScreen({super.key, required this.isFemale});

  @override
  ConsumerState<NewlistScreen> createState() => _NewlistScreenState();
}

class _NewlistScreenState extends ConsumerState<NewlistScreen> {
  final Map<String, TextEditingController> controllers = {};
  final TextEditingController noteController = TextEditingController();
  bool _isSaving = false; // Loading state

  @override
  void initState() {
    super.initState();
    List<String> fieldNames = [
      'name', 'number', 'length', 'arm', 'shoulder', 'color', 'chest',
      'lap', 'pant', 'paincha',
    ];

    if (widget.isFemale) {
      fieldNames.addAll([
        'armRound', 'armHole', 'waist', 'hips', 'side', 'neck', 'pantWidth',
      ]);
    }

    for (var field in fieldNames) {
      controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    noteController.dispose();
    super.dispose();
  }

  void saveMeasurement() async {
    List<String> requiredFields = [
      'name', 'number', 'length', 'arm', 'shoulder', 'color', 'chest',
      'lap', 'pant', 'paincha',
    ];

    if (widget.isFemale) {
      requiredFields.addAll([
        'armRound', 'armHole', 'waist', 'hips', 'side', 'neck', 'pantWidth',
      ]);
    }

    for (String key in requiredFields) {
      if (controllers[key]!.text.trim().isEmpty) {
        Fluttertoast.showToast(msg: "Please fill out all fields before saving.");
        return;
      }
    }

    setState(() => _isSaving = true); // Start loading

    final measurement = Measurement(
      name: controllers['name']!.text,
      number: controllers['number']!.text,
      gender: widget.isFemale ? 'Female' : 'Male',
      length: double.tryParse(controllers['length']!.text) ?? 0,
      arm: double.tryParse(controllers['arm']!.text) ?? 0,
      shoulder: double.tryParse(controllers['shoulder']!.text) ?? 0,
      color: controllers['color']!.text,
      chest: double.tryParse(controllers['chest']!.text) ?? 0,
      lap: double.tryParse(controllers['lap']!.text) ?? 0,
      pant: double.tryParse(controllers['pant']!.text) ?? 0,
      paincha: double.tryParse(controllers['paincha']!.text) ?? 0,
      note: noteController.text, // Using separate noteController
      armRound: widget.isFemale ? double.tryParse(controllers['armRound']!.text) : null,
      armHole: widget.isFemale ? double.tryParse(controllers['armHole']!.text) : null,
      waist: widget.isFemale ? double.tryParse(controllers['waist']!.text) : null,
      hips: widget.isFemale ? double.tryParse(controllers['hips']!.text) : null,
      side: widget.isFemale ? double.tryParse(controllers['side']!.text) : null,
      neck: widget.isFemale ? double.tryParse(controllers['neck']!.text) : null,
      pantWidth: widget.isFemale ? double.tryParse(controllers['pantWidth']!.text) : null,
    );

    await ref.read(measurementRepositoryProvider).saveOrUpdateMeasurement(measurement, context);

    setState(() => _isSaving = false); // Stop loading
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Enter Measurements",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
    actions: [
  _isSaving 
      ? Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
        )
      : TextButton(
          onPressed: _isSaving ? null : saveMeasurement, // Calls the same function
          child: Text(
            "Save",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
],

        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    // All input fields
                    ...controllers.entries.map((entry) {
                      return buildInputField(entry.key, entry.value);
                    }),

                    // Note field (Placed above the save button)
                    buildNoteSection(),

                    Gap(20),

                    // Save button
                    buildSaveButton(),

                    Gap(50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNoteSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note - نوٹ",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: TextField(
              controller: noteController, // Using separate controller
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputField(String key, TextEditingController controller) {
    String label = Measurement.labels[key] ?? key;
  TextInputType keyboardType = 
      (key == 'name' || key == 'color') ? TextInputType.text : TextInputType.number; 
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade300),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 5,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSaveButton() {
    return ElevatedButton(
      onPressed: _isSaving ? null : saveMeasurement,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
      ),
      child: _isSaving
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Text(
              "Save",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
