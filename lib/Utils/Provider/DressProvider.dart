  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:tailor_app/Utils/models/DressModel.dart';

  final dressProvider = AsyncNotifierProvider<DressNotifier, List<DressModel>>(DressNotifier.new);

  class DressNotifier extends AsyncNotifier<List<DressModel>> {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    @override
    Future<List<DressModel>> build() async {
      return await _fetchDresses();
    }

    Future<List<DressModel>> _fetchDresses() async {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final snapshot = await _firestore
          .collection('users')
          .doc(user.email!)
          .collection('dresses')
          .get();

      return snapshot.docs.map((doc) => DressModel.fromMap(doc.data())).toList();
    }

    Future<void> addOrUpdateDress(DressModel dress) async {
      try {
        final user = _auth.currentUser;
        if (user == null) throw Exception('User not authenticated');

        await _firestore
            .collection('users')
            .doc(user.email!)
            .collection('dresses')
            .doc(dress.number)
            .set(dress.toMap(user.email!));

        state = await AsyncValue.guard(() => _fetchDresses());
      } catch (e, stack) {
        state = AsyncValue.error(e, stack);
        rethrow;
      }
    }

  Future<void> toggleCompletion(String dressNumber, bool isCompleted) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Update Firestore
      await _firestore
          .collection('users')
          .doc(user.email!)
          .collection('dresses')
          .doc(dressNumber)
          .update({'isCompleted': isCompleted});

      // Update local state more efficiently
      state = await AsyncValue.guard(() async {
        return state.valueOrNull?.map((dress) {
          return dress.number == dressNumber 
              ? dress.copyWith(isCompleted: isCompleted)
              : dress;
        }).toList() ?? await _fetchDresses();
      });
      
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

    Future<void> removeDress(String number) async {
      try {
        final user = _auth.currentUser;
        if (user == null) throw Exception('User not authenticated');

        await _firestore
            .collection('users')
            .doc(user.email!)
            .collection('dresses')
            .doc(number)
            .delete();

        state = await AsyncValue.guard(() => _fetchDresses());
      } catch (e, stack) {
        state = AsyncValue.error(e, stack);
        rethrow;
      }
    }
  }