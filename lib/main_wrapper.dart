import 'package:careers/screens/home/job_seeker/job_seeker_home.dart';
import 'package:careers/screens/home/recruiter/recruiter_home.dart';
import 'package:careers/screens/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  Future<Widget> getInitialScreen() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginScreen(); // Not logged in
    }

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final userType = userDoc.data()?['userType']?.toString().toLowerCase();

    if (userType == 'jobseeker') {
      return const JobSeekerHome();
    } else if (userType == 'recruiter') {
      return const RecruiterHome();
    } else {
      return const LoginScreen(); // Unknown or missing userType
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Something went wrong")),
          );
        }

        return snapshot.data!;
      },
    );
  }
}
