import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/Utils/Snackbar/Snackbar.dart';
import 'package:tailor_app/Utils/models/measurmentmodel.dart';
import 'package:tailor_app/View/Data/SavedMeasures/SavedScreen.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final authProvider = Provider((ref) => FirebaseAuth.instance);
final measurementProvider = StreamProvider<List<Measurement>>((ref) {
  final repo = ref.read(measurementRepositoryProvider);
  return repo.getMeasurements();
});

final measurementRepositoryProvider = Provider(
  (ref) => MeasurementRepository(ref.read(firestoreProvider), ref.read(authProvider)),
);

class MeasurementRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  MeasurementRepository(this._firestore, this._auth);

  /// ✅ **Save or Update Measurement (Based on Mobile Number)**
  Future<void> saveOrUpdateMeasurement(Measurement measurement, BuildContext context) async {
    final user = _auth.currentUser;
    if (user == null) {
      showSnackBar("Error", "No User Logged In");
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.email!) // Tailor's email as document ID
          .collection('clients')
          .doc(measurement.number) // Client's phone number as document ID
          .set(measurement.toMap(user.email!), SetOptions(merge: true)); // Merge if exists

      showSnackBar("Success", "Measurement Saved Successfully");
      Navigator.pop(context);
    } catch (e) {
      showSnackBar("Error", e.toString());
    }
  }

  /// ✅ **Get All Measurements**
  Stream<List<Measurement>> getMeasurements() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.email!) // Get tailor's data
        .collection('clients') // Fetch all clients
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Measurement(
              name: data['name'] ?? '',
              number: data['number'] ?? '',
              gender: data['gender'] ?? 'Male',
              length: (data['length'] ?? 0).toDouble(),
              arm: (data['arm'] ?? 0).toDouble(),
              shoulder: (data['shoulder'] ?? 0).toDouble(),
              color: data['color'] ?? '',
              chest: (data['chest'] ?? 0).toDouble(),
              lap: (data['lap'] ?? 0).toDouble(),
              pant: (data['pant'] ?? 0).toDouble(),
              paincha: (data['paincha'] ?? 0).toDouble(),
              note: data['note'] ?? '',
              armRound: (data['armRound'] ?? 0).toDouble(),
              armHole: (data['armHole'] ?? 0).toDouble(),
              waist: (data['waist'] ?? 0).toDouble(),
              hips: (data['hips'] ?? 0).toDouble(),
              lapExtra: (data['lapExtra'] ?? 0).toDouble(),
              side: (data['side'] ?? 0).toDouble(),
              neck: (data['neck'] ?? 0).toDouble(),
              pantWidth: (data['pantWidth'] ?? 0).toDouble(),
            );
          }).toList();
        });
  }

  /// ✅ **Delete a Measurement**
  Future<void> deleteMeasurement(String clientNumber) async {
    final user = _auth.currentUser;
    if (user == null) {
      showSnackBar("Error", "No User Logged In");
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.email!)
          .collection('clients')
          .doc(clientNumber)
          .delete();

      showSnackBar("Success", "Measurement Deleted Successfully");
    } catch (e) {
      showSnackBar("Error", e.toString());
    }
  }
Future<void> UpdateData(Measurement measurement, BuildContext context) async {
  final user = _auth.currentUser;
  if (user == null) {
    showSnackBar("Error", "No User Logged In");
    return;
  }

  try {
    final docRef = _firestore
        .collection('users')
        .doc(user.email!)
        .collection('clients')
        .doc(measurement.number);

    await docRef.set(measurement.toMap(user.email!));

    showSnackBar("Success", "Measurement Saved Successfully");
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
  return SavedScreen();
},));
  } catch (e) {
    showSnackBar("Error", e.toString());
  }
}

  /// ✅ **Fetch a Single Measurement for Editing**
  Future<Measurement?> getMeasurementByNumber(String clientNumber) async {
    final user = _auth.currentUser;
    if (user == null) {
      showSnackBar("Error", "No User Logged In");
      return null;
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('users')
          .doc(user.email!)
          .collection('clients')
          .doc(clientNumber)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        return Measurement(
          name: data['name'] ?? '',
          number: data['number'] ?? '',
          gender: data['gender'] ?? 'Male',
          length: (data['length'] ?? 0).toDouble(),
          arm: (data['arm'] ?? 0).toDouble(),
          shoulder: (data['shoulder'] ?? 0).toDouble(),
          color: data['color'] ?? '',
          chest: (data['chest'] ?? 0).toDouble(),
          lap: (data['lap'] ?? 0).toDouble(),
          pant: (data['pant'] ?? 0).toDouble(),
          paincha: (data['paincha'] ?? 0).toDouble(),
          note: data['note'] ?? '',
          armRound: (data['armRound'] ?? 0).toDouble(),
          armHole: (data['armHole'] ?? 0).toDouble(),
          waist: (data['waist'] ?? 0).toDouble(),
          hips: (data['hips'] ?? 0).toDouble(),
          lapExtra: (data['lapExtra'] ?? 0).toDouble(),
          side: (data['side'] ?? 0).toDouble(),
          neck: (data['neck'] ?? 0).toDouble(),
          pantWidth: (data['pantWidth'] ?? 0).toDouble(),
        );
      }
    } catch (e) {
      showSnackBar("Error", e.toString());
    }

    return null;
  }
}
