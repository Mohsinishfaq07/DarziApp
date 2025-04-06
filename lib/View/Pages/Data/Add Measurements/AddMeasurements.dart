import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Utils/Provider/EditProvider.dart';
import 'package:tailor_app/Utils/models/measurmentmodel.dart';
import 'package:tailor_app/Widgets/BannerAd/BannerAdWidget.dart';
import 'package:tailor_app/Widgets/Button/CustomButton.dart';
import 'package:tailor_app/Widgets/Inpufield/MeasurementFields.dart';

class AddMeasurementScreen extends ConsumerStatefulWidget {
  final bool isFemale;
  const AddMeasurementScreen({super.key, required this.isFemale});

  @override
  ConsumerState<AddMeasurementScreen> createState() => _NewlistScreenState();
}

class _NewlistScreenState extends ConsumerState<AddMeasurementScreen> {
  // Create a GlobalKey for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(measurementFormProvider.notifier)
          .initializeForNewData(widget.isFemale);
    });
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(measurementFormProvider);

    return Scaffold(
      bottomNavigationBar: BannerAdWidget(),
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
          formState.isSaving
              ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
              : TextButton(
                onPressed:
                    formState.isSaving
                        ? null
                        : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Trigger save if form is valid
                            await ref
                                .read(measurementFormProvider.notifier)
                                .saveMeasurement(context);
                          }
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
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey, // Assign the GlobalKey here
                  child: Column(
                    children: [
                      // All input fields
                      ...formState.controllers.entries.map((entry) {
                        return MeasurementFields(
                          controller: entry.value,
                          label: Measurement.labels[entry.key] ?? entry.key,
                          keyboardType:
                              (entry.key == 'name' || entry.key == 'color')
                                  ? TextInputType.text
                                  : TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "${entry.key} Cannot be empty";
                            }
                            return null;
                          },
                        );
                      }),
                      NoteSection(noteController: formState.noteController),
                      Gap(20),
                      ActionButton(
                        label: "Save",
                        isLoading: formState.isSaving,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Trigger save if form is valid
                            ref
                                .read(measurementFormProvider.notifier)
                                .saveMeasurement(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Banner Ad
        ],
      ),
    );
  }
}
