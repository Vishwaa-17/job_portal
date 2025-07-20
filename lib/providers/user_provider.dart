import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:careers/models/user.dart' as model;

class UserProvider with ChangeNotifier {
  model.User? _user; // Can be null initially
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Updated: nullable getter
  model.User? get getUser => _user;

  Future<void> refreshUser() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snap.exists && snap.data() != null) {
        _user = model.User.fromSnap(snap);
        notifyListeners();
      } else {
        if (kDebugMode) {
          print('No user document found for uid: $uid');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in UserProvider.refreshUser: $e');
      }
    }
  }
}
