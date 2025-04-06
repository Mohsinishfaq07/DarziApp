class Measurement {
  final String name;
  final String number;
  final String gender;
  final double length;
  final double arm;
  final double shoulder;
  final String color;
  final double chest;
  final double lap;
  final double pant;
  final double paincha;
  final double? armRound;
  final double? armHole;
  final double? waist;
  final double? hips;
  final double? lapExtra;
  final double? side;
  final double? neck;
  final double? pantWidth;
  final String? note;

  Measurement({
    required this.name,
    required this.number,
    required this.gender,
    required this.length,
    required this.arm,
    required this.shoulder,
    required this.color,
    required this.chest,
    required this.lap,
    required this.pant,
    required this.paincha,
    this.armRound,
    this.armHole,
    this.waist,
    this.hips,
    this.lapExtra,
    this.side,
    this.neck,
    this.pantWidth,
    this.note,
  });
  factory Measurement.fromMap(Map<String, dynamic> map) {
    return Measurement(
      name: map['name'] ?? '',
      number: map['number'] ?? '',
      gender: map['gender'] ?? '',
      length: (map['length'] ?? 0).toDouble(),
      arm: (map['arm'] ?? 0).toDouble(),
      shoulder: (map['shoulder'] ?? 0).toDouble(),
      color: map['color'] ?? '',
      chest: (map['chest'] ?? 0).toDouble(),
      lap: (map['lap'] ?? 0).toDouble(),
      pant: (map['pant'] ?? 0).toDouble(),
      paincha: (map['paincha'] ?? 0).toDouble(),
      armRound:
          map['armRound'] != null ? (map['armRound'] as num).toDouble() : null,
      armHole:
          map['armHole'] != null ? (map['armHole'] as num).toDouble() : null,
      waist: map['waist'] != null ? (map['waist'] as num).toDouble() : null,
      hips: map['hips'] != null ? (map['hips'] as num).toDouble() : null,
      lapExtra:
          map['lapExtra'] != null ? (map['lapExtra'] as num).toDouble() : null,
      side: map['side'] != null ? (map['side'] as num).toDouble() : null,
      neck: map['neck'] != null ? (map['neck'] as num).toDouble() : null,
      pantWidth:
          map['pantWidth'] != null
              ? (map['pantWidth'] as num).toDouble()
              : null,
      note: map['note'] as String?,
    );
  }

  static final Map<String, String> labels = {
    'name': 'Name - نام',
    'number': 'Number - نمبر',
    'length': 'Length - لمبائی',
    'arm': 'Arm - بازو',
    'shoulder': 'Shoulder - کندھا',
    'color': 'Color - رنگ',
    'chest': 'Chest - چھاتی',
    'lap': 'Lap - دامن',
    'pant': 'Pant - شلوار',
    'paincha': 'Paincha - پانچہ',
    'armRound': 'Arm Round - بازو کا گھیرا',
    'armHole': 'Arm Hole - تیرہ',
    'waist': 'Waist - کمر',
    'hips': 'Hips - کولہے',
    'lapExtra': 'Lap Extra - اضافی دامن',
    'side': 'Side - سائیڈ',
    'neck': 'Neck - گلا',
    'pantWidth': 'Pant Width - شلوار کی چوڑائی',
    'note': 'Note - نوٹ',
  };

  Map<String, dynamic> toMap(String tailorEmail) {
    return {
      'tailorEmail': tailorEmail,
      'name': name,
      'number': number,
      'gender': gender,
      'length': length,
      'arm': arm,
      'shoulder': shoulder,
      'color': color,
      'chest': chest,
      'lap': lap,
      'pant': pant,
      'paincha': paincha,
      'note': note,
      if (gender == 'Female') ...{
        'armRound': armRound,
        'armHole': armHole,
        'waist': waist,
        'hips': hips,
        'lapExtra': lapExtra,
        'side': side,
        'neck': neck,
        'pantWidth': pantWidth,
      },
    };
  }
}
