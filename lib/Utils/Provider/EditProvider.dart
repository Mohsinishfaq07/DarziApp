import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tailor_app/Utils/Provider/MeasurementsProvider.dart';
import 'package:tailor_app/Utils/models/measurmentmodel.dart';

final measurementFormProvider =
    StateNotifierProvider<MeasurementFormNotifier, MeasurementFormState>(
      (ref) => MeasurementFormNotifier(ref),
    );

class MeasurementFormState {
  final Map<String, TextEditingController> controllers;
  final TextEditingController noteController;
  final bool isSaving;
  final bool isFemale;

  MeasurementFormState({
    required this.controllers,
    required this.noteController,
    this.isSaving = false,
    required this.isFemale,
  });

  MeasurementFormState copyWith({
    Map<String, TextEditingController>? controllers,
    TextEditingController? noteController,
    bool? isSaving,
    bool? isFemale,
  }) {
    return MeasurementFormState(
      controllers: controllers ?? this.controllers,
      noteController: noteController ?? this.noteController,
      isSaving: isSaving ?? this.isSaving,
      isFemale: isFemale ?? this.isFemale,
    );
  }
}

// class MeasurementFormNotifier extends StateNotifier<MeasurementFormState> {
//   final Ref ref;

//   MeasurementFormNotifier(this.ref)
//     : super(
//         MeasurementFormState(
//           controllers: {},
//           noteController: TextEditingController(),
//           isFemale: false,
//         ),
//       );

//   void initializeForm(bool isFemale) {
//     List<String> fieldNames = [
//       'name',
//       'number',
//       'length',
//       'arm',
//       'shoulder',
//       'color',
//       'chest',
//       'lap',
//       'pant',
//       'paincha',
//     ];

//     if (isFemale) {
//       fieldNames.addAll([
//         'armRound',
//         'armHole',
//         'waist',
//         'hips',
//         'side',
//         'neck',
//         'pantWidth',
//       ]);
//     }

//     final controllers = {
//       for (var field in fieldNames) field: TextEditingController(),
//     };

//     state = state.copyWith(controllers: controllers, isFemale: isFemale);
//   }

//   void disposeControllers() {
//     for (var controller in state.controllers.values) {
//       controller.dispose();
//     }
//     state.noteController.dispose();
//   }

//   Future<void> saveMeasurement(BuildContext context) async {
//     if (state.isSaving) return;

//     state = state.copyWith(isSaving: true);

//     final measurement = Measurement(
//       name: state.controllers['name']!.text,
//       number: state.controllers['number']!.text,
//       gender: state.isFemale ? 'Female' : 'Male',
//       length: double.tryParse(state.controllers['length']!.text) ?? 0,
//       arm: double.tryParse(state.controllers['arm']!.text) ?? 0,
//       shoulder: double.tryParse(state.controllers['shoulder']!.text) ?? 0,
//       color: state.controllers['color']!.text,
//       chest: double.tryParse(state.controllers['chest']!.text) ?? 0,
//       lap: double.tryParse(state.controllers['lap']!.text) ?? 0,
//       pant: double.tryParse(state.controllers['pant']!.text) ?? 0,
//       paincha: double.tryParse(state.controllers['paincha']!.text) ?? 0,
//       note: state.noteController.text, // Optional note
//       armRound:
//           state.isFemale
//               ? double.tryParse(state.controllers['armRound']!.text)
//               : null,
//       armHole:
//           state.isFemale
//               ? double.tryParse(state.controllers['armHole']!.text)
//               : null,
//       waist:
//           state.isFemale
//               ? double.tryParse(state.controllers['waist']!.text)
//               : null,
//       hips:
//           state.isFemale
//               ? double.tryParse(state.controllers['hips']!.text)
//               : null,
//       side:
//           state.isFemale
//               ? double.tryParse(state.controllers['side']!.text)
//               : null,
//       neck:
//           state.isFemale
//               ? double.tryParse(state.controllers['neck']!.text)
//               : null,
//       pantWidth:
//           state.isFemale
//               ? double.tryParse(state.controllers['pantWidth']!.text)
//               : null,
//     );

// await ref
//     .read(measurementRepositoryProvider)
//     .saveOrUpdateMeasurement(measurement, context);

// state = state.copyWith(isSaving: false);
//   }
// }
class MeasurementFormNotifier extends StateNotifier<MeasurementFormState> {
  final Ref ref;

  MeasurementFormNotifier(this.ref)
    : super(
        MeasurementFormState(
          controllers: {},
          noteController: TextEditingController(),
          isFemale: false,
          isSaving: false,
        ),
      );

