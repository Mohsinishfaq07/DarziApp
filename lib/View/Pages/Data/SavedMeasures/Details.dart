import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Utils/Provider/EditProvider.dart';
import 'package:tailor_app/Utils/models/measurmentmodel.dart';
import 'package:tailor_app/Widgets/Genderwidget/GenderWidget.dart';
import 'package:tailor_app/Widgets/Inpufield/MeasurementFields.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final Measurement measurement;

  const DetailScreen({super.key, required this.measurement});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool isfemale = widget.measurement.gender == "female" ? true : false;
      ref
          .read(measurementFormProvider.notifier)
          .initializeForExistingData(widget.measurement, isfemale);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(measurementFormProvider);

    List<String> requiredFields = [
      'name',
      'number',
      'length',
      'arm',
      'shoulder',
      'color',
      'chest',
      'lap',
      'pant',
      'paincha',
    ];

    if (widget.measurement.gender == 'Female') {
      requiredFields.addAll([
        'armRound',
        'armHole',
        'waist',
        'hips',
        'side',
        'neck',
        'pantWidth',
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit ${widget.measurement.name}",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          state.isSaving
              ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
              : TextButton(
                onPressed:
                    state.isSaving
                        ? null
                        : () async {
                          await ref
                              .read(measurementFormProvider.notifier)
                              .updateMeasurement(
                                widget.measurement,
                                requiredFields,
                                ref,
                                context,
                              );
                        },
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    ...state.controllers.entries.map((entry) {
                      return EditFields(entry.key, entry.value);
                    }),
                    NoteSection(noteController: state.noteController),
                    Gap(20),
                    CustomButton(() {
                      state.isSaving
                          ? null
                          : ref
                              .read(measurementFormProvider.notifier)
                              .updateMeasurement(
                                widget.measurement,
                                requiredFields,
                                ref,
                                context,
                              );
                    }, "Save"),
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
}
