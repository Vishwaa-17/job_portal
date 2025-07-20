import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up user - ONLY creates the Firebase Auth account.
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (err.code == 'email-already-in-use') {
        res = 'An account already exists for that email.';
      } else {
        res = err.message ?? 'An unknown authentication error occurred.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Login user with improved error handling
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'some error occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = 'Please enter both email and password.';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found' || err.code == 'wrong-password' || err.code == 'invalid-credential') {
        res = 'Invalid email or password.';
      } else {
        res = err.message ?? 'An unknown error occurred.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // --- THIS IS THE CORRECTED AND STANDARDIZED METHOD ---
  // It now expects 'firstName' and 'lastName' but saves them as 'first_name' and 'last_name'
  Future<void> saveJobSeekerPersonalDetails({
    required String uid,
    required String firstName,
    required String lastName,
    required String dob,
    required String gender,
    required String state,
    required String city,
    required String email,
    required String phoneNo,
  }) async {
    try {
      await _firestore.collection('job_seekers').doc(uid).set({
        'uid': uid,
        'email': email,
        'phoneNo': phoneNo,
        'userType': 'jobSeeker',
        'first_name': firstName, // Saving with snake_case
        'last_name': lastName,   // Saving with snake_case
        'dob': dob,
        'gender': gender,
        'state': state,
        'city': city,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save job seeker personal details: $e');
    }
  }

  // Save Job Seeker Work Details
  Future<void> saveJobSeekerWorkDetails({
    required String uid,
    required String company,
    required String position,
    required String duration,
  }) async {
    try {
      await _firestore.collection('job_seekers').doc(uid).set({
        'company': company,
        'position': position,
        'duration': duration,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save job seeker work details: $e');
    }
  }

  // Save Recruiter Personal Details
  Future<void> saveRecruiterPersonalDetails({
    required String uid,
    required String firstName,
    required String lastName,
    required String dob,
    required String gender,
    required String state,
    required String city,
    required String email,
    required String phoneNo,
  }) async {
    try {
      // For consistency, we'll ensure this one also saves with snake_case.
      await _firestore.collection('recruiters').doc(uid).set({
        'uid': uid,
        'first_name': firstName, // Saving with snake_case
        'last_name': lastName,   // Saving with snake_case
        'dob': dob,
        'gender': gender,
        'state': state,
        'city': city,
        'email': email,
        'phoneNo': phoneNo,
        'userType': 'recruiter',
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save recruiter personal details: $e');
    }
  }

  // This method is optional, depending on if you use a separate 'users' collection.
  Future<void> saveUserType(String uid, String userType) async {
    try {
      await _firestore.collection('users').doc(uid).set(
        {'userType': userType},
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to save user type: $e');
    }
  }
}