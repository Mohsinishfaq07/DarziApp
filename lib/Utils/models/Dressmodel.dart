import 'package:tailor_app/Utils/models/measurmentmodel.dart';

class DressModel {
  final String name;
  final String number;
  final String dressColor;
  final String dressPic;
  final DateTime bookDate;
  final Measurement measurements;
  final bool isCompleted;

  DressModel({
    required this.name,
    required this.number,
    required this.dressColor,
    required this.dressPic,
    required this.bookDate,
    required this.measurements,
    required this.isCompleted,
  });
 DressModel copyWith({
    String? name,
    String? number,
    String? dressColor,
    String? dressPic,
    DateTime? bookDate,
    Measurement? measurements,
    bool? isCompleted,
  }) {
    return DressModel(
      name: name ?? this.name,
      number: number ?? this.number,
      dressColor: dressColor ?? this.dressColor,
      dressPic: dressPic ?? this.dressPic,
      bookDate: bookDate ?? this.bookDate,
      measurements: measurements ?? this.measurements,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
  Map<String, dynamic> toMap(String tailorEmail) {
    return {
      'name': name,
      'number': number,
      'dressColor': dressColor,
      'dressPic': dressPic,
      'bookDate': bookDate.millisecondsSinceEpoch,
      'measurements': measurements.toMap(tailorEmail),
      'isCompleted': isCompleted,
    };
  }

  factory DressModel.fromMap(Map<String, dynamic> map) {
    return DressModel(
      name: map['name'] as String? ?? '',
      number: map['number'] as String? ?? '',
      dressColor: map['dressColor'] as String? ?? '',
      dressPic: map['dressPic'] as String? ?? '',
      bookDate: DateTime.fromMillisecondsSinceEpoch(map['bookDate'] as int? ?? 0),
      measurements: Measurement.fromMap(map['measurements'] as Map<String, dynamic>? ?? {}),
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }
}