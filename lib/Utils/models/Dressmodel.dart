
import 'package:tailor_app/Utils/models/clientmodel.dart';

class DressModel {
  final String name;
  final String number;
  final String dressColor;
  final String dressPic;
  final DateTime bookDate;
  final Measurement measurements;

  DressModel({
    required this.name,
    required this.number,
    required this.dressColor,
    required this.dressPic,
    required this.bookDate,
    required this.measurements,
  });

  /// ✅ **Convert DressModel to Firestore Map**
  Map<String, dynamic> toMap(String tailorEmail) {
    return {
      'name': name,
      'number': number,
      'dressColor': dressColor,
      'dressPic': dressPic,
      'bookDate': bookDate.millisecondsSinceEpoch, // Store date as timestamp
      'measurements': measurements.toMap(tailorEmail), // ✅ Sync using existing `toMap()`
    };
  }

  /// ✅ **Convert Firestore document to DressModel**
  factory DressModel.fromMap(Map<String, dynamic> map) {
    return DressModel(
      name: map['name'] ?? '',
      number: map['number'] ?? '',
      dressColor: map['dressColor'] ?? '',
      dressPic: map['dressPic'] ?? '',
      bookDate: DateTime.fromMillisecondsSinceEpoch(map['bookDate']),
      measurements: Measurement.fromMap(map['measurements']), // ✅ Directly use `Measurement.fromMap()`
    );
  }

  /// ✅ **Copy method for updates**
  DressModel copyWith({
    String? name,
    String? number,
    String? dressColor,
    String? dressPic,
    DateTime? bookDate,
    Measurement? measurements,
  }) {
    return DressModel(
      name: name ?? this.name,
      number: number ?? this.number,
      dressColor: dressColor ?? this.dressColor,
      dressPic: dressPic ?? this.dressPic,
      bookDate: bookDate ?? this.bookDate,
      measurements: measurements ?? this.measurements,
    );
  }
}