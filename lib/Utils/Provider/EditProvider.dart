import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/Utils/Provider/MeasurementsProvider.dart';
import 'package:tailor_app/Utils/models/measurmentmodel.dart';

final measurementEditControllerProvider = StateNotifierProvider.autoDispose
    .family<MeasurementEditController, bool, Measurement>(
      (ref, measurement) => MeasurementEditController(ref, measurement),
    );

class MeasurementEditController extends StateNotifier<bool> {
  final Ref ref;
  final Measurement measurement;

  late final Map<String, TextEditingController> controllers;
  late final TextEditingController noteController;

  MeasurementEditController(this.ref, this.measurement) : super(false) {
    _initControllers();
  }

  void _initControllers() {
    controllers = {};

    final fields = {
      'name': measurement.name,
      'number': measurement.number,
      'length': measurement.length.toString(),
      'arm': measurement.arm.toString(),
      'shoulder': measurement.shoulder.toString(),
      'color': measurement.color,
      'chest': measurement.chest.toString(),
      'lap': measurement.lap.toString(),
      'pant': measurement.pant.toString(),
      'paincha': measurement.paincha.toString(),
      'armRound': measurement.armRound?.toString() ?? '',
      'armHole': measurement.armHole?.toString() ?? '',
      'waist': measurement.waist?.toString() ?? '',
      'hips': measurement.hips?.toString() ?? '',
      'side': measurement.side?.toString() ?? '',
      'neck': measurement.neck?.toString() ?? '',
      'pantWidth': measurement.pantWidth?.toString() ?? '',
    };

    fields.forEach((key, value) {
      controllers[key] = TextEditingController(text: value);
    });

    noteController = TextEditingController(text: measurement.note ?? '');
  }

  Future<bool> saveChanges(BuildContext context) async {
    state = true;

    final requiredFields = [
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

    if (measurement.gender == 'Female') {
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

    for (final field in requiredFields) {
      if (controllers[field]?.text.trim().isEmpty ?? true) {
        state = false;
        return false;
      }
    }

    final updated = Measurement(
      name: controllers['name']!.text,
      number: controllers['number']!.text,
      gender: measurement.gender,
      length: double.tryParse(controllers['length']!.text) ?? 0,
      arm: double.tryParse(controllers['arm']!.text) ?? 0,
      shoulder: double.tryParse(controllers['shoulder']!.text) ?? 0,
      color: controllers['color']!.text,
      chest: double.tryParse(controllers['chest']!.text) ?? 0,
      lap: double.tryParse(controllers['lap']!.text) ?? 0,
      pant: double.tryParse(controllers['pant']!.text) ?? 0,
      paincha: double.tryParse(controllers['paincha']!.text) ?? 0,
      note: noteController.text,
      armRound:
          measurement.gender == 'Female'
              ? double.tryParse(controllers['armRound']!.text)
              : null,
      armHole:
          measurement.gender == 'Female'
              ? double.tryParse(controllers['armHole']!.text)
              : null,
      waist:
          measurement.gender == 'Female'
              ? double.tryParse(controllers['waist']!.text)
              : null,
      hips:
          measurement.gender == 'Female'
              ? double.tryParse(controllers['hips']!.text)
              : null,
      side:
          measurement.gender == 'Female'
              ? double.tryParse(controllers['side']!.text)
              : null,
      neck:
          measurement.gender == 'Female'
              ? double.tryParse(controllers['neck']!.text)
              : null,
      pantWidth:
          measurement.gender == 'Female'
              ? double.tryParse(controllers['pantWidth']!.text)
              : null,
    );

    await ref.read(measurementRepositoryProvider).UpdateData(updated, context);
    state = false;
    return true;
  }

  void disposeAll() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    noteController.dispose();
  }
}
