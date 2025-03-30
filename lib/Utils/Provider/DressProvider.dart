import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/Utils/models/DressModel.dart';

/// **Dress Provider using AsyncNotifier for real-time Firestore data**
final dressProvider = AsyncNotifierProvider<DressNotifier, List<DressModel>>(DressNotifier.new);

class DressNotifier extends AsyncNotifier<List<DressModel>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<List<DressModel>> build() async {
    return await _fetchDresses();
  }

  /// ✅ **Fetch all dresses from Firestore**
/// ✅ **Fetch all dresses from Firestore**
Future<List<DressModel>> _fetchDresses() async {
  final user = _auth.currentUser;
  if (user == null) {
    throw Exception('User is not authenticated.');
  }

  try {
    final snapshot = await _firestore
        .collection('users')
        .doc(user.email!)
        .collection('dresses')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return DressModel.fromMap(data);
    }).toList();
  } catch (e) {
    throw Exception("🔥 Error fetching dresses: $e");
  }
}


  /// ✅ **Add or Update a Dress**
  Future<void> addOrUpdateDress(DressModel dress) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated.');
      }

      await _firestore
          .collection("users")
          .doc(user.email!)
          .collection("dresses")
          .doc(dress.number)
          .set(
        dress.toMap(),
        SetOptions(merge: true),
      );

      state = AsyncValue.data(await _fetchDresses());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("🔥 Error adding/updating dress: $e");
    }
  }

  /// ✅ **Update a Dress**
  Future<void> updateDress(DressModel dress) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated.');
      }

      await _firestore
          .collection("users")
          .doc(user.email!)
          .collection("dresses")
          .doc(dress.number)
          .update(dress.toMap());

      state = AsyncValue.data(await _fetchDresses());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("🔥 Error updating dress: $e");
    }
  }

  /// ✅ **Mark Dress as Completed**
  Future<void> toggleCompletionStatus(String number, bool isCompleted) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated.');
      }

      await _firestore
          .collection("users")
          .doc(user.email!)
          .collection("dresses")
          .doc(number)
          .update({"isCompleted": isCompleted});

      state = AsyncValue.data(await _fetchDresses());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("🔥 Error updating dress status: $e");
    }
  }

  /// ✅ **Remove a Dress**
  Future<void> removeDress(String number) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated.');
      }

      await _firestore
          .collection("users")
          .doc(user.email!)
          .collection("dresses")
          .doc(number)
          .delete();

      state = AsyncValue.data(await _fetchDresses());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("🔥 Error removing dress: $e");
    }
  }
}
