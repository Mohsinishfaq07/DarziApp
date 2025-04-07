import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/Utils/Snackbar/Snackbar.dart';
import 'package:tailor_app/Utils/models/Profilemodel.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel?>>((ref) {
      return ProfileNotifier();
    });

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel?>> {
  ProfileNotifier() : super(const AsyncValue.loading()) {
    _initListener();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? _subscription;
  bool isSaving = false; // Track saving status

  void _initListener() {
    final email = _auth.currentUser?.email;
    if (email == null) {
      state = AsyncValue.error("User not logged in", StackTrace.current);
      return;
    }

    _subscription = _firestore
        .collection("tailor_profiles")
        .doc(email)
        .snapshots()
        .listen(
          (doc) {
            if (doc.exists) {
              final data = ProfileModel.fromMap(
                doc.data()!,
              ).copyWith(email: email);
              state = AsyncValue.data(data);
            } else {
              state = const AsyncValue.data(null);
            }
          },
          onError: (e, stack) {
            state = AsyncValue.error(e, stack);
          },
        );
  }

  Future<void> saveProfile(ProfileModel profile) async {
    isSaving = true; // Set isSaving to true when the save operation starts
    state = AsyncValue.data(
      state.value,
    ); // Notify listeners that saving has started

    try {
      final email = _auth.currentUser?.email;
      if (email == null) throw Exception("User not logged in");

      final updated = profile.copyWith(email: email);

      await _firestore
          .collection("tailor_profiles")
          .doc(email)
          .set(updated.toMap());

      state = AsyncValue.data(updated); // Update state with saved profile
      showSnackBar("Profile", 'Profile saved successfully!');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current); // Handle errors
    } finally {
      isSaving = false; // Reset isSaving after the operation
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
