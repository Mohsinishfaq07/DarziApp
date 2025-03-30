  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:gap/gap.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:fluttertoast/fluttertoast.dart';
  import 'package:tailor_app/Utils/models/clientmodel.dart';
  import 'package:tailor_app/Utils/Provider/MeasurementsProvider.dart';
import 'package:tailor_app/Widgets/Genderwidget/GenderWidget.dart';

  class DetailScreen extends ConsumerStatefulWidget {
    final Measurement measurement;

    const DetailScreen({super.key, required this.measurement});

    @override
    ConsumerState<DetailScreen> createState() => _DetailScreenState();
  }

  class _DetailScreenState extends ConsumerState<DetailScreen> {
    final Map<String, TextEditingController> controllers = {};
    final TextEditingController noteController = TextEditingController();
    bool _isSaving = false;
  @override
  void initState() {
    super.initState();

    List<String> fieldNames = [
      'name', 'number', 'length', 'arm', 'shoulder', 'color', 'chest',
      'lap', 'pant', 'paincha',
    ];

    if (widget.measurement.gender == 'Female') {
      fieldNames.addAll([
        'armRound', 'armHole', 'waist', 'hips', 'side', 'neck', 'pantWidth',
      ]);
    }

    // Mapping field names to actual measurement properties
    final measurementMap = {
      'name': widget.measurement.name,
      'number': widget.measurement.number,
      'length': widget.measurement.length.toString() ?? '',
      'arm': widget.measurement.arm?.toString() ?? '',
      'shoulder': widget.measurement.shoulder?.toString() ?? '',
      'color': widget.measurement.color,
      'chest': widget.measurement.chest?.toString() ?? '',
      'lap': widget.measurement.lap?.toString() ?? '',
      'pant': widget.measurement.pant?.toString() ?? '',
      'paincha': widget.measurement.paincha?.toString() ?? '',
      'armRound': widget.measurement.armRound?.toString() ?? '',
      'armHole': widget.measurement.armHole?.toString() ?? '',
      'waist': widget.measurement.waist?.toString() ?? '',
      'hips': widget.measurement.hips?.toString() ?? '',
      'side': widget.measurement.side?.toString() ?? '',
      'neck': widget.measurement.neck?.toString() ?? '',
      'pantWidth': widget.measurement.pantWidth?.toString() ?? '',
    };

    for (var field in fieldNames) {
      controllers[field] = TextEditingController(text: measurementMap[field] ?? '');
    }

    noteController.text = widget.measurement.note ?? "";
  }


    @override
    void dispose() {
      for (var controller in controllers.values) {
        controller.dispose();
      }
      noteController.dispose();
      super.dispose();
    }

    void updateMeasurement() async {
      List<String> requiredFields = [
        'name', 'number', 'length', 'arm', 'shoulder', 'color', 'chest',
        'lap', 'pant', 'paincha',
      ];

      if (widget.measurement.gender == 'Female') {
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

      setState(() => _isSaving = true);

      final updatedMeasurement = Measurement(
        name: controllers['name']!.text,
        number: controllers['number']!.text,
        gender: widget.measurement.gender,
        length: double.tryParse(controllers['length']!.text) ?? 0,
        arm: double.tryParse(controllers['arm']!.text) ?? 0,
        shoulder: double.tryParse(controllers['shoulder']!.text) ?? 0,
        color: controllers['color']!.text,
        chest: double.tryParse(controllers['chest']!.text) ?? 0,
        lap: double.tryParse(controllers['lap']!.text) ?? 0,
        pant: double.tryParse(controllers['pant']!.text) ?? 0,
        paincha: double.tryParse(controllers['paincha']!.text) ?? 0,
        note: noteController.text,
        armRound: widget.measurement.gender == 'Female' ? double.tryParse(controllers['armRound']!.text) : null,
        armHole: widget.measurement.gender == 'Female' ? double.tryParse(controllers['armHole']!.text) : null,
        waist: widget.measurement.gender == 'Female' ? double.tryParse(controllers['waist']!.text) : null,
        hips: widget.measurement.gender == 'Female' ? double.tryParse(controllers['hips']!.text) : null,
        side: widget.measurement.gender == 'Female' ? double.tryParse(controllers['side']!.text) : null,
        neck: widget.measurement.gender == 'Female' ? double.tryParse(controllers['neck']!.text) : null,
        pantWidth: widget.measurement.gender == 'Female' ? double.tryParse(controllers['pantWidth']!.text) : null,
      );

      await ref.read(measurementRepositoryProvider).UpdateData(updatedMeasurement, context);

      setState(() => _isSaving = false);
      Navigator.pop(context);
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit ${widget.measurement.name}",
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
          actions: [
            _isSaving
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                : TextButton(
                    onPressed: _isSaving ? null : updateMeasurement,
                    child: Text(
                      "Save",
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
          ],
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
                      ...controllers.entries.map((entry) {
                        return buildInputField(entry.key, entry.value);
                      }).toList(),
                      buildNoteSection(),
                      Gap(20),
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
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: TextField(
                controller: noteController,
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
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      return CustomButton(() {
        _isSaving ? null : updateMeasurement;
      }, "Save");
    }
  }