  // Initialize form for creating new data
  void initializeForNewData(bool isFemale) {
    List<String> fieldNames = [
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

    if (isFemale) {
      fieldNames.addAll([
        'armRound',
        'armHole',
        'waist',
        'hips',
        'side',
        'neck',
        'pantWidth',
      ]);
    }

    final controllers = {
      for (var field in fieldNames) field: TextEditingController(text: ''),
    };

    TextEditingController noteController = TextEditingController(text: '');

    state = state.copyWith(
      controllers: controllers,
      noteController: noteController,
      isFemale: isFemale,
    );
  }

  // Initialize form with existing data
  void initializeForExistingData(Measurement measurement, bool isFemale) {
    List<String> fieldNames = [
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

    if (isFemale) {
      fieldNames.addAll([
        'armRound',
        'armHole',
        'waist',
        'hips',
        'side',
        'neck',
        'pantWidth',
      ]);
    }

    final controllers = {
      for (var field in fieldNames)
        field: TextEditingController(text: _getFieldValue(measurement, field)),
    };

    TextEditingController noteController = TextEditingController(
      text: measurement.note ?? "",
    );

    state = state.copyWith(
      controllers: controllers,
      noteController: noteController,
      isFemale: isFemale,
    );
  }

  // Helper method to get the field value from the Measurement object
  String _getFieldValue(Measurement measurement, String field) {
    switch (field) {
      case 'name':
        return measurement.name;
      case 'number':
        return measurement.number;
      case 'length':
        return measurement.length.toString() ?? '';
      case 'arm':
        return measurement.arm.toString() ?? '';
      case 'shoulder':
        return measurement.shoulder.toString() ?? '';
      case 'color':
        return measurement.color;
      case 'chest':
        return measurement.chest.toString() ?? '';
      case 'lap':
        return measurement.lap.toString() ?? '';
      case 'pant':
        return measurement.pant.toString() ?? '';
      case 'paincha':
        return measurement.paincha.toString() ?? '';
      case 'armRound':
        return measurement.armRound?.toString() ?? '';
      case 'armHole':
        return measurement.armHole?.toString() ?? '';
      case 'waist':
        return measurement.waist?.toString() ?? '';
      case 'hips':
        return measurement.hips?.toString() ?? '';
      case 'side':
        return measurement.side?.toString() ?? '';
      case 'neck':
        return measurement.neck?.toString() ?? '';
      case 'pantWidth':
        return measurement.pantWidth?.toString() ?? '';
      default:
        return '';
    }
  }

  // Dispose controllers when no longer needed
  void disposeControllers() {
    for (var controller in state.controllers.values) {
      controller.dispose();
    }
    state.noteController.dispose();
  }

  Future<void> updateMeasurement(
    Measurement measurement,
    List<String> requiredFields,
    WidgetRef ref,
    BuildContext context,
  ) async {
    for (String key in requiredFields) {
      if (state.controllers[key]!.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Please fill out all fields before saving.",
        );
        return;
      }
    }

    state = state.copyWith(isSaving: true);

    final updatedMeasurement = Measurement(
      name: state.controllers['name']!.text,
      number: state.controllers['number']!.text,
      gender: measurement.gender,
      length: double.tryParse(state.controllers['length']!.text) ?? 0,
      arm: double.tryParse(state.controllers['arm']!.text) ?? 0,
      shoulder: double.tryParse(state.controllers['shoulder']!.text) ?? 0,
      color: state.controllers['color']!.text,
      chest: double.tryParse(state.controllers['chest']!.text) ?? 0,
      lap: double.tryParse(state.controllers['lap']!.text) ?? 0,
      pant: double.tryParse(state.controllers['pant']!.text) ?? 0,
      paincha: double.tryParse(state.controllers['paincha']!.text) ?? 0,
      note: state.noteController.text,
      armRound:
          measurement.gender == 'Female'
              ? double.tryParse(state.controllers['armRound']!.text)
              : null,
      armHole:
          measurement.gender == 'Female'
              ? double.tryParse(state.controllers['armHole']!.text)
              : null,
      waist:
          measurement.gender == 'Female'
              ? double.tryParse(state.controllers['waist']!.text)
              : null,
      hips:
          measurement.gender == 'Female'
              ? double.tryParse(state.controllers['hips']!.text)
              : null,
      side:
          measurement.gender == 'Female'
              ? double.tryParse(state.controllers['side']!.text)
              : null,
      neck:
          measurement.gender == 'Female'
              ? double.tryParse(state.controllers['neck']!.text)
              : null,
      pantWidth:
          measurement.gender == 'Female'
              ? double.tryParse(state.controllers['pantWidth']!.text)
              : null,
    );

    await ref
        .read(measurementRepositoryProvider)
        .updateData(updatedMeasurement, context);
    state = state.copyWith(isSaving: false);
    Navigator.pop(context);
  }

  Future<void> saveMeasurement(BuildContext context) async {
    if (state.isSaving) return;
    state = state.copyWith(isSaving: true);
    final measurement = Measurement(
      name: state.controllers['name']!.text,
      number: state.controllers['number']!.text,
      gender: state.isFemale ? 'Female' : 'Male',
      length: double.tryParse(state.controllers['length']!.text) ?? 0,
      arm: double.tryParse(state.controllers['arm']!.text) ?? 0,
      shoulder: double.tryParse(state.controllers['shoulder']!.text) ?? 0,
      color: state.controllers['color']!.text,
      chest: double.tryParse(state.controllers['chest']!.text) ?? 0,
      lap: double.tryParse(state.controllers['lap']!.text) ?? 0,
      pant: double.tryParse(state.controllers['pant']!.text) ?? 0,
      paincha: double.tryParse(state.controllers['paincha']!.text) ?? 0,
      note: state.noteController.text,
      armRound:
          state.isFemale
              ? double.tryParse(state.controllers['armRound']!.text)
              : null,
      armHole:
          state.isFemale
              ? double.tryParse(state.controllers['armHole']!.text)
              : null,
      waist:
          state.isFemale
              ? double.tryParse(state.controllers['waist']!.text)
              : null,
      hips:
          state.isFemale
              ? double.tryParse(state.controllers['hips']!.text)
              : null,
      side:
          state.isFemale
              ? double.tryParse(state.controllers['side']!.text)
              : null,
      neck:
          state.isFemale
              ? double.tryParse(state.controllers['neck']!.text)
              : null,
      pantWidth:
          state.isFemale
              ? double.tryParse(state.controllers['pantWidth']!.text)
              : null,
    );
    await ref
        .read(measurementRepositoryProvider)
        .saveOrUpdateMeasurement(measurement, context);
    state = state.copyWith(isSaving: false);
  }
}
